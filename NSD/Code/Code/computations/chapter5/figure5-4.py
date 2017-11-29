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

ode1 = hamiltonian.HamiltonianODE(potential1)

# initial conditions 
theta = 2*scipy.pi*scipy.arange(0,1.,1e-2)
y0_range = 8./5.+2./5.*scipy.cos(theta)
ydot0_range = 2./5.*scipy.sin(theta)
t0 = 0.
# end time of simulation
tend = 10.
# time step
h = 2.e-2

# create newton solver for nonlinear systems
solver_param = solvers.newton_solver.NewtonSolver.getDefaultParameters()
solver_param['abs_tol']=1e-14
newt1 = solvers.newton_solver.NewtonSolver(solver_param)

# create forward Euler integrator
im1 = integrators.implicit_midpoint_integrator.ImplicitMidpointIntegrator(ode1,newt1)
      
# integrate on the requested time interval
y0 = scipy.array([y0_range[0],ydot0_range[0]])
t,y1 = im1.integrate(y0,t0,tend,h)

y1_all = scipy.zeros((len(y0_range),len(t)))
ydot1_all = scipy.zeros((len(y0_range),len(t)))

y1_all[0,:]=y1[:,0]
ydot1_all[0,:]=y1[:,1]

for i in range(1,len(y0_range)):
    y0=scipy.array([y0_range[i],ydot0_range[i]])
    t,y1 = im1.integrate(y0,t0,tend,h)
    y1_all[i,:]=y1[:,0]
    ydot1_all[i,:]=y1[:,1]
        
# ... and plot
plt.figure()      
k_range = int(scipy.size(t)/8.)*scipy.arange(0,7)
print scipy.size(t),k_range
for k in k_range:   
    plt.plot(y1_all[:,k],ydot1_all[:,k])


