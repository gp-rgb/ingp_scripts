import cv2
import os
import matplotlib
import matplotlib.pyplot as plt
import argparse

matplotlib.use('module://drawilleplot')

def get_focus(image):
    # https://pyimagesearch.com/2015/09/07/blur-detection-with-opencv/
    grey = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    return cv2.Laplacian(grey, cv2.CV_64F).var()

def get_file_paths(path,ext=".jpg"):
    files = os.listdir(path)
    files_dot_ext = [file for file in files if os.path.splitext(file)[1] == ext]
    return files_dot_ext

def plot_histogram(data,n_bins):
    plt.hist(data, bins=n_bins, edgecolor='black')  # You can adjust the number of bins as needed
    plt.xlabel('Values')
    plt.ylabel('Frequency')
    plt.title('Image Focus Frequencies')
    plt.show()

def main(args):
    print("Received arguments:", args)
    jpg_paths = sorted(get_file_paths(path=args.directory, ext=args.ext))
    blurry_jpgs = []
    focus_scores = []

    os.chdir(args.directory)

    for file in jpg_paths:
        image = cv2.imread(file)
        focus_val = get_focus(image)
        focus_scores.append(focus_val)
        #if blurry:
        #    blurry_jpgs.append(os.path.join(args.directory,file))
    ranked_scores = sorted(enumerate(focus_scores), key=lambda x: x[1])
    bottom_scores = ranked_scores[:round((args.percentage / 100.0)*len(focus_scores))]
    for index,score in bottom_scores:
        file = jpg_paths[index]
        blurry_jpgs.append(os.path.join(args.directory,file))
        
    print(f"{len(jpg_paths)} images were analysed for their Focus Scores. The distribution of values is as follows:")
    plot_histogram(focus_scores,10)
    print(f"The blurriest {args.percentage}% of images ({len(blurry_jpgs)} out of {len(jpg_paths)}) have a maximum Focus Score of {max(bottom_scores, key=lambda x: x[1])[1]}.")

    if args.delete:
        for blurry_file in blurry_jpgs:
            os.remove(blurry_file)
        print(f"{len(blurry_jpgs)} blurry images deleted from {args.directory}")

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Removes Images with Focus Lower than Threshold.")

    parser.add_argument('directory', type=str, help='Working Directory')
    parser.add_argument('--percentage', type=int, default='10', help='Percentage of Images to Delete')
    parser.add_argument('--ext', type=str, default='.jpg', help='Image Extension of Interest')
    parser.add_argument('--delete', type=bool, default=False, help='Delete Blurry Images')

    # Parse the command-line arguments
    args = parser.parse_args()

    # Call the main function with the parsed arguments
    main(args)












