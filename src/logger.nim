import logging, strutils
import config / config
proc initLogger*(): void =
    var handler = newConsoleLogger(fmtStr = "$time [$levelname] $message")
    addHandler(handler)
    let level = config.configInstance.logLevel.toLower()
    case level:
        of "debug":
            setLogFilter(lvlDebug)
        of "info":
            setLogFilter(lvlInfo)
        of "warning":
            setLogFilter(lvlWarn)
        of "error":
            setLogFilter(lvlError)
        else:
            echo "Invalid LOGLEVEL, defaulting to info"
