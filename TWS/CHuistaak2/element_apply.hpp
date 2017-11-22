#ifndef tws_cg_hpp
#define tws_cg_hpp

namespace tws {
	
	template <typename Fun, typename V>
	void element_apply(Fun const& f, V& v){
		
		for(int i=0;i<v.size();i++){
			f(v[i]);
		}
		
	}
	
}

#endif