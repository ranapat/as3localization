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
		
		public static function getClassName(instance:Object):String {
			return getQualifiedClassName(instance);
		}
		
		public static function getClass(instance:Object):Class {
			return getDefinitionByName(Tools.getClassName(instance)) as Class;
		}
	}

}