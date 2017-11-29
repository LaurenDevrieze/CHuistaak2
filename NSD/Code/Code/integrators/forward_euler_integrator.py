# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:11:11 2013

@author: giovanni
"""

import explicit_one_step_integrator as eosi

class ForwardEulerIntegrator(eosi.ExplicitOneStepIntegrator):
        
    def step(self,t0,y0,h,f0):
        """
        takes a forward Euler time step 
        Input:
            t0 -- current time 
            y0 -- state at time t0
            h - size of time step
        Output:
            y -- state at time t0+h
        """
        ynew = y0 + h*f0
        fnew = self.ode.f(t0+h,ynew)
        return ynew, fnew
    
