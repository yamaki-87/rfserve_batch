import ../domain/downloadlinks
import times, os, logging, strutils
type
    RfserveRmService*[T: DownloadLinksMapper] = object
        mapper: T


proc deleteOldFiles*[T: DownloadLinksMapper](self: RfserveRmService[T],
        dir: string, remove_id: string) =
    for kind, path in walkDir(dir):
        if kind != pcFile:
            continue
        let fname = extractFilename(path)
        if remove_id in fname:
            logging.info "削除対象ファイル：", fname
            try:
                removeFile(path)
            except OSError as e:
                logging.error("file name :", $fname, " failed to delete:",
                        e.msg, " type:", e.name)

proc execute*[T: DownloadLinksMapper](self: RfserveRmService[T],
        removePath: string) =
    logging.info "rfserve削除batch start"
    try:
        let now = now()
        let entities = self.mapper.selectByTime(now)
        logging.info "削除対象レコード：", repr(entities)
        self.mapper.deleteByTime(now)
        for e in entities:
            self.deleteOldFiles(removePath, e.object_path)
    except CatchableError as e:
        logging.error("execute error:", e.msg, " type:", e.name)
    logging.info "rfserve削除batch end"

proc newRfserveRmService*[T: DownloadLinksMapper](mapper: T): RfserveRmService[T] =
    result.mapper = mapper
