# -*- coding: utf-8 -*-
"""
This file contains the code to create figure 5.1 in the book of Iserles
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.sphere as sphere
import integrators.implicit_midpoint_integrator
import solvers.newton_solver

# create ODE    
lambd = 1.
ode = sphere.SphereODE()

# initial condition 
y0 = scipy.sqrt(3)/3.*scipy.ones((3,))
t0 = 0.
# end time of simulation
tend = 1000.
# time step
h = 1.e-2

# create newton solver for nonlinear systems
solver_param = solvers.newton_solver.NewtonSolver.getDefaultParameters()
solver_param['abs_tol']=1e-14
newt = solvers.newton_solver.NewtonSolver(solver_param)

# create forward Euler integrator
im = integrators.implicit_midpoint_integrator.ImplicitMidpointIntegrator(ode,newt)
      
# integrate on the requested time interval
t,y = im.integrate(y0,t0,tend,h)

# ... and plot
plt.figure()      
plt.plot(t,y[:,0])
plt.figure()      
plt.plot(t,y[:,1])
plt.figure()      
plt.plot(t,y[:,2])

plt.figure()
plt.plot(y[:,0],y[:,1])
