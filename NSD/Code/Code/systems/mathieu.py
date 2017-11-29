# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:35:17 2013

@author: giovanni
"""

import scipy

import ode_system

class MathieuODE(ode_system.ODESystem):
    
    def __init__(self):
        """ 
        creates an object of the type: Mathieu ODE
        Output:
            an object of the class MathieuODE 

        """
        pass 
        
    def f(self,t,y):
        """ 
        contains the righthand side of van der Pol ODE
        Input:
            t -- current time
            y -- current state
        Output:
            righthand side f(t,y) 
        
        """
        # make a one-dimensional array to avoid dimension conflicts
        # between row and column vectors
        yflat = y.flat
        ydot = scipy.zeros_like(yflat)
        ydot[0] = yflat[1]
        ydot[1] = -(2.-scipy.cos(2.*t))*yflat[0]
        return ydot
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        # make a one-dimensional array to avoid dimension conflicts
        # between row and column vectors
        J = scipy.zeros((2,2))
        J[0,0]=0.
        J[0,1]=1.
        J[1,0]=-(2.-scipy.cos(2.*t))
        J[1,1]=0.
        return J
    
    

