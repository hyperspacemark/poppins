struct FileInfo {
    let path: String
    let rev: String
}

extension FileInfo {
    static func fromDropboxMetadata(_ metadata: DBMetadata) -> FileInfo {
        return FileInfo(path: NSURL(fileURLWithPath: metadata.path).lastPathComponent!, rev: metadata.rev)
    }
}
