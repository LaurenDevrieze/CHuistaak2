# -*- coding: utf-8 -*-
"""
This file contains the code to create figure 5.1 in the book of Iserles
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.polynomial as polynomial
import integrators.implicit_midpoint_integrator
import solvers.newton_solver

# create ODE    
coeff1 = scipy.array([1./8.,0.,0.,-1.])
coeff2 = scipy.array([1./8.,1./6.,0.,-1.])

ode1 = polynomial.PolynomialODE(coeff1)
ode2 = polynomial.PolynomialODE(coeff2)

# initial conditions 
y0_range = scipy.arange(-1,1.05,0.1)
t0 = 0.
# end time of simulation
tend = 10.
# time step
h = 2.e-2

# create newton solver for nonlinear systems
solver_param = solvers.newton_solver.NewtonSolver.getDefaultParameters()
solver_param['abs_tol']=1e-14
newt1 = solvers.newton_solver.NewtonSolver(solver_param)
newt2 = solvers.newton_solver.NewtonSolver(solver_param)

# create forward Euler integrator
im1 = integrators.implicit_midpoint_integrator.ImplicitMidpointIntegrator(ode1,newt1)
im2 = integrators.implicit_midpoint_integrator.ImplicitMidpointIntegrator(ode2,newt2)
      
# integrate on the requested time interval
y0 = y0_range[0]
t,y1 = im1.integrate(y0,t0,tend,h)
t,y2 = im2.integrate(y0,t0,tend,h)

y1_all = scipy.zeros((len(y0_range),len(t)))
y2_all = scipy.zeros((len(y0_range),len(t)))

y1_all[0,:]=y1[:,0]
y2_all[0,:]=y2[:,0]

for i in range(1,len(y0_range)):
    y0=y0_range[i]
    t,y1 = im1.integrate(y0,t0,tend,h)
    t,y2 = im2.integrate(y0,t0,tend,h)
    y1_all[i,:]=y1[:,0]
    y2_all[i,:]=y2[:,0]
        
# ... and plot
plt.figure()      
plt.plot(t,y1_all.transpose())
plt.figure()      
plt.plot(t,y2_all.transpose())

