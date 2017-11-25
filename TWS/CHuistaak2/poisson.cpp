#include "vector.hpp"
#include "cg.hpp"
#include "element_apply.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>
#include <limits>
#include <iomanip>
#include <algorithm>  

/* Lauren Devrieze

Time spent :

Commands : g++ -Wall -std=c++14 -o poisson poisson.cpp

*/

template <typename T>
void matvec( T const& x, T& y){
  assert( x.size()==y.size() ) ;
  double h = 1.0/(x.size() + 1.0);
  std::cout<<"h :"<<h<<std::endl;
  for (int i=1; i<x.size()-1; ++i) {
    y[i] = (1/(h*h))*(-x[i-1] + 2*x[i] - x[i+1]) ;
  }
	y[0] = (1/(h*h))*(2*x[0] - x[1]);
	y[x.size()-1] = (1/(h*h))*(-x[x.size()-2] + 2*x[x.size()-1]);
}

template <typename T>
void expfun(T& v){
	v = exp(v*v/2);
}

int main() {
  int n=100;
  typedef double type;
  tws::vector<type> f(n) ;
  tws::vector<type> f_ex(n) ;
  tws::vector<type> s(n) ;
  tws::vector<type> u(n) ;
  tws::vector<type> v(n) ;
  tws::vector<type> y(n) ;
  tws::vector<type> err(n) ;
  type max_norm_err;

  //Initialize values
  for (int i=0; i<u.size(); ++i) {
	type x = (i+1)/(s.size()+1);
	s[i] = (x - x*x)*exp(-x);
	f[i] = (x*x - 5*x + 4)*exp(-x);
  }
  u.randomize();
  
  v.randomize();
  tws::element_apply(expfun,v);
  
  //matvec(u,y)
  
  tws::cg(matvec<tws::vector<double>>, u, f, 1.e-10,n);
  //matvec<tws::vector<double>>(u,sol);
  
  //Calculate max_norm_err
  for (int i = 0; i<u.size(); ++i){
	err[i] = std::abs(s[i]-u[i]); 
  }
  max_norm_err = std::max(err)
  
  std::cout
  << std::setprecision(std::numeric_limits<long double>::digits10+1)
  << std::scientific;
  std::cout<< n << " " << max_norm_err<< "\t"<< std::endl;
  
  //std::cout<<tws::norm_2(sol-b_ex)/tws::norm_2(b_ex)<<std::endl;
  //std::cout<<"f_ex"<<x<<std::endl;
  std::cout<<"f"<<f<<std::endl;
  std::cout<<"u"<<u<<std::endl;
  std::cout<<"s"<<s<<std::endl;
  std::cout<<"y"<<y<<std::endl;
  //std::cout<<"sol"<<sol<<std::endl;

  return 0 ;
} 
