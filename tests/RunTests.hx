package ;

import haxe.unit.*;
import haxe.Int64;
import haxe.io.Bytes;
import deepequal.custom.*;
import deepequal.DeepEqual.compare;
import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Error;

class RunTests extends TestCase {

	static function main() {
		var runner = new TestRunner();
		runner.add(new RunTests());
		
		travix.Logger.exit(runner.run() ? 0 : 500);
	}
	
	function testObject() {
		var a = {a:1, b:2};
		var e = {a:1, b:2};
		assertSuccess(compare(e, a));
		
		var a = {a:1, b:[2]};
		var e = {a:1, b:[2]};
		assertSuccess(compare(e, a));
		
		var a = {a:1, b:2};
		var e = {a:1, c:2};
		assertFailure(compare(e, a));
		
		var a = {a:1, b:2};
		var e = {a:1, b:3};
		assertFailure(compare(e, a));
		
		var a = {a:1, b:2};
		var e = {a:1, b:'2'};
		assertFailure(compare(e, a));
	}
	
	function testArrayOfObjects() {
		var a = [{a:1, b:2}];
		var e = [{a:1, b:2}];
		assertSuccess(compare(e, a));
		
		var a = [{a:1, b:2}];
		var e = [{a:1, c:2}];
		assertFailure(compare(e, a));
		
		var a = [{a:1, b:2}];
		var e = [{a:1, b:3}];
		assertFailure(compare(e, a));
	}
	
	function testArray() {
		var a = [0.1];
		var e = [0.1];
		assertSuccess(compare(e, a));
		
		var a = [0.1];
		var e = [1.1];
		assertFailure(compare(e, a));
		
		var a = [0.1, 0.2];
		var e = [0.1, 0.2, 0.3];
		assertFailure(compare(e, a));
	}
	
	function testFloat() {
		var a = 0.1;
		var e = 0.1;
		assertSuccess(compare(e, a));
		
		var a = 0.1;
		var e = 1.1;
		assertFailure(compare(e, a));
	}
	
	function testInt() {
		var a = 0;
		var e = 0;
		assertSuccess(compare(e, a));
		
		var a = 0;
		var e = 1;
		assertFailure(compare(e, a));
	}
	
	function testString() {
		var a = 'actual';
		var e = 'actual';
		assertSuccess(compare(e, a));
		
		var a = 'actual';
		var e = 'expected';
		assertFailure(compare(e, a));
	}
	
	function testDate() {
		var a = new Date(2016, 1, 1, 1, 1, 1);
		var e = new Date(2016, 1, 1, 1, 1, 1);
		assertSuccess(compare(e, a));
		
		var a = new Date(2016, 1, 1, 1, 1, 2);
		var e = new Date(2016, 1, 1, 1, 1, 1);
		assertFailure(compare(e, a));
	}
	
	function testInt64() {
		var a = Int64.make(1, 2);
		var e = Int64.make(1, 2);
		assertSuccess(compare(e, a));
		
		var a = Int64.make(1, 2);
		var e = Int64.make(1, 3);
		assertFailure(compare(e, a));
	}
	
	function testEnum() {
		var a = Success('foo');
		var e = Success('foo');
		assertSuccess(compare(e, a));
		
		var a = Success('foo');
		var e = Success('f');
		assertFailure(compare(e, a));
		
		var a = Success('foo');
		var e = Failure('foo');
		assertFailure(compare(e, a));
		
		var a = FakeOutcome.Success(1);
		var e = Outcome.Success(1);
		assertFailure(compare(e, a));
	}
	
	function testClass() {
		var a = new Foo(1);
		var e = new Foo(1);
		assertSuccess(compare(e, a));
		
		var a = new Foo({a: 1});
		var e = new Foo({a: 1});
		assertSuccess(compare(e, a));
		
		var a = new Foo(([1, 'a']:Array<Dynamic>));
		var e = new Foo(([1, 'a']:Array<Dynamic>));
		assertSuccess(compare(e, a));

		var a = new Foo(1);
		var e = new Foo(2);
		assertFailure(compare(e, a));
		
		var a = new Foo(1);
		var e = new Bar(1);
		assertFailure(compare(e, a));
		
		var a = new Foo(1);
		var e = new Bar(2);
		assertFailure(compare(e, a));
	}
	
	function testBytes() {
		
		var a = Bytes.alloc(10);
		var e = Bytes.alloc(10);
		assertSuccess(compare(e, a));
		
		var a = Bytes.ofString('abc');
		var e = Bytes.ofString('abc');
		assertSuccess(compare(e, a));
		
		var a = Bytes.alloc(10);
		var e = Bytes.alloc(20);
		assertFailure(compare(e, a));
		
		var a = Bytes.ofString('abc');
		var e = Bytes.ofString('def');
		assertFailure(compare(e, a));
		
		
	}
	
	function testClassObj() {
		var a = Foo;
		var e = Foo;
		assertSuccess(compare(e, a));
		
		var a = Foo;
		var e = Bar;
		assertFailure(compare(e, a));
	}
	
	function testEnumObj() {
		var a = Outcome;
		var e = Outcome;
		assertSuccess(compare(e, a));
		
		var a = Outcome;
		var e = haxe.ds.Option;
		assertFailure(compare(e, a));
	}
	
	function testArrayContains() {
		var a = [1,2,3,4];
		var e = new ArrayContains([1,2,3]);
		assertSuccess(compare(e, a));

		var a = [1,2,3,4];
		var e = new ArrayContains([3,5]);
		assertFailure(compare(e, a));
	}
	
	function testArrayLength() {
		var a = [1,2,3];
		var e = new ArrayLength(3);
		assertSuccess(compare(e, a));

		var a = [1,2,3,4];
		var e = new ArrayLength(3);
		assertFailure(compare(e, a));
	}
	
	function testObjectContainsKeys() {
		var a = {a: 1, b: '2'}
		var e = new ObjectContainsKeys(['a', 'b']);
		assertSuccess(compare(e, a));

		var a = {a: 1, c: '2'}
		var e = new ObjectContainsKeys(['a', 'b']);
		assertFailure(compare(e, a));
	}
	
	function testAnything() {
		var a = null;
		var e = new Anything();
		assertSuccess(compare(e, a));

		var a = [1,2,3,4];
		var e = new Anything();
		assertSuccess(compare(e, a));
		
		var a = [1,2,3,4];
		var e = [for(i in 0...4) new Anything()]; // essentially same as ArrayLength
		assertSuccess(compare(e, a));
		
		var a = [1,2,3];
		var e = [for(i in 0...4) new Anything()]; // essentially same as ArrayLength
		assertFailure(compare(e, a));
	}
	
	function testEnumByName() {
		var a = Success(1);
		var e = new EnumByName(Outcome, 'Success');
		assertSuccess(compare(e, a));
		
		var a = Success(1);
		var e = new EnumByName(Outcome, 'Success', [1]);
		assertSuccess(compare(e, a));
		
		var a = Success(1);
		var e = new EnumByName(Outcome, 'Success', [2]);
		assertFailure(compare(e, a));
		
		var a = Success(1);
		var e = new EnumByName(FakeOutcome, 'Success');
		assertFailure(compare(e, a));
		
		var a = Success(1);
		var e = new EnumByName(Outcome, 'Failure');
		assertFailure(compare(e, a));
	}
	
	function assertSuccess(outcome:Outcome<Noise, Error>, ?pos:haxe.PosInfos) {
		switch outcome {
			case Success(_): assertTrue(true, pos);
			case Failure(e): trace(e.message, e.data); assertTrue(false, pos);
		}
	}
	
	function assertFailure(outcome:Outcome<Noise, Error>, ?message:String, ?pos:haxe.PosInfos) {
		switch outcome {
			case Failure(f) if(message == null): assertTrue(true, pos);
			case Failure(f): assertEquals(message, f.message, pos);
			case Success(e): assertTrue(false, pos);
		}
	}
}

class Foo<T> {
	var value:T;
	public function new(v:T) {
		value = v;
	}
}
class Bar<T> {
	var value:T;
	public function new(v:T) {
		value = v;
	}
}

