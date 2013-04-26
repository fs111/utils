#!/bin/bash
set -e

<< DOC
simple bash script that starts a lighttpd in the given directory in the
forground intended to be used in an interactive shell for quick and easy
sharing of files. Inspired by the builtin web server of python (python -m
SimpleHTTPServer) and the usage of lighttpd in git instaweb

Written by André Kelpe <efeshundertelf [at] googlemail [dot] com>
Licence: Do whatever you like with it, but don't kill
         kittens or puppies with it!
DOC

# make sure we got exactly one param that is an existing directory
if [ ! $# -eq 1 ]
then
    echo "usage qs <directory>"
    exit 1
fi

DIRECTORY=$1
if [ ! -d $1 ]
 then
    echo "cannot find directory: ${DIRECTORY}"
    exit 1
fi

# listening on port 8000, change if needed
PORT=8000

# not incredible secure, but we need a file for lighty and we do not know if
# $DIRECTORY is writable
TMPCONF=`mktemp`

# filling out config template
cat > $TMPCONF << EOC

server.document-root = "${DIRECTORY}/"
server.port = ${PORT}
dir-listing.activate = "enable"
dir-listing.encoding  = "utf-8"
dir-listing.hide-dotfiles = "enable"
#ugly, ugly, but we want to serve some mime types...
mimetype.assign             = (
  ".rpm"          =>      "application/x-rpm",
  ".pdf"          =>      "application/pdf",
  ".sig"          =>      "application/pgp-signature",
  ".spl"          =>      "application/futuresplash",
  ".class"        =>      "application/octet-stream",
  ".ps"           =>      "application/postscript",
  ".torrent"      =>      "application/x-bittorrent",
  ".dvi"          =>      "application/x-dvi",
  ".gz"           =>      "application/x-gzip",
  ".pac"          =>      "application/x-ns-proxy-autoconfig",
  ".swf"          =>      "application/x-shockwave-flash",
  ".tar.gz"       =>      "application/x-tgz",
  ".tgz"          =>      "application/x-tgz",
  ".tar"          =>      "application/x-tar",
  ".zip"          =>      "application/zip",
  ".mp3"          =>      "audio/mpeg",
  ".m3u"          =>      "audio/x-mpegurl",
  ".wma"          =>      "audio/x-ms-wma",
  ".wax"          =>      "audio/x-ms-wax",
  ".ogg"          =>      "application/ogg",
  ".wav"          =>      "audio/x-wav",
  ".gif"          =>      "image/gif",
  ".jar"          =>      "application/x-java-archive",
  ".jpg"          =>      "image/jpeg",
  ".jpeg"         =>      "image/jpeg",
  ".png"          =>      "image/png",
  ".xbm"          =>      "image/x-xbitmap",
  ".xpm"          =>      "image/x-xpixmap",
  ".xwd"          =>      "image/x-xwindowdump",
  ".css"          =>      "text/css",
  ".html"         =>      "text/html",
  ".htm"          =>      "text/html",
  ".js"           =>      "text/javascript",
  ".asc"          =>      "text/plain",
  ".c"            =>      "text/plain",
  ".cpp"          =>      "text/plain",
  ".log"          =>      "text/plain",
  ".conf"         =>      "text/plain",
  ".text"         =>      "text/plain",
  ".txt"          =>      "text/plain",
  ".dtd"          =>      "text/xml",
  ".xml"          =>      "text/xml",
  ".mpeg"         =>      "video/mpeg",
  ".mpg"          =>      "video/mpeg",
  ".mov"          =>      "video/quicktime",
  ".qt"           =>      "video/quicktime",
  ".avi"          =>      "video/x-msvideo",
  ".asf"          =>      "video/x-ms-asf",
  ".asx"          =>      "video/x-ms-asf",
  ".wmv"          =>      "video/x-ms-wmv",
  ".bz2"          =>      "application/x-bzip",
  ".tbz"          =>      "application/x-bzip-compressed-tar",
  ".tar.bz2"      =>      "application/x-bzip-compressed-tar",
  # default mime type
  ""              =>      "application/octet-stream",
 )
EOC

echo "starting lighttpd at 0.0.0.0:${PORT}. use ctrl-c to stop."
echo "your URLs are"
LANG=C
for ip in $( /sbin/ifconfig | grep "inet addr" | awk -F: '{print $2}' | awk '{print $1}')
do
    echo http://${ip}:${PORT}/
done
echo "---------------------------------------"
/usr/sbin/lighttpd -D -f $TMPCONF > /dev/null # enjoy the silence :)

rm $TMPCONF
