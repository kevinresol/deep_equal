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
	public function check(other:Dynamic, compare:Dynamic->Dynamic->Result) {
		if(!Reflect.isEnumValue(other)) return return Failure({message: 'Expected $other to be an enum', path: []});
		var oenm = Type.getEnum(other);
		if(enm != oenm) return Failure({message: 'Expected enum of ${Type.getEnumName(enm)} but got $other', path: []});
		switch compare(name, (other:EnumValue).getName()) {
			case Failure(f): return Failure({message: 'Expected enum named $name but got $other', path: []});
			default:
		}
		if(params != null) switch compare(params, (other:EnumValue).getParameters()) {
			case Failure(f): return Failure({message: 'Unmatched enum parameters in $other', path: []});
			default:
		}
		return Success(Noise);
	}
	@:keep
	public function toString()
		return 'EnumByName($enm, $name, $params)';
}
