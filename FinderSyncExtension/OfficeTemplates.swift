import Foundation

// Generates minimal valid Office Open XML (OOXML) packages.
// All three formats (.docx / .pptx / .xlsx) are ZIP archives
// containing a handful of XML files. They open without errors
// in Microsoft Office, LibreOffice, and Pages/Keynote/Numbers.
enum OfficeTemplates {

    // MARK: - Public

    static func docx() throws -> Data {
        let entries: [MinimalZIPWriter.Entry] = [
            .init(name: "[Content_Types].xml",          data: xml(docxContentTypes)),
            .init(name: "_rels/.rels",                  data: xml(docxRels)),
            .init(name: "word/document.xml",             data: xml(docxDocument)),
            .init(name: "word/_rels/document.xml.rels",  data: xml(emptyRels)),
            .init(name: "word/settings.xml",             data: xml(docxSettings)),
        ]
        return MinimalZIPWriter.archive(entries: entries)
    }

    static func pptx() throws -> Data {
        let entries: [MinimalZIPWriter.Entry] = [
            .init(name: "[Content_Types].xml",                          data: xml(pptxContentTypes)),
            .init(name: "_rels/.rels",                                  data: xml(pptxRels)),
            .init(name: "ppt/presentation.xml",                          data: xml(pptxPresentation)),
            .init(name: "ppt/_rels/presentation.xml.rels",               data: xml(pptxPresentationRels)),
            .init(name: "ppt/slides/slide1.xml",                         data: xml(pptxSlide)),
            .init(name: "ppt/slides/_rels/slide1.xml.rels",              data: xml(pptxSlideRels)),
            .init(name: "ppt/slideLayouts/slideLayout1.xml",             data: xml(pptxSlideLayout)),
            .init(name: "ppt/slideLayouts/_rels/slideLayout1.xml.rels",  data: xml(emptyRels)),
            .init(name: "ppt/slideMasters/slideMaster1.xml",             data: xml(pptxSlideMaster)),
            .init(name: "ppt/slideMasters/_rels/slideMaster1.xml.rels",  data: xml(pptxSlideMasterRels)),
            .init(name: "ppt/theme/theme1.xml",                          data: xml(pptxTheme)),
        ]
        return MinimalZIPWriter.archive(entries: entries)
    }

    static func xlsx() throws -> Data {
        let entries: [MinimalZIPWriter.Entry] = [
            .init(name: "[Content_Types].xml",                    data: xml(xlsxContentTypes)),
            .init(name: "_rels/.rels",                            data: xml(xlsxRels)),
            .init(name: "xl/workbook.xml",                        data: xml(xlsxWorkbook)),
            .init(name: "xl/_rels/workbook.xml.rels",             data: xml(xlsxWorkbookRels)),
            .init(name: "xl/worksheets/sheet1.xml",               data: xml(xlsxSheet)),
            .init(name: "xl/worksheets/_rels/sheet1.xml.rels",    data: xml(emptyRels)),
            .init(name: "xl/sharedStrings.xml",                   data: xml(xlsxSharedStrings)),
            .init(name: "xl/styles.xml",                          data: xml(xlsxStyles)),
            .init(name: "docProps/app.xml",                       data: xml(officeAppProps)),
        ]
        return MinimalZIPWriter.archive(entries: entries)
    }

    // MARK: - Helpers

    private static func xml(_ s: String) -> Data { Data(s.utf8) }

    // MARK: - Shared XML fragments

    private static let emptyRels = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships"/>
        """

    private static let officeAppProps = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties">
          <Application>ImprovedRightClick</Application>
        </Properties>
        """

    // MARK: - DOCX

    private static let docxContentTypes = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
          <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
          <Default Extension="xml"  ContentType="application/xml"/>
          <Override PartName="/word/document.xml"
            ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.document.main+xml"/>
          <Override PartName="/word/settings.xml"
            ContentType="application/vnd.openxmlformats-officedocument.wordprocessingml.settings+xml"/>
        </Types>
        """

    private static let docxRels = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId1"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"
            Target="word/document.xml"/>
        </Relationships>
        """

    private static let docxDocument = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main">
          <w:body>
            <w:p/>
            <w:sectPr/>
          </w:body>
        </w:document>
        """

    private static let docxSettings = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <w:settings xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"/>
        """

    // MARK: - PPTX

    private static let pptxContentTypes = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
          <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
          <Default Extension="xml"  ContentType="application/xml"/>
          <Override PartName="/ppt/presentation.xml"
            ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
          <Override PartName="/ppt/slides/slide1.xml"
            ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
          <Override PartName="/ppt/slideLayouts/slideLayout1.xml"
            ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>
          <Override PartName="/ppt/slideMasters/slideMaster1.xml"
            ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>
          <Override PartName="/ppt/theme/theme1.xml"
            ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
        </Types>
        """

    private static let pptxRels = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId1"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"
            Target="ppt/presentation.xml"/>
        </Relationships>
        """

    private static let pptxPresentation = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <p:presentation xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
                        xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                        xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
          <p:sldMasterIdLst>
            <p:sldMasterId id="2147483648" r:id="rId1"/>
          </p:sldMasterIdLst>
          <p:sldIdLst>
            <p:sldId id="256" r:id="rId2"/>
          </p:sldIdLst>
          <p:sldSz cx="9144000" cy="6858000"/>
          <p:notesSz cx="6858000" cy="9144000"/>
        </p:presentation>
        """

    private static let pptxPresentationRels = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId1"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster"
            Target="slideMasters/slideMaster1.xml"/>
          <Relationship Id="rId2"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide"
            Target="slides/slide1.xml"/>
        </Relationships>
        """

    private static let pptxSlide = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <p:sld xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
               xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
               xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
          <p:cSld><p:spTree>
            <p:nvGrpSpPr>
              <p:cNvPr id="1" name=""/>
              <p:cNvGrpSpPr/>
              <p:nvPr/>
            </p:nvGrpSpPr>
            <p:grpSpPr>
              <a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>
                <a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm>
            </p:grpSpPr>
          </p:spTree></p:cSld>
          <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
        </p:sld>
        """

    private static let pptxSlideRels = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId1"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout"
            Target="../slideLayouts/slideLayout1.xml"/>
        </Relationships>
        """

    private static let pptxSlideLayout = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <p:sldLayout xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
                     xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                     xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships"
                     type="blank">
          <p:cSld name="Blank"><p:spTree>
            <p:nvGrpSpPr>
              <p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/>
            </p:nvGrpSpPr>
            <p:grpSpPr>
              <a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>
                <a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm>
            </p:grpSpPr>
          </p:spTree></p:cSld>
          <p:clrMapOvr><a:masterClrMapping/></p:clrMapOvr>
        </p:sldLayout>
        """

    private static let pptxSlideMaster = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <p:sldMaster xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"
                     xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main"
                     xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
          <p:cSld><p:spTree>
            <p:nvGrpSpPr>
              <p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/>
            </p:nvGrpSpPr>
            <p:grpSpPr>
              <a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/>
                <a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm>
            </p:grpSpPr>
          </p:spTree></p:cSld>
          <p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2"
                    accent1="accent1" accent2="accent2" accent3="accent3"
                    accent4="accent4" accent5="accent5" accent6="accent6"
                    hlink="hlink" folHlink="folHlink"/>
          <p:sldLayoutIdLst>
            <p:sldLayoutId id="2147483649" r:id="rId1"/>
          </p:sldLayoutIdLst>
          <p:txStyles>
            <p:titleStyle><a:lstStyle/></p:titleStyle>
            <p:bodyStyle><a:lstStyle/></p:bodyStyle>
            <p:otherStyle><a:lstStyle/></p:otherStyle>
          </p:txStyles>
        </p:sldMaster>
        """

    private static let pptxSlideMasterRels = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId1"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout"
            Target="../slideLayouts/slideLayout1.xml"/>
          <Relationship Id="rId2"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme"
            Target="../theme/theme1.xml"/>
        </Relationships>
        """

    private static let pptxTheme = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office Theme">
          <a:themeElements>
            <a:clrScheme name="Office">
              <a:dk1><a:sysClr lastClr="000000" val="windowText"/></a:dk1>
              <a:lt1><a:sysClr lastClr="ffffff" val="window"/></a:lt1>
              <a:dk2><a:srgbClr val="44546A"/></a:dk2>
              <a:lt2><a:srgbClr val="E7E6E6"/></a:lt2>
              <a:accent1><a:srgbClr val="4472C4"/></a:accent1>
              <a:accent2><a:srgbClr val="ED7D31"/></a:accent2>
              <a:accent3><a:srgbClr val="A9D18E"/></a:accent3>
              <a:accent4><a:srgbClr val="FFC000"/></a:accent4>
              <a:accent5><a:srgbClr val="5B9BD5"/></a:accent5>
              <a:accent6><a:srgbClr val="70AD47"/></a:accent6>
              <a:hlink><a:srgbClr val="0563C1"/></a:hlink>
              <a:folHlink><a:srgbClr val="954F72"/></a:folHlink>
            </a:clrScheme>
            <a:fontScheme name="Office">
              <a:majorFont><a:latin typeface="Calibri Light"/><a:ea typeface=""/><a:cs typeface=""/></a:majorFont>
              <a:minorFont><a:latin typeface="Calibri"/><a:ea typeface=""/><a:cs typeface=""/></a:minorFont>
            </a:fontScheme>
            <a:fmtScheme name="Office">
              <a:fillStyleLst>
                <a:solidFill><a:schemeClr val="phClr"/></a:solidFill>
                <a:solidFill><a:schemeClr val="phClr"/></a:solidFill>
                <a:solidFill><a:schemeClr val="phClr"/></a:solidFill>
              </a:fillStyleLst>
              <a:lnStyleLst>
                <a:ln w="6350"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln>
                <a:ln w="12700"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln>
                <a:ln w="19050"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln>
              </a:lnStyleLst>
              <a:effectStyleLst>
                <a:effectStyle><a:effectLst/></a:effectStyle>
                <a:effectStyle><a:effectLst/></a:effectStyle>
                <a:effectStyle><a:effectLst/></a:effectStyle>
              </a:effectStyleLst>
              <a:bgFillStyleLst>
                <a:solidFill><a:schemeClr val="phClr"/></a:solidFill>
                <a:solidFill><a:schemeClr val="phClr"/></a:solidFill>
                <a:solidFill><a:schemeClr val="phClr"/></a:solidFill>
              </a:bgFillStyleLst>
            </a:fmtScheme>
          </a:themeElements>
        </a:theme>
        """

    // MARK: - XLSX

    private static let xlsxContentTypes = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
          <Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
          <Default Extension="xml"  ContentType="application/xml"/>
          <Override PartName="/xl/workbook.xml"
            ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sheet.main+xml"/>
          <Override PartName="/xl/worksheets/sheet1.xml"
            ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.worksheet+xml"/>
          <Override PartName="/xl/sharedStrings.xml"
            ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.sharedStrings+xml"/>
          <Override PartName="/xl/styles.xml"
            ContentType="application/vnd.openxmlformats-officedocument.spreadsheetml.styles+xml"/>
          <Override PartName="/docProps/app.xml"
            ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
        </Types>
        """

    private static let xlsxRels = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId1"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument"
            Target="xl/workbook.xml"/>
          <Relationship Id="rId2"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties"
            Target="docProps/app.xml"/>
        </Relationships>
        """

    private static let xlsxWorkbook = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <workbook xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main"
                  xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships">
          <sheets>
            <sheet name="Sheet1" sheetId="1" r:id="rId1"/>
          </sheets>
        </workbook>
        """

    private static let xlsxWorkbookRels = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
          <Relationship Id="rId1"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/worksheet"
            Target="worksheets/sheet1.xml"/>
          <Relationship Id="rId2"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/sharedStrings"
            Target="sharedStrings.xml"/>
          <Relationship Id="rId3"
            Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/styles"
            Target="styles.xml"/>
        </Relationships>
        """

    private static let xlsxSheet = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <worksheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
          <sheetData/>
        </worksheet>
        """

    private static let xlsxSharedStrings = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <sst xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main" count="0" uniqueCount="0"/>
        """

    private static let xlsxStyles = """
        <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
        <styleSheet xmlns="http://schemas.openxmlformats.org/spreadsheetml/2006/main">
          <fonts count="1"><font><sz val="11"/><name val="Calibri"/></font></fonts>
          <fills count="2">
            <fill><patternFill patternType="none"/></fill>
            <fill><patternFill patternType="gray125"/></fill>
          </fills>
          <borders count="1"><border><left/><right/><top/><bottom/><diagonal/></border></borders>
          <cellStyleXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0"/></cellStyleXfs>
          <cellXfs count="1"><xf numFmtId="0" fontId="0" fillId="0" borderId="0" xfId="0"/></cellXfs>
        </styleSheet>
        """
}
