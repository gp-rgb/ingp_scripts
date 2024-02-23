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
        echo "  -p, --prune"
        echo "          Whether to prune images with motion blur during dataset during creation."
        echo "  -r, --render"
        echo "          Whether to render images from the model after Training."
        echo "  -s, --sweep"
        echo "          Whether to generate Renders/Point Clouds at multiple stages during Training."
      
      exit 1
      ;;
  esac
done
shift "$(($OPTIND -1))"
echo $number_images
echo $iterations
echo $prune
## PATH SETTINGS
splatt_path=/home/ubuntu/georgia/splatt/gaussian-splatting/
home_path=/home/ubuntu/georgia/ingp_scripts/
data_path=/home/ubuntu/georgia/data/
colmap_path=/home/ubuntu/georgia/colmap/build/src/colmap/exe/colmap

input_path=${data_path}/${name}/
output_path=${data_path}/${name}_splatt/
model_path=$output_path/${name}_model/

### CREATE DATASET
if [ "$create_dataset" -eq 1 ]; then
        num_links=`python -c "print(round( (($prune/100.0)+1) * $number_images ))"`
    
        echo "NUM Images is ${number_images}"
        echo "NUM LINKS is ${num_links}"
        ${home_path}/data/create_linked_dataset.sh ${input_path} ${output_path} -n ${num_links} -s "images" -d "input"
        python ${home_path}/data/motion_blur.py ${output_path}/input/ --delete True --percentage ${prune}
fi

### RUN COLMAP
cd ${splatt_path}
start=$(date +%s.%N)
python convert.py \
        -s ${output_path}/ \
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
                                -s ${output_path} \
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
                        -s ${output_path} \
                        -m ${model_path} \
                        --save_iterations ${N} 
        fi
else
        ## NO SWEEP
        python train.py \
                        --iterations ${iterations} \
                        --eval \
                        -s ${output_path} \
                        -m ${model_path} \
                        --save_iterations ${iterations}
fi

### ZIP RESULTS
cd /home/ubuntu/georgia/data/${name}/
zip ${name}_100.zip /home/ubuntu/georgia/data/${name}/${name}_model/  -r

