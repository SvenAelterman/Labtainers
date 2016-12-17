#!/usr/bin/env bash

# parameterize.sh
#
# Usage: parameterize.sh <LAB_INSTANCE_SEED>
# Arguments:
#     <LAB_INSTANCE_SEED> -- laboratory instance seed
# 
# Description:
# 1. Call ParameterParser.py (passing $LAB_INSTANCE_SEED)
# 2. If file .local/bin/fixlocal.sh exist, run it

#echo "Parameterizing laboratory"

# Configuration variables
LAB_SEEDFILE="/home/ubuntu/.local/.seed"
USER_EMAILFILE="/home/ubuntu/.local/.email"
LAB_NAMEFILE="/home/ubuntu/.local/.labname"
LAB_PARAMCONFIGFILE="/home/ubuntu/.local/config/parameter.config"

# Do not display instruction during parameterization
LOCKDIR=/tmp/.mylockdir
mkdir "$LOCKDIR" >/dev/null 2>&1

#echo "number of argument is $#"
#echo "argument is $@"

if [ $# -ne 3 ]
then
    echo "Usage: parameterize.sh <LAB_INSTANCE_SEED> <USER_EMAIL> <LAB_NAME>"
    echo "       <LAB_INSTANCE_SEED> -- laboratory instance seed"
    echo "       <USER_EMAIL> -- user's e-mail"
    echo "       <LAB_NAME> -- name of the lab"
    exit 1
fi

LAB_INSTANCE_SEED=$1
USER_EMAIL=$2
LAB_NAME=$3

# Laboratory instance seed is always stored in $LAB_SEEDFILE
echo "$LAB_INSTANCE_SEED" > $LAB_SEEDFILE
# User's e-mail is always stored in $USER_EMAILFILE
echo "$USER_EMAIL" > $USER_EMAILFILE
echo "$LAB_NAME" > $LAB_NAMEFILE

# call ParameterParser.py (passing $LAB_INSTANCE_SEED)
sudo /home/ubuntu/.local/bin/ParameterParser.py $LAB_INSTANCE_SEED $LAB_PARAMCONFIGFILE

# If file /home/ubuntu/.local/bin/fixlocal.sh exist, run it
if [ -f /home/ubuntu/.local/bin/fixlocal.sh ]
then
    /home/ubuntu/.local/bin/fixlocal.sh 2>>/tmp/fixlocal.output
fi

rmdir $LOCKDIR

