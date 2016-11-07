package deepequal.custom;

import deepequal.Outcome;
import deepequal.Noise;

/**
	Checks if target is an enum specified by a string name
**/
class EnumByName implements deepequal.CustomCompare {
	
	var enm:Enum<Dynamic>; 
	var name:Dynamic;
	var params:Dynamic;
	public function new(enm:Enum<Dynamic>, name:Dynamic, ?params:Dynamic) {
		this.enm = enm;
		this.name = name;
		this.params = params;
	}
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Outcome<Noise, Error>) {
		var oenm = Type.getEnum(other);
		if(enm != oenm) return Failure(new Error('Expected enum of ${Type.getEnumName(enm)} but got $other'));
		switch compare(name, (other:EnumValue).getName()) {
			case Failure(f): return Failure(Error.withData('Expected enum named $name but got $other', f));
			default:
		}
		if(params != null) switch compare(params, (other:EnumValue).getParameters()) {
			case Failure(f): return Failure(Error.withData('Unmatched enum parameters in $other', f));
			default:
		}
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'EnumByName($enm, $name, $params)';
}
