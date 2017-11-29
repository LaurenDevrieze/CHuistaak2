# -*- coding: utf-8 -*-
"""
Created on Fri Oct 25 11:05:55 2013

@author: giovanni
"""

import scipy

import integrators.forward_euler_integrator as fei

class MilneMultiStepIntegrator(object):

    def __init__(self, ode,integrator,control,interpolator, param = None):
        """
        Initializes a forward Euler time integration object for the system of
        ODEs specified by the function rhs.
        Input:
            ode --  the ODE to be integrated
            integrator -- the integrator that will be used to compute the result
            control -- the integrator that will be used to estimate the error
        Output:
            an integrator object that can integrate the ODE y'=f(t,y) with 
            adaptive step size control
        """
        self.ode = ode
        self.integrator = integrator
        self.control = control
        self.interpolator = interpolator
        # self.s should contain the number of stages of the integrator
        self.s = self.integrator.s
        # self.q should contain the extra number of stages for the control 
        # integrator
        self.q = self.control.s - self.integrator.s 
        if param == None:
            param = MilneMultiStepIntegrator.getDefaultParameters()
        self.param = param

    def getDefaultParameters():
        """
        Sets the default parameters of the Milne device
        Output: 
            a structure containing parameters:
            - delta : tolerance per time step
        """
        param = {}
        param['delta'] = 1e-5
        return param
    getDefaultParameters = staticmethod(getDefaultParameters)

    def step(self, tn, yn, h, fn):
        """
        takes a single time step
        Beware: this method needs to be overridden for specific methods !
        Input:
            t0 -- current time
            yn -- state at times t_n, t_{n+1}, ..., t_{n+s}
            fn -- time derivatives at times t_n ... t_{n+s}
            h - size of time step
        Output:
            y -- state at time t_{h+s}
            f -- time derivative at time t_{n+s}
            err -- an estimate of norm of the local error made during the step
        """
        # compute the solution at the next time step  
        q = self.q
        ynew,fnew = self.integrator.step(tn[-1],yn[q:,:],h,fn[q:,:])
        # estimate error using Milne device
        xnew,fxnew = self.control.step(tn[-1],yn,h,fn)
        c = self.integrator.constant 
        ctilde = self.control.constant
        kappa = scipy.absolute(c/(c-ctilde))*scipy.linalg.norm(ynew - xnew)
        return ynew, fnew, kappa      
        
    def integrate(self,y0,t0,tend,h0):
        """
        Integrates over a number of time steps
        Input:
            t0 -- initial time 
            y0 -- initial condition at time t0
            tend -- time horizon of time integration
            h0 -- size of initial time step (needs to be very small)
        """
        # have temporary storage for solution (can be adjusted later) 
        # (append is a very bad option for memory management)
        # obtain the number of time steps, assuming constant time step
        N = int(scipy.ceil(tend/h0))
        # create a vector of time instances 
        t = scipy.zeros((N+1,))
        # obtain a number of equations
        D = scipy.size(y0)
        # create a matrix that will contain the solutions
        y = scipy.zeros((N+1,D))
        # create a matrix that will contain all time derivatives
        # to avoid re-evaluation of time derivatives
        f = scipy.zeros((N+1,D))
        # perform the time integration
        s = self.s
        q = self.q
        # put starting values to exact solution if available
        t[0:s+q]=h0*scipy.arange(0,s+q)
        try:
            y[0:s+q,:]=self.ode.y_exact(t[0:s+q],t0,y0)
            for m in range(s+q):
                f[m,:]=self.ode.f(t[m],y[m,:])
        except NotImplementedError:
            # if we arrive here, then ode.y_exact is not implemented
            # in a good code, one would use a variable order method to start up
            # here, I just used forward Euler -- I assume the initial step
            # is chosen very small !
            fe = fei.ForwardEulerIntegrator(self.ode)
            y[0,:]=y0;
            f[0,:] = self.ode.f(t[0],y[0,:])
            for k in range(1,s+q):
                y[k,:],f[k,:]=fe.step(t[k-1],y[k-1,:],h0,f[k-1,:])
        # current time
        tcur = (s+q-1)*h0
        n = s+q
        # current step size
        hcur = h0
        # copy the needed data into a temporary array
        ttemp = scipy.array(t[n-s-q:n])
        ytemp = scipy.array(y[n-s-q:n,:])
        ftemp = scipy.array(f[n-q-s:n,:])
        # keep track of whether we are able to double step size
        doubling_allowed = False
        steps_until_doubling = s-q+1
        # loop until end time is reached
        while tcur < tend:
            # take the next step 
            ynew,fnew,kappa=self.step(ttemp,ytemp,hcur,\
                                ftemp)
            # decide to accept the step or not
            if kappa < hcur*self.param['delta']:
                # step gets accepted 
                # update current time  
                tcur = tcur + hcur
                # store solution
                y[n,:]=ynew
                t[n]=tcur
                f[n,:]=fnew
                # update temporary array
                ttemp[:-1]=ttemp[1:]; ttemp[-1]=tcur
                ytemp[:-1,:]=ytemp[1:,:]; ytemp[-1,:]=ynew
                ftemp[:-1,:]=ftemp[1:,:]; ftemp[-1,:]=fnew
                # update where we are in the integration
                n = n+1
                # keep track of ability to double or not
                if (steps_until_doubling == 0):
                    doubling_allowed = True
                if (not doubling_allowed):
                    steps_until_doubling = steps_until_doubling - 1
            else:
                # step gets rejected -> halve step size and redo step
                hcur = hcur / 2.
                # interpolate on new mesh 
                n,ttemp,ytemp = self.interpolator.interpolate(t,y,n)   
                # evaluate time derivative
                ftemp = scipy.zeros_like(ytemp)
                for k in range(len(ttemp)):                
                    ftemp[k,:] = self.ode.f(ttemp[k],ytemp[k,:])
            if (kappa < 0.1*hcur*self.param['delta'] and doubling_allowed):
                # step size got accepted, but is too small
                # double step size
                hcur = hcur * 2.
                # take points that are further apart
                ttemp = scipy.array(t[n-2*(s+q)+1:n+1:2])
                ytemp = scipy.array(y[n-2*(s+q)+1:n+1:2,:])
                ftemp = scipy.array(f[n-2*(s+q)+1:n+1:2,:])
                # we are not allowed to double step too quickly
                doubling_allowed = False
                steps_until_doubling = s

        return t[:n],y[:n]

