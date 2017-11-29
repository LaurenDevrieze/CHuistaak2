# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 14:38:53 2013

@author: giovanni
"""
import scipy

import implicit_multi_step_integrator as imsi

class Template_Integrator(imsi.ImplicitMultiStepIntegrator):
    
    def __init__(self,ode,solver):
        imsi.ImplicitMultiStepIntegrator.__init__(self,ode,solver)
        self.s = FILL IN NUMBER OF STEPS
        self.constant = FILL IN ERROR CONSTANT
        self.a = FILL IN ARRAY OF LENGTH S+1; LAST ENTRY NEEDS TO BE 1
        self.b = FILL IN ARRAY OF LENGTH S+1; LAST ENTRY NEEDS TO BE NONZERO
    


