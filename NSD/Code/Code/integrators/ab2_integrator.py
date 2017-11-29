# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 14:38:53 2013

@author: giovanni
"""

import scipy.linalg

import explicit_multi_step_integrator as emsi

class AB2_Integrator(emsi.ExplicitMultiStepIntegrator):
    
    def __init__(self,ode):
        emsi.ExplicitMultiStepIntegrator.__init__(self,ode)
        self.s = 2
        self.constant = 5./12.
        self.a = scipy.array([0,-1,1])
        self.b = scipy.array([-1./2.,3./2.,0])
    

