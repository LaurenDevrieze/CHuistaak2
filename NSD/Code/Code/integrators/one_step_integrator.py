# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:05:55 2013

@author: giovanni
"""

import scipy

class OneStepIntegrator(object):
        
    def __init__(self,ode):
        """
        Initializes a forward Euler time integration object for the system of
        ODEs specified by the object ode
        Input:
            ode -- an object of the class ODESystem that contain the ODE to be
            integrated
        Output:
            an object of the class ForwardEulerIntegrator that can integrate 
            the ODE specified in the object ode
        """
        self.ode = ode
        # the number of steps is 1 for a one-step integrator
        self.s = 1
    
    def step(self,tn,yn,h,fn):
        """
        takes a single time step
        Beware: this method needs to be overridden for specific methods !
        Input:
            tn -- current time 
            yn -- state at time tn
            h  -- size of time step
            fn -- time derivative at tn
        Output:
            y -- state at time tn+h
            f -- time derivative at tn+h
        """
        raise NotImplementedError
        
    def integrate(self,y0,t0,tend,h):
        """
        Integrates using forward Euler time steps
        Input:
            t0 -- initial time 
            y0 -- initial condition at time t0
            tend -- time horizon of time integration
            Dt -- size of time step
        """
        # obtain the number of time steps
        N = int(scipy.ceil((tend-t0)/h))
        # create a vector of time instances 
        t = scipy.arange(t0,N*h+h/2.,h)
        # obtain the number of equations
        D = scipy.size(y0)
        # create the matrix that will contain the solutions
        y = scipy.zeros((N+1,D))
        # set the initial condition
        y[0,:]=y0
        f = self.ode.f(t0,y0)
        # perform N time steps        
        for n in range(N):
            y[n+1,:],f=self.step(t[n],y[n,:],h,f)
        return t,y

