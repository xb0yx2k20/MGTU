import numpy as np
from numba import njit, prange

@njit(parallel=True)
def sopr(A, b, x, max_iterations=1000, tolerance=1e-3):
    r = b - np.dot(A, x)
    p = r.copy()
    
    for i in range(max_iterations):
        alpha = np.dot(r, r) / np.dot(p, np.dot(A, p))
        x = x + alpha * p
        r_next = r - alpha * np.dot(A, p)
        beta = np.dot(r_next, r_next) / np.dot(r, r)
        p = r_next + beta * p
        r = r_next
        if (np.linalg.norm(r) / np.linalg.norm(b)) < tolerance:
            break

    return x

# Пример использования
A = np.array([[4.0, 1.0], [1.0, 3.0]])
b = np.array([3.0, 4.0])
x = np.zeros_like(b)

result = sopr(A, b, x)

print("Result:", result)
