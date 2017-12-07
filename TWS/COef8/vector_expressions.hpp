#ifndef tws_vector_expressions_hpp
#define tws_vector_expressions_hpp

namespace tws{

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

// V1, V2 : Vector
template <typename V1, typename V2>
class vector_sub {
  public:
    typedef typename V1::size_type size_type ;
    typedef decltype( typename V1::value_type() + typename V2::value_type() ) value_type ;

  public:
    vector_sub( V1 const& v1, V2 const& v2 )
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
      return v1_(i) - v2_(i) ;
    }

  private:
    V1 const& v1_ ;
    V2 const& v2_ ;
} ;

template <typename V1, typename V2>
vector_sub<V1,V2> operator-(V1 const& v1, V2 const& v2 ) {
  return vector_sub<V1,V2>(v1,v2) ;
}

// V1, V2 : Vector
template <typename S, typename V1>
class vector_scalMul {
  public:
    typedef typename V1::size_type size_type ;
    typedef decltype( typename V1::value_type()) value_type ;
		typedef S scalar_type ;

  public:
    vector_scalMul( S const& s, V1 const& v1 )
    : v1_( v1 )
    , s_( s )
    {
    }

    size_type size() const {
      return v1_.size() ;
    }

    value_type operator()( size_type i ) const {
      assert( i>=0 ) ;
      assert( i<size() ) ;
      return s_*v1_(i) ;
    }

  private:
    V1 const& v1_ ;
    S const& s_ ;
} ;

template <typename S, typename V1>
vector_scalMul<S,V1> operator*(S const& s, V1 const& v1 ) {
  return vector_scalMul<S,V1>(s,v1) ;
}

}
#endif

