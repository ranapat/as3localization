package org.ranapat.localization {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;

	[Event(name = "complete", type = "org.ranapat.localization.DataLoaderEvent")]
	[Event(name = "failed", type = "org.ranapat.localization.DataLoaderEvent")]
	internal class DataLoader extends EventDispatcher {
		private var _loader:URLLoader;
		private var _embeddedLanguages:EmbeddedLanguages;
		private var _factory:EmbeddedLanguageFactory;
		
		public function DataLoader(factory:EmbeddedLanguageFactory) {
			this._factory = factory;
		}
		
		public function load(url:String):void {
			this.initializeLoader();
			this._loader.load(new URLRequest(url));
		}
		
		public function embedded(language:String):void {
			this.initializeEmbeddedLanguages();
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.COMPLETE, this._embeddedLanguages.getJSONString(language)));
		}
		
		public function destroy():void {
			this.removeLoader();
			this.removeEmbeddedLanguages();
			
			this._factory = null;
		}
		
		private function initializeEmbeddedLanguages():void {
			this.removeEmbeddedLanguages();
			
			this._embeddedLanguages = new EmbeddedLanguages(this._factory);
		}
		
		private function removeEmbeddedLanguages():void {
			if (this._embeddedLanguages) {
				this._embeddedLanguages = null;
			}
		}
		
		private function initializeLoader():void {
			this.removeLoader();
			
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.TEXT;
			this._loader.addEventListener(Event.COMPLETE, this.handleLoaderComplete, false, 0, true);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleLoaderIOError, false, 0, true);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleLoaderSecurityError, false, 0, true);
		}
		
		private function removeLoader():void {
			if (this._loader) {
				this._loader.removeEventListener(Event.COMPLETE, this.handleLoaderComplete);
				this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.handleLoaderIOError);
				this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleLoaderSecurityError);
				this._loader.close();
				this._loader = null;
			}
		}
		
		private function handleLoaderComplete(e:Event):void {
			this.removeLoader();
			
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.COMPLETE, String(e.target.data)));
		}
		
		private function handleLoaderIOError(e:IOErrorEvent):void {
			this.removeLoader();
			
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.FAILED));
		}
		
		private function handleLoaderSecurityError(e:SecurityErrorEvent):void {
			this.removeLoader();
			
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.FAILED));
		}
		
	}

}