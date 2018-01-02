extern "C"
{
	void fortran_eig(double * mptr, int & n, double * eigvr, double * eigvi);
	int cpp_eig(double *matrix_values, int n, double *eigvr, double *eigvi);
}
int cpp_eig(double *matrix_values, int n, double *eigvr, double *eigvi){
	fortran_eig(matrix_values,n,eigvr,eigvi);
	return 0;
}

