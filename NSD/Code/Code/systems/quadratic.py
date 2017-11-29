# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:35:17 2013

@author: giovanni
"""

import scipy

import ode_system

class QuadraticODE(ode_system.ODESystem):
    
    def __init__(self):
        """ 
        creates an object of the type: quadratic ODE 
        of the form y'=f(t,y)=-y^2
        
        Output:
            an object of the class QuadraticODE 

        """
        pass
        
    def f(self,t,y):
        """ 
        contains the righthand side of a quadratic ODE 
        of the form y'=f(t,y)=-y^2
        Input:
            t -- current time
            y -- current state
        Output:
            righthand side f(t,y) 
        
        """
        return -y**2
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        return -2*y

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
        yt[:,0]= 1./(1.+time)
        return yt

    

