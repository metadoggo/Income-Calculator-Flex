package uk.co.huydinh.app.incomecalculator.models
{
	import mx.collections.ArrayList;
	import mx.validators.CurrencyValidator;
	
	import uk.co.huydinh.app.incomecalculator.events.SalaryEvent;

	public class SalaryFormModel
	{
		public static const ANNUALLY:String = "Annually";
		public static const MONTHLY:String = "Monthly";
		public static const WEEKLY:String = "Weekly";
		public static const DAILY:String = "Daily";
		public static const HOURLY:String = "Hourly";
		
		public var term:String;
		public var amount:Number;
		public var hoursPerDay:Number;
		public var daysPerWeek:Number;
		private var _holidaysPerYear:Number;
		public var repayStudentLoan:Boolean;
		
		public function SalaryFormModel()
		{
		}
		
		/**
		 * The [MessageDispatcher] metadata tells Parsley to configure the 
		 * function so it can be used to send (dispatch) messages.
		 */ 
		[MessageDispatcher]
		public var sendMessage:Function;
		
		public function get holidaysPerYear():Number
		{
			if (isNaN(_holidaysPerYear)) _holidaysPerYear = 0;
			return _holidaysPerYear;
		}
		
		public function set holidaysPerYear(value:Number):void
		{
			_holidaysPerYear = value;
		}
		
		public function get annualSalary():Number
		{
			switch (term) {
				case HOURLY:
					return amount * hoursPerDay * daysPerWeek * IncomeService.WEEKS_PER_YEAR;
				case DAILY:
					return amount * daysPerWeek * IncomeService.WEEKS_PER_YEAR;
				case WEEKLY:
					return amount * IncomeService.WEEKS_PER_YEAR;
				case MONTHLY:
					return amount * IncomeService.MONTHS_PER_YEAR;
				default:
					return amount;
			}
		}
		
		public function submit():void
		{
			sendMessage(new SalaryEvent(SalaryEvent.CALCULATE, this));
		}
		
		public function toString():String
		{
			return "[SalaryFormModel term=\"" + term
				+ "\" amount=" + amount
				+ " hoursPerDay=" + hoursPerDay
				+ " daysPerWeek=" + daysPerWeek
				+ " holidaysPerYear=" + holidaysPerYear
				+ " repayStudentLoan=" + repayStudentLoan + "]";
		}
	}
}