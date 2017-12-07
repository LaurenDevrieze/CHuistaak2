#ifndef tws_matrix_expressions_hpp
#define tws_matrix_expressions_hpp

namespace tws{

// V1, V2 : Vector
template <typename V1, typename V2>
class matrix_sum {
  public:
    typedef typename V1::size_type size_type ;
    typedef decltype( typename V1::value_type() + typename V2::value_type() ) value_type ;

  public:
    matrix_sum( V1 const& v1, V2 const& v2 )
    : v1_( v1 )
    , v2_( v2 )
    {
      assert( v1.num_rows()==v2.num_rows() ) ;
			assert( v1.num_columns()==v2.num_columns() ) ;
    }

    size_type num_columns() const {
      return v1_.num_columns() ;
    }

		size_type num_rows() const {
      return v1_.num_rows() ;
    }

    value_type operator()( size_type i, size_type j ) const {
      assert( i>=0 ) ;
			assert( j>=0 ) ;
      assert( i<num_rows() ) ;
			assert( j<num_columns() ) ;
      return v1_(i,j) + v2_(i,j) ;
    }

  private:
    V1 const& v1_ ;
    V2 const& v2_ ;
} ;

template <typename V1, typename V2>
matrix_sum<V1,V2> operator+(V1 const& v1, V2 const& v2 ) {
  return matrix_sum<V1,V2>(v1,v2) ;
}

// V1, V2 : Vector
template <typename V1, typename V2>
class matrix_sub {
  public:
    typedef typename V1::size_type size_type ;
    typedef decltype( typename V1::value_type() + typename V2::value_type() ) value_type ;

  public:
    matrix_sub( V1 const& v1, V2 const& v2 )
    : v1_( v1 )
    , v2_( v2 )
    {
      assert( v1.num_rows()==v2.num_rows() ) ;
			assert( v1.num_columns()==v2.num_columns() ) ;
    }

    size_type num_columns() const {
      return v1_.num_columns() ;
    }

		size_type num_rows() const {
      return v1_.num_rows() ;
    }

    value_type operator()( size_type i, size_type j ) const {
      assert( i>=0 ) ;
			assert( j>=0 ) ;
      assert( i<num_rows() ) ;
			assert( j<num_columns() ) ;
      return v1_(i,j) - v2_(i,j) ;
    }

  private:
    V1 const& v1_ ;
    V2 const& v2_ ;
} ;

template <typename V1, typename V2>
matrix_sub<V1,V2> operator-(V1 const& v1, V2 const& v2 ) {
  return matrix_sub<V1,V2>(v1,v2) ;
}

// V1, V2 : Vector
template <typename S, typename V1>
class matrix_scalMul {
  public:
    typedef typename V1::size_type size_type ;
    typedef decltype( typename V1::value_type()) value_type ;
		typedef S scalar_type ;

  public:
    matrix_scalMul( S const& s, V1 const& v1 )
    : v1_( v1 )
    , s_( s )
    {
    }

    size_type num_columns() const {
      return v1_.num_columns() ;
    }

		size_type num_rows() const {
      return v1_.num_rows() ;
    }

    value_type operator()( size_type i, size_type j ) const {
      assert( i>=0 ) ;
			assert( j>=0 ) ;
      assert( i<num_rows() ) ;
			assert( j<num_columns() ) ;
      return s_*v1_(i,j) ;
    }

  private:
    V1 const& v1_ ;
    S const& s_ ;
} ;

template <typename S, typename V1>
matrix_scalMul<S,V1> operator*(S const& s, V1 const& v1 ) {
  return matrix_scalMul<S,V1>(s,v1) ;
}

}
#endif

