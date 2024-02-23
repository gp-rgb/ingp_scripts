#./train.sh video chair -f 15 -o -n 0
python ../data/motion_blur.py ../../data/chair_frames/images/ --thresh 250
./train.sh images chair_frames -o -n 1000 > logs_no_prune.txt
python ../data/motion_blur.py ../../data/chair_frames/images/ --thresh 250 --delete True
./train.sh images chair_frames -o -n 1000 > logs_prune.txt
