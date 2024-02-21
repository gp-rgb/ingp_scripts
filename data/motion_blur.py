import cv2
import os
import matplotlib.pyplot as plt
import argparse

def get_focus(grey):
    # https://pyimagesearch.com/2015/09/07/blur-detection-with-opencv/
    return cv2.Laplacian(grey, cv2.CV_64F).var()

def is_blurry(image, thresh):
    grey = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    focus = get_focus(grey)
    return (focus<thresh) 

def get_file_paths(path,ext=".jpg"):
    files = os.listdir(path)
    files_dot_ext = [file for file in files if os.path.splitext(file)[1] == ext]
    return files_dot_ext

def plot_histogram(data,n_bins,thresh):
    plt.hist(data, bins=n_bins, edgecolor='black')  # You can adjust the number of bins as needed
    plt.xlabel('Values, Red Dot Indicates Threshold')
    plt.ylabel('Frequency')
    plt.title('Image Focus Frequencies')
    plt.scatter([0], [thresh], color='red', marker='o', s=100)  # Adjust the coordinates (x, y) as needed
    plt.show()

def main(args):
    # Your main logic goes here
    print("Received arguments:", args)
    jpg_paths = get_file_paths(path=args.directory, ext=args.ext)
    blurry_jpgs = []

    os.chdir(args.directory)

    for file in jpg_paths:
        image = cv2.imread(file)
        if is_blurry(image,thresh=args.thresh):
            blurry_jpgs.append(os.path.join(args.directory,file))
            #plt.imshow(image,cv2.COLOR_BGR2RGB)
            #plt.show()
    
    print(f"{len(blurry_jpgs)} images (out of {len(jpg_paths)}) have been detected that are below the desired focus threshold of {args.thresh}.")
    if args.delete:
        for blurry_file in blurry_jpgs:
            os.remove(blurry_file)
    print(f"{len(blurry_jpgs)} blurry images deleted from {args.directory}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Removes Images with Focus Lower than Threshold.")

    parser.add_argument('directory', type=str, help='Working Directory')
    parser.add_argument('--thresh', type=int, default='100', help='Focus Threshold')
    parser.add_argument('--ext', type=str, default='.jpg', help='Image Extension of Interest')
    parser.add_argument('--delete', type=bool, default=False, help='Delete Blurry Images')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Call the main function with the parsed arguments
    main(args)






