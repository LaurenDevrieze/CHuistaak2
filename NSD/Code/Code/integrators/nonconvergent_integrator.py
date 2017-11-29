# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 14:38:53 2013

@author: giovanni
"""

import explicit_multi_step_integrator as emsi

class NonConvergent_Integrator(emsi.ExplicitMultiStepIntegrator):
    
    def __init__(self,ode):
        emsi.ExplicitMultiStepIntegrator.__init__(self,ode)
        self.s = 2
    
    def step(self,t,y,h,f):
        ynew = 2.01*y[1,:]-1.01*y[0,:] + h * (0.995*f[1,:]-1.005*f[0,:])
        fnew = self.ode.f(t+h,ynew)
        return ynew,fnew


