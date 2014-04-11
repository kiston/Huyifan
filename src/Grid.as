package {
	public class Grid
	{
		public var count:int;
		
		public var nodes:Array;	
		
		public var centerX:Number;
		
		public var centerY:Number;
		
		public var coordinateX:int;
		
		public var coordinateY:int;
		
		public function Grid(gx:int,gy:int){
			this.count=0;
			this.nodes=new Array();
			this.centerX=gx*100+50;
			this.centerY=gy*100+50;
			this.coordinateX=gx;
			this.coordinateY=gy;
		}
		
		public function insert(nd:int):void{
			this.count=this.count+1;
			this.nodes.push(nd);
		}
		
		public function del(nd:int):void{
			this.nodes.splice(nodes.indexOf(nd),1);
			this.count=this.count-1;
		}
	}
}
