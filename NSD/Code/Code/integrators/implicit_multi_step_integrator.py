# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:05:55 2013

@author: giovanni
"""
import scipy

import multi_step_integrator as msi

class ImplicitMultiStepIntegrator(msi.MultiStepIntegrator):
        

    def __init__(self,ode,solver):
        """
        Sets the nonlinear solver to be used
        Input:
            solver -- a nonlinear solver to solve the nonlinear systems
        """
        # calls the superclass constructor
        super(ImplicitMultiStepIntegrator,self).__init__(ode)
        # sets a bidirectional coupling between solver and method
        self.solver = solver
        solver.eq=self

    def step(self, tn, yn, h,fn):
        """
        takes a single time step
        Input:
            t0 -- current time
            yn -- state at times t_n, t_{n+1}, ..., t_{n+s}
            fn -- time derivatives at times t_n ... t_{n+s}
            h - size of time step
        Output:
            y -- state at time t_{h+s}
            f -- time derivative at time t_{n+s} 
        """
        # value of time at end of time step
        self.tnh = tn+h
        # size of time step
        self.h = h
        # construct righthand side using all known solution values
        self.setBeta(tn, yn, h,fn) 
        # call nonlinear solver with starting value yn
        ynew = self.solver.solve(yn[-1,:])
        fnew = self.ode.f(self.tnh,ynew)
        return ynew, fnew

    def residual(self,y):
        return y-self.h*self.g(y)-self.beta
    
    def Jacobian(self,y):
        n = scipy.size(y)
        I = scipy.identity(n)
        return I-self.h*self.g_jac(y)
        
    def g(self,y):
        return self.b[-1]*self.ode.f(self.tnh,y)
        
    def g_jac(self,y):
        return self.b[-1]*self.ode.Jacobian(self.tnh,y)
        
    def setBeta(self,tn, yn, h,fn):
        neq = scipy.shape(yn)[1]
        Y = scipy.zeros((neq,))
        F = scipy.zeros((neq,))
        for k in range(self.s):
            Y += -self.a[k]*yn[k,:]
            F += self.b[k]*fn[k,:]
        self.beta = h*F + Y
    
        

