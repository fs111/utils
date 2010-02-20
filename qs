#!/bin/bash -u

<< DOC
simple bash script that starts a lighttpd in the given directory in the
forground intended to be used in an interactive shell for quick and easy
sharing of files. Inspired by the builtin web server of python (python -m
SimpleHTTPServer) and the usage of lighttpd in git instaweb

Written by André Kelpe
License: Do whatever you like with it!
DOC

DIRECTORY=$1

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
EOC

echo "starting lighttpd at 0.0.0.0:${PORT}. use ctrl-c to stop."
lighttpd -D -f $TMPCONF > /dev/null # enjoy the silence :)

rm $TMPCONF
