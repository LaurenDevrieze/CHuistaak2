# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:19:28 2013

@author: giovanni
"""

import explicit_one_step_integrator as eosi

class RK4_Integrator(eosi.ExplicitOneStepIntegrator):
    
    def step(self,t0,y0,h,f0):
        """
        takes a second order Runge-Kutta time step 
        Input:
            t0 -- current time 
            y0 -- state at time t0
            h - size of time step
        Output:
            y -- state at time t0+h
        """
        k1 = f0
        xi2 = y0 + h/2.* k1
        k2 = self.ode.f(t0+h/2.,xi2)
        xi3 = y0+ h/2. * k2
        k3 = self.ode.f(t0+h/2.,xi3)
        xi4 = y0 + h * k3
        k4 = self.ode.f(t0+h,xi4)
        ynew = y0 + h/6. * (k1 + 2.*k2 + 2.*k3 +k4)
        fnew = self.ode.f(t0+h,ynew)
        return ynew, fnew
