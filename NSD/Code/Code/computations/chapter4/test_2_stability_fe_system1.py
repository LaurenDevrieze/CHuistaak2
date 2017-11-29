# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 13:17:55 2013

@author: giovanni
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 09:49:33 2013

@author: giovanni
"""

import sys
sys.path.append("../../")

import scipy
import matplotlib.pyplot as plt

import systems.linear_system_ode as ls
import integrators.forward_euler_integrator


# create a linear ODE with system matrix A
A = scipy.array([[-100.,1.],[0,-1./10.]])
ode = ls.LinearSystemODE(A)

# problem-specific parameters 
y0 = scipy.array([0.,1.])
t0 = 0.
tend = 10.

# compute exact solution for comparison
h = 5e-3
t_ex1 = scipy.arange(t0,tend,h)
y_ex1 = ode.y_exact(t_ex1,t0,y0)

# create forward Euler integrator
fe = integrators.forward_euler_integrator.ForwardEulerIntegrator(ode)


# first example  -- time-step results in instability, 
# despite accurate solution of slow component
# integrate with a slightly unstable time step
h = 1./49.
t1,y1 = fe.integrate(y0,t0,tend,h) 

plt.figure(1)
plt.subplot(221)
plt.plot(t_ex1,y_ex1[:,0])
plt.plot(t1,y1[:,0],'-o')
plt.figure(2)
plt.subplot(221)
plt.plot(t_ex1,y_ex1[:,1])
plt.plot(t1,y1[:,1],'-o')

# second example -- decrease timestep for stability
h = 1./51.
t1,y1 = fe.integrate(y0,t0,tend,h) 

plt.figure(1)
plt.subplot(222)
plt.plot(t_ex1,y_ex1[:,0])
plt.plot(t1,y1[:,0],'-+')
plt.figure(2)
plt.subplot(222)
plt.plot(t_ex1,y_ex1[:,1])
plt.plot(t1,y1[:,1],'-+')
        
        
# third example -- specific initial condition, consistent with slow mode       
        
# problem-specific parameters 
y0 = scipy.array([1.,999./10.])
t0 = 0.
tend = 10.

# compute exact solution for comparison
h = 5e-3
t_ex1 = scipy.arange(t0,tend,h)
y_ex1 = ode.y_exact(t_ex1,t0,y0)


# unstable step size ... hope everything is OK...
h = 1./49.
t1,y1 = fe.integrate(y0,t0,tend,h) 
plt.figure(1)
plt.subplot(223)
plt.plot(t_ex1,y_ex1[:,0])
plt.plot(t1,y1[:,0],'-v')
plt.figure(2)
plt.subplot(223)
plt.plot(t_ex1,y_ex1[:,1])
plt.plot(t1,y1[:,1],'-v')
        
# ... now integrate for a little longer ...        
tend = 20.
        
t1,y1 = fe.integrate(y0,t0,tend,h) 
plt.figure(1)
plt.subplot(224)
plt.plot(t1,y1[:,0],'-v')
plt.figure(2)
plt.subplot(224)
plt.plot(t1,y1[:,1],'-v')
