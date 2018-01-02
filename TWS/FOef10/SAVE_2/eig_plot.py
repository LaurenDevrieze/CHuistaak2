import numpy
import matplotlib.pyplot as pyplot
import random
import ctypes

matrix_size = 10
matrix = numpy.random.rand(matrix_size, matrix_size)
pyplot.scatter(matrix[1,:],matrix[2,:])
pyplot.show()

from numpy.ctypeslib import ndpointer
lib = ctypes.cdll.LoadLibrary("./eigenv_wrapper.so")
fun = lib.cpp_eig
fun.restype = int
fun.argtypes = [ndpointer(ctypes.c_double, flags="C_CONTIGUOUS"), \
ctypes.c_int, ndpointer(ctypes.c_double, flags="C_CONTIGUOUS") , \
ndpointer(ctypes.c_double, flags="C_CONTIGUOUS")]
def wrapper_eig(matrix,x,y):
	assert x.size == y.size
	fun(matrix, x.size, x, y)

x = numpy.empty((matrix_size), order='C')
y = numpy.empty((matrix_size), order='C')
wrapper_eig(matrix, x, y)
print(x)
print(y)
