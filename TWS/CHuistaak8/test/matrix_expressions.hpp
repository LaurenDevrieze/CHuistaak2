#ifndef tws_matrix_expressions_hpp
#define tws_matrix_expressions_hpp
namespace tws{
       
    template <typename M>
    class matrix_transpose {
        public:
        typedef typename M::size_type size_type ;
        typedef typename M::value_type value_type ;

        public:
        matrix_transpose( M const& m)
        : m_( m )
        {}

        size_type size() const {
            return m_.size() ;
        }

        size_type num_rows() const {
            return m_.num_columns() ;
        }

        size_type num_columns() const {
            return m_.num_rows() ;
        }

        value_type operator()( size_type i, size_type j ) const {
            assert( i>=0 ) ;
            assert( i<num_rows() ) ;
            assert( j>=0 ) ;
            assert( j<num_columns() ) ;
            return m_(j,i) ;
        }

        private:
        M const& m_ ;
    } ;

    template <typename M>
    matrix_transpose<M> transpose( M const& m ) {
        return matrix_transpose<M>( m ) ;
    }
       
    template <typename M, typename V>
    class matrix_vector {
        public:
        typedef decltype( typename M::size_type() + typename V::size_type() ) size_type ;
        typedef decltype( typename M::value_type() + typename V::value_type() ) value_type ;

        public:
        matrix_vector( M const& m, V const& v )
        : m_( m ),
          v_( v )
        {
            assert( m_.num_columns() == v_.size() );
        }

        size_type size() const {
            return m_.num_rows() ;
        }

        value_type operator()( size_type i ) const {
            assert( i>=0 ) ;
            assert( i<size() ) ;
            value_type el = 0.0;
            for(size_type j=0;j<v_.size();++j){
                el += m_(i,j)*v_(j);
            }
            return el;
        }

        private:
        M const& m_ ;
        V const& v_ ;
    } ;

    template <typename M, typename V>
    matrix_vector<M, V> multiply( M const& m, V const& v ) {
        return matrix_vector<M,V>( m, v ) ;
    }
    
    
   

} // namespace tws

#endif
