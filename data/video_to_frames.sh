#!/bin/bash
vid_dir=$1
num_images=$2
vid_path=`ls ${vid_dir}/*.mp4`
echo $vid_dir
rm -r ${vid_dir}/images/
mkdir ${vid_dir}/images/
duration=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 ${vid_path}`

echo $duration
fps=`python -c "print( $num_images / $duration)"`
echo $fps
ffmpeg -i ${vid_path} -vf fps=${fps} ${vid_dir}/images/%03d.png
