# Specification 

## Overview :

This document provides a detailed specification of the SIFT (Scale Invariant Feature Transform) algorithm implementation in VHDL.


## Parameters :
At this stage, the implementation supports only the following image format:
- Grayscale, 8 bits per pixel
- Resolution: 512 × 512 pixels


## Input :

In this initial implementation, the processing operates row by row. At the input stage, it requires the first 3 rows of 512 pixels each (a total of 1536 pixels). As processing progresses, the module continues to read subsequent pixels as needed for computation.

## Output

At the end of the processing, the output consists of the 32 addresses corresponding to the most significant keypoints detected in the image. These addresses indicate the pixel locations of the keypoints within the 512 × 512 image.








