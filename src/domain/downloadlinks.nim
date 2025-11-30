import times
type
    DownloadLinks* = object
        url*: string
        object_path*: string

type
    DownloadLinksMapper* = concept x
        deleteByTime(x, DateTime)
        selectByTime(x, DateTime) is seq[DownloadLinks]



