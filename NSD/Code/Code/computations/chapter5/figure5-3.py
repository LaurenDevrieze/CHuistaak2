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
import solvers.newton_solver
import systems.potential as potential

potential1 = potential.Potential1()
potential2 = potential.Potential2()

ode1 = hamiltonian.HamiltonianODE(potential1)
ode2 = hamiltonian.HamiltonianODE(potential2)

# initial conditions 
y0_range = scipy.arange(-3.,6.05,0.5)
t0 = 0.
# end time of simulation
tend = 20.
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
y0 = scipy.array([y0_range[0],0.])
t,y1 = im1.integrate(y0,t0,tend,h)
t,y2 = im2.integrate(y0,t0,tend,h)

y1_all = scipy.zeros((len(y0_range),len(t)))
ydot1_all = scipy.zeros((len(y0_range),len(t)))
y2_all = scipy.zeros((len(y0_range),len(t)))
ydot2_all = scipy.zeros((len(y0_range),len(t)))

y1_all[0,:]=y1[:,0]
ydot1_all[0,:]=y1[:,1]
y2_all[0,:]=y2[:,0]
ydot2_all[0,:]=y2[:,1]

for i in range(1,len(y0_range)):
    y0=scipy.array([y0_range[i],0.])
    t,y1 = im1.integrate(y0,t0,tend,h)
    t,y2 = im2.integrate(y0,t0,tend,h)
    y1_all[i,:]=y1[:,0]
    y2_all[i,:]=y2[:,0]
    ydot1_all[i,:]=y1[:,1]
    ydot2_all[i,:]=y2[:,1]
        
# ... and plot
plt.figure()      
plt.plot(y1_all.transpose(),ydot1_all.transpose())
plt.figure()      
plt.plot(y2_all.transpose(),ydot2_all.transpose())

