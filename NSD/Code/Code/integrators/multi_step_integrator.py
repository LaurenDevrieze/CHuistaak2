# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:05:55 2013

@author: giovanni
"""

import scipy

import integrators.forward_euler_integrator as fei

class MultiStepIntegrator(object):

    def __init__(self, ode):
        """
        Initializes a forward Euler time integration object for the system of
        ODEs specified by the function rhs.
        Input:
            ode -- an object of the class ODESystem that contain the ODE to be
            integrated
        Output:
            an object of the class ForwardEulerIntegrator that can integrate
            the ODE y'=f(t,y)
        """
        self.ode = ode
        # self.s should contain the number of stages; at this abstract level
        # this number of stages is not defined; hence the None
        self.s = None

    def step(self, tn, yn, h, fn):
        """
        takes a single time step
        Beware: this method needs to be overridden for specific methods !
        Input:
            t0 -- current time
            yn -- state at times t_n, t_{n+1}, ..., t_{n+s}
            fn -- time derivatives at times t_n ... t_{n+s}
            h - size of time step
        Output:
            y -- state at time t_{h+s}
            f -- time derivative at time t_{n+s} 
        """
        raise NotImplementedError
        
    def integrate(self,y0,t0,tend,h):
        """
        Integrates over a number of time steps
        Input:
            t0 -- initial time 
            y0 -- initial condition at time t0
            tend -- time horizon of time integration
            h -- size of time step
        """
        # obtain the number of time steps
        N = int(scipy.ceil(tend/h))
        # create a vector of time instances 
        t = scipy.arange(t0,N*h+h/2.,h)
        # obtain the number of equations
        D = scipy.size(y0)
        # create the matrix that will contain the solutions
        y = scipy.zeros((N+1,D))
        # create a matrix that will contain all time derivatives
        # to avoid re-evaluation of time derivatives
        f = scipy.zeros((N+1,D))
        # perform the time integration
        s = self.s
        # put starting values to exact solution
        try:
            y[0:s,:]=self.ode.y_exact(t[0:s],t0,y0)
            for m in range(s):
                f[m,:]=self.ode.f(t[m],y[m,:])
        except NotImplementedError:
            # if we arrive here, then ode.y_exact is not implemented
            # in a good code, one would use a variable order method to start up
            # here, I just used forward Euler -- I assume the initial step
            # is chosen sufficiently small !
            fe = fei.ForwardEulerIntegrator(self.ode)
            y[0,:]=y0;
            f[0,:] = self.ode.f(t[0],y[0,:])
            for k in range(1,s):
                y[k,:],f[k,:]=fe.step(t[k-1],y[k-1,:],h,f[k-1,:])

        for n in range(N-s+1):
            # take the next step (and also obtain the time derivative in 
            # the next point)
            y[n+s,:],f[n+s,:]=self.step(t[n+s-1],y[n:n+s,:],h,f[n:n+s,:])
        return t,y

