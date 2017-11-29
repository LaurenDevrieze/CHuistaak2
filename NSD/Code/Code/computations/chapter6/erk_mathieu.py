# -*- coding: utf-8 -*-
"""
This file tests the Milne device on the Mathieu equation
"""

import sys
sys.path.append("../../")

import scipy
import matplotlib.pyplot as plt

import systems.mathieu as mathieu
import adaptive_integrators.erk23_integrator as erk23_integrator
import integrators.ab3_integrator as ab3_integrator
# create ODE    
ode = mathieu.MathieuODE()

# initial condition 
y0 = scipy.array([1.,0.])
t0 = 0.
# end time of simulation
# time steps
h0 = 0.001
tend = 30.

# create AB2 integrator
erk23 = erk23_integrator.ERK23_Integrator(ode)

# create Milne integrator
param=erk23_integrator.ERK23_Integrator.getDefaultParameters()
param['delta']=1e-3
erk23 = erk23_integrator.ERK23_Integrator(ode,param)

# integrate
t,y = erk23.integrate(y0,t0,tend,h0)

# plot solution
plt.figure()      
plt.plot(t,y)

# plot time steps taken
# not that these are not exactly the time steps taken, because the interpolated
# values are also stored -- this is one of the reasons for a difference wrt
# the book by Iserles
plt.figure()
plt.plot(t[1:],t[1:]-t[:-1])

# compute reference solution -- high order, fine time step, for comparison
hfine = 1e-5
ab3 = ab3_integrator.AB3_Integrator(ode)
tfine,yfine = ab3.integrate(y0,t0,t[-1]+hfine/2.,hfine)

ind = t/hfine
indices = ind.astype(int)

plt.figure()
plt.plot(t,scipy.absolute(y-yfine[indices,:]))
