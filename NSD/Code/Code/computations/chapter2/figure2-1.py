# -*- coding: utf-8 -*-
"""
This file contains the code to create figure 1.2 in the book of Iserles
It additionally shows how to test the order of a method more reliably
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.quadratic as quadratic
import integrators.forward_euler_integrator
import integrators.ab2_integrator
import integrators.ab3_integrator

# create ODE    
ode = quadratic.QuadraticODE()

# initial condition 
y0 = 1.
t0 = 0.
# end time of simulation
tend = 10.
# time steps
h_range = scipy.array([1./5.,1./10.,1./20.,1./40.])

# create forward Euler integrator
fe = integrators.forward_euler_integrator.ForwardEulerIntegrator(ode)
# create AB2 integrator
ab2 = integrators.ab2_integrator.AB2_Integrator(ode)
# create AB2 integrator
ab3 = integrators.ab3_integrator.AB3_Integrator(ode)

#top left figure (h=1/5)
  
plt.figure()      

h = h_range[0]
# integrate on the requested time interval with the 3 integrators
t_fe,y_fe = fe.integrate(y0,t0,tend,h)
t_ab2,y_ab2 = ab2.integrate(y0,t0,tend,h)
t_ab3,y_ab3 = ab3.integrate(y0,t0,tend,h)
# compute exact solution (NOT possible in reality, only for testing)
y_ex = ode.y_exact(t_fe,t0,y0) 
# compute and plot error
err_fe = scipy.absolute(y_fe-y_ex)
err_ab2 = scipy.absolute(y_ab2-y_ex)
err_ab3 = scipy.absolute(y_ab3-y_ex)
plt.plot(t_fe,scipy.log(err_fe),'-',t_ab2,scipy.log(err_ab2),'--',t_ab3,scipy.log(err_ab3),'-.')
    

#top right figure (h=1/10)
  
plt.figure()      

h = h_range[1]
# integrate on the requested time interval with the 3 integrators
t_fe,y_fe = fe.integrate(y0,t0,tend,h)
t_ab2,y_ab2 = ab2.integrate(y0,t0,tend,h)
t_ab3,y_ab3 = ab3.integrate(y0,t0,tend,h)
# compute exact solution (NOT possible in reality, only for testing)
y_ex = ode.y_exact(t_fe,t0,y0) 
# compute and plot error
err_fe = scipy.absolute(y_fe-y_ex)
err_ab2 = scipy.absolute(y_ab2-y_ex)
err_ab3 = scipy.absolute(y_ab3-y_ex)
plt.plot(t_fe,scipy.log(err_fe),'-',t_ab2,scipy.log(err_ab2),'--',t_ab3,scipy.log(err_ab3),'-.')

#bottom left figure (h=1/20)
  
plt.figure()      

h = h_range[2]
# integrate on the requested time interval with the 3 integrators
t_fe,y_fe = fe.integrate(y0,t0,tend,h)
t_ab2,y_ab2 = ab2.integrate(y0,t0,tend,h)
t_ab3,y_ab3 = ab3.integrate(y0,t0,tend,h)
# compute exact solution (NOT possible in reality, only for testing)
y_ex = ode.y_exact(t_fe,t0,y0) 
# compute and plot error
err_fe = scipy.absolute(y_fe-y_ex)
err_ab2 = scipy.absolute(y_ab2-y_ex)
err_ab3 = scipy.absolute(y_ab3-y_ex)
plt.plot(t_fe,scipy.log(err_fe),'-',t_ab2,scipy.log(err_ab2),'--',t_ab3,scipy.log(err_ab3),'-.')

#bottom right figure (h=1/40)
  
plt.figure()      

h = h_range[3]
# integrate on the requested time interval with the 3 integrators
t_fe,y_fe = fe.integrate(y0,t0,tend,h)
t_ab2,y_ab2 = ab2.integrate(y0,t0,tend,h)
t_ab3,y_ab3 = ab3.integrate(y0,t0,tend,h)
# compute exact solution (NOT possible in reality, only for testing)
y_ex = ode.y_exact(t_fe,t0,y0) 
# compute and plot error
err_fe = scipy.absolute(y_fe-y_ex)
err_ab2 = scipy.absolute(y_ab2-y_ex)
err_ab3 = scipy.absolute(y_ab3-y_ex)
plt.plot(t_fe,scipy.log(err_fe),'-',t_ab2,scipy.log(err_ab2),'--',t_ab3,scipy.log(err_ab3),'-.')


# a better way to visualise the order of a method

plt.figure()

plt.rc("font", size=20)

h_range = scipy.array([0.5,0.2,0.1,0.05,0.02,0.01,5e-3,2e-3,1e-3,5e-4,2e-4])
# vectors to collect error at final time for each value of step size
err_fe = scipy.zeros_like(h_range)
err_ab2 = scipy.zeros_like(h_range)
err_ab3 = scipy.zeros_like(h_range)

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
    t,y = ab2.integrate(y0,t0,tend,h)
    # compute and plot error
    err_ab2[i] = scipy.absolute(y-y_ex)[-1]
    # integrate on the requested time interval with AB2 integrator
    t,y = ab3.integrate(y0,t0,tend,h)
    # compute and plot error
    err_ab3[i] = scipy.absolute(y-y_ex)[-1]

plt.loglog(h_range,err_fe,'b',h_range,err_ab2,'g--',h_range,err_ab3,'r-.',linewidth=5)

plt.savefig('chapter2_order.pdf')