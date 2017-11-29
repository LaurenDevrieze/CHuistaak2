# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:35:17 2013

@author: giovanni
"""

import scipy

import ode_system

class LinearODE(ode_system.ODESystem):
    
    def __init__(self,lambd):
        """ 
        creates an object of the type: linear ODE 
        of the form y'=f(t,y)=lambd*y
        Input:
            lambd -- the parameter for the righthand side
        Output:
            an object of the class LinearODE 

        """
        self.lambd = lambd
        self.neq = 1
        
    def f(self,t,y):
        """ 
        contains the righthand side of a linear ODE 
        of the form y'=f(t,y)=lambd * y
        Input:
            t -- current time
            y -- current state
        Output:
            righthand side f(t,y) 
        
        """
        return self.lambd*y
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        return self.lambd

    def y_exact(self,time,t0,y0):
        """ 
        contains the exact solution of a quadratic ODE  
        Input:
            time -- array of values at which time is required
            y0 -- initial value
            t0 -- initial time
        Output:
            exact solution y(time)
        """
        nt = scipy.size(time)
        yt = scipy.zeros((nt,1))
        yt[:,0]= y0*scipy.exp(self.lambd*time)
        return yt

    

