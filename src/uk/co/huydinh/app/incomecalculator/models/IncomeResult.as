package uk.co.huydinh.app.incomecalculator.models
{
	import mx.collections.IList;

	public class IncomeResult
	{
		public var label:String;
		public var data:IList;
		
		public function IncomeResult(label:String, data:IList)
		{
			this.label = label;
			this.data = data;
		}
	}
}