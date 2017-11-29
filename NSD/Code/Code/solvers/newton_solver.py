# -*- coding: utf-8 -*-

# -*- coding: utf-8 -*-

import scipy.linalg

import nonlinear_solver as nls

class NewtonSolver(nls.NonLinearSolver):
            
    def iterate(self,y):
        """
        takes the current guess and updates it using Newton's method
        Input:
            yk -- current guess of solution
        Output:
            an updated guess of the solution                
        """
        # flattened to resolve conflict with row and column vector
        minres = -self.eq.residual(y)
        minresflat = minres.flat
        J = self.eq.Jacobian(y)
        dy = scipy.linalg.solve(J,minresflat)
        return y + dy        

