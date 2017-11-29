# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:42:30 2013

@author: giovanni
"""

import scipy
import scipy.linalg

import ode_system

class SphereODE(ode_system.ODESystem):
    
    def __init__(self):
        """ 
        creates an object of the type type: linear ODE system
        of the form y'=f(t,y)=A*y
        Input: None
        
        """
        pass
    
    def f(self,t,y):
        """ 
        contains the righthand side of the ODE 
        """
        ydot = scipy.zeros((3,))
        yf = y.flat
        ydot[0] = yf[1]*yf[2]*scipy.sin(t)-yf[0]*yf[1]*yf[2]
        ydot[1] = -yf[0]*yf[2]*scipy.sin(t)+1./20.*yf[0]*yf[2]
        ydot[2] = yf[0]**2*yf[1]-1./20.*yf[0]*yf[1]
        return ydot
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        J = scipy.zeros((3,3))
        yf = y.flat
        J[0,0] = -yf[1]*yf[2]
        J[0,1] = yf[2]*scipy.sin(t)-yf[0]*yf[2]
        J[0,2] = yf[1]*scipy.sin(t)-yf[0]*yf[1]
        J[1,0] = -yf[2]*scipy.sin(t)+1./20.*yf[2]
        J[1,1] = 0.
        J[1,2] = -yf[0]*scipy.sin(t)+1./20.*yf[0]
        J[2,0] = 2*yf[0]*yf[1]-1./20.*yf[1]
        J[2,1] = yf[0]**2-1./20.*yf[0]
        J[2,2] = 0.    
        return J
    
        

