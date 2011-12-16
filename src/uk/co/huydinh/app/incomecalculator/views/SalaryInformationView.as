package uk.co.huydinh.app.incomecalculator.views
{
	import mx.core.IVisualElement;
	import mx.events.CloseEvent;
	import mx.events.PropertyChangeEvent;
	
	import org.spicefactory.parsley.dsl.view.Configure;
	
	import spark.components.Group;
	import spark.components.supportClasses.SkinnableComponent;
	
	import uk.co.huydinh.app.incomecalculator.components.IncomeResultWindow;
	import uk.co.huydinh.app.incomecalculator.models.SalaryInformationModel;
	
	public class SalaryInformationView extends SkinnableComponent
	{
		
		[Inject]
		[Bindable]
		public var model:SalaryInformationModel;
		
		[SkinPart(required="true")]
		public var content:Group;
		
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
					var window:IncomeResultWindow = new IncomeResultWindow();
					window.results = model.results;
					window.selectedIndex = model.selectedIndex;
					window.addEventListener(CloseEvent.CLOSE, handleWindowCloseClick);
					content.addElement(window);
					break;
			}
		}
		
		protected function handleWindowCloseClick(event:CloseEvent):void
		{
			content.removeElement(event.target as IVisualElement);
		}
	}
}