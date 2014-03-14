package org.ranapat.localization {
	
	internal class TextFieldProperties {
		public var y:Number;
		public var height:Number;
		public var textHeight:Number;
		
		public function TextFieldProperties(y:Number, height:Number, textHeight:Number) {
			this.y = y;
			this.height = height;
			this.textHeight = textHeight;
		}
		
		public function get offset():Number {
			return this.height - this.textHeight;
		}
		
	}

}