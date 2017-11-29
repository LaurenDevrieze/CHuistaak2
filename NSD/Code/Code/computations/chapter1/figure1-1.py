# -*- coding: utf-8 -*-
"""
This file contains the code to create figure 1.1 in the book of Iserles
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.logistic as logistic
import integrators.forward_euler_integrator

# create ODE    
lambd = 1.
ode = logistic.LogisticODE(lambd)

# initial condition 
y0 = 0.1
t0 = 0.
# end time of simulation
tend = 5.
# time step
h = 1.

# create forward Euler integrator
fe = integrators.forward_euler_integrator.ForwardEulerIntegrator(ode)
      
# integrate on the requested time interval
t,y = fe.integrate(y0,t0,tend,h)

# ... and plot
plt.figure()      
plt.plot(t,y)


# compute exact solution trajectories going through the numerical solution values
local_time = scipy.arange(-0.2,1.+0.005,0.01)
time = scipy.zeros((len(t),len(local_time)))
y_ex = scipy.zeros_like(time)

for i in range(len(t)):
    t0 = t[i]
    y0 = y[i]
    time[i,:] = t0 + h * local_time
    y_ex[i,:] = ode.y_exact(time[i,:],t0,y0)[:,0]

plt.plot(time.transpose(),y_ex.transpose(),'g--')


plt.savefig("figure1-1.pdf")

