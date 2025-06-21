import os
import numpy as np
from image2tb.image2bin import read_image
from image2tb.give_adress import get_address

# Variables : 

filename_image = "../Data/Image/Lenna.png"
filename_tb = "../Test/image_tb/Lenna_tb.vhd"

# Main :

if __name__ == "__main__":
    if not os.path.exists(filename):
        raise FileNotFoundError(f"File {filename} does not exist.")
    data = read_image(filename)
    ans = get_address(data)
    print("Data shape:", data.shape)
    print(ans)
