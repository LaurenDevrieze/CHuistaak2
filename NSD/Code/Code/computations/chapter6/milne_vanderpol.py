# -*- coding: utf-8 -*-
"""
This file tests the Milne device on the VanderPol equation
"""

import sys
sys.path.append("../../")

import scipy
import matplotlib.pyplot as plt

import systems.vanderPol as vanderPol
import solvers.newton_solver as ns
import integrators.ab2_integrator
import integrators.ab3_integrator
import integrators.trapezium_integrator
import interpolators.quadratic_interpolation as qi
import adaptive_integrators.milne_multistep_integrator as mmi

# create ODE    
eps = 1.
ode = vanderPol.VanderPolODE(eps)

# initial condition 
y0 = 0.5*scipy.ones((2,))
t0 = 0.
# end time of simulation
# time steps
h0 = 0.001
tend = 10.

# create AB2 integrator
ab2 = integrators.ab2_integrator.AB2_Integrator(ode)
# create TR integrator with Newton solver
nsolver = ns.NewtonSolver()
tr = integrators.trapezium_integrator.TrapeziumIntegrator(ode,nsolver)
# create interpolator
interpol = qi.QuadraticInterpolation(ode)

# create Milne integrator
param=mmi.MilneMultiStepIntegrator.getDefaultParameters()
param['delta']=1e-4
mil = mmi.MilneMultiStepIntegrator(ode,tr,ab2,interpol,param)

# integrate
t,y = mil.integrate(y0,t0,tend,h0)

# plot solution
plt.figure()      
plt.plot(t,y)

# plot time steps taken
# not that these are not exactly the time steps taken, because the interpolated
# values are also stored -- this is one of the reasons for a difference wrt
# the book by Iserles
plt.figure()
plt.plot(t[1:],t[1:]-t[:-1])

# compute reference solution -- high order, fine time step, for comparison
hfine = 1e-5
ab3 = integrators.ab3_integrator.AB3_Integrator(ode)
tfine,yfine = ab3.integrate(y0,t0,t[-1]+hfine/2.,hfine)

ind = t/hfine
indices = ind.astype(int)

plt.figure()
plt.plot(t,scipy.absolute(y-yfine[indices,:]))
