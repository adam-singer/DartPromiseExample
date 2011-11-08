#import('dart:dom');

class FibInfo {
  int fibIndex;
  int fibValue;
  FibInfo([this.fibIndex=0,this.fibValue=0]);
}

//int fib(int x, Promise<FibInfo> p) {
int fib(int x) {
//  print("fib(int ${x})");
//  if (p.isCancelled()) return null;
  
  if (x<=0) {
    return 0;
  }
  else if (x==1) {
    return 1;
  }
  else {
    //return fib(x-1,p) + fib(x-2,p);
    return fib(x-1) + fib(x-2);
  }    
}

class PromiseExample {
  int fibIndexCount = 10;
  int fibWaitCount = 10;
  List<Promise<FibInfo>> fibsList;
  Promise<FibInfo> fibs; 
  
  PromiseExample() {
    fibs = new Promise<FibInfo>();
    fibsList = new List<Promise<FibInfo>>();
    
    for (int j=0; j<fibIndexCount; j++) {
      fibsList.add(new Promise<FibInfo>());
    }
    
    fibsList.forEach((Promise<FibInfo> p)  {
      p.then((FibInfo x) { 
        x.fibValue = fib(x.fibIndex);
      });
      
      p.addCompleteHandler((FibInfo x) {
        print("addCompleteHandler ${x}");
        bool hasValue = p.hasValue();
        print("x.hasValue = " + hasValue);
        print("x.value = ${p.value}");
        print("x.value.fibIndex = ${x.fibIndex}");
        print("x.value.fibValue = ${x.fibValue}");
      });
    });
  }

  void run() {
//    print("run()");
    
    List<FibInfo> fibInfoArr = new List<FibInfo>();
    
    for (int j=0; j<fibIndexCount; j++) {
      fibInfoArr.add(new FibInfo(j));
    }
    
    
//    fibInfoArr.forEach(o(FibInfo p)  {
//      print("[fibIndex=${p.fibIndex},fibValue=${p.fibValue}]");
//    });
     
    
    int i=0;
    fibsList.forEach(o(Promise<FibInfo> p)  {
      p.complete(fibInfoArr[i++]);
      print("p.complete = ${i}");
    });
    
    fibs.waitFor(fibsList, fibWaitCount);
    
    fibsList.forEach(o(Promise<FibInfo> p)  {
      print("[fibIndex=${p.value.fibIndex},fibValue=${p.value.fibValue}]");
      write("[fibIndex=${p.value.fibIndex},fibValue=${p.value.fibValue}]");
    });
    
    write("Done!");
  }

  void write(String message) {
    // the DOM library defines a global "window" variable
    HTMLDocument doc = window.document;
    HTMLParagraphElement p = doc.createElement('p');
    p.innerText = message;
    doc.body.appendChild(p);
  }
}

void main() {
  new PromiseExample().run();
}
