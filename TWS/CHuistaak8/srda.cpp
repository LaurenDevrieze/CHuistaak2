#include "vector.hpp"
#include "matrix.hpp"
#include "tws_util.hpp"
#include "vector_expressions.hpp"
#include "matrix_expressions.hpp"

/*Homework 3 C++

Lauren Devrieze

Time spent: 4-5 hours

Commands: g++ -Wall -std=c++14 -o srda srda.cpp (-DVERSION2)
		  for i in `seq 1 10`; do ./srda $((2**$i)) 100 5; done | tee mult1.out
		  
Only the files srda.cpp and matrix_expressions were changed.

Version 1: 	In 'multiply(X,x)' the complexity is O(N^2) since that's the complexity
			of the inner product, but since in xtx_op_v1 'multiply(transpose(X),multiply(X,x))'
			is done. 'multiply(X,x)' will have to be calculated N times. The complexity
			is then O(N^3). This is also clear in the plot.
			
Version 2:	In this version multiply(X,x) is saved in a variable such that it doesn't have to
			be calculated N times so then the complexity is O(N^2)
*/






		
namespace tws{

// xtx version 1	
template<typename X, typename V>
class xtx_v1{
    typedef decltype( typename X::value_type() + typename V::value_type() ) value_type ;
  
    public:
    xtx_v1(X const& m, value_type const& beta)
    : m_(m),
      beta_(beta)
    {}

    void operator()(V const& x, V& y)const{
        assert(x.size()==y.size()) ;
        assert(x.size()==m_.num_columns()) ;
        y = multiply(transpose(m_), multiply(m_,x)) + beta_*x ;
    }
        
    private:
    X const& m_ ;
    value_type const& beta_ ;
};

// xtx version 2
template<typename X, typename V>
class xtx_v2{
    typedef typename X::size_type size_type ;
    typedef decltype( typename X::value_type() + typename V::value_type() ) value_type ;
  
    public:
    xtx_v2(X const& m, value_type const& beta)
    : m_(m),
      beta_(beta)
    {}

    void operator()(V const& x, V& y)const{
        assert(x.size()==y.size()) ;
        assert(x.size()==m_.num_columns()) ;

        tws::vector<double> t(m_.num_rows());
        t = multiply(m_,x);
        y = multiply(transpose(m_),t) + beta_*x;
    }
        
    private:
    X const& m_ ;
    value_type const& beta_ ;
};
	
int srda(){
 /*-------------------------------------------------------
    perform SRDA, define xtx_op below 
    -------------------------------------------------------*/
  std::string s1("madelon/madelon_train.data");
  auto X=tws::matrix_read<tws::matrix<double>>(s1);
  std::string s2("madelon/madelon_train.labels");
  auto labels=tws::vector_read<tws::vector<double>>(s2);
  std::string s3("madelon/madelon_valid.data");
  auto Xtest=tws::matrix_read<tws::matrix<double>>(s3);
  std::string s4("madelon/madelon_valid.labels");
  auto test_labels=tws::vector_read<tws::vector<int>>(s4);

/*
  std::string s1("gaussian/gaussian_train.data");
  auto X=tws::matrix_read<tws::matrix<double>>(s1);
  std::string s2("gaussian/gaussian_train.labels");
  auto labels=tws::vector_read<tws::vector<double>>(s2);
  std::string s3("gaussian/gaussian_valid.data");
  auto Xtest=tws::matrix_read<tws::matrix<double>>(s3);
  std::string s4("gaussian/gaussian_valid.labels");
  auto test_labels=tws::vector_read<tws::vector<int>>(s4); 
*/


  tws::vector<double> x(X.num_columns(),0.) ; 
  tws::vector<double> b(X.num_columns(),0.) ; 
  tws::vector<double> b_ex(X.num_columns(),0.) ; 
  b=multiply(transpose(X),labels);
  b_ex=b;

  double beta=1e1;

  #ifdef VERSION2
    tws::xtx_v2<tws::matrix<double>, tws::vector<double>> xtx_op(X, beta);
  #else
	tws::xtx_v1<tws::matrix<double>, tws::vector<double>> xtx_op(X, beta);
  #endif

  tws::cg( xtx_op, x, b, 1.e-10, X.num_columns()*X.num_rows() ) ;
  xtx_op ( x, b) ;
  
  std::cout<<"relative error: "<<tws::norm_2(b-b_ex)/tws::norm_2(b_ex)<<std::endl;

  tws::vector<double> train_rating(X.num_rows(),1) ; 
  train_rating=multiply(X,x);
  std::transform(labels.begin(),labels.end(),labels.begin(),[](auto v){return (v+1)/2;}); 
  std::cout<<"train auc roc: "<<tws::auc_roc(train_rating,labels)<<std::endl;    

  tws::vector<double> test_rating(Xtest.num_rows(),1) ; 
  test_rating=multiply(Xtest,x);
  std::transform(test_labels.begin(),test_labels.end(),test_labels.begin(),[](auto v){return (v+1)/2;}); 
  std::cout<<"test auc roc: "<<tws::auc_roc(test_rating,test_labels)<<std::endl;
  return 0 ;
}//srda

}//namespace tws

int main(int argc, char *argv[]) {

  /*-------------------------------------------------------
    Timing XtX
    -------------------------------------------------------*/
  assert(argc==4);
  int N = std::atoi(argv[1]);
  int number_exp=std::atoi(argv[2]);
  int discard=std::atoi(argv[3]);
  assert(N>0 && number_exp>0 && discard>=0 && number_exp>discard);
 
  double beta=1.0;
  tws::matrix<double> X(N,N,1.0);
  

  #ifdef VERSION2
    tws::xtx_v2<tws::matrix<double>, tws::vector<double>> xtx_op(X, beta);
  #else
	tws::xtx_v1<tws::matrix<double>, tws::vector<double>> xtx_op(X, beta);
  #endif
  
  tws::time_mv(xtx_op,N,number_exp,discard);
    
  tws::srda();
  return 0;
} 