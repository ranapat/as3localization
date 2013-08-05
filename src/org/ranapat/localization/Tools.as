package org.ranapat.localization {
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	
	internal class Tools {
		
		public static function ensureAbstractClass(instance:Object, _class:Class):void {
			var className:String = getQualifiedClassName(instance);
			if (getDefinitionByName(className) == _class) {
				throw new Error(getQualifiedClassName(_class) + " Class can not be instantiated directly.");
			}
		}
	}

}