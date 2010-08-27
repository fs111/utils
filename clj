#!/bin/bash

# simple bash script to create a clj command
# we want nice commandline editing, so we wrap the REPL
# with jline, if we have arguments, we can ommit the jline


if [ -z "$1" ]
    then
    java jline.ConsoleRunner clojure.main
else
    java clojure.main $*
fi
