#!/bin/bash

ENTITY=$1
XML=$2
CONFIG=$3
CHANNELID=$4

source $CONFIG
mkdir -p $logDir
mkdir -p $CACHEDIR


SCRIPT_PATH="$(dirname $(readlink -f $BASH_SOURCE[0]))"
source $SCRIPT_PATH/logging.sh
source $SCRIPT_PATH/compileProfile.sh


#compile the profile
compileProfile $CHANNELID $CACHEDIR


if [ ! -e "$CACHEDIR/compiledProfile_$CHANNELID.xsl" ];
then
    CHANNELID="default"
fi



#evaluate the profile
ERRORS=`xsltproc $CACHEDIR/compiledProfile_$CHANNELID.xsl $XML 2> $logDir/$ENTITY.xml 2>&1`

if [ -n "$ERRORS" -o -s "$logDir/$ENTITY.xml" ]; then
    echo "$ERRORS" >> "$logDir/$ENTITY-errors.xml"
    error "$ERRORS \n `cat $logDir/$ENTITY.xml`"
    cat "$logDir/$ENTITY.xml"
    exit 1
else
    echo "{"
    echo "\"valid\" : true"
    echo "}"
    rm "$logDir/$ENTITY.xml"
fi

#rm -r $TEMPDIR
