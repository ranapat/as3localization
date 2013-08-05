package org.ranapat.localization.examples 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import org.ranapat.localization.Localization;
	/**
	 * ...
	 * @author ranapat
	 */
	public class ExampleClass extends Sprite
	{
		
		public var test:String = "123";
		public var bbb:TextField;
		
		public function ExampleClass() 
		{
			addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			
			
			bbb = new TextField();
			bbb.text = "1111";
			bbb.name = "_justSomeTestNotWorkingTxt"
			bbb.width = 500;
			bbb.y = 200;
			addChild(bbb);
			
			Localization.instance.applyToDisplayObjectContainer(this);
		}
		
	}

}