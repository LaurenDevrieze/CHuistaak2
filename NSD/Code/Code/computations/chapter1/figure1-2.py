# -*- coding: utf-8 -*-
"""
This file contains the code to create figure 1.2 in the book of Iserles
It additionally shows how to test the order of a method more reliably
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.forced as forced
import integrators.forward_euler_integrator
import integrators.trapezium_integrator
import solvers.newton_solver

# create ODE    
lambd = 1.
ode = forced.ForcedODE(lambd)

# initial condition 
y0 = 0.
t0 = 0.
# end time of simulation
tend = 10.
# time steps
h_range = scipy.array([0.5,0.1,0.02])

# create forward Euler integrator

fe = integrators.forward_euler_integrator.ForwardEulerIntegrator(ode)

# create newton solver for nonlinear systems
solver_param = solvers.newton_solver.NewtonSolver.getDefaultParameters()
solver_param['abs_tol']=1e-14
newt = solvers.newton_solver.NewtonSolver(solver_param)

# create trapezium rule with the newton solver
tr = integrators.trapezium_integrator.TrapeziumIntegrator(ode,newt)
    
#top figure (forward Euler rule)
    
plt.figure()      

for h in h_range:
    # integrate on the requested time interval with forward Euler integrator
    t,y = fe.integrate(y0,t0,tend,h)
    y_ex = ode.y_exact(t,t0,y0) 
    # compute and plot error
    err = scipy.absolute(y-y_ex)
    plt.plot(t,scipy.log(err))
    
#bottom figure (trapezoidal rule)

plt.figure()      

for h in h_range:
    # integrate on the requested time interval with trapezoidal integrator
    t,y = tr.integrate(y0,t0,tend,h)
    y_ex = ode.y_exact(t,t0,y0)  
    # compute and plot error
    err = scipy.absolute(y-y_ex)
    plt.plot(t,scipy.log(err))

# a better way to visualise the order of a method

plt.figure()

plt.rc("font", size=20)


h_range = scipy.array([0.5,0.2,0.1,0.05,0.02,0.01,5e-3,2e-3,1e-3,5e-4,2e-4])
# vectors to collect error at final time for each value of step size
err_fe = scipy.zeros_like(h_range)
err_tr = scipy.zeros_like(h_range)

for i in range(len(h_range)):
    h = h_range[i]
    print h
    # integrate on the requested time interval with forward Euler integrator
    t,y = fe.integrate(y0,t0,tend,h)
    y_ex = ode.y_exact(t,t0,y0)  
    # compute and plot error
    err_fe[i] = scipy.absolute(y-y_ex)[-1]
    # integrate on the requested time interval with trapezoidal integrator
    t,y = tr.integrate(y0,t0,tend,h)
    # compute and plot error
    err_tr[i] = scipy.absolute(y-y_ex)[-1]

plt.loglog(h_range,err_fe,'b',h_range,err_tr,'g--',linewidth=5)



plt.savefig('chapter1_order.pdf')