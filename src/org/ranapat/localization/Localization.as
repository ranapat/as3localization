package org.ranapat.localization {
	import com.adobe.serialization.json.JSON;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;
	
	[Event(name = "initialized", type = "org.ranapat.localization.LanguageChangedEvent")]
	[Event(name = "requested", type = "org.ranapat.localization.LanguageChangedEvent")]
	[Event(name = "changed", type = "org.ranapat.localization.LanguageChangedEvent")]
	[Event(name = "skipped", type = "org.ranapat.localization.LanguageChangedEvent")]
	[Event(name = "failed", type = "org.ranapat.localization.LanguageChangedEvent")]
	public class Localization extends EventDispatcher {
		private static var _allowInstance:Boolean;
		private static var _instance:Localization;
		
		public static function get instance():Localization {
			if (!Localization._instance) {
				Localization._allowInstance = true;
				Localization._instance = new Localization();
				Localization._allowInstance = false;
			}
			return Localization._instance;
		}
		
		private var _language:String;
		private var _dataLoader:DataLoader;
		private var _supportedLanguage:SupportedLanguage;
		private var _collectMode:Boolean;
		private var _collected:Object;
		
		public function Localization() {
			if (Localization._allowInstance) {
				this._dataLoader = new DataLoader();
				this._dataLoader.addEventListener(DataLoaderEvent.COMPLETE, this.handleDataLoaderComplete, false, 0, true);
				this._dataLoader.addEventListener(DataLoaderEvent.FAILED, this.handleDataLoaderFailed, false, 0, true);
			} else {
				throw new Error("Use Localization::instance getter instead");
			}
		}
		
		public function destroy():void {
			this._dataLoader.removeEventListener(DataLoaderEvent.COMPLETE, this.handleDataLoaderComplete);
			this._dataLoader.removeEventListener(DataLoaderEvent.FAILED, this.handleDataLoaderFailed);
			this._dataLoader.destroy();
			this._dataLoader = null;
		}
		
		public function set language(value:String):void {
			var validated:String = SupportedLanguages.validate(value);
			
			if (validated != this._language) {
				this._language = validated;
				this._supportedLanguage = null;
				
				this.dispatchEvent(new LanguageChangedEvent(LanguageChangedEvent.REQUESTED, this.language));
				
				if (Settings.EMBED_MODE) {
					this._dataLoader.embedded(validated);
				} else {
					this._dataLoader.load(Settings.PATH + validated + Settings.EXTENSION);
				}
			} else {
				this.dispatchEvent(new LanguageChangedEvent(LanguageChangedEvent.SKIPPED, this.language));
			}
		}
		
		public function get language():String {
			return this._language;
		}
		
		public function set collectMode(value:Boolean):void {
			if (value != this._collectMode) {
				this._collected = { };
			}
			
			this._collectMode = value;
		}
		
		public function get collectMode():Boolean {
			return this._collectMode;
		}
		
		public function get collected():String {
			return JSON.encode(this._collected);
		}
		
		public function translate(key:String, bundle:String = null, _default:String = null):String {
			var missing:String = _default? _default : ("??" + key + "??");
			var result:String = this._supportedLanguage? this._supportedLanguage.get(key, bundle) : missing;
			result = this._supportedLanguage && this._supportedLanguage.latestGetSuccess? result : missing;
			if (this.collectMode) {
				missing = _default? _default : Settings.MISSING_TRANSLATION_STRING;
				if (bundle) {
					if (!this._collected[bundle]) {
						this._collected[bundle] = { };
					}
					this._collected[bundle][key] = this._supportedLanguage && this._supportedLanguage.latestGetSuccess? result : missing;
				} else {
					this._collected[key] = this._supportedLanguage && this._supportedLanguage.latestGetSuccess? result : missing;
				}
			}
			return result;
		}
		
		public function get(hash:String, _default:String = null):String {
			var parts:Array = hash.split(Settings.KEY_BUNDLE_DELIMITER);
			return this.translate(parts.shift(), parts.join(Settings.BUNDLE_BUNDLE_DELIMITER), _default);
		}
		
		public function string(hash:String, ...args):String {
			trace("@@@@@@@@@@@@ " + args.length)
			
			var result:String = this.get(hash);
			
			var regexp:RegExp = /%([d|f|s])/;
			while (regexp.test(result) && args.length > 0) {
				var type:String = result.match(regexp)[1];
				var value:String = args.shift();
				
				var properValue:*;
				if (type == "s") {
					properValue = value;
				} else if (type == "d") {
					properValue = int(value);
				} else if (type == "f") {
					properValue = Number(value).toString();
				}
				
				result = result.replace(regexp, properValue);
			}
			
			return result;
		}
		
		public function applyToDisplayObjectContainer(object:DisplayObjectContainer):void {
			var length:uint = object.numChildren;
			var tmp:DisplayObject;
			for (var i:uint = 0; i < length; ++i) {
				tmp = object.getChildAt(i);
				
				if (this.checkDisplayObjectForApplyTranslation(tmp)) {
					this.translateDisplayObject(tmp, object);
				}
			}
		}
		
		private function checkDisplayObjectForApplyTranslation(tmp:DisplayObject):Boolean {
			var j:uint;
			var typePass:Boolean = false;
			var types:Vector.<Class> = Settings.DISPLAY_OBJECT_TYPES_TO_TRANSLATE;
			var typesLength:uint = types.length;
			for (j = 0; j < typesLength && !typePass; ++j) {
				typePass = tmp is types[j];
			}
			
			if (typePass) {
				var namePass:Boolean = false;
				var names:Vector.<RegExp> = Settings.DISPLAY_OBJECT_NAMES_TO_TRANSLATE;
				var namesLength:uint = names.length;
				for (j = 0; j < namesLength && !namePass; ++j) {
					namePass = names[j].test(tmp.name);
				}
				
				if (namePass) {
					return true;
				}
			}
			
			return false;
		}
		
		private function translateDisplayObject(object:DisplayObject, container:DisplayObjectContainer):void {
			if (object is TextField) {
				var tmp:TextField = object as TextField;
				tmp.text = this.translate(tmp.name, Tools.getClassName(container));
			}
		}
		
		private function handleDataLoaderComplete(e:DataLoaderEvent):void {
			var isChanged:Boolean = this._supportedLanguage != null;
			
			this._supportedLanguage = new SupportedLanguage(e.result);
			
			if (isChanged) {
				this.dispatchEvent(new LanguageChangedEvent(LanguageChangedEvent.CHANGED, this.language));
			} else {
				this.dispatchEvent(new LanguageChangedEvent(LanguageChangedEvent.INITIALIZED, this.language));
			}			
		}
		
		private function handleDataLoaderFailed(e:DataLoaderEvent):void {
			this.dispatchEvent(new LanguageChangedEvent(LanguageChangedEvent.FAILED, this.language));
		}
	}

}