# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:35:17 2013

@author: giovanni
"""

import scipy

import ode_system

class HamiltonianODE(ode_system.ODESystem):
    
    def __init__(self,potential):
        """ 
        creates an object of the type: logistic ODE 
        of the form y''=-sin y
        Input:
            potential -- a potential class, containing the force 
        Output:
            an object of the class HamiltonianODE with the specified potential 

        """
        self.potential = potential
    
    def f(self,t,y):
        """ 
        contains the righthand side of a logistic ODE 
        of the form y'=f(t,y)=lambd*y*(1-y)
        Input:
            t -- current time
            y -- current state
        Output:
            righthand side f(t,y) 
        
        """
        ydot = scipy.zeros((2,))
        yf = y.flat
        ydot[0]= yf[1]
        ydot[1] = - self.potential.force(yf[0])
        return ydot
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        J = scipy.zeros((2,2))
        yf = y.flat
        J[0,0] = 0.
        J[0,1] = 1.
        J[1,0] = -self.potential.hess(yf[0])
        J[1,1] = 0.
        return J
    
    

