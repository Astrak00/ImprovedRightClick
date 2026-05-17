import Foundation
import Combine

final class FileTypeStore: ObservableObject {
    @Published var types: [FileTypeConfig] {
        didSet { FileTypeStorage.save(types) }
    }

    init() {
        self.types = FileTypeStorage.load()
    }

    func resetToDefaults() {
        types = FileTypeStorage.defaultTypes
    }

    func delete(_ config: FileTypeConfig) {
        types.removeAll { $0.id == config.id }
    }

    func move(from source: IndexSet, to destination: Int) {
        types.move(fromOffsets: source, toOffset: destination)
    }

    func add(_ config: FileTypeConfig) {
        types.append(config)
    }
}
