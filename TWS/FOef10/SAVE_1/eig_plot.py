import numpy
import matplotlib.pyplot as pyplot
import random

matrix_size = 10
matrix = numpy.random.rand(matrix_size, matrix_size)
pyplot.scatter(matrix[1,:],matrix[2,:])
pyplot.show()
