extern "C"
{
	void fortran_eig(double * mptr, int & n, double * eigvr, double * eigvi);
	int cpp_eig(double *matrix_values, int n, double *eigvr, double *eigvi);
	void avc(double A[], int & n, double x[], double y[]);
}
int cpp_eig(double *matrix_values, int n, double *eigvr, double *eigvi){
	fortran_eig(matrix_values,n,eigvr,eigvi);
	return 0;
}
void avc(double A[], int & n, double x[], double y[]){
	for(int j = 0; j < n ; j++){
		for(int i = 0; i < n ; i++){
			x[j + n*i] = A[j]...
		}
	}
	// A*e_i doen voor iedere rij en zo omzetten in kolommen.
}
