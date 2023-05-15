class Queue {
  // single Node in Queue
  class Node {
    // variables
    public PVector data; //data in queue
    public Node next;  //next node

    // constructor
    public Node(PVector data) {
      this.data = data;
      next = null;
    }
  }

  //--------------------------------------------------------------------------
  // variables
  private Node first;

  //--------------------------------------------------------------------------
  // constructor
  public Queue() {
    first = null;
  }

  //--------------------------------------------------------------------------
  // functions

  // enqueues new data
  public void enqueue(PVector x) {
    if (first == null) {
      first = new Node(x);
      return;
    }
    Node n = first;
    while (n.next != null)
      n = n.next;
    n.next = new Node(x);
  }

  // dequeues data and returns it
  public PVector dequeue() {
    if (first == null)
      throw new ArrayIndexOutOfBoundsException("the queue is empty");
    Node ret = first;
    first = first.next;
    return ret.data;
  }

  // get last inserted item -> head
  public PVector head() {
    if (first == null)
      throw new ArrayIndexOutOfBoundsException("the queue is empty");
    return first.data;
  }
  
  // get first inserted item -> tail
  public PVector tail() {
    if (first == null)
      throw new ArrayIndexOutOfBoundsException("the queue is empty");
    Node ret = first;
    while (ret.next != null)
      ret = ret.next;
    return ret.data;
  }

  // is the queue empty
  public boolean isEmpty() {
    return first == null;
  }

  // returns the amount of nodes in the queue
  public int length() {
    Node n = first;
    int length = 0;
    while (n != null) {
      n = n.next;
      length++;
    }
    return length;
  }

  // returns the data of a Node at the parameter index
  public PVector getItem(int index) {
    if (first == null)
      throw new ArrayIndexOutOfBoundsException("the queue is empty");
    Node n = first;
    for (int i = 0; i < index; i++) {
      n = n.next;
      if (n == null)
        throw new ArrayIndexOutOfBoundsException("the index is not in the list");
    }
    return n.data;
  }
  
  // returns true if the queue contains the parameter data in one of its nodes
  public boolean contains(PVector p) {
    if (first == null)
      return false;
    Node n = first;
    while (n != null) {
      if (n.data.x == p.x && n.data.y == p.y)
        return true;
      n = n.next;
    }
    return false;
  }
  
  // clears queue
  public void clear() {
    first = null;
  }
  
  public void draw(float xoff, float yoff, float tilewidth, color c) {
    fill(c);
    stroke(0);
    Node n = first;
    while (n != null) {
      rect(n.data.x * tilewidth + xoff, n.data.y * tilewidth + yoff, tilewidth, tilewidth);
      n = n.next;
    }
  }
  
  public void printSnake() {
    Node n = first;
    while (n != null) {
      print("[" + round(n.data.x) + ", " + round(n.data.y) + "]");
      n = n.next;
    }
    println();
  }
  
  public Queue copy() {
    Queue result = new Queue();
    Node n = first;
    Node n1 = result.first;
    while (n != null) {
      n1 = new Node(n.data.copy());
      n1 = n.next;
      n = n.next;
    }
    return result;
  }
}
