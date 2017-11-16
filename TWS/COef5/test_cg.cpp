#include "vector.hpp"
#include "cg.hpp"
#include <iostream>
#include <typeinfo>
#include <type_traits>

template <typename T>
class matvec{
public:
void operator() ( T const& x, T& y ) const {
    assert( x.size()==y.size() ) ;

    for (int i=0; i<x.size(); ++i) {
      y[i] = x[i] / (i+1) ;
    }
}
};

template <typename T>				//moet boven classe zetten als functionaliteit wil
class funct{
public:
	funct(double const& m)
	: parameter(m)
	{}

	void operator() (T const& x, T& y) const{
		assert( x.size()==y.size() ) ;

    for (int i=0; i<x.size(); ++i) {
      y[i] = x[i] / (i+parameter) ;
    }
	}

private:
	double parameter;
};

//!!!!!! deel huistaak !!!!!!!!
void poissonFun( T const& x, T& y){
	assert( x.size()==y.size() ) ;

  for (int i=1; i<x.size()-1; ++i) {
    y[i] = (1/(h**2))*(-x[i-1] + 2*x[i] - x[i+1] ;
  }
	y[0] = 2*x[0] - x[1];
	y[x.size()-1] = -x[x.size()-2] + 2*x[x.size()-1];
}
 

/*template <typename T>
void function(T const& x, T& y){
	assert( x.size()==y.size() ) ;

    for (int i=0; i<x.size(); ++i) {
      y[i] = x[i] / (i+m) ;
    }
}*/
/*
template <typename T>
void matvec ( T const& x, T& y ) {
    assert( x.size()==y.size() ) ;

    for (int i=0; i<x.size(); ++i) {
      y[i] = x[i] / (i+1) ;
    }
}*/


	

int main() {
  int n=100;
  tws::vector<double> b(n) ;
  tws::vector<double> sol(n) ;
  tws::vector<double> x(n) ;
  tws::vector<double> b_ex(n) ;

  for (int i=0; i<x.size(); ++i) {
    x[i] = 1 ;
  }
  
	//Initialiseer matvec functor
	/*matvec<tws::vector<double>> matvector;
  matvector( x, b ) ;*/

	//Initialiseer funct functor
	/*funct<tws::vector<double>> functie(1);
	functie(x,b);*/

	double m = 1;

	auto lambda_function = [m]( auto const& x, auto& y ){
		assert( x.size()==y.size() ) ;

    for (int i=0; i<x.size(); ++i) {
      y[i] = x[i] / (i+m) ;
    }
	};

	/*function<tws::vector<double>>(x,b);*/

	lambda_function(x,b);

  b_ex=b ;

  //x random between 0 and 1
  //x.randomize();

  //x zero vector
  x = 0.0 * x ;

  /*tws::cg( matvector, x, b, 1.e-10, n ) ;
  matvector( x, sol ) ;*/
	/*tws::cg(functie, x, b, 1.e-10,n);
	functie(x,sol);*/
	/*tws::cg(function<tws::vector<double>>, x, b, 1.e-10,n); //zal niet werken met functie omdat
	functie<tws::vector<double>>(x,sol);*/										//cg zou moeten aanpassen voor var m

	tws::cg(lambda_function, x, b, 1.e-10,n);
	lambda_function(x,sol);

  std::cout<<"relative error: "<<tws::norm_2(sol-b_ex)/tws::norm_2(b_ex)<<std::endl;
  //std::cout<<"x"<<x<<std::endl;
  //std::cout<<"sol"<<sol<<std::endl;






  return 0 ;
} 
