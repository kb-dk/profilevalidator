#!/bin/bash

CONFIG=$1
CHANNELID=$2
OUTDIR=$3

SPECIFIC_PROFILE="${CHANNELID}_${PROFILE}"

source $CONFIG

SCRIPT_PATH="$(dirname $(readlink -f $0))"

source $SCRIPT_PATH/common.sh

if [ ! -e $PROFILE_DIR/$SPECIFIC_PROFILE  ];
then
    CHANNELID="default"
    SPECIFIC_PROFILE="${CHANNELID}_${PROFILE}"
fi

if [ $OUTDIR/compiledProfile_$CHANNELID.xsl -nt $PROFILE_DIR/$SPECIFIC_PROFILE ];
then
  return
fi

#transform the profile to xslt
ERRORS=`xsltproc -o $OUTDIR/step1_$CHANNELID.xsl $SCRIPT_PATH/schematron/iso_dsdl_include.xsl $PROFILE_DIR/$SPECIFIC_PROFILE 2>&1`
breakup "$ERRORS"

ERRORS=`xsltproc -o $OUTDIR/step2_$CHANNELID.xsl $SCRIPT_PATH/schematron/iso_abstract_expand.xsl $OUTDIR/step1_$CHANNELID.xsl 2>&1`
breakup "$ERRORS"
rm "$OUTDIR/step1_$CHANNELID.xsl"

ERRORS=`xsltproc -o $OUTDIR/compiledProfile_$CHANNELID.xsl $SCRIPT_PATH/schematron/iso_schematron_message.xsl $OUTDIR/step2_$CHANNELID.xsl 2>&1`
breakup "$ERRORS"
rm "$OUTDIR/step2_$CHANNELID.xsl"

#notify "transformation done"
