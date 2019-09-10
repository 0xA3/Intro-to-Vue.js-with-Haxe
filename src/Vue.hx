extern class Vue {
	static var config:Dynamic;
	function new( ?options:Dynamic );
	static function component( name:String, options:Dynamic ):Void;
	@:native("$emit") function emit( name:String, options:Dynamic ):Void;
	@:native("$on") function on( name:String, options:Dynamic ):Void;
}