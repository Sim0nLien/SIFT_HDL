import os
import numpy as np
from image2tb.image2bin import read_image
from image2tb.give_adress import get_address
from image2tb.write_tb import main as write_tb

# Variables : 

filename_image = "../Data/Image/Lenna.png"
filename_tb = "../Test/image_tb/Lenna_tb.vhd"

# Main :

if __name__ == "__main__":
    if not os.path.exists(filename_image):
        raise FileNotFoundError(f"File {filename_image} does not exist.")
    data = read_image(filename_image)
    data = data.flatten()
    write_tb(filename_tb, data)
    
