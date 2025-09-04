# RAM Specification (Draft Version v0.1)


## 1. Introduction

This documents describe the functional specifications of the RAM module used in the SIFT FPGA implementation. 


### 1.1 Functional Overview

This module is designed to store image data. The manager module requests a data address, and this module provides the value at that address along with the value directly below it. The RAM is dual-port, allowing the next row of the image to be written while computations are performed simultaneously. Finally, the 3×3 memory stores data before carrying out the convolution calculation.

## 2. Dual Port RAM


## 3. Write Module


## 4. Ram Module


## 5. Read Module


## 6. 3*3 Memory Module


## 7. Top RAM Module