#!/bin/bash

function compileProfile(){

local CHANNELID=$1
local OUTDIR=$2

local SPECIFIC_PROFILE="${CHANNELID}_${PROFILE}"


inf "Compiling for channel $CHANNELID"
inf "Compiling specific profile '$PROFILE_DIR/$SPECIFIC_PROFILE' "


if [ ! -e $PROFILE_DIR/$SPECIFIC_PROFILE  ];
then
    warn "$CHANNELID does not have a profile, using default"
    CHANNELID="default"
    SPECIFIC_PROFILE="${CHANNELID}_${PROFILE}"
fi

if [ $OUTDIR/compiledProfile_$CHANNELID.xsl -nt $PROFILE_DIR/$SPECIFIC_PROFILE ];
then
    debug "$CHANNELID is already compiled, will not recompile"
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
}