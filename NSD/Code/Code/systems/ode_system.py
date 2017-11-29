# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:03:06 2013

@author: giovanni
"""

class ODESystem(object):
    
    def __init__(self):
        """
        Constructor for ODE system.  Input can take the form that the 
        subclasses desire. This abstract class is meant to create a common 
        interface that can be used by Integrator objects.
        """
        raise NotImplementedError

    def f(self,t,y):
        """
        Return the righthand side of the ODE
        """
        raise NotImplementedError        
    
    def Jacobian(self,t,y):
        raise NotImplementedError
        
    def y_exact(self,t,t0,y0):
        """
        Returns the exact solution for the ODE at times t, 
        starting from y0 at time t=0
        """
        raise NotImplementedError
        
