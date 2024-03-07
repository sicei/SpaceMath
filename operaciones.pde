class Operacion {

  int a, b;
  
  Operacion(int a, int b){
    this.a = a;
    this.b = b;
  }
  
  int suma(){
    return this.a + this.b;
  }
  
  int resta(){
    return this.a - this.b;  
  }
  
  int multiplicacion(){
    return this.a * this.b;
  }

}
