# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 14:38:53 2013

@author: giovanni
"""

import explicit_multi_step_integrator as emsi

class Template_Integrator(emsi.ExplicitMultiStepIntegrator):
    
    def __init__(self,ode):
        emsi.ExplicitMultiStepIntegrator.__init__(self,ode)
        self.s = FILL IN NUMBER OF STEPS
        self.constant = FILL IN ERROR CONSTANT
        self.a = FILL IN ARRAY OF LENGTH S+1; LAST ENTRY NEEDS TO BE 1
        self.b = FILL IN ARRAY OF LENGTH S+1; LAST ENTRY NEEDS TO BE 0
    


