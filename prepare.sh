#!/bin/sh

set -e

dirname=`dirname $0`
abs_dirname=`readlink -f $dirname`
base_dirname=`basename $abs_dirname`
[ tiedot != "$base_dirname" ] && echo Please execute this script from cloned tiedot repository && exit 1

prepare_ver=$1
[ -z "$prepare_ver" ] && echo Please specify the version to be prepared for distribution && exit 1
[ -z "$GOPATH" ] && echo GOPATH is not set && exit 1

rm -rf ./src/* $GOPATH/pkg $GOPATH/bin $GOPATH/src/github.com/HouzuoGuo/tiedot/tiedot 
pushd $GOPATH/src/github.com/HouzuoGuo/tiedot
git checkout master && git pull && git checkout $prepare_ver
go clean && go get
popd

rm -rf ./tiedot*
cp -R $GOPATH/src ./
pushd src
find . -name '.git*' -exec rm -rf {} \; || true
find . -name '.hg*' -exec rm -rf {} \; || true
popd

echo Done
