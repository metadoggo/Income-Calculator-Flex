package uk.co.huydinh.app.incomecalculator.models
{
	

	public class IncomeService
	{
		public static const DAYS_PER_YEAR:int = 365;
		public static const MONTHS_PER_YEAR:int = 12;
		public static const DAYS_PER_WEEK:int = 7;
		public static const WEEKS_PER_YEAR:Number = 52;
		
		protected var _grossAnnualSalary:Number;
		protected var _taxData:TaxData;
		
		public var repayStudentLoan:Boolean;
		
		public function IncomeService(taxData:TaxData, grossSalary:Number, repayStudentLoan:Boolean = false)
		{
			this.taxData = taxData;
			this.grossSalary = grossSalary;
			this.repayStudentLoan = repayStudentLoan;
		}
		
		public function get grossSalary():Number
		{
			return _grossAnnualSalary;
		}
		
		public function set grossSalary(value:Number):void
		{
			_grossAnnualSalary = value;
		}
		
		public function get taxData():TaxData
		{
			return _taxData;
		}
		
		public function set taxData(value:TaxData):void
		{
			_taxData = value;
		}
		
		public function get incomeTax():Number
		{
			var grossIncome:Number = this.grossSalary;
			var remainingIncome:Number = 0;
			var totalIncomeTax:Number = 0;
			
			for (var i:int = 0, j:int = this.taxData.incomeTaxBands.length; i < j; i++) {
				var incomeTaxBand:TaxBand = this.taxData.incomeTaxBands[i];
				if (grossIncome >= incomeTaxBand.limit && incomeTaxBand.limit > 0) {
					totalIncomeTax += (incomeTaxBand.limit - remainingIncome) * incomeTaxBand.rate;
					if (0 == incomeTaxBand.rate) {
						grossIncome -= incomeTaxBand.limit;
					} else {
						remainingIncome = incomeTaxBand.limit - remainingIncome;
						grossIncome -= remainingIncome;
					}
				} else {
					totalIncomeTax += grossIncome * incomeTaxBand.rate;
					grossIncome = 0;
					break;
				}
			}
			return totalIncomeTax;
		}
		
		public function get nationalInsurance():Number
		{
			var remainingIncome:Number = this.grossSalary / WEEKS_PER_YEAR;
			var totalNi:Number = 0;
			var currentNiBand:TaxBand;
			var nextNiBand:TaxBand;
			var i:int = this.taxData.niBands.length;
			while (--i) {
				currentNiBand = this.taxData.niBands[i];
				nextNiBand = this.taxData.niBands[i - 1];
				if (remainingIncome > nextNiBand.limit) {
					totalNi += (remainingIncome - nextNiBand.limit) * currentNiBand.rate;
				}
				remainingIncome = Math.min(remainingIncome, nextNiBand.limit);
			}
			return (totalNi * WEEKS_PER_YEAR);
		}
		
		public function get studentLoan():int
		{
			if (this.repayStudentLoan)
			{
				var remainingIncome:Number = this.grossSalary - 15000;
				if (remainingIncome) {
					return remainingIncome * 0.09;
				}
			}
			return 0;
		}
		
		public function get totalDeductions():Number
		{
			return this.incomeTax + this.nationalInsurance + this.studentLoan;
		}
		
		public function get netlSalary():Number
		{
			return this.grossSalary - this.totalDeductions;
		}
		
		public function toString():String
		{
			return "[IncomeService taxData=" + this.taxData
				+ " grossAnnualSalary=" + this.grossSalary
				+ " repayStudentLoan=" + this.repayStudentLoan
				+ "]";
		}
	}
}