# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:35:17 2013

@author: giovanni
"""

import scipy

import ode_system

class DiffusionODE(ode_system.ODESystem):
    
    def __init__(self,N):
        """ 
        Input:
            lambd -- the parameter for the righthand side
        Output:
            an object of the class LinearODE 

        """
        self.N = N
        # needs to be changed to a sparse matrix format
        A = scipy.zeros((N,N)) 
        A[0,0] = -20.
        A[0,1] = 10.
        for n in range(1,N-1):
            A[n,n-1] = 10.
            A[n,n] = -20.
            A[n,n+1] = 10.
        A[-1,-2] = 10
        A[-1,-1] = -20        
        self.A = A
        self.neq = N
        
    def f(self,t,y):
        """ 
        contains the righthand side of a linear ODE 
        of the form y'=f(t,y)= A * y with A = tridiag (10,-20,10)
        Input:
            t -- current time
            y -- current state
        Output:
            righthand side f(t,y) 
        
        """
        ydot = scipy.zeros((self.N,))
        ydot[0] = -20.*y[0]+10.*y[1]
        for n in range(1,self.N-1):
            ydot[n] = 10.*y[n-1]-20.*y[n]+10.*y[n+1]
        ydot[-1] = 10.*y[-2]-20.*y[-1]
        return ydot
    
    def Jacobian(self,t,y):
        """
        returns the Jacobian of f with respect to y
        """
        return self.A

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
        yt = scipy.zeros((nt,self.N))
        for n in range(nt):
            yt[n,:]= scipy.dot(scipy.linalg.expm(self.A*time[n]),y0)
        return yt

    

