#include <algorithm>

class matrix {
  public:
    typedef double value_type ;
    typedef int    size_type ;

  public:
    matrix( size_type n, size_type m )
    : num_rows_( n )
    , num_columns_( m )
    , data_( new value_type[num_rows_*num_columns_] )
    {}

    ~matrix() {
      delete [] data_ ;
    }

    // Copy constructor
    matrix( matrix const& that )
    : num_rows_( that.num_rows_ )
    , num_columns_( that.num_columns_ )
    , data_( new value_type[num_rows_*num_columns_] )
    {
      (*this) = that ;
    }

    // Assignment operator
    void operator=( matrix const& that ) {
      assert( that.num_rows_ == num_rows_ ) ;
      assert( that.num_columns_ == num_columns_ ) ;
      std::copy( that.data_, that.data_+num_columns_*num_rows_, data_ ) ;
      //for (size_type i=0; i<num_columns_*num_rows_; ++i) data_[i] = that.data_[i] ;
    }

    size_type num_rows() const {
      return num_rows_ ;
    }

    size_type num_columns() const {
      return num_columns_ ;
    }

    value_type operator() (size_type i, size_type j) const {
      return data_[ j*num_rows_ + i ] ;
    }

    value_type& operator() (size_type i, size_type j) {
      return data_[ j*num_rows_ + i ] ;
    }

  private:
    size_type   num_rows_ ;
    size_type   num_columns_ ;
    value_type* data_ ;
} ;

int main() {
  matrix A(4, 3) ;
}
