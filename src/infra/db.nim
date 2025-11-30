import times, logging
import db_connector/db_postgres
import ../domain/downloadlinks
import ../config/config
type
    DB* = ref object
        conn: DbConn

    DownloadLinksMapperImpl* = object
        db: DB

proc dbInit*(): DB =
    try:
        new(result)
        let conn = open("", configInstance.user, configInstance.password,
                configInstance.database)
        result.conn = conn
    except CatchableError as e:
        logging.fatal "db初期化失敗：", e.msg, " trace:", e.trace

proc dbClose*(self: DB) =
    self.conn.close()

proc begin*(self: DB) {.inline.} =
    self.conn.exec(sql"BEGIN")

proc commit*(self: DB) {.inline.} =
    self.conn.exec(sql"COMMIT")

proc rollback*(self: DB) {.inline.} =
    self.conn.exec(sql"ROLLBACK")

proc toDownloadLinks(row: Row): DownloadLinks =
    result.url = row[0];
    result.object_path = row[1];

proc deleteByTime*(self: DownloadLinksMapperImpl, time: DateTime) =
    try:
        self.db.begin()
        self.db.conn.exec(sql"DELETE FROM downloadlinks WHERE expires_at <= ?", $time)
        self.db.commit()
    except CatchableError as e:
        logging.error "DB処理失敗", e.msg, " type:", e.name
        self.db.rollback()

proc selectByTime*(self: DownloadLinksMapperImpl, time: DateTime): seq[
        DownloadLinks] =
    let rows = self.db.conn.getAllRows(sql"select url,object_path from downloadlinks WHERE expires_at <= ?", $time)
    result = @[]
    for r in rows:
        result.add toDownloadLinks(r)

proc newDownloadLinksMapper*(db: DB): DownloadLinksMapperImpl =
    result.db = db
