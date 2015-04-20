#!/bin/bash

set -x

export SCRIPT_PATH=$(dirname $(readlink -f $0))
#This test will be done later
export VHSINGEST_LOGS=$PWD
rm $SCRIPT_PATH/compiledProfile_default.xsl
../../main/profileValidator/validateXmlWithProfile.sh entity test.xml $SCRIPT_PATH/unittest1_config.sh default
