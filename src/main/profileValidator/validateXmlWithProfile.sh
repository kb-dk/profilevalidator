#!/bin/bash

XML=$1
CONFIG=$2
CHANNELID=$3

source $CONFIG

SCRIPT_PATH="$(dirname $(readlink -f $0))"

source $SCRIPT_PATH/common.sh

TEMPDIR=`mktemp -d`

#compile the profile
$SCRIPT_PATH/compileProfile.sh $CONFIG $CHANNELID $TEMPDIR

#evaluate the profile
ERRORS=`xsltproc $TEMPDIR/compiledProfile_$CHANNELID.xsl $XML 2> $TEMPDIR/result.xml 2>&1`
breakup "$ERRORS"

if [ -s $TEMPDIR/result.xml ]; then
    error "`cat $TEMPDIR/result.xml`"
    cat $TEMPDIR/result.xml
    rm -r $TEMPDIR
else
    echo "{"
    echo "\"valid\" : true"
    echo "}"
    rm -r $TEMPDIR
fi