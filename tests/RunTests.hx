package ;

import tink.unit.*;
import tink.testrunner.*;
import haxe.Int64;
import haxe.io.Bytes;
import deepequal.custom.*;
import deepequal.DeepEqual.compare;
import deepequal.Outcome;
import deepequal.Noise;
import deepequal.Error;

using StringTools;
using RunTests;

@:asserts
class RunTests {

	static function main() {
		Runner.run(TestBatch.make([
			new RunTests(),
		])).handle(Runner.exit);
	}
	
	static function print(v:Dynamic) {
		trace('Value: $v');
	}
	
	function new() {}
	
	public function nil() {
		var a = null;
		var e = null;
		asserts.assert(compare(e, a));
		
		var a = null;
		var e = 1;
		asserts.assertFailure(compare(e, a), 'Expected 1 but got null @ v');
		
		var a = null;
		var e = Success('foo');
		asserts.assertFailure(compare(e, a), 'Expected Success(foo) but got null @ v');
		
		var a = null;
		var e = new Foo(1);
		asserts.assertFailureRegex(compare(e, a), ~/Expected .* but got null @ v/);
		
		var a = null;
		var e = Foo;
		asserts.assertFailureRegex(compare(e, a), ~/Expected .* but got null @ v/);
		
		var a = 1;
		var e = null;
		asserts.assertFailure(compare(e, a), 'Expected null but got 1 @ v');
		
		return asserts.done();
	}
	
	#if !jvm // see: https://github.com/HaxeFoundation/haxe/issues/8286
	public function object() {
		var a = {a:1, b:2};
		var e = {a:1, b:2};
		asserts.assert(compare(e, a));
		
		var a = {a:1, b:[2]};
		var e = {a:1, b:[2]};
		asserts.assert(compare(e, a));
		
		var a = {a:1, b:2};
		var e = {a:1, c:2};
		asserts.assertFailure(compare(e, a), 'Expected 2 but got null @ v.c');
		
		var a = {a:1, b:2};
		var e = {a:1, b:3};
		asserts.assertFailure(compare(e, a), 'Expected 3 but got 2 @ v.b');
		
		var a = {a:1, b:2};
		var e = {a:1, b:'2'};
		asserts.assertFailure(compare(e, a), 'Expected "2" but got 2 @ v.b');
		
		return asserts.done();
	}
	
	public function arrayOfObjects() {
		var a = [{a:1, b:2}];
		var e = [{a:1, b:2}];
		asserts.assert(compare(e, a));
		
		var a = [{a:1, b:2}];
		var e = [{a:1, c:2}];
		asserts.assertFailure(compare(e, a), 'Expected 2 but got null @ v[0].c');
		
		var a = [{a:1, b:2}];
		var e = [{a:1, b:3}];
		asserts.assertFailure(compare(e, a), 'Expected 3 but got 2 @ v[0].b');
		
		return asserts.done();
	}
	#end
	
	public function array() {
		var a = [0.1];
		var e = [0.1];
		asserts.assert(compare(e, a));
		
		var a = [0.1];
		var e = [1.1];
		asserts.assertFailure(compare(e, a), 'Expected 1.1 but got 0.1 @ v[0]');
		
		var a = [0.1, 0.2];
		var e = [0.1, 0.2, 0.3];
		asserts.assertFailure(compare(e, a), 'Expected array of length 3 but got 2 @ v');
		
		return asserts.done();
	}
	
	public function float() {
		var a = 0.1;
		var e = 0.1;
		asserts.assert(compare(e, a));
		
		var a = 0.1;
		var e = 1.1;
		asserts.assertFailure(compare(e, a), 'Expected 1.1 but got 0.1 @ v');
		
		return asserts.done();
	}
	
	public function int() {
		var a = 0;
		var e = 0;
		asserts.assert(compare(e, a));
		
		var a = 0;
		var e = 1;
		asserts.assertFailure(compare(e, a), 'Expected 1 but got 0 @ v');
		
		return asserts.done();
	}
	
	public function string() {
		var a = 'actual';
		var e = 'actual';
		asserts.assert(compare(e, a));
		
		var a = 'actual';
		var e = 'expected';
		asserts.assertFailure(compare(e, a), 'Expected "expected" but got "actual" @ v');
		
		return asserts.done();
	}
	
	public function date() {
		var a = new Date(2016, 1, 1, 1, 1, 1);
		var e = new Date(2016, 1, 1, 1, 1, 1);
		asserts.assert(compare(e, a));
		
		var a = new Date(2016, 1, 1, 1, 1, 2);
		var e = new Date(2016, 1, 1, 1, 1, 1);
		asserts.assertFailure(compare(e, a), 'Expected 2016-02-01 01:01:01 but got 2016-02-01 01:01:02 @ v');
		
		return asserts.done();
	}
	
	public function int64() {
		var a = Int64.make(1, 2);
		var e = Int64.make(1, 2);
		asserts.assert(compare(e, a));
		
		var a = Int64.make(1, 2);
		var e = Int64.make(1, 3);
		asserts.assertFailure(compare(e, a), 'Expected 4294967299 but got 4294967298 @ v');
		
		return asserts.done();
	}
	
	public function map() {
		var a = [1 => 'a', 2 => 'b'];
		var e = [1 => 'a', 2 => 'b'];
		asserts.assert(compare(e, a));
		
		var a = [1 => 'a'];
		var e = [1 => 'a', 2 => 'b'];
		asserts.assertFailure(compare(e, a), 'Expected 2 field(s) but got 1 @ v');
		
		var a = [1 => 'a', 3 => 'c'];
		var e = [1 => 'a', 2 => 'b'];
		asserts.assertFailure(compare(e, a), 'Map keys mismatch: Expected 2 but got 3 @ v[1]');
		
		var a = [1 => 'a', 2 => 'b'];
		var e = ['1' => 'a', '2' => 'b'];
		asserts.assertFailure(compare(e, a), 'Map keys mismatch: Expected "1" but got 1 @ v[0]');
		
		return asserts.done();
	}
	
	public function func() {
		var a = main;
		var e = main;
		asserts.assert(compare(e, a));
		
		var a = func;
		var e = func;
		asserts.assert(compare(e, a));
		
		var a = function() {};
		var e = function() {};
		asserts.assertFailure(compare(e, a), 'The two functions are not equal @ v');
		
		return asserts.done();
	}
	
	public function enm() {
		var a = Success('foo');
		var e = Success('foo');
		asserts.assert(compare(e, a));
		
		var a = Success('foo');
		var e = Success('f');
		asserts.assertFailure(compare(e, a), 'Expected "f" but got "foo" @ v(enumParam:0)');
		
		var a = Success('foo');
		var e = Failure('foo');
		asserts.assertFailure(compare(e, a), 'Expected enum constructor Failure but got Success @ v');
		
		var a = FakeOutcome.Success(1);
		var e = Outcome.Success(1);
		asserts.assertFailure(compare(e, a), 'Expected enum tink.core.Outcome but got FakeOutcome @ v');
		
		return asserts.done();
	}
	
	public function cls() {
		var a = new Foo(1);
		var e = new Foo(1);
		asserts.assert(compare(e, a));
		
		var a = new Foo({a: 1});
		var e = new Foo({a: 1});
		asserts.assert(compare(e, a));
		
		var a = new Foo(([1, 'a']:Array<Dynamic>));
		var e = new Foo(([1, 'a']:Array<Dynamic>));
		asserts.assert(compare(e, a));

		var a = new Foo(1);
		var e = new Foo(2);
		asserts.assertFailure(compare(e, a), 'Expected 2 but got 1 @ v.value');
		
		var a = new Foo(1);
		var e = new Bar(1);
		asserts.assertFailure(compare(e, a), 'Expected class instance of Bar but got Foo @ v');
		
		var a = new Foo(1);
		var e = new Bar(2);
		asserts.assertFailure(compare(e, a), 'Expected class instance of Bar but got Foo @ v');
		
		return asserts.done();
	}
	
	public function bytes() {
		
		var a = Bytes.alloc(10);
		var e = Bytes.alloc(10);
		asserts.assert(compare(e, a));
		
		var a = Bytes.ofString('abc');
		var e = Bytes.ofString('abc');
		asserts.assert(compare(e, a));
		
		var a = Bytes.alloc(10);
		var e = Bytes.alloc(20);
		asserts.assertFailure(compare(e, a), 'Expected bytes of length 20 but got 10 @ v');
		
		var a = Bytes.ofString('xyz');
		var e = Bytes.ofString('abc');
		asserts.assertFailure(compare(e, a), 'Expected bytes(hex):616263 but got bytes(hex):78797a @ v');
		
		return asserts.done();
	}
	
	public function classObj() {
		var a = Foo;
		var e = Foo;
		asserts.assert(compare(e, a));
		
		var a = Foo;
		var e = Bar;
		asserts.assertFailureRegex(compare(e, a), ~/^Expected Bar but got Foo @ v$/);
		
		return asserts.done();
	}
	
	public function enumObj() {
		// var a = Outcome;
		// var e = Outcome;
		// asserts.assert(compare(e, a));
		
		var a = Outcome;
		var e = haxe.ds.Option;
		asserts.assertFailureRegex(compare(e, a), ~/^Expected haxe.ds.Option but got tink.core.Outcome @ v$/);
		
		return asserts.done();
	}
	
	public function arrayContains() {
		var a = [1,2,3,4];
		var e = new ArrayContains([1,2,3]);
		asserts.assert(compare(e, a));

		var a = [1,2,3,4];
		var e = new ArrayContains([3,5]);
		asserts.assertFailure(compare(e, a), 'Cannot find 5 in [1,2,3,4] @ v');
		
		return asserts.done();
	}
	
	public function arrayOfLength() {
		var a = [1,2,3];
		var e = new ArrayOfLength(3);
		asserts.assert(compare(e, a));

		var a = [1,2,3,4];
		var e = new ArrayOfLength(3);
		asserts.assertFailure(compare(e, a), 'Expected array of length 3 but got 4 @ v');
		
		return asserts.done();
	}
	
	public function objectContains() {
		var a = {a: 1, b: '2'}
		var e = new ObjectContains({a: 1});
		asserts.assert(compare(e, a));
		
		var a = {a: 1, b: '2'}
		var e = new ObjectContains({b: 2});
		asserts.assertFailure(compare(e, a), 'Expected 2 but got "2" @ v.b');
		
		var a = {a: 1, b: '2'}
		var e = new ObjectContains({b: '2'});
		asserts.assert(compare(e, a));
		
		var a = {a: 1, c: '2'}
		var e = new ObjectContains({a:1, b:2});
		asserts.assertFailure(compare(e, a), 'Cannot find field b @ v');
		
		return asserts.done();
	}
	
	public function objectContainsKeys() {
		var a = {a: 1, b: '2'}
		var e = new ObjectContainsKeys(['a', 'b']);
		asserts.assert(compare(e, a));

		var a = {a: 1, c: '2'}
		var e = new ObjectContainsKeys(['a', 'b']);
		asserts.assertFailure(compare(e, a), 'Cannot find key b @ v');
		
		return asserts.done();
		
	}
	
	public function anything() {
		var a = null;
		var e = new Anything();
		asserts.assert(compare(e, a));

		var a = [1,2,3,4];
		var e = new Anything();
		asserts.assert(compare(e, a));
		
		var a = [1,2,3,4];
		var e = [for(i in 0...4) new Anything()]; // essentially same as ArrayLength
		asserts.assert(compare(e, a));
		
		var a = [1,2,3];
		var e = [for(i in 0...4) new Anything()]; // essentially same as ArrayLength
		asserts.assertFailure(compare(e, a), 'Expected array of length 4 but got 3 @ v');
		
		return asserts.done();
	}
	
	public function enumByName() {
		var a = Success(1);
		var e = new EnumByName(Outcome, 'Success');
		asserts.assert(compare(e, a));
		
		var a = Success(1);
		var e = new EnumByName(Outcome, 'Success', [1]);
		asserts.assert(compare(e, a));
		
		var a = Success(1);
		var e = new EnumByName(Outcome, 'Success', [2]);
		asserts.assertFailure(compare(e, a), 'Unmatched enum parameters in Success(1) @ v');
		
		var a = Success(1);
		var e = new EnumByName(FakeOutcome, 'Success');
		asserts.assertFailure(compare(e, a), 'Expected enum of FakeOutcome but got Success(1) @ v');
		
		var a = Success(1);
		var e = new EnumByName(Outcome, 'Failure');
		asserts.assertFailure(compare(e, a), 'Expected enum named Failure but got Success(1) @ v');
		
		var a = 'Success';
		var e = new EnumByName(Outcome, 'Failure');
		asserts.assertFailure(compare(e, a), 'Expected Success to be an enum @ v');
		
		return asserts.done();
	}
	
	public function regex() {
		var a = 'Success';
		var e = new Regex(~/Suc/);
		asserts.assert(compare(e, a));
		
		var a = 'Success';
		var e = new Regex(~/suc/);
		asserts.assertFailureRegex(compare(e, a), ~/^Cannot match Success with the required regex:.*/);
		
		var a = 'Success';
		var e = new Regex(~/suc/i);
		asserts.assert(compare(e, a));
		
		var a = 'Success';
		var e = new Regex(~/Suc.*/);
		asserts.assert(compare(e, a));
		
		return asserts.done();
	}
	
	public function stringStartsWith() {
		var a = 'Success';
		var e = new StringStartsWith('Succ');
		asserts.assert(compare(e, a));
		
		var a = 'Success';
		var e = new StringStartsWith('succ');
		asserts.assertFailure(compare(e, a), 'Expected string starting with succ but got Success @ v');
		
		var a = 'Success';
		var e = new StringStartsWith('Success');
		asserts.assert(compare(e, a));
		
		var a = 'Success';
		var e = new StringStartsWith('Failure');
		asserts.assertFailure(compare(e, a), 'Expected string starting with Failure but got Success @ v');
		
		return asserts.done();
	}
	
	public function nonEnum() {
		var a = {};
		var e = Success(1);
		asserts.assert(compare(e, a).match(Failure(_)));
		
		return asserts.done();
	}
	
	static function assertFailure(asserts:AssertionBuffer, outcome:Outcome<Noise, Error>, message:String, ?pos:haxe.PosInfos) {
		switch outcome {
			case Failure(e): asserts.assert(e.message == message, pos);
			case Success(e): asserts.fail('Expected a Failure', pos);
		}
	}
	
	static function assertFailureRegex(asserts:AssertionBuffer, outcome:Outcome<Noise, Error>, regex:EReg, ?pos:haxe.PosInfos) {
		switch outcome {
			case Failure(e): asserts.assert(regex.match(e.message.replace('\n', '')), pos);
			case Success(_): asserts.fail('Expected a Failure', pos);
		}
	}
}

class Foo<T> {
	var value:T;
	public function new(v:T) {
		value = v;
	}
	function foo() {}
}
class Bar<T> {
	var value:T;
	public function new(v:T) {
		value = v;
	}
	function bar() {}
}

