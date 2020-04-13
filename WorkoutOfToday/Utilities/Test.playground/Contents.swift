
class Test {
    var prop: Int = 0 {
        didSet {
            print("changed in props")
        }
    }
    
    func printClassName() {
        print(String(describing: type(of: self)))
    }
}

struct Test2 {
    var prop: Int = 0
}


var test = Test() {
    didSet {
        print("DidSet in class")
    }
    willSet {
        print("Wiilset")
    }
}

var test2 = Test2() {
    didSet {
        print("DidSet in struct")
    }
}

test = Test()

test.printClassName()
