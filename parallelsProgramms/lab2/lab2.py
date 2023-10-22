import numpy as np
from mpi4py import MPI
import pickle
import time

# mpiexec -n 4 /Library/Frameworks/Python.framework/Versions/3.11/bin/python3 lab2.py
comm = MPI.COMM_WORLD
rank = comm.Get_rank()
size = comm.Get_size()
st = time.time()
comm.send(st, dest=size-1)
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






n = 80
a = []
b = []
x = [0.01] * n
generate_matrix(a, b, n)
a = split_array(a, n // size)
#print(a)

res = []
k = 0
for i in range(n // size * rank, n // size * (1+rank)):
    k += 1
    res.append(sopr(a[i], b, x))
    #print(sopr(a[i], b, x), i)
    #print(a[i])

x_all = comm.gather(res, root=0)
#if rank == 0:
    #print(x_all, rank, size)

if rank == size - 1:
    et = time.time()
    st = comm.recv(source=0)
    print(round((et - st), 3), "s")


# mpiexec -n 2 /Library/Frameworks/Python.framework/Versions/3.11/bin/python3 lab2.py