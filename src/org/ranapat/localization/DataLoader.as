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
		
		public function DataLoader() {
			this._loader = new URLLoader();
			this._loader.dataFormat = URLLoaderDataFormat.TEXT;
		}
		
		public function load(url:String):void {
			this._loader.load(new URLRequest(url));
			this.addEventListeners();
		}
		
		public function destroy():void {
			this.removeEventListeners();
		}
		
		private function addEventListeners():void {
			this._loader.addEventListener(Event.COMPLETE, this.handleLoaderComplete, false, 0, true);
			this._loader.addEventListener(IOErrorEvent.IO_ERROR, this.handleLoaderIOError, false, 0, true);
			this._loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleLoaderSecurityError, false, 0, true);
		}
		
		private function removeEventListeners():void {
			this._loader.removeEventListener(Event.COMPLETE, this.handleLoaderComplete);
			this._loader.removeEventListener(IOErrorEvent.IO_ERROR, this.handleLoaderIOError);
			this._loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, this.handleLoaderSecurityError);
		}
		
		private function handleLoaderComplete(e:Event):void {
			this.removeEventListeners();
			
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.COMPLETE, String(e.target.data)));
		}
		
		private function handleLoaderIOError(e:IOErrorEvent):void {
			this.removeEventListeners();
			
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.FAILED));
		}
		
		private function handleLoaderSecurityError(e:SecurityErrorEvent):void {
			this.removeEventListeners();
			
			this.dispatchEvent(new DataLoaderEvent(DataLoaderEvent.FAILED));
		}
		
	}

}