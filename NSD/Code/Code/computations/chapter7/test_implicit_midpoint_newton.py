# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 22:06:01 2013

@author: giovanni
"""

import sys
sys.path.append("../../")

import scipy
import matplotlib.pyplot as plt

import systems.linear_system_ode as ls
import integrators.implicit_midpoint_integrator
import solvers.newton_solver

# create a linear ODE with system matrix A
A = scipy.array([[-100.,1.],[-1./20,-1./20.]])
ode = ls.LinearSystemODE(A)

# problem-specific parameters 
y0 = scipy.array([1.,999./10.])
t0 = 0.
tend = 150.
 
# compute exact solution for comparison
dt = 5e-3
t_ex1 = scipy.arange(t0,tend,dt)
y_ex1 = ode.y_exact(t_ex1,t0,y0)

# create trapezium integrator
solver_param = solvers.newton_solver.NewtonSolver.getDefaultParameters()
solver_param['abs_tol']=1e-13
newt = solvers.newton_solver.NewtonSolver(solver_param)

im = integrators.implicit_midpoint_integrator.ImplicitMidpointIntegrator(ode,newt)

Dt = 5.
t1,y1 = im.integrate(y0,t0,tend,Dt) 
plt.figure(1)
plt.subplot(211)
plt.plot(t1,y1[:,0],'-o')
plt.subplot(212)
plt.plot(t1,y1[:,1],'-o')
        
