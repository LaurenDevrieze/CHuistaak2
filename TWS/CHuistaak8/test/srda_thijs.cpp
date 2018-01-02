/*
 * Name: Thijs Steel
 * required files:
 *
 * vector.hpp (unchanged)
 * matrix.hpp (unchanged)
 * tws_util.hpp (unchanged)
 * vector_expressions.hpp (unchanged)
 * matrix_expressions.hpp (own implementation)
 *
 * compiler commands: 
 * g++ -std=c++14 -o test srda.cpp -O3
 * for i in `seq 1 9`; do ./test $((2**$i)) 100 10; done | tee timings_v1.out
 *
 * g++ -std=c++14 -o test srda.cpp -O3 -DSTORE
 * for i in `seq 1 12`; do ./test $((2**$i)) 100 10; done | tee timings_v2.out
 *
 * g++ -std=c++14 -o test srda.cpp -O3 -DFASTEST
 * for i in `seq 1 12`; do ./test $((2**$i)) 100 10; done | tee timings_v3.out
 * 
 * compiler version: g++ 5.4.1 20160904
 * computer: eupen
 * time spent: 5 hours
 */
 
 /*
  * The output of srda for the madelon data set is
  *
  * relative error: 6.87699e-11
  * train auc roc: 0.821888
  * test auc roc: 0.564456
  *
  * The output of srda for the gaussian data set is
  *
  * relative error: 5.77924e-15
  * train auc roc: 0.965034
  * test auc roc: 0.972928
  * 
  * These numbers are the same as the ones mentioned in the assignment, showing the correctness of te code
  */
  
 /*
  * Comparison between different versions.
  * Version 1: In the outer part of "multiply(transpose(m_), multiply(m_, x))",
  *            we take N inner products between a row of transpose(m_) and multiply(m_, x).
  *            Due to the implementation of the expression templates, this means that
  *            multiply(m_, x) is calculated N times, Leading to a total complexity of O(N^3).
  *            We can also see this complexity in the plot.
  *
  * Version 2: In this version, we explicitly store the result of multiply(m_, x).
  *            This leads to some overhead, especially visible in the plot for small N.
  *            However, because multiply(m_, x) is now evaluated only once,
  *            the total complexity is reduced to O(N^2), which can be verified in the plot.
  *
  * Version 3: By looking in the code of matrix.hpp we can see that the matrices are stored in column major order.
  *            (another way to see this is to put time and effort into optimising the operator
  *            for row major order, only to find it is slower than the original version)
  *            Optimising the operation t = multiply(m_, x) for column major order can be done by swapping the loops.
  *            Not only does this avoid cache misses, but it promotes the use of SIMD instructions
  *            for even more efficienty.
  *            The operation "y = multiply(transpose(m_), t) + beta_*x" does not need to be optimised, as
  *            it already avoids cache misses due to the implicit formation of the transpose.
  *
  * Conclusion While expression templates usually lead to clean and efficient code
  *            it is still necessary to optimise certain specific operations.
  */

#include "vector.hpp"
#include "matrix.hpp"
#include "tws_util.hpp"
#include "vector_expressions.hpp"
#include "matrix_expressions.hpp"
		
namespace tws{

/*
 * First version of the the operator. Just uses the expression templates. 
 */
template<typename M, typename V>
class xtx
{
    typedef decltype( typename M::value_type() + typename V::value_type() ) value_type ;
  
    public:
    xtx( M const& m, value_type const& beta )
    : m_(m),
      beta_(beta)
    {}

    void operator() (V const& x, V& y) const {
        assert( x.size()==y.size() ) ;
        assert( x.size()==m_.num_columns() ) ;

        y = multiply(transpose(m_), multiply(m_, x)) + beta_*x ;
    }
        
    private:
    M const& m_ ;
    value_type const& beta_ ;
};

/*
 * Second version of the operator. Stores intermediate results.
 */
template<typename M, typename V>
class xtx_v2
{
    typedef typename M::size_type size_type ;
    typedef decltype( typename M::value_type() + typename V::value_type() ) value_type ;
  
    public:
    xtx_v2( M const& m, value_type const& beta )
    : m_(m),
      beta_(beta)
    {}

    void operator() (V const& x, V& y) const {
        assert( x.size()==y.size() ) ;
        assert( x.size()==m_.num_columns() ) ;

        tws::vector<double> t(m_.num_rows());
        t = multiply(m_, x);
        y = multiply(transpose(m_), t) + beta_*x;
    }
        
    private:
    M const& m_ ;
    value_type const& beta_ ;
};

/*
 * Third version of the operator. Cache optimised
 */
template<typename M, typename V>
class xtx_v3
{
    typedef typename M::size_type size_type ;
    typedef decltype( typename M::value_type() + typename V::value_type() ) value_type ;
  
    public:
    xtx_v3( M const& m, value_type const& beta )
    : m_(m),
      beta_(beta)
    {}

    void operator() (V const& x, V& y) const {
        assert( x.size()==y.size() ) ;
        assert( x.size()==m_.num_columns() ) ;
        
        
        tws::vector<double> t(m_.num_rows(),0.0);
        for(size_type j=0; j<m_.num_columns();++j){
            for(size_type i=0; i<m_.num_rows();++i){
                t(i) += m_(i,j)*x(j);
            }
        }
        y = multiply(transpose(m_), t) + beta_*x;
    }
        
    private:
    M const& m_ ;
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
  
  xtx_v3<tws::matrix<double>, tws::vector<double>> xtx_op(X, beta);

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
  
  
    #ifdef FASTEST
        tws::xtx_v3<tws::matrix<double>, tws::vector<double>> xtx_op(X, beta);
    #else
        #ifdef STORE
            tws::xtx_v2<tws::matrix<double>, tws::vector<double>> xtx_op(X, beta);
        #else
            tws::xtx<tws::matrix<double>, tws::vector<double>> xtx_op(X, beta);
        #endif
    #endif
    tws::time_mv(xtx_op,N,number_exp,discard);

    tws::srda(); //comment out when gathering data, only used for testing correctness
    return 0;
} 
