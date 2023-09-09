from random import randint
from threading import Thread
import numpy as np
import time

a, b, c = [], [], []
n = 100

def printt():
    print(a)
    print(b)
    print(c, '\n')

def generateMatrix():
    for i in range(n):
        rowsA = []
        rowsB = []
        rowsC = []
        for j in range(n):
            rowsA.append(randint(0, 9))
            rowsB.append(randint(0, 9))
            rowsC.append(0)
        a.append(rowsA)
        b.append(rowsB)
        c.append(rowsC)

def defaultAlg():
    start_time = time.time()
    for i in range(n):
        for j in range(n):
            cij = 0
            for k in range(n):
                cij += a[i][k] * b[k][j]
            c[i][j] = cij
    end_time = time.time()
    print("Время вычисления по строкам: ", round((end_time - start_time) * 1000, 3), "ms")
    #printt()

def notDefaultAlg():
    start_time = time.time()
    for i in range(n):
        for j in range(n):
            cji = 0
            for k in range(n):
                cji += a[j][k] * b[k][i]
            c[j][i] = cji
    end_time = time.time()
    print("Время вычисления по столбцам: ", round((end_time - start_time) * 1000, 3), "ms")
    #printt()

def threadAlg(k):
    rows = []
    for i in range(n):
        row = 0
        for j in range(n):
            row += a[k][j] * b[j][i]
        rows.append(row)
    #print(rows)
    


generateMatrix()
defaultAlg()
notDefaultAlg()


start_time = time.time()
for i in range(n):
    thread = (Thread(target=threadAlg, args=(i,)))
    thread.start()
    thread.join()
end_time = time.time()
print("Время вычисления по потокам: ", round((end_time - start_time) * 1000, 3), "ms")


'''
thread1.start()
thread2.start()
thread1.join()
thread2.join()

'''
