#ifndef tws_matrix_expressions_hpp
#define tws_matrix_expressions_hpp

namespace tws{

// V1, V2 : Vector
/*template <typename V1, typename V2>
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
}*/

// C : Matrix
template <typename C>
class matrix_trans {
  public:
    typedef typename C::size_type size_type ;
    typedef decltype( typename C::value_type() ) value_type ;

  public:
    matrix_trans( C const& c )
    : c_( c )
    {
      
    }

    size_type num_columns() const {
      return c_.num_columns() ;
    }

		size_type num_rows() const {
      return c_.num_rows() ;
    }

    value_type operator()( size_type i, size_type j ) const {
      assert( i>=0 ) ;
	  assert( j>=0 ) ;
      assert( i<num_rows() ) ;
	  assert( j<num_columns() ) ;
      return c_(j,i) ;
	}

  private:
    C const& c_ ;
} ;

template <typename C>
matrix_trans<C> transpose(C const& c) {
  return matrix_trans<C>(c) ;
}

template <typename M, typename V>
    class matrix_vector_multiply {
        public:
        typedef typename V::size_type size_type ;
        typedef decltype( typename M::value_type() + typename V::value_type() ) value_type ;

        public:
        matrix_vector_multiply( M const& m, V const& v )
        : m_( m )
        , v_( v )
        {
			//assert( m.num_columns() == v.size() );
        }

        size_type size() const {
            return m_.num_rows() ;
        }

        value_type operator()( size_type j ) const {
            assert( j>=0 ) ;
            assert( j<size() ) ;
			value_type sum = 0;
			for (int i = 0; i < m_.num_columns(); i++){
				sum = sum + m_(j,i)*v_(i);
			}
            return sum;
        }

        private:
        M const& m_ ;
        V const& v_ ;
    } ; //matrix_vector_multiply

    template <typename M, typename V>
    matrix_vector_multiply<M,V> multiply(M const& m, V const& v ) {
        return matrix_vector_multiply<M,V>(m,v) ;
		// hoe vector krijgen?
    }//multiply

}
#endif

