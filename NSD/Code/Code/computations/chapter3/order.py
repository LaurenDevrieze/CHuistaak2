# -*- coding: utf-8 -*-
"""
This file contains the code to create an order plot for the second order 
Runge-Kutta method
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.linear as linear
import integrators.forward_euler_integrator
import integrators.rk2_integrator
import integrators.rk4_integrator

# create ODE    
lambd = -1.
ode = linear.LinearODE(lambd)

# initial condition 
y0 = 1.
t0 = 0.
# end time of simulation
tend = 1.

# create forward Euler integrator
fe = integrators.forward_euler_integrator.ForwardEulerIntegrator(ode)
# create RK2 integrator
rk2 = integrators.rk2_integrator.RK2_Integrator(ode)
rk4 = integrators.rk4_integrator.RK4_Integrator(ode)
  
plt.figure()

plt.rc("font", size=20)

h_range = scipy.array([0.5,0.2,0.1,0.05,0.02,0.01,5e-3,2e-3,1e-3,5e-4,2e-4])
# vectors to collect error at final time for each value of step size
err_fe = scipy.zeros_like(h_range)
err_rk2 = scipy.zeros_like(h_range)
err_rk4 = scipy.zeros_like(h_range)

for i in range(len(h_range)):
    h = h_range[i]
    print h
    # integrate on the requested time interval with forward Euler integrator
    t,y = fe.integrate(y0,t0,tend,h)
    # compute exact solution
    y_ex = ode.y_exact(t,t0,y0)  
    # compute and plot error
    err_fe[i] = scipy.absolute(y-y_ex)[-1]
    # integrate on the requested time interval with AB2 integrator
    t,y = rk2.integrate(y0,t0,tend,h)
    # compute and plot error
    err_rk2[i] = scipy.absolute(y-y_ex)[-1]
    # integrate on the requested time interval with AB2 integrator
    t,y = rk4.integrate(y0,t0,tend,h)
    # compute and plot error
    err_rk4[i] = scipy.absolute(y-y_ex)[-1]
    

plt.loglog(h_range,err_fe,'b',h_range,err_rk2,'g--',h_range,err_rk4,'r-.',linewidth=5)

plt.savefig('assignment_order.pdf')