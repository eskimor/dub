#!/bin/sh
set -e

LIBS=`pkg-config --libs libcurl 2>/dev/null || echo "-lcurl"`
LIBS=`echo "$LIBS" | sed 's/^-L/-L-L/; s/ -L/ -L-L/g; s/^-l/-L-l/; s/ -l/ -L-l/g'`

# HACK to work around (r)dmd placing -lcurl before the object files - which is wrong if --as-needed is used
# On newer Ubuntu versions this is the default, though
uname -a | grep "Ubuntu" > /dev/null && LIBS="-L--no-as-needed $LIBS"

rdmd --build-only -ofbin/dub -g -debug -w -property -Isource $* $LIBS source/app.d
echo DUB has been built as bin/dub