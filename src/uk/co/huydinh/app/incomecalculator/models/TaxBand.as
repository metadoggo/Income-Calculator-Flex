package uk.co.huydinh.app.incomecalculator.models
{
	public class TaxBand
	{
		public var rate:Number;
		public var limit:Number;
		
		public function TaxBand(rate:Number, limit:Number = 0)
		{
			this.rate = rate;
			this.limit = limit;
		}
		
		public function toString():String
		{
			return "[TaxBand rate=" + this.rate
				+ " limit=" + this.limit
				+ "]";
		}
	}
}