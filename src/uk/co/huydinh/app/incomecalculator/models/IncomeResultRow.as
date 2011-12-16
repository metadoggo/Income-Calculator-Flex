package uk.co.huydinh.app.incomecalculator.models
{
	public class IncomeResultRow
	{
		private var _label : String;
		private var _amount : Number;
		private var _workingDaysPerYear : Number;
		private var _workingHoursPerYear : Number;
		
		public function IncomeResultRow(label:String, amount:Number, workingDaysPerYear:Number, workingHoursPerYear:Number)
		{
			this._label = label;
			this._amount = amount;
			this._workingDaysPerYear = workingDaysPerYear;
			this._workingHoursPerYear = workingHoursPerYear;
		}
		
		public function get label():String { return _label; }
		
		public function get annually():Number
		{
			return _amount;
		}
		
		public function get monthly():Number
		{
			return _amount / IncomeService.MONTHS_PER_YEAR;
		}
		
		public function get weekly():Number
		{
			return _amount / IncomeService.WEEKS_PER_YEAR;
		}
		
		public function get daily():Number
		{
			return _amount / _workingDaysPerYear;
		}
		
		public function get hourly():Number
		{
			return _amount / _workingHoursPerYear;
		}
	}
}