import Foundation

// Writes an uncompressed (STORE) ZIP archive in pure Swift.
// No external dependencies; works inside App Extension sandboxes.
enum MinimalZIPWriter {

    struct Entry {
        let name: String  // Use "/" as separator; trailing "/" = directory entry
        let data: Data
    }

    static func archive(entries: [Entry]) -> Data {
        var localBlocks = Data()
        var centralDir  = Data()
        var offsets     = [UInt32]()

        for entry in entries {
            let nameBytes = Data(entry.name.utf8)
            let crc       = crc32(entry.data)
            let size      = UInt32(entry.data.count)

            offsets.append(UInt32(localBlocks.count))

            // Local file header (30 bytes + name + data)
            localBlocks += sig(0x04034b50)
            localBlocks += u16(20)          // version needed
            localBlocks += u16(0)           // flags
            localBlocks += u16(0)           // compression: STORE
            localBlocks += u16(0)           // mod time
            localBlocks += u16(0)           // mod date
            localBlocks += u32(crc)
            localBlocks += u32(size)        // compressed size
            localBlocks += u32(size)        // uncompressed size
            localBlocks += u16(UInt16(nameBytes.count))
            localBlocks += u16(0)           // extra field length
            localBlocks += nameBytes
            localBlocks += entry.data
        }

        let centralDirOffset = UInt32(localBlocks.count)

        for (i, entry) in entries.enumerated() {
            let nameBytes = Data(entry.name.utf8)
            let crc       = crc32(entry.data)
            let size      = UInt32(entry.data.count)

            centralDir += sig(0x02014b50)
            centralDir += u16(20)           // version made by
            centralDir += u16(20)           // version needed
            centralDir += u16(0)            // flags
            centralDir += u16(0)            // compression
            centralDir += u16(0)            // mod time
            centralDir += u16(0)            // mod date
            centralDir += u32(crc)
            centralDir += u32(size)         // compressed size
            centralDir += u32(size)         // uncompressed size
            centralDir += u16(UInt16(nameBytes.count))
            centralDir += u16(0)            // extra field length
            centralDir += u16(0)            // comment length
            centralDir += u16(0)            // disk number start
            centralDir += u16(0)            // internal attributes
            centralDir += u32(0)            // external attributes
            centralDir += u32(offsets[i])   // local header offset
            centralDir += nameBytes
        }

        // End of central directory record
        var end = Data()
        end += sig(0x06054b50)
        end += u16(0)                               // disk number
        end += u16(0)                               // disk with central dir
        end += u16(UInt16(entries.count))           // entries on this disk
        end += u16(UInt16(entries.count))           // total entries
        end += u32(UInt32(centralDir.count))
        end += u32(centralDirOffset)
        end += u16(0)                               // comment length

        return localBlocks + centralDir + end
    }

    // MARK: - CRC-32

    private static func crc32(_ data: Data) -> UInt32 {
        var crc: UInt32 = 0xFFFF_FFFF
        for byte in data {
            crc ^= UInt32(byte)
            for _ in 0..<8 {
                crc = (crc & 1) != 0 ? (crc >> 1) ^ 0xEDB8_8320 : crc >> 1
            }
        }
        return ~crc
    }

    // MARK: - Little-endian helpers

    private static func sig(_ v: UInt32) -> Data { u32(v) }

    private static func u16(_ v: UInt16) -> Data {
        Data([UInt8(v & 0xFF), UInt8(v >> 8)])
    }

    private static func u32(_ v: UInt32) -> Data {
        Data([
            UInt8(v & 0xFF),
            UInt8((v >> 8)  & 0xFF),
            UInt8((v >> 16) & 0xFF),
            UInt8(v >> 24)
        ])
    }
}

private func +=(lhs: inout Data, rhs: Data)  { lhs.append(rhs) }
