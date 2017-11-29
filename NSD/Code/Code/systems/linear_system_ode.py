# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:42:30 2013

@author: giovanni
"""

import scipy
import scipy.linalg

import ode_system

class LinearSystemODE(ode_system.ODESystem):
    
    def __init__(self,A):
        """ 
        creates an object of the type type: linear ODE system
        of the form y'=f(t,y)=A*y
        Input:
            lambd -- the eigenvalue for the righthand side
        """
        self.A = A
        self.neq = scipy.shape(A)[0]
    
    def f(self,t,y):
        """ 
        contains the righthand side of a linear scalar ODE 
        of the form y'=f(t,y)=lambd*y
        """
        return scipy.dot(self.A,y)
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        return self.A
    
    def y_exact(self,t,t0,y0):
        return scipy.array([scipy.dot(scipy.linalg.expm(self.A*(t[n]-t0)),y0) \
                            for n in range(len(t))])
        

