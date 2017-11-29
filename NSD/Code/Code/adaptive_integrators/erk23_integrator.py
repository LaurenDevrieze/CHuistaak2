# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:19:28 2013

@author: giovanni
"""
import scipy.linalg

import embedded_rk_integrator as erk

class ERK23_Integrator(erk.EmbeddedRKIntegrator):
    
    def step(self,tcur,ycur,hcur,fcur):
        """
        takes a time step with a second-third order embedded RK pair
        Input:
            tcur -- current time 
            ycur -- state at time tcur
            hcur - size of time current step
        Output:
            y -- state at time tcur+hcur
            f -- time derivative at time tcur+hcur
            kappa -- error estimator 
            
        """
        # base method
        k1 = fcur
        xi2 = ycur + 2./3.*hcur*k1
        k2 = self.ode.f(tcur+2./3.*hcur,xi2)
        # this would be the result for the second order method
        # (note that it is not used later on!!)
        y_order2 = ycur + hcur/4.*(k1+3.*k2)
        # extension for error control
        xi3 = ycur + 2./3.*hcur*k2
        k3 = self.ode.f(tcur+2./3.*hcur,xi3)
        # result for third order method
        y_order3 = ycur + hcur/8.*(2.*k1+3.*k2+3.*k3)
        ynew = y_order3
        fnew = self.ode.f(tcur+hcur,ynew)
        # note that the error estimator uses the third order method to estimate
        # the error on the second order method
        # but, why waste a higher order result? We return the higher order result
        # _as if the error is being reported for that method_... We hope this is
        # an overestimation !!
        kappa = 3./8.*hcur*scipy.linalg.norm(k3-k2)
        return ynew, fnew, kappa

    def step_test(self,tcur,ycur,hcur,fcur):
        """
        takes a time step with a second-third order embedded RK pair
        Input:
            tcur -- current time 
            ycur -- state at time tcur
            hcur - size of time current step
        Output:
            y -- state at time tcur+hcur
            f -- time derivative at time tcur+hcur
            kappa -- error estimator 
            
        """
        # base method
        k1 = fcur
        xi2 = ycur + 2./3.*hcur*k1
        k2 = self.ode.f(tcur+2./3.*hcur,xi2)
        # this would be the result for the second order method
        # (note that it is not used later on!!)
        y_order2 = ycur + hcur/4.*(k1+3.*k2)
        # extension for error control
        xi3 = ycur + 2./3.*hcur*k2
        k3 = self.ode.f(tcur+2./3.*hcur,xi3)
        # result for third order method
        y_order3 = ycur + hcur/8.*(2.*k1+3.*k2+3.*k3)
        ynew = y_order3
        fnew = self.ode.f(tcur+hcur,ynew)
        # note that the error estimator uses the third order method to estimate
        # the error on the second order method
        # but, why waste a higher order result? We return the higher order result
        # _as if the error is being reported for that method_... We hope this is
        # an overestimation !!
        kappa = 3./8.*scipy.linalg.norm(k3-k2)
        return y_order2, y_order3, kappa

