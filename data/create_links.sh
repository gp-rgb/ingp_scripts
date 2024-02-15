SOURCE=still_life
DATASET=still_life_frames

source_directory="/home/ubuntu/georgia/data/${SOURCE}/rgbd/"
destination_directory="/home/ubuntu/georgia/data/${DATASET}/images"
number_of_links=50


# Create destination directory if it doesn't exist
rm -r ${destination_directory}
mkdir -p "$destination_directory"

# Use find to locate all JPEG files in the source directory
find "$source_directory" -type f -name "*.jpg" -o -name "*.jpeg" | shuf -n "$number_of_links" | while IFS= read -r file; do
    # Create symbolic links in the destination directory
    ln -s "$file" "$destination_directory"
done
ls {$destination_directory}

