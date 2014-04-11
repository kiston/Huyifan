package {
	public class Transaction
	{
		public var date:String;
		
		public var idFrom:String;
		
		public var idTo:String;
		
		public var acctNameFrom:String;
		
		public var acctNameTo:String;
		
		public var insideFrom:int;
		
		public var insideTo:int;
		
		public var amount:Number;
		
		public var frame:int;
		
		public function Transaction(date:String,idFrom:String,idTo:String,acctNameFrom:String,acctNameTo:String,insideFrom:String,insideTo:String,amount:String,frame:String){
			this.date=date;
			this.idFrom=idFrom;
			this.idTo=idTo;
			this.acctNameFrom=acctNameFrom;
			this.acctNameTo=acctNameTo;
			this.insideFrom=int(insideFrom);
			this.insideTo=int(insideTo);
			this.amount=Number(amount);
			this.frame=int(frame);
		}
	}
}
