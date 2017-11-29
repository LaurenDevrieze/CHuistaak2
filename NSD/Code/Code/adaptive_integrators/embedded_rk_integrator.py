# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:05:55 2013

@author: giovanni
"""

import scipy

class EmbeddedRKIntegrator(object):
        
    def __init__(self,ode,param=None):
        """
        Initializes an Embedded Runge-Kutta time integration object for the system of
        ODEs specified by the object ode
        Input:
            ode -- an object of the class ODESystem that contain the ODE to be
            integrated
        Output:
            an object of the class EmbeddedRKIntegrator that can integrate 
            the ODE specified in the object ode
        """
        self.ode = ode
        # the number of steps is 1 for a one-step integrator
        self.s = 1
        if param == None:
            param = EmbeddedRKIntegrator.getDefaultParameters()
        self.param = param

    def getDefaultParameters():
        """
        Sets the default parameters of the Milne device
        Output: 
            a structure containing parameters:
            - delta : tolerance per time step
        """
        param = {}
        param['delta'] = 1e-5
        return param
    getDefaultParameters = staticmethod(getDefaultParameters)
    
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
            kappa -- error estimate for the current time step
        """
        raise NotImplementedError
        
    def integrate(self,y0,t0,tend,h0):
        """
        Integrates using forward Euler time steps
        Input:
            t0 -- initial time 
            y0 -- initial condition at time t0
            tend -- time horizon of time integration
            Dt -- size of time step
        """
        # obtain the number of time steps
        N = int(scipy.ceil(tend/h0))
        # create a vector of time instances 
        t = scipy.arange(t0,N*h0+h0/2.,h0)
        # obtain the number of equations
        D = scipy.size(y0)
        # create the matrix that will contain the solutions
        y = scipy.zeros((N+1,D))
        # set the initial condition
        y[0,:]=y0
        f0 = self.ode.f(t0,y0)
        # perform N time steps      
        ycur = y0
        fcur = f0
        hcur = h0
        tcur = t0
        n = 1
        while (tcur < tend):
#            print n, tcur, hcur
            ynew,fnew,kappa=self.step(tcur,ycur,hcur,\
                                fcur)
#            print kappa, self.param['delta']*hcur
#            print "+++"
            # decide to accept the step or not
            if kappa < hcur*self.param['delta']:
                # step gets accepted 
                tcur = tcur + hcur; t[n]=tcur; 
                # store solution
                ycur = ynew; y[n,:]=ycur
                fcur = fnew; 
                # update where we are in the integration
                n = n+1
            else:
                # step gets rejected -> halve step size and redo step
                hcur = hcur / 2.
            if (kappa < 0.1*hcur*self.param['delta']):
                # step size got accepted, but is too small
                # double step size
                hcur = hcur * 2.
        return t[:n],y[:n,:]

