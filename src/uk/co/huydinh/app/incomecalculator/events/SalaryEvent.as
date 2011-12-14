package uk.co.huydinh.app.incomecalculator.events
{
	import flash.events.Event;
	
	import uk.co.huydinh.app.incomecalculator.models.SalaryFormModel;
	
	public class SalaryEvent extends Event
	{
		
		public static const CALCULATE:String = "calculate";
		
		public var formModel:SalaryFormModel;
		
		public function SalaryEvent(type:String, formModel:SalaryFormModel, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.formModel = formModel;
		}
		
		override public function clone():Event
		{
			return new SalaryEvent(type, formModel, bubbles, cancelable);
		}
		
		override public function toString():String
		{
			return formatToString("SalaryEvent", "type", "formModel", "bubbles", "cancelable");
		}
	}
}