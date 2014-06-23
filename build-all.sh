#!/bin/bash
source ./setenv-android-4.1.sh

export XPLATFORM=andorid-9
for XARCH in arm arm-v7a x86
do
	environment_setup -a $XARCH -t $XPLATFORM

	make clean
	make
done
