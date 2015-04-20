#!/bin/bash

PROFILE=vhsfileingestffprobe.sch

PROFILE_DIR=$SCRIPT_PATH/schematron

logDir=$SCRIPT_PATH
logFile=$logDir/ffprobeProfileValidation.log

LOCKFILE=$SCRIPT_PATH/ffProbeProfileValidationLogLock

CACHEDIR=$SCRIPT_PATH
verbosity=3 # default to show warnings
#silent_lvl=0
#err_lvl=1
#wrn_lvl=2
#inf_lvl=3
#dbg_lvl=4


