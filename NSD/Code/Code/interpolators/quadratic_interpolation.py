# -*- coding: utf-8 -*-

import scipy

class QuadraticInterpolation(object):
    
    def __init__(self,ode):
        self.ode = ode
            
    def interpolate(self,t,y,n):
        """
        Takes an array of t, y and f and interpolates quadratically
        Input:
            - t: array of all time points in the simulation
            - y: array of all solution points
            - n: the current time index
        Output:
            - ttemp: new temporary time array to continue with
            - ytemp: new temporary solution array
            - n: new loaction within t array to store solutions
        """
        # compute new data point via interpolation
        tnew = (t[n-1]+t[n-2])/2.
        ynew = 1./8.*(3*y[n-1,:]+6*y[n-2,:]-y[n-3,:])
        # adjust set of stored solutions
        t[n]=t[n-1]; t[n-1]=tnew
        y[n,:]=y[n-1,:]; y[n-1,:]=ynew;
        # create temporary array for time-steppers
        ttemp = scipy.array(t[n-1:n+1])
        ytemp = scipy.array(y[n-1:n+1,:])
        n = n + 1
        return n,ttemp,ytemp