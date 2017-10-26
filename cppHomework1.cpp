#include <iostream>
#include <cstdlib>

int main( int argc, char* argv[]){
	/* 	argv[0] = size
		argv[1] = range
		argv[2] = number of experiments
		argv[3] = number of discarded timings */
		
	int size = argv[0];
	real r = argv[1];
	int numExp = argv[2];
	int disExp = argv[3];
	
	
		
	std::random_device rd;
	std::mt19937 generator(rd());
	std::uniform_real_distribution<> distribution(0, r);
	for(auto& vi:v){
		vi=distribution(generator);
	}
	
	//shuffle v with the given random number generator
	std::shuffle(v.begin(), v.end(), std::mt19937{std::random_device{}()});
}