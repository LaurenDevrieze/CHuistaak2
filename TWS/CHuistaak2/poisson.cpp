#include "vector.hpp"
#include "cg.hpp"
#include "element_apply.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>
#include <limits>
#include <iomanip>
#include <cstdlib>  

/* Lauren Devrieze

Time spent : 5 hours

Commands : g++ -Wall -std=c++14 -o poisson poisson.cpp
		   for i in `seq 1 15`; do ./poisson $((2**$i)); done | tee poisson_"type".out
				=> type = double, float or longdouble
				
Discussion: - for the startvector u, a randomised vector is used. A few different vectors
			  were used to test and the results were very similar.
			- In the figure poisson.pdf we see that the error of double and longdouble is
			  is the same and monotonously decreasing. This is because on double and long-
			  double it is the trunctuation error that has the biggest effect and not the
			  rounding error.
			  For float the error decreases first but then it increases again until the 
			  result is useless. This is caused because of rounding errors. For example
			  adding numbers of different magnitudes with each other.
*/ 

template <typename T>
void matvec( T const& x, T& y){
  assert( x.size()==y.size() ) ;
  typedef typename T::value_type value_type ;
  value_type h = 1.0/(x.size() + 1.0);
  for (int i=1; i<x.size()-1; ++i) {
    y[i] = (1/(h*h))*(-x[i-1] + 2*x[i] - x[i+1]) ;
  }
	y[0] = (1/(h*h))*(2*x[0] - x[1]);
	y[x.size()-1] = (1/(h*h))*(-x[x.size()-2] + 2*x[x.size()-1]);
}

template <typename K>
void expfun(K& v){
	v = exp(v*v/2);
}

int main( int argc, char* argv[]) {
  //Declare variables
  int n = std::atoi(argv[1]);
  typedef long double type;
  tws::vector<type> f(n) ;
  tws::vector<long double> s(n) ;
  tws::vector<type> u(n) ;
  tws::vector<type> v(n) ;
  tws::vector<type> err(n) ;
  type max_norm_err;

  //Initialize values
  for (int i=0; i<u.size(); ++i) {
	type x = (i+ 1.0)/(u.size()+ 1.0);
	s[i] = (x - x*x)*exp(-x);
	f[i] = (x*x - 5*x + 4)*exp(-x);
  }
  u.randomize();
  
  v.randomize();
  tws::element_apply(expfun<type>,v);
  
  //Calculate solution
  tws::cg(matvec<tws::vector<type>>, u, f, 1.e-16,n);
  
  //Calculate max_norm_err
  max_norm_err = 0;
  for (int i = 0; i<u.size(); ++i){
	err[i] = std::abs(s[i]- u[i]); 
	if(err[i] > max_norm_err){
		max_norm_err = err[i];
	}
  }
  
  //Output max_norm_err
  std::cout
  << std::setprecision(std::numeric_limits<long double>::digits10+1)
  << std::scientific;
  std::cout<< n << " " << max_norm_err<< "\t"<< std::endl;

  return 0 ;
} 
