# -*- coding: utf-8 -*-
"""
This file contains the code to create figure 5.1 in the book of Iserles
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.scalar_hamiltonian as hamiltonian
import integrators.implicit_midpoint_integrator
import integrators.nystrom_integrator
import solvers.newton_solver
import systems.potential as potential

potential1 = potential.Potential1()

ode1 = hamiltonian.HamiltonianODE(potential1)

# initial conditions 
y0 = scipy.array([1,0])
t0 = 0.
# end time of simulation
tend = 100.
# time step
h = 1.e-1

# create newton solver for nonlinear systems
solver_param = solvers.newton_solver.NewtonSolver.getDefaultParameters()
solver_param['abs_tol']=1e-14
newt1 = solvers.newton_solver.NewtonSolver(solver_param)

# create implicit midpoint and Nystrom integrator
im = integrators.implicit_midpoint_integrator.ImplicitMidpointIntegrator(ode1,newt1)
ny = integrators.nystrom_integrator.NystromIntegrator(ode1)
      
# integrate on the requested time interval
t,y_im = im.integrate(y0,t0,tend,h)
t,y_ny = ny.integrate(y0,t0,tend,h)
        
# ... and plot
plt.figure()      
plt.plot(t,y_im)
plt.figure()      
plt.plot(t,y_ny)


