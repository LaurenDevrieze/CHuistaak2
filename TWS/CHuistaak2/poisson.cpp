#include "vector.hpp"
#include "cg.hpp"
#include "element_apply.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>

/* Lauren Devrieze

Time spent :

Commands : g++ -Wall -std=c++14 -o poisson poisson.cpp

*/

template <typename T>
void poissonFun( T const& x, T& y){
	assert( x.size()==y.size() ) ;
  double h = 1/(x.size() + 1);
  for (int i=1; i<x.size()-1; ++i) {
    y[i] = (1/(h*h))*(-x[i-1] + 2*x[i] - x[i+1]) ;
  }
	y[0] = (1/(h*h))*(2*x[0] - x[1]);
	y[x.size()-1] = (1/(h*h))*(-x[x.size()-2] + 2*x[x.size()-1]);
}

template <typename T>
void expfun(T& v){
	v = exp(v*v/2)
}

int main() {
  int n=100;
  tws::vector<double> f(n) ;
  tws::vector<double> f_ex(n) ;
  tws::vector<double> s(n) ;
  tws::vector<double> u(n) ;
  tws::vector<double> sol(n) ;
  tws::vector<double> v(n) ;

  //Initialize values
  for (int i=0; i<x.size(); ++i) {
	double x = (i+1)/(s.size()+1);
	s[i] = (x - x*x)*exp(-x);
	f[i] = (x*x - 5*x + 4)*exp(-x);
  }
  u.randomize();
  
  v.randomize();
  tws::element_apply(v);
  
  tws::cg(poissonFun<tws::vector<double>>, u, f, 1.e-10,n);
  poissonFun<tws::vector<double>>(u,sol);

  //std::cout<<"relative error: "<<tws::norm_2(sol-b_ex)/tws::norm_2(b_ex)<<std::endl;
  //std::cout<<"f_ex"<<x<<std::endl;
  std::cout<<"f"<<f<<std::endl;
  std::cout<<"x"<<x<<std::endl;
  std::cout<<"s"<<s<<std::endl;
  //std::cout<<"sol"<<sol<<std::endl;

  return 0 ;
} 
