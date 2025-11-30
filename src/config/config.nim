import dotenv
import os
type
    Config* = object
        logLevel*: string
        removePath*: string
        password*: string
        user*: string
        database*: string

proc loadConfig(): Config =
    try:
        dotenv.load()
    except CatchableError as e:
        when defined(debug):
            echo e.msg

    result.logLevel = getEnv("LOGLEVEL", "info")
    result.removePath = getEnv("REMOVE_PATH")
    result.password = getEnv("PASSWORD")
    result.user = getEnv("USER")
    result.database = getEnv("DATABASE")

let configInstance* = loadConfig()
