# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:05:55 2013

@author: giovanni
"""

import scipy

import implicit_one_step_integrator as iosi

class ImplicitMidpointIntegrator(iosi.ImplicitOneStepIntegrator):
        

    def __init__(self,ode,solver):
        """
        Sets the nonlinear solver to be used
        Input:
            solver -- a nonlinear solver to solve the nonlinear systems
        """
        # calls the superclass constructor
        super(ImplicitMidpointIntegrator,self).__init__(ode,solver)
        # self.nu needs to contain the number of stages
        self.nu = 1
        self.c = scipy.array([1./2.])
        self.b = scipy.array([1.])
    
    def g(self,w):
        tc = self.stage_times[0]
        return 1./2.*self.ode.f(tc,w)
    
    def g_jac(self,w):
        tc = self.stage_times[0]
        return 1./2.*self.ode.Jacobian(tc,w)




