# -*- coding: utf-8 -*-
"""
This file contains the code to create figure 1.2 in the book of Iserles
It additionally shows how to test the order of a method more reliably
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy
import scipy.linalg

import systems.diffusion as diffusion
import integrators.ab2_integrator
import integrators.forward_euler_integrator
import integrators.implicit_euler_integrator
import solvers.newton_solver

# create ODE    
N = 10
ode = diffusion.DiffusionODE(N)

# initial condition 
y0 = scipy.ones((N,))
t0 = 0.
# end time of simulation
tend = 10.
# time steps
h_range = scipy.array([0.027,0.0275])

# create AB2 integrator
solver = solvers.newton_solver.NewtonSolver()
imp = integrators.implicit_euler_integrator.ImplicitEulerIntegrator(ode,solver)
#imp = ab2_integrator.AB2_integrator(ode)
plt.figure()      

# integrate on the requested time interval with the 2 step sizes
h = h_range[0]
t1,y1 = imp.integrate(y0,t0,tend,h)
# compute norm at every moment in time
y1_norm = scipy.zeros_like(t1)
for n in range(len(t1)):
    y1_norm[n]=scipy.linalg.norm(y1[n,:])

h = h_range[1]
t2,y2 = imp.integrate(y0,t0,tend,h)
# compute norm at every moment in time
y2_norm = scipy.zeros_like(t2)
for n in range(len(t2)):
    y2_norm[n]=scipy.linalg.norm(y2[n,:])

# plot norm of solution as a function of time
plt.plot(t1,y1_norm,'-',t2,y2_norm,'--')

plt.savefig('chapter2_implicit_euler.pdf')
    
