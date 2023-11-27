from numba import njit, prange
import numpy as np
import os
import time

# Функция дл создания матриц
def generate_matrix(a, b, n):
    for i in range(n):
        b.append(n + 1)
        a_elem = []
        for j in range(n):
            if (i == j):
                a_elem.append(2.0)
            else:
                a_elem.append(1.0)
        a.append(a_elem)


def split_array(original_array, subarray_size):
    subarrays = []
    for i in range(0, len(original_array), subarray_size):
        subarray = original_array[i:i+subarray_size]
        subarrays.append(subarray)
    
    # Combine the subarrays into a flat array
    flat_array = [item for sublist in subarrays for item in sublist]
    
    return flat_array


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
    #print(x)
    return x


def run_parallel_function(array, num_threads):
    os.environ["NUMBA_NUM_THREADS"] = str(num_threads)
    size = num_threads
    n = 640
    a = []
    b = []
    x = [0.01] * n
    generate_matrix(a, b, n)
    a = split_array(a, n // size)
    start_time = time.time()
    output_array = parallel_function(a, b, n, x, size)
    end_time = time.time()
    elapsed_time = end_time - start_time

    print(f"Threads: {num_threads}, Result: {output_array}, Time: {elapsed_time:.6f} seconds")



@njit(parallel=True)
def parallel_function(a, b, n, x, size, res=0, k = 0):

    for rank in prange(size):
        for i in prange(n // size * rank, n // size * (1+rank)):
            k += 1
            res += k * 2

    return res

# Пример использования
input_array = np.arange(10)




# Запуск функции с разным количеством потоков
run_parallel_function(input_array, num_threads=1)
run_parallel_function(input_array, num_threads=4)
run_parallel_function(input_array, num_threads=8)
