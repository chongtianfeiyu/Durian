/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class defaultViewUI extends View {
		protected var uiXML:XML =
			<View>
			  <Button label="login" skin="png.component.button" x="550" y="309"/>
			  <TextInput skin="png.component.textinput" x="416" y="309"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}