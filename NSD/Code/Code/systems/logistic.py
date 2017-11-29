# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:35:17 2013

@author: giovanni
"""

import scipy

import ode_system

class LogisticODE(ode_system.ODESystem):
    
    def __init__(self,lambd):
        """ 
        creates an object of the type: logistic ODE 
        of the form y'=f(t,y)=lambd*y*(1-y)
        Input:
            lambd -- the parameter for the righthand side
        Output:
            an object of the class LogisticODE 

        """
        self.lambd = lambd
        self.neq = 1
    
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
        return self.lambd*y*(1-y)
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        return self.lambd*(1-2*y)
    
    def y_exact(self,time,t0,y0):
        """ 
        contains the exact solution of the logistic equation  
        Input:
            time -- array of values at which time is required
            y0 -- initial value
            t0 -- initial time
        Output:
            exact solution y(time)
        """
        nt = scipy.size(time)
        yt = scipy.zeros((nt,1))
        C = y0/(1-y0)
        yt[:,0]= C*scipy.exp(self.lambd*(time-t0))/(1+C*scipy.exp(self.lambd*(time-t0)))
        return yt

    

