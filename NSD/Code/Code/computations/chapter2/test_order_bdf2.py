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
import solvers.newton_solver
import integrators.bdf2_integrator

# create ODE    
ode = quadratic.QuadraticODE()

# initial condition 
y0 = 1.
t0 = 0.
# end time of simulation
tend = 10.

# create forward Euler integrator
fe = integrators.forward_euler_integrator.ForwardEulerIntegrator(ode)
# create BDF2 integrator
solver_param = solvers.newton_solver.NewtonSolver.getDefaultParameters()
solver_param['abs_tol']=1e-14
newt = solvers.newton_solver.NewtonSolver(solver_param)
bdf2 = integrators.bdf2_integrator.BDF2_Integrator(ode,newt)

plt.figure()

plt.rc("font", size=20)

h_range = scipy.array([0.5,0.2,0.1,0.05,0.02,0.01,5e-3,2e-3,1e-3,5e-4,2e-4])
# vectors to collect error at final time for each value of step size
err_fe = scipy.zeros_like(h_range)
err_bdf2 = scipy.zeros_like(h_range)

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
    t,y = bdf2.integrate(y0,t0,tend,h)
    # compute and plot error
    err_bdf2[i] = scipy.absolute(y-y_ex)[-1]

plt.loglog(h_range,err_fe,'b',h_range,err_bdf2,'g--',linewidth=5)
