# -*- coding: utf-8 -*-
"""
Created on Mon Oct 14 22:06:01 2013

@author: giovanni
"""

import scipy
import scipy.linalg
import implicit_one_step_integrator as iosi

class TrapeziumIntegrator(iosi.ImplicitOneStepIntegrator):
    """ 
    A trapezoidal integrator 
    """
    def __init__(self,ode,solver):
        """
        Sets the nonlinear solver to be used
        Input:
            solver -- a nonlinear solver to solve the nonlinear systems
        """
        # calls the superclass constructor
        super(TrapeziumIntegrator,self).__init__(ode,solver)
        # self.nu needs to contain the number of stages
        self.nu = 2
        self.c = scipy.array([0.,1.])
        self.b = scipy.array([1./2.,1./2.])
        self.constant = -1./12.
            
    def g(self,w):
        result = scipy.zeros_like(w)
        tc = self.stage_times
        neq = scipy.size(w)/self.nu
        result[neq:]= 1./2.*(self.ode.f(tc[0],w[:neq])+\
                        self.ode.f(tc[1],w[neq:]))
        return result
        
    def g_jac(self,w):
        tc = self.stage_times
        n = scipy.size(w)
        neq = n/self.nu
        result = scipy.zeros((n,n))
        result[neq:,:neq] = 1./2.*self.ode.Jacobian(tc[0],w[:neq])
        result[neq:,neq:] = 1./2.*self.ode.Jacobian(tc[1],w[neq:])
        return result