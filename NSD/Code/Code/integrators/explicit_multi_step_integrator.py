# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:05:55 2013

This class contains all common features for explicit one-step integrators

@author: giovanni
"""
import scipy

import multi_step_integrator as msi

class ExplicitMultiStepIntegrator(msi.MultiStepIntegrator):
        
    def step(self,t,y,h,f):
        neq = scipy.shape(y)[1]
        Y = scipy.zeros((neq,))
        F = scipy.zeros((neq,))
        for k in range(self.s):
            Y += -self.a[k]*y[k,:]
            F += self.b[k]*f[k,:]
        ynew = Y + h*F
        fnew = self.ode.f(t+h,ynew)
        return ynew,fnew
        
    