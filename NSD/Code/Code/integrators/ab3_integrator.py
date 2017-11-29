# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 14:38:53 2013

@author: giovanni
"""
import scipy

import explicit_multi_step_integrator as emsi

class AB3_Integrator(emsi.ExplicitMultiStepIntegrator):
    
    def __init__(self,ode):
        emsi.ExplicitMultiStepIntegrator.__init__(self,ode)
        self.s = 3
        self.constant = None
        self.a = scipy.array([0,0,-1,1])
        self.b = scipy.array([5./12.,-4./3.,23./12.,0])
    

