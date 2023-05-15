class StaticMatrix {
  // creates a single column matrix from parameter array
  public Matrix singleColumnMatrixFromArray(float[] array) {
    Matrix result = new Matrix(array.length, 1);
    for (int i = 0; i < array.length; i++) {
      result.matrix[i][0] = array[i];
    }
    return result;
  }
}
