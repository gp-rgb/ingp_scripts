#!/bin/bash


#defaults
NUM_LINKS=100
SOURCE_NAME="rgbd"
DEST_NAME="input"
prune=0


#argparser
if [ $# -lt 2 ]; then
    echo "Usage: $(basename $0) [SOURCE] [DEST] --num_links <e.g. 100> --source_name <e.g. 'rgbd'> --dest_name <e.g. 'input'>"
    exit 1
fi

#req'd args
SOURCE=${1}
DEST=${2}
shift 2

#opt args
while getopts 'n:s:d:' opt; do
    case "$opt" in
        n|num_links)
            NUM_LINKS=${OPTARG}
            ;;
        s|source_name)
            SOURCE_NAME=${OPTARG}
            ;;
        d|dest_name)
            DEST_NAME=${OPTARG}
            ;;
        ?|h)
            echo "Usage: $(basename $0) [SOURCE] [DEST] --num_links <e.g. 100> --source_name <e.g. 'rgbd'> --dest_name <e.g. 'input'> --prune <0 for FALSE, 1 for TRUE>"
            echo "  SOURCE: directory of dataset containing desired images."
            echo "  DEST: directory of new dataset to have links to SOURCE images."
            echo "  num_links: number of images to make links to (size of DEST dataset)."
            echo "  source_name/dest_name: name of folder containing images inside dataset directory."
            echo "  prune: if set to 1, removes images with significant motion blur."
            ;;
    esac 
done
shift "$(($OPTIND -1))"
echo $NUM_LINKS
echo $SOURCE_NAME
echo $DEST_NAME
echo $prune


SOURCE_PATH=$SOURCE/$SOURCE_NAME
DEST_PATH=$DEST/$DEST_NAME
echo $SOURCE_PATH
echo $DEST_PATH

rm -r ${DEST_PATH}
mkdir -p "$DEST_PATH"

find "$SOURCE_PATH" -type f -name "*.jpg" -o -name "*.jpeg" | shuf -n "$NUM_LINKS" | while IFS= read -r file; do
    ln -s "$file" "$DEST_PATH"
done
ls {$DEST_PATH}


