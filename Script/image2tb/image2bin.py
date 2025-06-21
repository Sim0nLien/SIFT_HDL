from PIL import Image
import numpy as np

def read_image(filename):
    img = Image.open(filename).convert('L')  # convert to grayscale
    data = np.array(img)
    return data