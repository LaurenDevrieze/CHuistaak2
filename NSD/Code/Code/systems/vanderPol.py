# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:35:17 2013

@author: giovanni
"""

import scipy

import ode_system

class VanderPolODE(ode_system.ODESystem):
    
    def __init__(self,eps):
        """ 
        creates an object of the type: van der Pol ODE
        Input:
            lambd -- the parameter for the righthand side
        Output:
            an object of the class VanderPolODE 

        """
        self.eps = eps
    
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
        ydot[1] = self.eps*(1-yflat[0]**2)*yflat[1]-yflat[0]
        return ydot
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        # make a one-dimensional array to avoid dimension conflicts
        # between row and column vectors
        yflat = y.flat
        J = scipy.zeros((2,2))
        J[0,0]=0.
        J[0,1]=1.
        J[1,0]=-2*self.eps*yflat[0]*yflat[1]-1.
        J[1,1]=self.eps*(1-yflat[0]**2)
        return J
    
    

