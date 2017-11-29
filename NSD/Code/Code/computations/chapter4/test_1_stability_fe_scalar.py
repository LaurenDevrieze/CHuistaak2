# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 09:49:33 2013

@author: giovanni
"""

"""
This file contains a forward Euler simulation of a linear scalar ODE
with different step sizes, to determine the accuracy and stability properties
of the forward Euler method
"""

import sys
sys.path.append("../../")

import scipy
import matplotlib.pyplot as plt

import systems.linear as ls
import integrators.forward_euler_integrator


# create a linear ODE with eigenvalue -1./10.    
lambd = -1./10.

ode = ls.LinearODE(lambd)
 
# problem-specific parameters 
y0 = 1.
t0 = 0.
tend = 150.

# compute exact solution for comparison
h = 1e-1
t_ex = scipy.arange(t0,tend,h)
y_ex = ode.y_exact(t_ex,t0,y0)

# create forward Euler integrator
fe = integrators.forward_euler_integrator.ForwardEulerIntegrator(ode)

plt.figure()

# first example        
plt.subplot(231)
plt.plot(t_ex,y_ex)
h = 1.
t1,y1 = fe.integrate(y0,t0,tend,h) 
print scipy.shape(t1), scipy.shape(y1)
plt.plot(t1,y1,'-o')

# second example
plt.subplot(232)
plt.plot(t_ex,y_ex)
h = 5.
t2,y2 = fe.integrate(y0,t0,tend,h) 
plt.plot(t2,y2,'-x')

# third example
plt.subplot(233)
plt.plot(t_ex,y_ex)
h = 10.
t3,y3 = fe.integrate(y0,t0,tend,h) 
plt.plot(t3,y3,'-v')
        
# fourth example
plt.subplot(234)
plt.plot(t_ex,y_ex)
h = 15.
t4,y4 = fe.integrate(y0,t0,tend,h) 
plt.plot(t4,y4,'-d')
        
# fifth example
plt.subplot(235)
plt.plot(t_ex,y_ex)
h = 20.
t5,y5 = fe.integrate(y0,t0,tend,h) 
plt.plot(t5,y5,'--')       
        
# sixth example
plt.subplot(236)
plt.plot(t_ex,y_ex)
h = 21.
t6,y6 = fe.integrate(y0,t0,tend,h) 
plt.plot(t6,y6,'--')

plt.savefig('test.png')
                
