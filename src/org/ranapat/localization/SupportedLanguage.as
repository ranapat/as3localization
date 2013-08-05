package org.ranapat.localization {
	import com.adobe.serialization.json.JSON;
	
	internal class SupportedLanguage {
		
		public var data:Object;
		
		public function SupportedLanguage(data:String) {
			try { this.data = JSON.decode(data); } catch (e:Error) { /**/ }
		}
		
		public function get(key:String, bundle:String = null):String {
			if (this.data) {
				if (bundle) {
					var items:Array = bundle.split(Settings.BUNDLE_DELIMITER);
					var tmp:Object = this.data;
					
					try {
						var length:uint = items.length;
						for (var i:uint = 0; i < length; ++i) {
							tmp = tmp[items[i]];
						}
						
						return tmp[key]? tmp[key] : ("!!" + bundle + "." + key + "!!");
					} catch (e:Error) {
						return "!!" + bundle + "." + key + "!!";
					}
				} else {
					try { return this.data[key]? this.data[key] : ("!!" + key + "!!"); } catch (e:Error) { return "!!" + key + "!!"; }
				}
			} else {
				return "!!" + key + "!!";
			}
			return "";
		}
		
	}

}