#ifndef tws_matrix_expressions_hpp
#define tws_matrix_expressions_hpp

namespace tws{

// C : Matrix
template <typename C>
class matrix_trans {
  public:
    typedef typename C::size_type size_type ;
    typedef typename C::value_type value_type ;

  public:
    matrix_trans( C const& c )
    : c_( c )
    {
      
    }

    size_type num_columns() const {
      return c_.num_rows() ;
    }

		size_type num_rows() const {
      return c_.num_columns() ;
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
        typedef decltype( typename M::size_type() + typename V::size_type() ) size_type ;
        typedef decltype( typename M::value_type() + typename V::value_type() ) value_type ;

        public:
        matrix_vector_multiply( M const& m, V const& v )
        : m_( m )
        , v_( v )
        {
			assert( m.num_columns() == v.size() );
        }

        size_type size() const {
            return m_.num_rows() ;
        }

        value_type operator()( size_type j ) const {
            assert( j>=0 ) ;
            assert( j<size() ) ;
			value_type sum = 0;
			for (int i = 0; i < m_.num_columns(); ++i){
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
    }//multiply

}
#endif

