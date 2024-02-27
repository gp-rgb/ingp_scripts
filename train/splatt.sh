#!/bin/bash
conda init bash
source ~/.bashrc
eval "$(conda shell.bash hook)"
conda activate gaussian_splatting

## DATA SETTINGS
create_dataset=0
iterations=8000
number_images=100
render=0
sweep=0
checkpoints=[ 125 250 500 1000 2000 4000 8000 ]
prune=0

## PARSE ARGUMENTS
if [ $# -lt 1 ]; then
    echo "Usage: $(basename $0) [DATASET]..."
    exit 1
fi
name="$1"
shift 1

while getopts 'c:i:p:rsh' opt; do
  case "$opt" in
    c|create_dataset)
        create_dataset=1
        number_images=${OPTARG}
        ;;
    i|iterations)
        iterations=${OPTARG}
        ;;
    p|prune)
        prune=${OPTARG}
        ;;
    r|render)
        render=1
        ;;
    s|sweep)
        sweep=1
        ;;
    ?|h)
        echo "Usage: $(basename $0) [DATASET]..."
        echo "  Optional arguments:"
        echo "  -c, --create_dataset <number of images>"
        echo "          Creates symlinks to an existing directory of images. Runs colmap."
        echo "  -i, --iterations <number>"
        echo "          Number of iterations to run Training for."
        echo "  -p, --prune <percentage of images to remove>"
        echo "          Whether to prune images with motion blur during dataset during creation (Desired dataset size will be preserved)."
        echo "  -r, --render"
        echo "          Whether to render images from the model after Training."
        echo "  -s, --sweep"
        echo "          Whether to generate Renders/Point Clouds at multiple stages during Training."
      
      exit 1
      ;;
  esac
done

#shift "$(($OPTIND -1))"
#echo $number_images
#echo $iterations
#echo $prune

## PATH SETTINGS
splatt_path=/home/ubuntu/georgia/splatt/gaussian-splatting/
home_path=/home/ubuntu/georgia/ingp_scripts/
data_path=/home/ubuntu/georgia/data/
colmap_path=/home/ubuntu/georgia/colmap/build/src/colmap/exe/colmap

images_source="images" 
images_dest="input"
source_path=${data_path}/${name}/
dest_path=${data_path}/${name}_splatt/
images_path=${dest_path}/${images_source}/
model_path=${dest_path}/${name}_model/

### CREATE DATASET
if [ "$create_dataset" -eq 1 ]; then
        rm -r $dest_path
        num_links=`python -c "print( round($number_images / (1 - ($prune/100)) ))"`
        #echo "NUM Images is ${number_images}"
        #echo "NUM LINKS is ${num_links}"
        ${home_path}/data/create_linked_dataset.sh ${source_path} ${dest_path} -n ${num_links} -s ${images_source} -d ${images_dest}
        python ${home_path}/data/motion_blur.py ${images_path} --delete True --percentage ${prune}
fi

### RUN COLMAP
cd ${splatt_path}
start=$(date +%s.%N)
python convert.py \
        -s ${dest_path}/ \
        --colmap_executable ${colmap_path}
dur=$(echo "$(date +%s.%N) - $start" | bc)
printf "Colmap Execution Time: %.6f seconds" $dur

### TRAIN SPLATT

if [ "$sweep" -eq 1 ]; then
        ## SWEEP
        if [ "$render" -eq 1 ]; then
                ## SWEEP MODELS MUST BE TRAINED ONE AT A TIME IF RENDERING
                for N in ${checkpoints}
                do
                        echo $N
                        python train.py \
                                --iterations ${N} \
                                --eval \
                                -s ${dest_path} \
                                -m ${model_path} \
                                --save_iterations ${N} 
                        python render.py \
                                --eval \
                                -m ${model_path}
                        
                done
        else   
                ## SWEEP MODELS TRAINED AT THE SAME TIME IF NOT RENDERING
                python train.py \
                        --iterations ${iterations} \
                        --eval \
                        -s ${dest_path} \
                        -m ${model_path} \
                        --save_iterations ${N} 
        fi
else
        ## NO SWEEP
        python train.py \
                --iterations ${iterations} \
                --eval \
                -s ${dest_path} \
                -m ${model_path} \
                --save_iterations ${iterations}

        if [ "$render" -eq 1 ]; then
            python render.py \
                    --eval \
                    -m ${model_path}
        fi
fi

### ZIP RESULTS
cd ${dest_path}
zip ${name}_model.zip ./${name}_model/  -r

