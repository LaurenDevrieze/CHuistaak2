#include <cassert>
#include <iostream>
#include <cmath>
#include <typeinfo>

namespace tws {

class base {
  public:
    typedef double value_type ;
    typedef int    size_type ;

    virtual size_type size() const = 0 ;

    virtual value_type operator() ( size_type i ) const = 0 ;
} ;

class vector
: public base
{
public:
    typedef base::value_type value_type ;
    typedef base::size_type  size_type ;
    
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
    
    vector& operator=( base const& that ) {
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

std::ostream& operator<<( std::ostream& os, vector const& v ) {
    os << "[" << v.size() << "](" ;
    for (vector::size_type i=0; i< v.size(); ++i) {
        os << v(i) << "," ;
    }
    os << ")" ;
    return os ;
}

class vector_sum
: public base
{
  public:
    typedef base::size_type size_type ;
    typedef base::value_type value_type ;

  public:
    vector_sum( base const& v1, base const& v2 )
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
    base const& v1_ ;
    base const& v2_ ;
} ;

vector_sum operator+(base const& v1, base const& v2 ) {
  return vector_sum(v1,v2) ;
}

} // namespace


int main() {
  tws::vector v(10) ;
  for (int i=0; i<v.size(); ++i) v(i) = i+1.0;

  tws::vector w(10) ;
  for (int i=0; i<v.size(); ++i) w(i) = 15-i+1.0;

  tws::vector t(10) ;
  for (int i=0; i<v.size(); ++i) t(i) = 20-i+1.0;

  tws::vector z(10) ;
  auto sum = v + w ;

  std::cout << typeid(v+w+t).name() << std::endl ;

  z = v + w ;
  std::cout << "v " << v << std::endl ;
  std::cout << "w " << w << std::endl ;
  std::cout << "z=v+w " << z << std::endl ;

  return 0;
}
