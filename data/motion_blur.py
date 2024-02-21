import cv2
import os
import matplotlib
import matplotlib.pyplot as plt
import argparse

matplotlib.use('module://drawilleplot')

def get_focus(grey):
    # https://pyimagesearch.com/2015/09/07/blur-detection-with-opencv/
    return cv2.Laplacian(grey, cv2.CV_64F).var()

def is_blurry(image, thresh):
    grey = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
    focus = get_focus(grey)
    return (focus<thresh, focus) 

def get_file_paths(path,ext=".jpg"):
    files = os.listdir(path)
    files_dot_ext = [file for file in files if os.path.splitext(file)[1] == ext]
    return files_dot_ext

def plot_histogram(data,n_bins,thresh):
    plt.hist(data, bins=n_bins, edgecolor='black')  # You can adjust the number of bins as needed
    plt.xlabel('Values')
    plt.ylabel('Frequency')
    plt.title('Image Focus Frequencies')
    plt.figure(figsize=(6,3))
    plt.show()

def main(args):
    print("Received arguments:", args)
    jpg_paths = get_file_paths(path=args.directory, ext=args.ext)
    blurry_jpgs = []
    focus_scores = []

    os.chdir(args.directory)

    for file in jpg_paths:
        image = cv2.imread(file)
        blurry, focus_val = is_blurry(image,thresh=args.thresh)
        focus_scores.append(focus_val)
        if blurry:
            blurry_jpgs.append(os.path.join(args.directory,file))
            #plt.imshow(image,cv2.COLOR_BGR2RGB)
            #plt.show()
    
    print(f"{len(jpg_paths)} were analysed for their Focus Scores. The distribution of values is as follows:")
    plot_histogram(focus_scores,10,args.thresh)
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






