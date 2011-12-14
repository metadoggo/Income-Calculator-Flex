package uk.co.huydinh.app.incomecalculator.views
{
	import mx.containers.ViewStack;
	import mx.events.PropertyChangeEvent;
	
	import org.spicefactory.parsley.dsl.view.Configure;
	
	import spark.components.supportClasses.SkinnableComponent;
	
	import uk.co.huydinh.app.incomecalculator.components.IncomeResultPanel;
	import uk.co.huydinh.app.incomecalculator.models.IncomeResult;
	import uk.co.huydinh.app.incomecalculator.models.SalaryInformationModel;
	
	public class SalaryInformationView extends SkinnableComponent
	{
		
		[Inject]
		[Bindable]
		public var model:SalaryInformationModel;
		
		[SkinPart(required="true")]
		public var stack:ViewStack;
		
		public function SalaryInformationView()
		{
			super();
			Configure.view(this).execute();
		}
		
		[Init]
		public function init():void
		{
			model.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE, handlePropertyChange);
		}
		
		protected function handlePropertyChange(event:PropertyChangeEvent):void
		{
			switch (event.property) {
				case "results":
					stack.removeAllElements();
					for each (var result:IncomeResult in model.results) {
						var panel:IncomeResultPanel = new IncomeResultPanel();
						panel.label = result.label;
						panel.dataProvider = result.data;
						
						stack.addElement(panel);
					}
					stack.selectedIndex = model.selectedIndex;
					break;
			}
		}
	}
}