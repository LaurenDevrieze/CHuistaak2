# -*- coding: utf-8 -*-
"""
This file tests the Milne device on the Curtis-Hirschfelder ODE
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.curtiss_hirschfelder as ch
import adaptive_integrators.erk23_integrator as erk23_integrator

# create ODE    
lambd = -50.
ode = ch.CHODE(lambd)

# initial condition 
y0 = 1.
t0 = 0.
# end time of simulation
tend = 10.
# time steps
h0 = 1.e-5

# create ERK23 integrator
param = erk23_integrator.ERK23_Integrator.getDefaultParameters()
param['delta']=1.e-3
erk23 = erk23_integrator.ERK23_Integrator(ode)

# integrate on the requested time interval 
t,y = erk23.integrate(y0,t0,tend,h0)

# plot solution
plt.figure()      
plt.plot(t,y)

# plot time step choice
plt.figure()
plt.plot(t[1:],t[1:]-t[:-1])

# compute exact solution for comparison
yex = ode.y_exact(t,t0,y0)
# plot error
plt.figure()
plt.plot(t,scipy.absolute(y-yex))