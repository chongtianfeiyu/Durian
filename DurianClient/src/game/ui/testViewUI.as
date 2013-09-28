/**Created by Morn,Do not modify.*/
package game.ui {
	import morn.core.components.*;
	public class testViewUI extends View {
		protected var uiXML:XML =
			<View>
			  <Image url="png.component.bg" x="14" y="5"/>
			  <Image url="png.component.blank" x="145" y="22"/>
			  <Button skin="png.component.btn_close" x="143" y="45"/>
			  <Button label="label" skin="png.component.button" x="137" y="88"/>
			  <CheckBox label="label" skin="png.component.checkbox" x="225" y="29"/>
			  <Clip url="png.component.clip_num" x="54" y="140" clipWidth="24" clipHeight="27" clipX="9" clipY="0" frame="2" interval="200" autoPlay="true"/>
			  <ComboBox labels="label1,label2" skin="png.component.combobox" x="143" y="135"/>
			  <HScrollBar skin="png.component.hscroll" x="35" y="204"/>
			  <HSlider skin="png.component.hslider" x="155" y="212"/>
			  <Label text="label" x="34" y="255"/>
			  <LinkButton label="label" x="138" y="257"/>
			  <ProgressBar skin="png.component.progress" x="35" y="298"/>
			  <RadioButton label="label" skin="png.component.radio" x="125" y="326"/>
			  <RadioGroup labels="label1,label2" skin="png.component.radiogroup" x="46" y="372"/>
			  <Tab labels="label1,label2" skin="png.component.tab" x="22" y="416"/>
			  <TextArea text="TextArea" skin="png.component.textarea" x="340" y="135"/>
			  <TextInput text="TextInput" skin="png.component.textinput" x="271" y="75"/>
			  <VScrollBar skin="png.component.vscroll" x="285" y="180"/>
			</View>;
		override protected function createChildren():void {
			createView(uiXML);
		}
	}
}