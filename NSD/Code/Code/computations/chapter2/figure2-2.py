# -*- coding: utf-8 -*-
"""
This file contains the code to create figure 1.2 in the book of Iserles
It additionally shows how to test the order of a method more reliably
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.linear as linear
import integrators.nonconvergent_integrator

# create ODE    
lambd = -1.
ode = linear.LinearODE(lambd)

# initial condition 
y0 = 1.
t0 = 0.
# end time of simulation
tend = 14.5
# time steps
h_range = scipy.array([1./10.,1./20.,1./40.])

# create nonconvergent integrator
nc = integrators.nonconvergent_integrator.NonConvergent_Integrator(ode)

plt.figure()      

# integrate on the requested time interval with the 3 step sizes
h = h_range[0]
t1,y1 = nc.integrate(y0,t0,tend,h)
h = h_range[1]
t2,y2 = nc.integrate(y0,t0,tend,h)
h = h_range[2]
t3,y3 = nc.integrate(y0,t0,tend,h)


plt.axis([0,14.5,0,2.5])
plt.plot(t1,y1,'-',t2,y2,'--',t3,y3,'-.')
    
