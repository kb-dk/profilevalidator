#!/bin/bash

XML=$1
CONFIG=$2

source $CONFIG

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null

source $SCRIPT_PATH/logging.sh

breakup() {
  if [ -n "$1" ]; then
    error "$1"
    rm -r $TEMPDIR
    exit 1
  fi
}


TEMPDIR=`mktemp -d`

#transform the profile to xslt
ERRORS=`xsltproc -o $TEMPDIR/step1.xsl $SCRIPT_PATH/schematron/iso_dsdl_include.xsl $PROFILE 2>&1`
breakup "$ERRORS"

ERRORS=`xsltproc -o $TEMPDIR/step2.xsl $SCRIPT_PATH/schematron/iso_abstract_expand.xsl $TEMPDIR/step1.xsl 2>&1`
breakup "$ERRORS"

ERRORS=`xsltproc -o $TEMPDIR/step3.xsl $SCRIPT_PATH/schematron/iso_schematron_message.xsl $TEMPDIR/step2.xsl 2>&1`
breakup "$ERRORS"

#notify "transformation done"

#evaluate the profile
ERRORS=`xsltproc $TEMPDIR/step3.xsl $XML 2> $TEMPDIR/result.xml 2>&1`
breakup "$ERRORS"

if [ -s $TEMPDIR/result.xml ]; then
    cat $TEMPDIR/result.xml
    rm -r $TEMPDIR
else
    echo "{"
    echo "\"valid\" : true"
    echo "}"
    rm -r $TEMPDIR
fi
