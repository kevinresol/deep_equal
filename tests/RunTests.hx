package ;

import haxe.unit.*;
import deepequal.DeepEqual.*;

class RunTests extends TestCase {

	static function main() {
		var runner = new TestRunner();
		runner.add(new RunTests());
		
		travix.Logger.exit(runner.run() ? 0 : 500);
	}
	
	function testObject() {
		var a = {a:1, b:2};
		var e = {a:1, b:2};
		shouldSucceed(compare.bind(e, a));
		
		var a = {a:1, b:[2]};
		var e = {a:1, b:[2]};
		shouldSucceed(compare.bind(e, a));
		
		var a = {a:1, b:2};
		var e = {a:1, c:2};
		shouldFail(compare.bind(e, a));
		
		var a = {a:1, b:2};
		var e = {a:1, b:3};
		shouldFail(compare.bind(e, a));
		
		var a = {a:1, b:2};
		var e = {a:1, b:'2'};
		shouldFail(compare.bind(e, a));
	}
	
	function testArrayOfObjects() {
		var a = [{a:1, b:2}];
		var e = [{a:1, b:2}];
		shouldSucceed(compare.bind(e, a));
		
		var a = [{a:1, b:2}];
		var e = [{a:1, c:2}];
		shouldFail(compare.bind(e, a));
		
		var a = [{a:1, b:2}];
		var e = [{a:1, b:3}];
		shouldFail(compare.bind(e, a));
	}
	
	function testArray() {
		var a = [0.1];
		var e = [0.1];
		shouldSucceed(compare.bind(e, a));
		
		var a = [0.1];
		var e = [1.1];
		shouldFail(compare.bind(e, a));
		
		var a = [0.1, 0.2];
		var e = [0.1, 0.2, 0.3];
		shouldFail(compare.bind(e, a));
	}
	
	function testFloat() {
		var a = 0.1;
		var e = 0.1;
		shouldSucceed(compare.bind(e, a));
		
		var a = 0.1;
		var e = 1.1;
		shouldFail(compare.bind(e, a));
	}
	
	function testInt() {
		var a = 0;
		var e = 0;
		shouldSucceed(compare.bind(e, a));
		
		var a = 0;
		var e = 1;
		shouldFail(compare.bind(e, a));
	}
	
	function testString() {
		var a = 'actual';
		var e = 'actual';
		shouldSucceed(compare.bind(e, a));
		
		var a = 'actual';
		var e = 'expected';
		shouldFail(compare.bind(e, a));
	}
	
	function testDate() {
		var a = new Date(2016, 1, 1, 1, 1, 1);
		var e = new Date(2016, 1, 1, 1, 1, 1);
		shouldSucceed(compare.bind(e, a));
		
		var a = new Date(2016, 1, 1, 1, 1, 2);
		var e = new Date(2016, 1, 1, 1, 1, 1);
		shouldFail(compare.bind(e, a));
	}
	
	function shouldSucceed(f:Void->Void) {
		try {
			f();
			assertTrue(true);
		} catch(e:Dynamic) {
			assertTrue(false);
		}
	}
	function shouldFail(f:Void->Void) {
		try {
			f();
			assertTrue(false);
		} catch(e:Dynamic) {
			assertTrue(true);
		}
	}
}