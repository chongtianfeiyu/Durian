/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class defaultViewUI extends View {
		public var loginBtn:Button;
		public var txtLoginUser:TextInput;
		public var regBtn:Button;
		public var txtLoginPass:TextInput;
		public var txtRegUser:TextInput;
		public var txtRegPass:TextInput;
		public var txtRegPassConfirm:TextInput;
		public var txtRegEmail:TextInput;
		protected var uiXML:XML =
			<View>
			  <Image url="png.component.blank" x="89" y="188" width="761" height="254"/>
			  <Button label="login" skin="png.component.button" x="338" y="247" var="loginBtn" name="loginBtn"/>
			  <TextInput skin="png.component.textinput" x="199" y="247" var="txtLoginUser" name="txtLoginUser"/>
			  <Button label="register" skin="png.component.button" x="686" y="247" var="regBtn" name="regBtn"/>
			  <TextInput skin="png.component.textinput" x="199" y="279" var="txtLoginPass" name="txtLoginPass"/>
			  <TextInput skin="png.component.textinput" x="547" y="247" var="txtRegUser" name="txtRegUser"/>
			  <TextInput skin="png.component.textinput" x="547" y="279" var="txtRegPass" name="txtRegPass"/>
			  <TextInput skin="png.component.textinput" x="547" y="311" var="txtRegPassConfirm" name="txtRegPassConfirm"/>
			  <TextInput skin="png.component.textinput" x="547" y="343" var="txtRegEmail" name="txtRegEmail"/>
			  <Label text="username" x="129" y="250"/>
			  <Label text="password" x="131" y="278"/>
			  <Label text="username" x="476" y="251"/>
			  <Label text="email" x="502" y="344"/>
			  <Label text="confirm password" x="434" y="313"/>
			  <Label text="password" x="478" y="282"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}