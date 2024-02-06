#!/bin/bash

# Check if the correct number of arguments is provided
if [ "$#" -ne 8 ]; then
    echo "Usage: $0 <MINX> <MINZ> <MAXX> <MAXZ> <MINY> <MAXY> <WORLDNAME> <OUTNAME>"
    exit 1
fi

# Assign arguments to variables for better readability
MINX=$1
MINZ=$2
MAXX=$3
MAXZ=$4
MINY=$5
MAXY=$6
WORLDNAME=$7
OUTNAME=$8

# Create a temporary directory
mkdir -p temp

# Run the Java command with the provided arguments
java -jar jMc2Obj-122.jar -o=temp -a=${MINX},${MINZ},${MAXX},${MAXZ} -h=${MINY},${MAXY} -d=0 --offset=center --render-sides ${WORLDNAME}

cd temp
# Convert the OBJ file to USDZ using usdzconvert
usdzconvert ./minecraft.obj ../${OUTNAME}.usdz -useObjMtl -metallic 0 -roughness 1

cd ..
# Optional: Clean up the temporary directory after conversion
# rm -rf temp
