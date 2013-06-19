#!/bin/bash

pandoc -s -f markdown -t html $1 | elinks -force-html
