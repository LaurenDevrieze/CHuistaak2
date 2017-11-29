# -*- coding: utf-8 -*-
"""
This file tests the Milne device on the Curtis-Hirschfelder ODE
"""

import sys
sys.path.append("../../")

import matplotlib.pyplot as plt
import scipy

import systems.curtiss_hirschfelder as ch
import solvers.newton_solver as ns
import integrators.ab2_integrator
import integrators.trapezium_integrator
import interpolators.quadratic_interpolation as qi
import adaptive_integrators.milne_multistep_integrator as mmi

# create ODE    
lambd = -50.
ode = ch.CHODE(lambd)

# initial condition 
y0 = 1.
t0 = 0.
# end time of simulation
tend = 10.
# time steps
h0 = 1.e-5

# create AB2 integrator
ab2 = integrators.ab2_integrator.AB2_Integrator(ode)
# create TR integrator with Newton solver
nsolver = ns.NewtonSolver()
tr = integrators.trapezium_integrator.TrapeziumIntegrator(ode,nsolver)
# create interpolator
interpol = qi.QuadraticInterpolation(ode)

# create Milne integrator
param = mmi.MilneMultiStepIntegrator.getDefaultParameters()
param['delta']=1.e-4
mil = mmi.MilneMultiStepIntegrator(ode,tr,ab2,interpol)


# integrate on the requested time interval 
t,y = mil.integrate(y0,t0,tend,h0)

# plot solution
plt.figure()      
plt.plot(t,y)

# plot time step choice
plt.figure()
plt.plot(t[1:],t[1:]-t[:-1])

# compute exact solution for comparison
yex = ode.y_exact(t,t0,y0)
# plot error
plt.figure()
plt.plot(t,scipy.absolute(y-yex))