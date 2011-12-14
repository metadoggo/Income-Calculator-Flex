package uk.co.huydinh.app.incomecalculator.models
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.xml.XMLNode;
	
	import mx.collections.ArrayList;
	import mx.collections.IList;
	import mx.controls.Alert;
	
	import org.spicefactory.parsley.core.messaging.MessageProcessor;
	
	import uk.co.huydinh.app.incomecalculator.events.SalaryEvent;

	public class SalaryInformationModel extends EventDispatcher
	{

		[Bindable]
		public var taxDatas:Array;
		
		[Bindable]
		public var results:Array;
		
		protected var _defaultYear:String;
		public var selectedIndex:uint;
		
		public function SalaryInformationModel()
		{
		}
		
		[Init]
		public function init():void
		{
			var request:URLRequest = new URLRequest('taxdata.xml');
			var loader:URLLoader = new URLLoader(request);
			loader.addEventListener(Event.COMPLETE, handleDataLoadComplete);
		}
		
		private function handleDataLoadComplete(event:Event):void
		{
			var loader:URLLoader = event.target as URLLoader;
			var xml:XML = new XML(loader.data);
			var defaultYear:String = xml.default.@year;
			var datas:Array = [];
			var i:uint;
			for each (var year:XML in xml.year) {
				var band:XML;
				var incomeTaxBands:Array = [];
				for each (band in year.incometax.band) {
					incomeTaxBands.push(new TaxBand(band.@rate, band.@limit));
				}
				var niBands:Array = [];
				for each (band in year.ni.band) {
					niBands.push(new TaxBand(band.@rate, band.@limit));
				}
				datas.push(new TaxData(year.@label, incomeTaxBands, niBands));
				
				if (defaultYear == year.@label.toString()) {
					selectedIndex = i
				} else {
					++i;
				}
			}
			taxDatas = datas;
		}
		
		[MessageInterceptor(type="uk.co.huydinh.app.incomecalculator.events.SalaryEvent")]
		public function checkTaxDataReady(processor:MessageProcessor):void
		{
			if (taxDatas) {
				processor.proceed();
			} else {
				Alert.show("Required data is still loading, please wait a bit and try again.", "Can't do that...", Alert.OK);
			}
		}
		[MessageHandler]
		public function calculateMessageHandler(event:SalaryEvent):void
		{
			var incomes:Array = [];
			
			for each (var taxData:TaxData in this.taxDatas) {
				var income:IncomeService = new IncomeService(
					taxData,
					event.formModel.annualSalary,
					event.formModel.repayStudentLoan
				);
				
				var workingDaysPerYear:Number = (event.formModel.daysPerWeek * IncomeService.WEEKS_PER_YEAR) - event.formModel.holidaysPerYear
				var workingHoursPerYear:Number = workingDaysPerYear * event.formModel.hoursPerDay;
				
				var data:Array = [
					new IncomeResultRow("Gross income", income.grossSalary, workingDaysPerYear, workingHoursPerYear),
					new IncomeResultRow("Income tax", income.incomeTax, workingDaysPerYear, workingHoursPerYear),
					new IncomeResultRow("National insurance", income.nationalInsurance, workingDaysPerYear, workingHoursPerYear)
				];
				if (event.formModel.repayStudentLoan) {
					data.push(new IncomeResultRow("Student loan", income.studentLoan, workingDaysPerYear, workingHoursPerYear));
				}
				data.push(new IncomeResultRow("Total deductions", income.totalDeductions, workingDaysPerYear, workingHoursPerYear));
				data.push(new IncomeResultRow("Net income", income.netlSalary, workingDaysPerYear, workingHoursPerYear));

				incomes.push(new IncomeResult(taxData.label, new ArrayList(data)));
			}
			
			this.results = incomes;
		}
	}
}