#include <iostream>
#include <cstdlib>
#include <random>
#include <algorithm>
// misschien nog andere packages ontbreken

int main( int argc, char* argv[]){
	/* 	argv[0] = size
		argv[1] = range
		argv[2] = number of experiments
		argv[3] = number of discarded timings */
	
	// String nog omzetten naar int
	int size = (int) argv[0];
	float r = (int) argv[1];
	int numExp = (int) argv[2];
	int disExp = (int) argv[3];

//	
for(int j = 1;j < size + 1 ; ++j){
	
	//initialeer vector with size j
	std::vector<float> v(j,1);
	
	std::random_device rd;
	std::mt19937 generator(rd());
	std::uniform_real_distribution<> distribution(0, r);
	for(auto& vi:v){
		vi=distribution(generator);
	}
	
	
	for(int i = 0; i < numExp+1; ++i){
		
		//shuffle v with the given random number generator
		std::shuffle(v.begin(), v.end(), std::mt19937{std::random_device{}()});
		
		//Start timing
		struct timespec l_start, l_end;
		clock_gettime(CLOCK_MONOTONIC, &l_start);
		
		std::sort(v.begin(), v.end());
	
		//Stop timing
		clock_gettime(CLOCK_MONOTONIC, &l_end);
		auto elapsed_time1 =(l_end.tv_sec - l_start.tv_sec) + (l_end.tv_nsec - l_start.tv_nsec)/1.0e9;
		
		if(i > disExp){
			meanExp1 = meanExp1 + elapsed_time1;
		}
		
		//Start timing
		clock_gettime(CLOCK_MONOTONIC, &l_start);
		
		bucketSort(v,r);
	
		//Stop timing
		clock_gettime(CLOCK_MONOTONIC, &l_end);
		auto elapsed_time2 =(l_end.tv_sec - l_start.tv_sec) + (l_end.tv_nsec - l_start.tv_nsec)/1.0e9;
		
		if(i > disExp){
			meanExp2 = meanExp2 + elapsed_time2;
		}
	}
	meanExp1 = meanExp1/(numExp-disExp);
	meanExp2 = meanExp2/(numExp-disExp);
	
	std::cout<<meanExp1<<" "<<meanExp2<<std::endl;
}

}

//// bucket sort
void bucketSort(vector<float> v, float range){
	std::vector<float> buckets[size(v)];
		for(int k=0; i< size(v); ++i){
			int ind = std::floor(v(i)*((size(v)-1)/range));
			buckets[ind].push_back(v(i));
		}
		for(int k=0; k <n ;++i){
			sort(buckets[k].begin(),buckets[k].end())
			//bucketSort(buckets[k], 'wat is range?')
		}
		int index = 0;
		for(int k=0; k <n ;++i){
			for (int m = 0; m < b[k].size(); ++m)
			v(index++) = b[k][m];
		}
	}
}

//pdflatex -shell-escape -interaction=nonstopmode plot.tex