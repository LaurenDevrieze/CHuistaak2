#include <cassert>
#include <iostream>
#include <cmath>
#include <typeinfo>

namespace tws {

template <typename T>
class vector {
public:
    typedef T   value_type ;
    typedef int size_type ;
    
public:
    vector( size_type size )
    : size_( size )
    , data_( new value_type[size_] )
    {}
    
    ~vector()
    { delete [] data_ ; }
    
public: // Copy
    vector( vector const& that )
    : size_( that.size_ )
    , data_( new value_type[size_] )
    {
        (*this) = that ;
    }
    
    vector& operator=( vector const& that ) {
      assert( that.size() == size() ) ;
        for (size_type i=0; i<size_; ++i) {
            data_[i] = that(i) ;
        }
        return *this ;
    }
    
    template <typename V>
    vector& operator=( V const& that ) {
      assert( that.size() == size() ) ;
        for (size_type i=0; i<size_; ++i) {
            data_[i] = that(i) ;
        }
        return *this ;
    }

public:// Access
    value_type operator() ( size_type i ) const {
        assert( i>=0 ) ;
        assert( i<size_ ) ;
        return data_[i] ;
    }
    
    value_type& operator() ( size_type i ) {
        assert( i>=0 ) ;
        assert( i<size_ ) ;
        return data_[i] ;
    }
    
    size_type size() const {
        return size_ ;
    }
    
public: // Fortran binding:
    typedef value_type* const& pointer ;
    pointer ptr() const {
        return data_ ;
    }
    
private:
    size_type   size_ ;
    value_type* data_ ;
};

template <typename T>
std::ostream& operator<<( std::ostream& os, vector<T> const& v ) {
    os << "[" << v.size() << "](" ;
    for (typename vector<T>::size_type i=0; i< v.size(); ++i) {
        os << v(i) << "," ;
    }
    os << ")" ;
    return os ;
}

// V1, V2 : Vector
template <typename V1, typename V2>
class vector_sum {
  public:
    typedef typename V1::size_type size_type ;
    typedef decltype( typename V1::value_type() + typename V2::value_type() ) value_type ;

  public:
    vector_sum( V1 const& v1, V2 const& v2 )
    : v1_( v1 )
    , v2_( v2 )
    {
      assert( v1.size()==v2.size() ) ;
    }

    size_type size() const {
      return v1_.size() ;
    }

    value_type operator()( size_type i ) const {
      assert( i>=0 ) ;
      assert( i<size() ) ;
      return v1_(i) + v2_(i) ;
    }

  private:
    V1 const& v1_ ;
    V2 const& v2_ ;
} ;

template <typename V1, typename V2>
vector_sum<V1,V2> operator+(V1 const& v1, V2 const& v2 ) {
  return vector_sum<V1,V2>(v1,v2) ;
}

} // namespace


int main() {
  tws::vector<double> v(10) ;
  for (int i=0; i<v.size(); ++i) v(i) = i+1.0;

  tws::vector<float> w(10) ;
  for (int i=0; i<v.size(); ++i) w(i) = 15-i+1.0;

  tws::vector<double> t(10) ;
  for (int i=0; i<v.size(); ++i) t(i) = 20-i+1.0;

  tws::vector<double> z(10) ;
  auto sum = v + w ;

  std::cout << typeid(v+w+t).name() << std::endl ;

  z = v + w + t ;
  std::cout << "v " << v << std::endl ;
  std::cout << "w " << w << std::endl ;
  std::cout << "t " << t << std::endl ;
  std::cout << "z=v+w+t " << z << std::endl ;

  return 0;
}
