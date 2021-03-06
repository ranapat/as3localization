package org.ranapat.localization {
	//import com.adobe.serialization.json.JSON;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.SimpleButton;
	import flash.events.EventDispatcher;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Dictionary;
	
	[Event(name = "initialized", type = "org.ranapat.localization.LanguageChangedEvent")]
	[Event(name = "requested", type = "org.ranapat.localization.LanguageChangedEvent")]
	[Event(name = "changed", type = "org.ranapat.localization.LanguageChangedEvent")]
	[Event(name = "skipped", type = "org.ranapat.localization.LanguageChangedEvent")]
	[Event(name = "failed", type = "org.ranapat.localization.LanguageChangedEvent")]
	public final class Localization extends EventDispatcher {
		private static var _allowInstance:Boolean;
		private static var _instance:Localization;
		
		public static function construct(supportedLanguages:SupportedLanguages, factory:EmbeddedLanguageFactory):void {
			if (!Localization._instance) {
				Localization._allowInstance = true;
				Localization._instance = new Localization(supportedLanguages, factory);
				Localization._allowInstance = false;
			}
		}
		
		public static function get instance():Localization {
			return Localization._instance;
		}
		
		private var _language:String;
		private var _dataLoader:DataLoader;
		private var _factory:EmbeddedLanguageFactory;
		private var _supportedLanguage:SupportedLanguage;
		private var _supportedLanguages:SupportedLanguages;
		private var _languageEverSet:Boolean;
		private var _collectMode:Boolean;
		private var _collected:Object;
		private var _autoTranslateDictionary:Dictionary;
		private var _supportedCharactersRegExp:RegExp;
		private var _defaultFontKeeperDictionary:Dictionary;
		private var _triggers:Triggers;
		private var _initialFitTextProperties:Dictionary;
		
		public function Localization(supportedLanguages:SupportedLanguages, factory:EmbeddedLanguageFactory) {
			if (Localization._allowInstance) {
				this._supportedLanguages = supportedLanguages;
				this._factory = factory;
				
				this._dataLoader = new DataLoader(this._factory);
				this._dataLoader.addEventListener(DataLoaderEvent.COMPLETE, this.handleDataLoaderComplete, false, 0, true);
				this._dataLoader.addEventListener(DataLoaderEvent.FAILED, this.handleDataLoaderFailed, false, 0, true);
				
				this._autoTranslateDictionary = new Dictionary(true);
				this._defaultFontKeeperDictionary = new Dictionary(true);
				
				this._triggers = new Triggers();
				
				this._initialFitTextProperties = new Dictionary(true);
				
				this.addEventListener(LanguageChangedEvent.CHANGED, this.handleSelfChanged, false, 0, true);
			} else {
				throw new Error("Use Localization::instance getter instead");
			}
		}
		
		public function destroy():void {
			this._dataLoader.removeEventListener(DataLoaderEvent.COMPLETE, this.handleDataLoaderComplete);
			this._dataLoader.removeEventListener(DataLoaderEvent.FAILED, this.handleDataLoaderFailed);
			this._dataLoader.destroy();
			this._dataLoader = null;
			
			this._factory = null;
			this._supportedLanguage = null;
			this._supportedLanguages = null;
			
			this.removeEventListener(LanguageChangedEvent.CHANGED, this.handleSelfChanged);
			this._autoTranslateDictionary = null;
			
			this._defaultFontKeeperDictionary = null;
			this._supportedCharactersRegExp = null;
			this._triggers = null;
			this._initialFitTextProperties = null;
		}
		
		public function set language(value:String):void {
			var validated:String = this._supportedLanguages.validate(value);
			
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
			return JSON.stringify(this._collected);
		}
		
		public function set supportedCharactersRegExp(value:RegExp):void {
			this._supportedCharactersRegExp = value;
		}
		
		public function get supportedCharactersRegExp():RegExp {
			return this._supportedCharactersRegExp;
		}
		
		public function set triggers(value:Triggers):void {
			this._triggers = value;
		}
		
		public function get triggers():Triggers {
			return this._triggers;
		}
		
		public function hash(hash:String, bundle:* = null):String {
			if (bundle) {
				if (bundle is String) {
					return hash + Settings.KEY_BUNDLE_DELIMITER + bundle;
				} else {
					return hash + Settings.KEY_BUNDLE_DELIMITER + Tools.getClassName(bundle);
				}
			} else {
				return hash;
			}
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
		
		public function getRaw(key:String, bundle:String = null, _default:String = null):* {
			var missing:String = _default? _default : ("??" + key + "??");
			var result:* = this._supportedLanguage? this._supportedLanguage.getRaw(key, bundle) : missing;
			result = this._supportedLanguage && this._supportedLanguage.latestGetSuccess? result : missing;
			return result;
		}
		
		public function get(hash:String, _default:String = null):String {
			var parts:Array = hash.split(Settings.KEY_BUNDLE_DELIMITER);
			return this.translate(parts.shift(), parts.join(Settings.BUNDLE_BUNDLE_DELIMITER), _default);
		}
		
		public function spritf(hash:String, ...args):String {
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
		
		public function string(hash:String, replacements:* = null):String {
			var result:String = this.get(hash).replace(/\n/g, "($n)");
			var replacementsString:String = ["number", "string"].indexOf(typeof(replacements)) >= 0? replacements : null;
			var replacementsObject:Object = replacementsString? null : replacements;
			
			if (replacementsString || replacementsObject) {
				var doBreak:Boolean;
				var regexp:RegExp;
				var index:uint;
				var replace:String;
				var results:Array;
				var searchGroups:Vector.<RegExp> = Settings.SEARCH_NAMED_GROUP_PATTERNS;
				var indexGroups:Vector.<uint> = Settings.SEARCH_NAMED_GROUP_INDEXES;
				var replaceGroups:Vector.<String> = Settings.REPLACE_NAMED_GROUP_PATTERNS;
				var length:uint = searchGroups.length;
				for (var i:uint = 0; i < length && !doBreak; ++i) {
					regexp = searchGroups[i];
					index = indexGroups[i];
					replace = replaceGroups[i];
					
					while ((results = result.match(regexp)) != null) {
						if (results.length > index) {
							if (replacementsString) {
								result = result.replace(regexp, replace.replace("($0)", replacementsString));
								
								doBreak = true;
								break;
							} else {
								var found:Boolean = false;
								for (var key:Object in replacementsObject) {
									if (results[index] == key) {
										result = result.replace(regexp, replace.replace("($0)", replacementsObject[key]));
										
										found = true;
										break;
									}
								}
								
								if (!found) {
									result = result.replace(regexp, replace.replace("($0)", "$" + index));
								}
							}
						}
					}
				}
			}
			
			return result.replace(/\(\$n\)/g, "\n");
		}
		
		public function supply(hash:String, bundle:* = null, replacements:* = null):String {
			return this.string(this.hash(hash, bundle), replacements);
		}
		
		public function apply(target:DisplayObject, replacements:* = null):void {
			if (target) {
				var name:String = target.name;
				if (target.parent) {
					name += Settings.KEY_BUNDLE_DELIMITER + Tools.getClassName(target.parent);
				}
				
				this.fillDisplayObject(target, this.string(name, replacements));
			}
		}
		
		public function applyToDisplayObject(target:DisplayObject, text:String):void {
			this.fillDisplayObject(target, text);
		}
		
		public function applyToSimpleButton(target:SimpleButton, text:*):void {
			this.fillSimpleButton(target, text);
		}
		
		public function applyToDisplayObjectContainer(object:DisplayObjectContainer, bundleObject:* = null):void {
			bundleObject = bundleObject? bundleObject : object;
			
			var length:uint = object.numChildren;
			var tmp:DisplayObject;
			for (var i:uint = 0; i < length; ++i) {
				tmp = object.getChildAt(i);
				
				if (this.checkDisplayObjectForApplyTranslation(tmp)) {
					this.fillDisplayObject(tmp, this.translate(tmp.name, Tools.getClassName(bundleObject)));
				}
			}
		}
		
		public function autoApplyToDisplayObjectContainer(object:DisplayObjectContainer, callback:Function = null):void {
			this._autoTranslateDictionary[object] = callback != null? callback : 1;
		}
		
		public function fitTextWithinTextField(object:TextField):void {
			if (!this._initialFitTextProperties[object]) {
				this._initialFitTextProperties[object] = new TextFieldProperties(object.y, object.height, object.textHeight);
			}
			var initialFitTextProperties:TextFieldProperties = this._initialFitTextProperties[object] as TextFieldProperties;
			
			var textFormat:TextFormat = object.getTextFormat();
			var size:uint = uint(textFormat.size? textFormat.size : 12);
			var initialTextWidth:Number = object.textWidth;
			var initialTextHeight:Number = object.textHeight;
			
			//var previousTextWidth:Number = object.textWidth;
			//var previousTextHeight:Number = object.textHeight;
			
			var guess:Number = Math.max(1, Math.max(object.textWidth / object.width, object.textHeight / object.height));
			var guessedSize:uint = Math.max(1, Math.floor(size / guess));
			
			/*
			while (
				object.textWidth - object.width > -1 * Settings.MINIMUM_WIDTH_DELTA_FOR_TEXT_FIT
				|| object.textHeight - object.height > -1 * Settings.MINIMUM_HEIGHT_DELTA_FOR_TEXT_FIT
			) {
				--size;
				textFormat.size = size;
				object.setTextFormat(textFormat);
				
				if (object.textWidth == previousTextWidth && object.textHeight == previousTextHeight) {
					break;
				} else {
					previousTextWidth = object.textWidth;
					previousTextHeight = object.textHeight;
				}
			}
			*/
			
			textFormat.size = guessedSize;
			object.setTextFormat(textFormat);
			
			if (!object.multiline) {
				object.y = initialFitTextProperties.y + ((object.height - object.textHeight) - initialFitTextProperties.offset) / 2;
			}
		}
		
		public function centerVerticallyMultilineTexts(object:TextField):void {
			if (object.multiline) {
				object.y += (object.height - object.textHeight) >> 1;
			}
		}
		
		public function charactersSupported(string:String):Boolean {
			if (this._supportedCharactersRegExp) {
				this._supportedCharactersRegExp.lastIndex = 0;
				return this._supportedCharactersRegExp.test(string);
			} else {
				return true;
			}
		}
		
		public function adjustTextFieldFont(object:TextField, replacementFont:String = "Arial", defaultFont:String = null):void {
			var textFormat:TextFormat;
			
			if (!this.charactersSupported(object.text)) {
				textFormat = object.getTextFormat();
				this._defaultFontKeeperDictionary[object] = textFormat.font;
				textFormat.font = replacementFont;
				
				object.embedFonts = false;
				object.setTextFormat(textFormat);
				object.antiAliasType = AntiAliasType.ADVANCED;
			} else {
				defaultFont = defaultFont? defaultFont : this._defaultFontKeeperDictionary[object];
				
				if (defaultFont) {
					textFormat = object.getTextFormat();
					textFormat.font = defaultFont;
					
					object.embedFonts = true;
					object.setTextFormat(textFormat);
					object.antiAliasType = AntiAliasType.ADVANCED;
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
		
		private function fillDisplayObject(object:DisplayObject, text:String):void {
			if (object is TextField) {
				this.fillTextField(object as TextField, text);
			} else if (object is SimpleButton) {
				this.fillSimpleButton(object as SimpleButton, text);
			}
		}
		
		private function fillTextField(object:TextField, text:String):void {
			object.text = text;
				
			this.processTriggers(object);
		}
		
		private function fillSimpleButton(object:SimpleButton, text:*):void {
			var stateContainer:DisplayObjectContainer;
			var length:uint;
			var i:uint;
			var index:uint;
			
			stateContainer = object.upState as DisplayObjectContainer;
			length = stateContainer.numChildren;
			index = 0;
			for (i = 0; i < length; ++i) {
				if (stateContainer.getChildAt(i) is TextField) {
					(stateContainer.getChildAt(i) as TextField).text = this.getTextFromAny(text, index++);
					this.processTriggers(stateContainer.getChildAt(i));
				}
			}
			stateContainer = object.downState as DisplayObjectContainer;
			length = stateContainer.numChildren;
			index = 0;
			for (i = 0; i < length; ++i) {
				if (stateContainer.getChildAt(i) is TextField) {
					(stateContainer.getChildAt(i) as TextField).text = this.getTextFromAny(text, index++);
					this.processTriggers(stateContainer.getChildAt(i));
				}
			}
			stateContainer = object.overState as DisplayObjectContainer;
			length = stateContainer.numChildren;
			index = 0;
			for (i = 0; i < length; ++i) {
				if (stateContainer.getChildAt(i) is TextField) {
					(stateContainer.getChildAt(i) as TextField).text = this.getTextFromAny(text, index++);
					this.processTriggers(stateContainer.getChildAt(i));
				}
			}
		}
		
		private function processTriggers(object:DisplayObject):void {
			if (object is TextField) {
				var textField:TextField = object as TextField;
				
				if (triggers.adjustTextFieldFont) {
					this.adjustTextFieldFont(textField, this.triggers.replacementFont);
				}
				if (this.triggers.fitTextWithinTextField) {
					this.fitTextWithinTextField(textField);
				}
				if (this.triggers.centerVerticallyMultilineTexts) {
					this.centerVerticallyMultilineTexts(textField);
				}
			}
		}
		
		private function getTextFromAny(text:*, index:uint):String {
			if (text is String) {
				return text;
			} else if (text is Array) {
				var vectorString:Array = text as Array;
				if (vectorString.length > index) {
					return vectorString[index];
				} else {
					return vectorString[0];
				}
			} else {
				return text;
			}
		}
		
		private function handleDataLoaderComplete(e:DataLoaderEvent):void {
			var isChanged:Boolean = this._languageEverSet;
			
			this._supportedLanguage = new SupportedLanguage(e.result);
			this._languageEverSet = true;
			
			if (isChanged) {
				this.dispatchEvent(new LanguageChangedEvent(LanguageChangedEvent.CHANGED, this.language));
			} else {
				this.dispatchEvent(new LanguageChangedEvent(LanguageChangedEvent.INITIALIZED, this.language));
			}			
		}
		
		private function handleDataLoaderFailed(e:DataLoaderEvent):void {
			this.dispatchEvent(new LanguageChangedEvent(LanguageChangedEvent.FAILED, this.language));
		}
		
		private function handleSelfChanged(e:LanguageChangedEvent):void {
			for (var i:Object in this._autoTranslateDictionary) {
				try {
					this.applyToDisplayObjectContainer(i as DisplayObjectContainer);
					if (this._autoTranslateDictionary[i] is Function) {
						(this._autoTranslateDictionary[i] as Function).apply();
					}
				} catch (e:Error) { /**/ }
			}
		}
	}

}