#!/bin/bash
source ./setenv-android-4.1.sh

export XPLATFORM=andorid-9
for XARCH in x86 arm arm-v7a
do
	environment_setup -a $XARCH -t $XPLATFORM

	make clean
	make
done
