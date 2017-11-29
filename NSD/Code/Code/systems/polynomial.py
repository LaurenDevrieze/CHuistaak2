# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:35:17 2013

@author: giovanni
"""

import scipy

import ode_system

class PolynomialODE(ode_system.ODESystem):
    
    def __init__(self,coeff):
        """ 
        creates an object of the type: polynomial ODE 
        of the form y'= coeff[0]+ coeff[1]*y + ... + coeff[k]*y**k
        
        Output:
            an object of the class PolynomialODE 

        """
        self.coeff = coeff
        
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
        K = scipy.size(self.coeff)
        ypowers = scipy.array([y**k for k in range(K)])
        return scipy.dot(self.coeff,ypowers)
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        K = scipy.size(self.coeff)
        ypowers = scipy.array([k*y**(k-1) for k in range(K)])
        return scipy.dot(self.coeff,ypowers)

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

    

