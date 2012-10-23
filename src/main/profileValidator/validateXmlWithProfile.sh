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

if [ -r "$SCHEMA" ]; then
    xmllint --noout --schema "$SCHEMA" "$XML"
    RETURNCODE=$?
    if [ $RETURNCODE -ne 0 ]; then
        exit $RETURNCODE
    fi
fi


#compile the profile
compileProfile $CHANNELID $CACHEDIR


if [ ! -e "$CACHEDIR/compiledProfile_$CHANNELID.xsl" ];
then
    CHANNELID="default"
fi



#evaluate the profile
xsltproc $CACHEDIR/compiledProfile_$CHANNELID.xsl $XML > $logDir/$ENTITY.xml 2> "$logDir/$ENTITY-errors.xml"

if [ -s "$logDir/$ENTITY-errors.xml" -o -s "$logDir/$ENTITY.xml" ]; then
    error "$(cat $logDir/$ENTITY.xml) \n $(cat $logDir/$ENTITY.xml)"
    cat "$logDir/$ENTITY.xml"
    cat "$logDir/$ENTITY-errors.xml" 1>&2
    exit 1
else
    echo "{"
    echo "\"valid\" : true"
    echo "}"
    rm "$logDir/$ENTITY.xml"
    rm "$logDir/$ENTITY-errors.xml"
fi

#rm -r $TEMPDIR
