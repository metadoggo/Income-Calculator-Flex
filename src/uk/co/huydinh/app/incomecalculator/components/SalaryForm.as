package uk.co.huydinh.app.incomecalculator.components
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayList;
	import mx.controls.Text;
	import mx.events.FlexEvent;
	import mx.validators.CurrencyValidator;
	import mx.validators.NumberValidator;
	import mx.validators.Validator;
	
	import org.spicefactory.parsley.dsl.view.Configure;
	
	import spark.components.Button;
	import spark.components.CheckBox;
	import spark.components.DropDownList;
	import spark.components.TextInput;
	import spark.components.supportClasses.SkinnableComponent;
	import spark.components.supportClasses.TextBase;
	
	import uk.co.huydinh.app.incomecalculator.models.SalaryFormModel;
	
	[Event(name="calculate", type="uk.co.huydinh.app.incomecalculator.components.salaryform.events.SalaryEvent")]
	
	public class SalaryForm extends SkinnableComponent
	{
		[Inject]
		[Bindable]
		public var model:SalaryFormModel;
		
		[SkinPart]
		public var termField:DropDownList;
		
		[SkinPart]
		public var amountField:TextInput;
		
		[SkinPart]
		public var hoursPerDayField:TextInput;
		
		[SkinPart]
		public var daysPerWeekField:TextInput;
		
		[SkinPart]
		public var holidaysPerYearField:TextInput;
		
		[SkinPart]
		public var repayStudentLoanField:CheckBox;
		
		[SkinPart]
		public var submitButton:Button;
		
		[SkinPart(required="false")]
		public var termFieldLabel:TextBase;
		
		[SkinPart(required="false")]
		public var amountFieldLabel:TextBase;
		
		[SkinPart(required="false")]
		public var hoursPerDayFieldLabel:TextBase;
		
		[SkinPart(required="false")]
		public var daysPerWeekFieldLabel:TextBase;
		
		[SkinPart(required="false")]
		public var holidaysPerYearFieldLabel:TextBase;
		
		[SkinPart(required="false")]
		public var repayStudentLoanFieldLabel:TextBase;
		
		private var _termLabel:String = "Payment term";
		private var _amountLabel:String = "Amount";
		private var _hoursPerDayLabel:String = "Hours per day";
		private var _daysPerWeekLabel:String = "Days per week";
		private var _holidaysPerYearLabel:String = "Holiday (days)";
		private var _repayStudentLoanLabel:String = "Repay student loan?";
		
		private var amountValidator:CurrencyValidator;
		private var hoursPerDayValidator:NumberValidator;
		private var daysPerWeekValidator:NumberValidator;
		private var holidaysPerYearValidator:NumberValidator;
		
		public function SalaryForm()
		{
			super();
			Configure.view(this).execute();
			addEventListener(FlexEvent.INITIALIZE, initialize_handler);
		}
		
		private function initialize_handler(event:FlexEvent):void
		{
			removeEventListener(FlexEvent.INITIALIZE, initialize_handler);
			
			amountValidator = new CurrencyValidator();
			amountValidator.source = amountField;
			amountValidator.property = "text";
			amountValidator.minValue = 0;
			amountValidator.requiredFieldError="Please enter a valid amount number";
			
			hoursPerDayValidator = new NumberValidator();
			hoursPerDayValidator.source = hoursPerDayField;
			hoursPerDayValidator.property = "text";
			hoursPerDayValidator.minValue = 0;
			hoursPerDayValidator.maxValue = 24;
			hoursPerDayValidator.requiredFieldError = "Please enter a valid number";
			
			daysPerWeekValidator = new NumberValidator();
			daysPerWeekValidator.source = daysPerWeekField;
			daysPerWeekValidator.property = "text";
			daysPerWeekValidator.minValue = 0;
			daysPerWeekValidator.maxValue = 24;
			daysPerWeekValidator.requiredFieldError = "Please enter a valid number";
			
			termField.dataProvider = new ArrayList([SalaryFormModel.ANNUALLY, SalaryFormModel.MONTHLY, SalaryFormModel.WEEKLY, SalaryFormModel.DAILY, SalaryFormModel.HOURLY]);
		}
		
		override protected function partAdded(partName:String, instance:Object):void
		{
			super.partAdded(partName, instance);
			
			switch (instance) {
				case submitButton:
					submitButton.addEventListener(MouseEvent.CLICK, submitButton_clickiHandler);
			}
		}
		
		override protected function partRemoved(partName:String, instance:Object):void
		{
			super.partRemoved(partName, instance);
			
			if (instance == submitButton) {
				submitButton.removeEventListener(MouseEvent.CLICK, submitButton_clickiHandler);
			}
		}
		
		
		protected function submitButton_clickiHandler(event:MouseEvent):void
		{
			if (isNaN(holidaysPerYearField.text as Number)) {
				holidaysPerYearField.text = "0";
			}
			var validators:Array = [
				amountValidator,
				hoursPerDayValidator,
				daysPerWeekValidator
			];
			
//			if (holidaysPerYearField.text) {
//				if (!holidaysPerYearValidator) {
//					holidaysPerYearValidator = new NumberValidator();
//					holidaysPerYearValidator.source = holidaysPerYearField;
//					holidaysPerYearValidator.property = "text";
//				}
//				validators.push(holidaysPerYearValidator);
//			} else {
//				validators.splice(validators.indexOf(holidaysPerYearValidator), 1);
//			}
			
			var errors:Array = Validator.validateAll(validators);
			
			if (errors.length == 0) {
				model.term = termField.selectedItem,
				model.amount = parseFloat(amountField.text),
				model.hoursPerDay = parseFloat(hoursPerDayField.text),
				model.daysPerWeek = parseFloat(daysPerWeekField.text),
				model.holidaysPerYear = parseFloat(holidaysPerYearField.text),
				model.repayStudentLoan = repayStudentLoanField.selected
				model.submit();
			}
		}
	}
}