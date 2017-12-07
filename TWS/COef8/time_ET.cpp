#include "vector.hpp"
#include "matrix.hpp"
#include <time.h>

/*
Use the option -DEXPR during compilation to use expression templates
*/
#ifdef EXPR
#include "vector_expressions.hpp"
#else
#include "vector_operations.hpp"
#endif 
/*
#ifdef EXPR
#include "matrix_expressions.hpp"
#else
#include "matrix_operations.hpp"
#endif 
*/		

int main() {
  int n=50000;
  int number_exp=200;
  int discard=5;

  struct timespec l_start, l_end;
/*
  tws::matrix<double> b_0(n,n) ;
  tws::matrix<double> b_1(n,n) ;
  tws::matrix<double> b_2(n,n) ;
  tws::matrix<double> b_3(n,n) ;
*/
  tws::vector<double> b_0(n,0.) ;
  tws::vector<double> b_1(n,0.) ;
  tws::vector<double> b_2(n,0.) ;
  tws::vector<double> b_3(n,0.) ;
  b_1.randomize(0.,1.);
  b_2.randomize(0.,1.);
  b_3.randomize(0.,1.);
  double elapsed_time=0.;
  double average_time=0.;
  double squared_time=0.;
  double time_diff=0.;

  for(int exp=0;exp<number_exp+discard;exp++){
    clock_gettime(CLOCK_MONOTONIC, &l_start);
    b_0=b_3+b_1+b_2+2.0*b_1-b_3+b_2+3.0*b_1-b_2+b_3+3.0*b_1;
    clock_gettime(CLOCK_MONOTONIC, &l_end);
    if(exp>=discard){
       elapsed_time=(l_end.tv_sec - l_start.tv_sec)+(l_end.tv_nsec - l_start.tv_nsec) / 1e9; 
       time_diff=elapsed_time-average_time;
       average_time+=time_diff/(exp-discard+1);
       squared_time+=time_diff*(elapsed_time-average_time);
    }
    b_0(0)+=b_0(0);
  }
  std::cout<<"Time(s): "<<average_time<<" "<<std::sqrt(squared_time/(number_exp-1))<<std::endl;
  return 0 ;
} 
