#include <iostream>
#include <cstdlib>
#include <random>
#include <algorithm>
#include <string>
#include <cstdlib>
#include <time.h>

// Bucket sort function
void bucketSort(std::vector<double>& v, double range, int n){
	//n = amount of buckets
	std::vector<double> buckets[n];
	//Put the elements of v in buckets according to hash function ind
	for(int k=0; k< n; ++k){
		int ind = 0; //std::floor(v[k]*((double)(n-1)/range));
		buckets[ind].push_back(v[k]);
	}
	//Sort the elements in the buckets
	for(int k=0; k <n ;++k){
		sort(buckets[k].begin(),buckets[k].end());
	}
	//Put the elements of the buckets back in the vector
	int index = 0;
	for(int k=0; k <n ;++k){
		for (int m = 0; m < buckets[k].size(); ++m)
		v[index++] = buckets[k][m];
	}

}


int main( int argc, char* argv[]){
	/* 	argv[1] = size
		argv[2] = range
		argv[3] = number of experiments
		argv[4] = number of discarded timings
		argv[5] = number of buckets */
	
	//Assign the input arguments to variables
	int size = std::atoi(argv[1]);
	double r = std::atof(argv[2]);
	int numExp = std::atoi(argv[3]);
	int disExp = std::atoi(argv[4]);
	int m = std::atoi(argv[5]);

for(int j = 1;j < size + 1 ; ++j){
	
	//Initialize vector with size j
	std::vector<double> v(j,1);
	
	//Give the vector a random distribution with range r
	std::random_device rd;
	std::mt19937 generator(rd());
	std::uniform_real_distribution<> distribution(0, r);
	for(auto& vi:v){
		vi=distribution(generator);
	}
	
	double meanExp1 = 0;
	double meanExp2 = 0;
	double stdev1 = 0;
	double stdev2 = 0;
	struct timespec l_start, l_end;
	std::vector<double> timeSample1, timeSample2;
	//
	for(int i = 0; i < numExp+1; ++i){
		
		//shuffle v with the given random number generator
		std::shuffle(v.begin(), v.end(), std::mt19937{std::random_device{}()});
		
		//Start timing
		clock_gettime(CLOCK_MONOTONIC, &l_start);
		
		std::sort(v.begin(), v.end());
	
		//Stop timing
		clock_gettime(CLOCK_MONOTONIC, &l_end);
		auto elapsed_time1 =(l_end.tv_sec - l_start.tv_sec) + (l_end.tv_nsec - l_start.tv_nsec)/1.0e9;
		
		if(i > disExp){
			meanExp1 = meanExp1 + elapsed_time1;
			timeSample1[i] = elapsed_time1;
		}
		
		//Start timing
		clock_gettime(CLOCK_MONOTONIC, &l_start);
		
		bucketSort(v,r,m);
	
		//Stop timing
		clock_gettime(CLOCK_MONOTONIC, &l_end);
		auto elapsed_time2 =(l_end.tv_sec - l_start.tv_sec) + (l_end.tv_nsec - l_start.tv_nsec)/1.0e9;
		
		if(i > disExp){
			meanExp2 = meanExp2 + elapsed_time2;
			timeSample2[i] = elapsed_time2;
		}
	}
	//Calculate mean and standard deviation of all the experiments
	meanExp1 = meanExp1/((double)(numExp-disExp));
	meanExp2 = meanExp2/((double)(numExp-disExp));
	for(int i = disExp + 1; i < numExp + 1 ; ++i){
		stdev1 += pow(timeSample1[i] - meanExp1,2);
		stdev2 += pow(timeSample2[i] - meanExp2,2);
	}
	stdev1 = sqrt((stdev1)/((double)(numExp-disExp)));
	stdev2 = sqrt((stdev2)/((double)(numExp-disExp)));
	
	std::cout<<j<<" "<<meanExp1<<" "<<stdev1<<std::endl;
	std::cout<<j<<" "<<meanExp2<<" "<<stdev2<<std::endl;
}
	return 0;
}



//pdflatex -shell-escape -interaction=nonstopmode plot.tex