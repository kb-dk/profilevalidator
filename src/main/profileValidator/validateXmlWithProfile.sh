#!/bin/bash

XML=$1
PROFILE=$2

pushd . > /dev/null
SCRIPT_PATH="${BASH_SOURCE[0]}";
if ([ -h "${SCRIPT_PATH}" ]) then
  while([ -h "${SCRIPT_PATH}" ]) do cd `dirname "$SCRIPT_PATH"`; SCRIPT_PATH=`readlink "${SCRIPT_PATH}"`; done
fi
cd `dirname ${SCRIPT_PATH}` > /dev/null
SCRIPT_PATH=`pwd`;
popd  > /dev/null



TEMPDIR=`mktemp -d`

#transform the profile to xslt
xsltproc -o $TEMPDIR/step1.xsl $SCRIPT_PATH/schematron/iso_dsdl_include.xsl $PROFILE
xsltproc -o $TEMPDIR/step2.xsl $SCRIPT_PATH/schematron/iso_abstract_expand.xsl $TEMPDIR/step1.xsl
xsltproc -o $TEMPDIR/step3.xsl $SCRIPT_PATH/schematron/iso_schematron_message.xsl $TEMPDIR/step2.xsl

#evaluate the profile
xsltproc $TEMPDIR/step3.xsl $XML 2> $TEMPDIR/result.xml


if [ -s $TEMPDIR/result.xml ]; then
    cat $TEMPDIR/result.xml
    rm -r $TEMPDIR
else
    echo "{"
    echo "\"valid\" : true"
    echo "}"
    rm -r $TEMPDIR
fi


