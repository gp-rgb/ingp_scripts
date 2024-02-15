#!/bin/bash
DS=still_life_frames
TYP=images

cd ../data/${DS}/
rm -r ${DS}_renders_*
rm ${DS}_nerfs_${TYP}.zip
cd ../../ingp_scripts/
./train.sh ${TYP} ${DS} -o -n 500 -r
./train.sh ${TYP} ${DS} -n 1000 -r
./train.sh ${TYP} ${DS} -n 2000 -r
./train.sh ${TYP} ${DS} -n 4000 -r
./train.sh ${TYP} ${DS} -n 8000 -r
./train.sh ${TYP} ${DS} -n 16000 -r
./train.sh ${TYP} ${DS} -n 32000 -r


cd ../data/${DS}/
zip ${DS}_nerfs_${TYP}.zip \
        ${DS}_renders_500.zip \
        ${DS}_renders_1000.zip \
        ${DS}_renders_2000.zip \
        ${DS}_renders_4000.zip \
        ${DS}_renders_8000.zip \
        ${DS}_renders_16000.zip \
        ${DS}_renders_32000.zip 
