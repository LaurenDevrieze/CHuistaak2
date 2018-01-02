extern "C"
{
	int cpp_eig(double *matrix_values, int n, double *eigvr, double *eigvi);
}
int cpp_eig(double *matrix_values, int n, double *eigvr, double *eigvi){
	for( int i = 0; i < n ; i++){
		eigvr[i] = matrix_values[i];
		eigvi[i] = matrix_values[i+n];
	}
	return 0;
}
