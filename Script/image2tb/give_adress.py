import numpy as np


def get_address(data):
    ans = []
    data = data.flatten()
    for i, val in enumerate(data):
        ans.append([i, val])
    return np.array(ans, dtype=np.int32)