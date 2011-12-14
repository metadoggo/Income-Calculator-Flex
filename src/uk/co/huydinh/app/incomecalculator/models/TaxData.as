package uk.co.huydinh.app.incomecalculator.models
{
	public class TaxData
	{
		public var label:String;
		public var incomeTaxBands:Array;
		public var niBands:Array;
		
		public function TaxData(label:String, incomeTaxBands:Array, niBands:Array)
		{
			this.label = label;
			this.incomeTaxBands = incomeTaxBands;
			this.niBands = niBands;
		}
		
		public function toString():String
		{
			return "[TaxData label=\"" + this.label + "\""
				+ " incomeTaxBands=[" + this.incomeTaxBands + "]"
				+ " niBands=[" + this.niBands + "]"
				+ "]";
		}
	}
}