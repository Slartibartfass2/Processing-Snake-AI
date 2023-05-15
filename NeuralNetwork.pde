class NeuralNetwork {
  // variables
  private int inputNodes;
  private int hiddenNodes;
  private int outputNodes;

  private Matrix weiInHid;   //weights between input and 1st hidden layer
  private Matrix weiHidHid;  //weights between 1st and 2nd hidden layer
  private Matrix weiHidOut;  //weights between 2nd hidden and output layer

  // Visualization Stuff
  private float[] inputValues;
  private float[] outputValues;
  private PFont font;

  //------------------------------------------------------------------------------------------
  // constructor
  public NeuralNetwork(int inputNodes, int hiddenNodes, int outputNodes) {
    this.inputNodes = inputNodes;
    this.hiddenNodes = hiddenNodes;
    this.outputNodes = outputNodes;

    // Value-Arrays for Visualization
    inputValues = new float[inputNodes];
    outputValues = new float[outputNodes];
    font = createFont("Arial", 20, true);  //Font

    //create first layer weights included bias weight
    weiInHid = new Matrix(hiddenNodes, inputNodes + 1);

    //create second layer weights included bias weight
    weiHidHid = new Matrix(hiddenNodes, hiddenNodes + 1);

    //create third layer weights included bias weight
    weiHidOut = new Matrix(outputNodes, hiddenNodes + 1);

    //generate random values
    weiInHid.randomize();
    weiHidHid.randomize();
    weiHidOut.randomize();
  }

  //------------------------------------------------------------------------------------------
  // functions

  //mutation function for geneic algorithm
  public void mutate(float mutationRate) {
    weiInHid.mutate(mutationRate);
    weiHidHid.mutate(mutationRate);
    weiHidOut.mutate(mutationRate);
  }

  //calculate output values by feeding forward
  public float[] output(float[] inputsArray) {
    inputValues = inputsArray.clone();

    //convert array to matrix
    Matrix inputs = new StaticMatrix().singleColumnMatrixFromArray(inputsArray);

    //add bias
    Matrix inputsBias = inputs.addBias();

    //---------------------------------------------------
    // calculate guessed output

    // apply layer one weights to the inputs
    Matrix hiddenInputs = weiInHid.multiplyMatrix(inputsBias);
    
    //activate 1st hidden layer
    Matrix hiddenOutputs = hiddenInputs.activate();

    //add bias
    Matrix hiddenOutputBias = hiddenOutputs.addBias();

    //apply layer 2 weights
    Matrix hiddenInputs2 = weiHidHid.multiplyMatrix(hiddenOutputBias);
    Matrix hiddenOutputs2 = hiddenInputs2.activate();
    Matrix hiddenOutputsBias2 = hiddenOutputs2.addBias();
    
    
    
    //apply level 3 weights
    Matrix outputInputs = weiHidOut.multiplyMatrix(hiddenOutputsBias2);
    //activate outputs
    Matrix outputs = outputInputs.activate();
    
    

    //convert to an array and return
    outputValues = outputs.toArray();
    return outputValues.clone();
  }

  //crossover function for genetic algorithm
  public NeuralNetwork crossover(NeuralNetwork partner) {
    //creates a new child with layer matrices from both parents
    NeuralNetwork child = new NeuralNetwork(inputNodes, hiddenNodes, outputNodes);
    child.weiInHid = weiInHid.crossover(partner.weiInHid);
    child.weiHidHid = weiHidHid.crossover(partner.weiHidHid);
    child.weiHidOut = weiHidOut.crossover(partner.weiHidOut);
    return child;
  }

  //return a neural net which is a clone of this
  public NeuralNetwork clone() {
    NeuralNetwork clone = new NeuralNetwork(inputNodes, hiddenNodes, outputNodes);
    clone.weiInHid = weiInHid.clone();
    clone.weiHidHid = weiHidHid.clone();
    clone.weiHidOut = weiHidOut.clone();
    return clone;
  }

  //converts net to table to store in file
  public Table neuralNetToTable() {
    Table t = new Table();

    //convert the matricies to an Array
    float[] weiInHidArray = weiInHid.toArray();
    float[] weiHidHidArray = weiHidHid.toArray();
    float[] weiHidOutArray = weiHidOut.toArray();

    //set the amount of columns in the table
    for (int i = 0; i < max(weiInHidArray.length, weiHidHidArray.length, weiHidOutArray.length); i++)
      t.addColumn();

    //set first row as weiInHid
    TableRow tr = t.addRow();

    for (int i = 0; i < weiInHidArray.length; i++)
      tr.setFloat(i, weiInHidArray[i]);

    //set second row as weiHidHid
    tr = t.addRow();

    for (int i = 0; i < weiHidHidArray.length; i++)
      tr.setFloat(i, weiHidHidArray[i]);

    //set third row as weiHidHid
    tr = t.addRow();

    for (int i = 0; i < weiHidOutArray.length; i++)
      tr.setFloat(i, weiHidOutArray[i]);

    return t;
  }

  //converts table to net from file
  public void tableToNeuralNet(Table t) {
    //create arrays to store data from each matrix
    float[] weiInHidArray = new float[weiInHid.rows * weiInHid.cols];
    float[] weiHidHidArray = new float[weiHidHid.rows * weiHidHid.cols];
    float[] weiHidOutArray = new float[weiHidOut.rows * weiHidOut.cols];

    //set weiInHid array as first row of table
    TableRow tr = t.getRow(0);

    for (int i = 0; i < weiInHidArray.length; i++)
      weiInHidArray[i] = tr.getFloat(i);

    //set weiHidHid array as second row of table
    tr = t.getRow(1);

    for (int i = 0; i < weiHidHidArray.length; i++)
      weiHidHidArray[i] = tr.getFloat(i);

    //set weiHidHid array as third row of table
    tr = t.getRow(2);

    for (int i = 0; i < weiHidOutArray.length; i++)
      weiHidOutArray[i] = tr.getFloat(i);

    //convert arrays back to matrices
    weiInHid.fromArray(weiInHidArray);
    weiHidHid.fromArray(weiHidHidArray);
    weiHidOut.fromArray(weiHidOutArray);
  }

  private int getMiddle(int yoffset, int i, int yo, int height, int count) {
    return yoffset + i * yo + height / 2 - count * yo / 2 + yo / 2;
  }

  public void draw(int xoffset, int yoffset, int width, int height) {
    int maxnodes = max(inputNodes, hiddenNodes, outputNodes);
    // vertikale Abstände, Breiten
    int nodewidth = int(height / float(maxnodes) * 0.75);
    int yo = nodewidth + 100 / maxnodes;
    // horizontale Abstände
    int dis = width / 4;
    int xo = dis / 2;
    xoffset -= xo / 2;

    textFont(font, nodewidth);
    fill(255);

    //----------- Nodes -----------//

    // InputNodes
    PVector[] inNodes = new PVector[inputNodes];
    for (int i = 0; i < inputNodes; i++) {
      inNodes[i] = new PVector(xoffset + dis - xo, getMiddle(yoffset, i, yo, height, inputNodes));
      ellipse(inNodes[i].x, inNodes[i].y, nodewidth, nodewidth);
      text(round(inputValues[i]), inNodes[i].x - nodewidth * 1.2, inNodes[i].y + nodewidth * 0.35);
    }
    
    fill(255);

    // 1st HiddenNodes
    PVector[] hidNodes1 = new PVector[hiddenNodes];
    for (int i = 0; i < hiddenNodes; i++) {
      hidNodes1[i] = new PVector(xoffset + dis * 2 - xo, getMiddle(yoffset, i, yo, height, hiddenNodes));
      ellipse(hidNodes1[i].x, hidNodes1[i].y, nodewidth, nodewidth);
    }

    // 2st HiddenNodes
    PVector[] hidNodes2 = new PVector[hiddenNodes];
    for (int i = 0; i < hiddenNodes; i++) {
      hidNodes2[i] = new PVector(xoffset + dis * 3 - xo, getMiddle(yoffset, i, yo, height, hiddenNodes));
      ellipse(hidNodes2[i].x, hidNodes2[i].y, nodewidth, nodewidth);
    }

    // find max output to find action
    float maxv = outputValues[0];
    int maxindex = 0;
    for (int i = 1; i < outputNodes; i++) {
      if (outputValues[i] > maxv) {
        maxv = outputValues[i];
        maxindex = i;
      }
    }
    
    

    String[] text = new String[] { "FD", "TL", "TR" };

    // OutputNodes
    PVector[] outNodes = new PVector[outputNodes];
    for (int i = 0; i < outputNodes; i++) {
      outNodes[i] = new PVector(xoffset + dis * 4 - xo, getMiddle(yoffset, i, yo, height, outputNodes));
      if (i == maxindex) fill(0);
      ellipse(outNodes[i].x, outNodes[i].y, nodewidth, nodewidth);
      if (i == maxindex) fill(255);
      text(text[i % text.length] + " " + nf(outputValues[i], 1, 1), outNodes[i].x + nodewidth * 0.55, outNodes[i].y + nodewidth * 0.35);
    }

    //----------- Weights -----------//
    int maxwidth = nodewidth / 8;

    // InputNodes zu 1st HiddenNodes
    for (int i = 0; i < inputNodes; i++) {
      for (int j = 0; j < hiddenNodes; j++) {
        float v = weiInHid.matrix[j][i];
        strokeWeight(abs(v) * maxwidth);
        stroke(v < 0.0 ? 255 : 0, v < 0.0 ? 0 : 255, 0);
        line(inNodes[i].x, inNodes[i].y, hidNodes1[j].x, hidNodes1[j].y);
      }
    }

    // 1st HiddenNodes zu 2nd HiddenNodes
    for (int i = 0; i < hiddenNodes; i++) {
      for (int j = 0; j < hiddenNodes; j++) {
        float v = weiHidHid.matrix[j][i];
        strokeWeight(abs(v) * maxwidth);
        stroke(v < 0.0 ? 255 : 0, v < 0.0 ? 0 : 255, 0);
        line(hidNodes1[i].x, hidNodes1[i].y, hidNodes2[j].x, hidNodes2[j].y);
      }
    }

    // 2nd HiddenNodes zu OuputNodes
    for (int i = 0; i < hiddenNodes; i++) {
      for (int j = 0; j < outputNodes; j++) {
        float v = weiHidOut.matrix[j][i];
        strokeWeight(abs(v) * maxwidth);
        stroke(v < 0.0 ? 255 : 0, v < 0.0 ? 0 : 255, 0);
        line(hidNodes2[i].x, hidNodes2[i].y, outNodes[j].x, outNodes[j].y);
      }
    }

    strokeWeight(1);
  }
}
