# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 14:38:53 2013

@author: giovanni
"""
import scipy

import implicit_multi_step_integrator as imsi

class BDF2_Integrator(imsi.ImplicitMultiStepIntegrator):
    
    def __init__(self,ode,solver):
        imsi.ImplicitMultiStepIntegrator.__init__(self,ode,solver)
        self.s = 2
        self.constant = None
        self.a = scipy.array([1./3.,-4./3.,1.])
        self.b = scipy.array([0.,0.,2./3.])
    


