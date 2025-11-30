# This is just an example to get you started. A typical binary package
# uses this file as the main entry point of the application.
import infra / db
import service / rfservermservice
import logger
import config / config
when isMainModule:
  logger.initLogger()
  let db_con = dbInit()
  let downloadLinksMapper = newDownloadLinksMapper(db_con)
  let service = newRfserveRmService(downloadLinksMapper)
  service.execute(configInstance.removePath)

  db_con.dbClose()
