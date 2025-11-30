# Package

version       = "0.1.0"
author        = "Ipsen87k"
description   = "A new awesome nimble package"
license       = "MIT"
srcDir        = "src"
bin           = @["rfserve_batch"]


# Dependencies

requires "nim >= 2.2.4"
requires "db_connector"
requires "dotenv"