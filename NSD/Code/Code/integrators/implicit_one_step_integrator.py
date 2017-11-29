# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:05:55 2013

@author: giovanni
"""
import scipy

import one_step_integrator as osi

class ImplicitOneStepIntegrator(osi.OneStepIntegrator):
        

    def __init__(self,ode,solver):
        """
        Sets the nonlinear solver to be used
        Input:
            solver -- a nonlinear solver to solve the nonlinear systems
        """
        # calls the superclass constructor
        super(ImplicitOneStepIntegrator,self).__init__(ode)
        # sets a bidirectional coupling between solver and method
        self.solver = solver
        # self.nu needs to contain the number of stages
        self.nu = None
        # self.c needs to contain the stage instances
        self.c = None
        self.b = None
        solver.eq=self

    def step(self,tn,yn,h,fn):
        """
        takes a single time step using an implicit method
        Input:
            tn -- current time 
            yn -- state at time tn
            h  -- size of time step
            fn -- time derivative at time tn+h
        Output:
            y -- state at time tn+h
            f -- time derivative at time tn+h
        """
        # size of time step
        self.h = h
        # set stage-times
        self.stage_times = tn+self.c*h
        # call nonlinear solver with starting value yn
        self.setBeta(yn)
        wn = self.beta
        w = self.solver.solve(wn)
        ynew = self.process(yn,w,h)
        fnew = self.ode.f(tn+h,ynew)
        return ynew,fnew
    
    def process(self,yn,w,h):
        n = scipy.size(yn)
        tc = self.stage_times
        b = self.b
        rhs = scipy.zeros_like(yn)
        for i in range(self.nu):
            rhs +=b[i]*self.ode.f(tc[i],w[i*n:(i+1)*n])
        return yn+h*rhs
    
    def residual(self,w):
        return w-self.h*self.g(w)-self.beta
    
    def Jacobian(self,w):
        n = scipy.size(w)
        I = scipy.identity(n)
        return I-self.h*self.g_jac(w)
        
    def g(self,w):
        raise NotImplementedError
        
    def g_jac(self,w):
        raise NotImplementedError
        
    def setBeta(self,yn):
        neq = scipy.size(yn)
        wn = scipy.zeros((self.nu*neq,))
        for i in range(self.nu):
            wn[i*neq:(i+1)*neq]=yn
        self.beta = wn
        
    
    


