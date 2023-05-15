class Matrix {
  // variables
  private int rows;
  private int cols;
  private float[][] matrix;

  //------------------------------------------------------------------------------------------
  // constructors
  public Matrix(int rows, int cols) {
    this.rows = rows;
    this.cols = cols;
    matrix = new float[rows][cols];
  }

  public Matrix(float[][] matrix) {
    this.matrix = matrix;
    cols = matrix.length;
    rows = matrix[0].length;
  }

  //------------------------------------------------------------------------------------------
  // functions

  // print Matrix in console
  public void printMatrix() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        print(matrix[r][c] + "  ");
      }
      println();
    }
    println();
  }

  // multiply by scalar
  public void multiplyScalar(float n) {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        matrix[r][c] *= n;
      }
    }
  }

  // return matrix multiplied by matrix
  public Matrix multiplyMatrix(Matrix m) {
    Matrix result = new Matrix(rows, m.cols);
    if (cols == m.rows) {
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < m.cols; c++) {
          float sum = 0;
          for (int k = 0; k < cols; k++) {
            sum += matrix[r][k] * m.matrix[k][c];
          }
          result.matrix[r][c] = sum;
        }
      }
    }
    return result;
  }

  // set the matrix to random values between -1 and 1
  public void randomize() {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        matrix[r][c] = random(-1, 1);
      }
    }
  }

  // add a scalar to each value of the matrix
  public void addScalar(float n) {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        matrix[r][c] += n;
      }
    }
  }

  // return sum-matrix of matrix and parameter matrix
  public Matrix addMatrix(Matrix m) {
    Matrix result = new Matrix(rows, cols);
    if (cols == m.cols && rows == m.rows) {
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          result.matrix[r][c] = matrix[r][c] + m.matrix[r][c];
        }
      }
    }
    return result;
  }

  // return dif-matrix of matrix and parameter matrix
  public Matrix subtractMatrix(Matrix m) {
    Matrix result = new Matrix(cols, rows);
    if (cols == m.cols && rows == m.rows) {
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          result.matrix[r][c] = matrix[r][c] - m.matrix[r][c];
        }
      }
    }
    return result;
  }

  // return product-matrix of matrix and parameter matrix
  public Matrix multiplyMatrixValues(Matrix m) {
    Matrix result = new Matrix(rows, cols);
    if (cols == m.cols && rows == m.rows) {
      for (int r = 0; r < rows; r++) {
        for (int c = 0; c < cols; c++) {
          result.matrix[r][c] = matrix[r][c] * m.matrix[r][c];
        }
      }
    }
    return result;
  }

  // return transposed matrix
  public Matrix transpose() {
    Matrix result = new Matrix(cols, rows);
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        result.matrix[c][r] = matrix[r][c];
      }
    }
    return result;
  }

  // set matrix from an array
  public void fromArray(float[] array) {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        matrix[r][c] = array[c + r * cols];
      }
    }
  }

  // returns array which represents matrix
  public float[] toArray() {
    float[] array = new float[rows * cols];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        array[c + r * cols] = matrix[r][c];
      }
    }
    return array;
  }

  // adds Bias to Matrix at the bottom
  public Matrix addBias() {
    Matrix result = new Matrix(rows + 1, 1);
    for (int r = 0; r < rows; r++) {
      result.matrix[r][0] = matrix[r][0];
    }
    result.matrix[rows][0] = 1;
    return result;
  }

  // sigmoid function
  private float sigmoid(float x) {
    return 1 / (1 + pow((float)Math.E, -x));
  }

  // activates matrix with the sigmoid function
  public Matrix activate() {
    Matrix result = new Matrix(rows, cols);
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        result.matrix[r][c] = sigmoid(matrix[r][c]);
      }
    }
    return result;
  }

  // derived sigmoid function
  public Matrix sigmoidDerived() {
    Matrix result = new Matrix(rows, cols);
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        result.matrix[r][c] = (matrix[r][c] * (1 - matrix[r][c]));
      }
    }
    return result;
  }

  // returns Matrix with the bottom layer removed
  public Matrix removeBottomLayer() {
    Matrix result = new Matrix(rows - 1, cols);
    for (int r = 0; r < result.rows; r++) {
      for (int c = 0; c < cols; c++) {
        result.matrix[r][c] = matrix[r][c];
      }
    }
    return result;
  }

  // mutate matrix for genetic algorithm
  void mutate(float mutationRate) {
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (random(1) < mutationRate) {  //chosen to be mutated
          matrix[r][c] += randomGaussian() / 5;  //add a random value to it(can be negative)
          //set boundaries to 1 and -1;
          if (matrix[r][c] > 1)
            matrix[r][c] = 1;
          else if (matrix[r][c] < -1)
            matrix[r][c] = -1;
        }
      }
    }
  }

  // returns a matrix which has a random number of values from matrix and the rest of parameter matrix
  public Matrix crossover(Matrix partner) {
    Matrix child = new Matrix(rows, cols);

    //pick random point in matrix
    int randCol = floor(random(cols));
    int randRow = floor(random(rows));
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (r < randRow || (r == randRow && c <= randCol))
          child.matrix[r][c] = matrix[r][c];
        else
          child.matrix[r][c] = partner.matrix[r][c];
      }
    }
    return child;
  }

  // returns a copy of matrix
  public Matrix clone() {
    Matrix clone = new Matrix(rows, cols);
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        clone.matrix[r][c] = matrix[r][c];
      }
    }
    return clone;
  }
}
