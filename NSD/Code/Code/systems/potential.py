# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:42:30 2013

@author: giovanni
"""

import scipy

class Potential1(object):
    
    def force(self,y):
        """ 
        contains the force for the ODE 
        """
        return scipy.sin(y)
    
    def hess(self,y):
        """
        returns the Jacobian of f with respect to y
        """
        return -scipy.cos(y)
    
class Potential2(object):
    
    def force(self,y):
        """ 
        contains the force for the ODE 
        """
        return y*scipy.sin(y)
    
    def hess(self,y):
        """
        returns the Jacobian of f with respect to y
        """
        return -y*scipy.cos(y)+scipy.sin(y)
        

