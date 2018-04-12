package ;

import haxe.unit.*;
import haxe.Int64;
import haxe.io.Bytes;
import deepequal.custom.*;
import deepequal.DeepEqual.compare;
import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Error;

using StringTools;

class RunTests extends TestCase {

	static function main() {
		var runner = new TestRunner();
		runner.add(new RunTests());
		
		travix.Logger.exit(runner.run() ? 0 : 500);
	}
	
	function testNull() {
		var a = null;
		var e = null;
		assertSuccess(compare(e, a));
		
		var a = null;
		var e = 1;
		assertFailure(compare(e, a), 'Expected 1 but got null @ v');
		
		var a = null;
		var e = Success('foo');
		assertFailure(compare(e, a), 'Expected Success(foo) but got null @ v');
		
		var a = null;
		var e = new Foo(1);
		assertFailureRegex(compare(e, a), ~/Expected .* but got null @ v/);
		
		var a = null;
		var e = Foo;
		assertFailureRegex(compare(e, a), ~/Expected .* but got null @ v/);
		
		var a = 1;
		var e = null;
		assertFailure(compare(e, a), 'Expected null but got 1 @ v');
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
		assertFailure(compare(e, a), 'Expected 2 but got null @ v.c');
		
		var a = {a:1, b:2};
		var e = {a:1, b:3};
		assertFailure(compare(e, a), 'Expected 3 but got 2 @ v.b');
		
		var a = {a:1, b:2};
		var e = {a:1, b:'2'};
		assertFailure(compare(e, a), 'Expected "2" but got 2 @ v.b');
	}
	
	function testArrayOfObjects() {
		var a = [{a:1, b:2}];
		var e = [{a:1, b:2}];
		assertSuccess(compare(e, a));
		
		var a = [{a:1, b:2}];
		var e = [{a:1, c:2}];
		assertFailure(compare(e, a), 'Expected 2 but got null @ v[0].c');
		
		var a = [{a:1, b:2}];
		var e = [{a:1, b:3}];
		assertFailure(compare(e, a), 'Expected 3 but got 2 @ v[0].b');
	}
	
	function testArray() {
		var a = [0.1];
		var e = [0.1];
		assertSuccess(compare(e, a));
		
		var a = [0.1];
		var e = [1.1];
		assertFailure(compare(e, a), 'Expected 1.1 but got 0.1 @ v[0]');
		
		var a = [0.1, 0.2];
		var e = [0.1, 0.2, 0.3];
		assertFailure(compare(e, a), 'Expected array of length 3 but got 2 @ v');
	}
	
	function testFloat() {
		var a = 0.1;
		var e = 0.1;
		assertSuccess(compare(e, a));
		
		var a = 0.1;
		var e = 1.1;
		assertFailure(compare(e, a), 'Expected 1.1 but got 0.1 @ v');
	}
	
	function testInt() {
		var a = 0;
		var e = 0;
		assertSuccess(compare(e, a));
		
		var a = 0;
		var e = 1;
		assertFailure(compare(e, a), 'Expected 1 but got 0 @ v');
	}
	
	function testString() {
		var a = 'actual';
		var e = 'actual';
		assertSuccess(compare(e, a));
		
		var a = 'actual';
		var e = 'expected';
		assertFailure(compare(e, a), 'Expected "expected" but got "actual" @ v');
	}
	
	function testDate() {
		var a = new Date(2016, 1, 1, 1, 1, 1);
		var e = new Date(2016, 1, 1, 1, 1, 1);
		assertSuccess(compare(e, a));
		
		var a = new Date(2016, 1, 1, 1, 1, 2);
		var e = new Date(2016, 1, 1, 1, 1, 1);
		assertFailure(compare(e, a), 'Expected 2016-02-01 01:01:01 but got 2016-02-01 01:01:02 @ v');
	}
	
	function testInt64() {
		var a = Int64.make(1, 2);
		var e = Int64.make(1, 2);
		assertSuccess(compare(e, a));
		
		var a = Int64.make(1, 2);
		var e = Int64.make(1, 3);
		assertFailure(compare(e, a), 'Expected 4294967299 but got 4294967298 @ v');
	}
	
	function testMap() {
		var a = [1 => 'a', 2 => 'b'];
		var e = [1 => 'a', 2 => 'b'];
		assertSuccess(compare(e, a));
		
		var a = [1 => 'a'];
		var e = [1 => 'a', 2 => 'b'];
		assertFailure(compare(e, a), 'Expected 2 field(s) but got 1 @ v');
		
		var a = [1 => 'a', 3 => 'c'];
		var e = [1 => 'a', 2 => 'b'];
		assertFailure(compare(e, a), 'Map keys mismatch: Expected 2 but got 3 @ v[1]');
		
		var a = [1 => 'a', 2 => 'b'];
		var e = ['1' => 'a', '2' => 'b'];
		assertFailure(compare(e, a), 'Map keys mismatch: Expected "1" but got 1 @ v[0]');
	}
	
	function testFunction() {
		var a = main;
		var e = main;
		assertSuccess(compare(e, a));
		
		var a = testFunction;
		var e = testFunction;
		assertSuccess(compare(e, a));
		
		var a = function() {};
		var e = function() {};
		assertFailure(compare(e, a));
	}
	
	function testEnum() {
		var a = Success('foo');
		var e = Success('foo');
		assertSuccess(compare(e, a));
		
		var a = Success('foo');
		var e = Success('f');
		assertFailure(compare(e, a), 'Expected "f" but got "foo" @ v(enumParam:0)');
		
		var a = Success('foo');
		var e = Failure('foo');
		assertFailure(compare(e, a), 'Expected enum constructor Failure but got Success @ v');
		
		var a = FakeOutcome.Success(1);
		var e = Outcome.Success(1);
		assertFailure(compare(e, a), 'Expected enum deepequal.Outcome but got FakeOutcome @ v');
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
		assertFailure(compare(e, a), 'Expected 2 but got 1 @ v.value');
		
		var a = new Foo(1);
		var e = new Bar(1);
		assertFailure(compare(e, a), 'Expected class instance of Bar but got Foo @ v');
		
		var a = new Foo(1);
		var e = new Bar(2);
		assertFailure(compare(e, a), 'Expected class instance of Bar but got Foo @ v');
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
		assertFailure(compare(e, a), 'Expected bytes of length 20 but got 10 @ v');
		
		var a = Bytes.ofString('xyz');
		var e = Bytes.ofString('abc');
		assertFailure(compare(e, a), 'Expected bytes(hex):616263 but got bytes(hex):78797a @ v');
		
		
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
		assertFailure(compare(e, a), 'Cannot find 5 in [1,2,3,4] @ v');
	}
	
	function testArrayOfLength() {
		var a = [1,2,3];
		var e = new ArrayOfLength(3);
		assertSuccess(compare(e, a));

		var a = [1,2,3,4];
		var e = new ArrayOfLength(3);
		assertFailure(compare(e, a), 'Expected array of length 3 but got 4 @ v');
	}
	
	function testObjectContains() {
		var a = {a: 1, b: '2'}
		var e = new ObjectContains({a: 1});
		assertSuccess(compare(e, a));
		
		var a = {a: 1, b: '2'}
		var e = new ObjectContains({b: 2});
		assertFailure(compare(e, a), 'Expected 2 but got "2" @ v.b');
		
		var a = {a: 1, b: '2'}
		var e = new ObjectContains({b: '2'});
		assertSuccess(compare(e, a));
		
		var a = {a: 1, c: '2'}
		var e = new ObjectContains({a:1, b:2});
		assertFailure(compare(e, a), 'Cannot find field b @ v');
	}
	
	function testObjectContainsKeys() {
		var a = {a: 1, b: '2'}
		var e = new ObjectContainsKeys(['a', 'b']);
		assertSuccess(compare(e, a));

		var a = {a: 1, c: '2'}
		var e = new ObjectContainsKeys(['a', 'b']);
		assertFailure(compare(e, a), 'Cannot find key b @ v');
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
		assertFailure(compare(e, a), 'Expected array of length 4 but got 3 @ v');
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
		
		var a = 'Success';
		var e = new EnumByName(Outcome, 'Failure');
		assertFailure(compare(e, a));
	}
	
	function testRegex() {
		var a = 'Success';
		var e = new Regex(~/Suc/);
		assertSuccess(compare(e, a));
		
		var a = 'Success';
		var e = new Regex(~/suc/);
		assertFailure(compare(e, a));
		
		var a = 'Success';
		var e = new Regex(~/suc/i);
		assertSuccess(compare(e, a));
		
		var a = 'Success';
		var e = new Regex(~/Suc.*/);
		assertSuccess(compare(e, a));
		
	}
	
	function testStringStartsWith() {
		var a = 'Success';
		var e = new StringStartsWith('Succ');
		assertSuccess(compare(e, a));
		
		var a = 'Success';
		var e = new StringStartsWith('succ');
		assertFailure(compare(e, a));
		
		var a = 'Success';
		var e = new StringStartsWith('Success');
		assertSuccess(compare(e, a));
		
		var a = 'Success';
		var e = new StringStartsWith('Failure');
		assertFailure(compare(e, a));
		
	}
	
	function assertSuccess(outcome:Outcome<Noise, Error>, ?pos:haxe.PosInfos) {
		switch outcome {
			case Success(_): assertTrue(true, pos);
			case Failure(e): trace(e.message); trace(e.data); assertTrue(false, pos);
		}
	}
	
	function assertFailure(outcome:Outcome<Noise, Error>, ?message:String, ?pos:haxe.PosInfos) {
		switch outcome {
			case Failure(f) if(message == null): assertTrue(true, pos);
			case Failure(f): assertEquals(message, f.message, pos);
			case Success(e): assertTrue(false, pos);
		}
	}
	
	function assertFailureRegex(outcome:Outcome<Noise, Error>, regex:EReg, ?pos:haxe.PosInfos) {
		switch outcome {
			case Failure(f): assertTrue(regex.match(f.message.replace('\n', '')), pos);
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

