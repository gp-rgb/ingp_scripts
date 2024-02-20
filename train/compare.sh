#!/bin/bash
data=/home/ubuntu/georgia/data/
train=/home/ubuntu/georgia/ingp_scripts/train/
DS=orchid
TYP=record3d

cd ${data}/${DS}/
rm -r ${DS}_renders_*
rm ${DS}_nerfs_${TYP}.zip
rm -r *.obj
cd ${train}

# generate metadata
./train.sh ${TYP} ${DS} -o -n 0 -d 11

#train and render
for N in 32000 
do
        ./train.sh ${TYP} ${DS} -n ${N} -r
done 

# mesh latest (greatest amount of training)
for M in 64 128 256 512
do
        ./train.sh ${TYP} ${DS} -l -m ${M}
done 

cd ../data/${DS}/
zip -r ${DS}_nerfs_${TYP}.zip \
        ${DS}_renders_*.zip \
        *.obj
