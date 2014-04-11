package {
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.BlurFilter;
	import flash.filters.GlowFilter;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.net.*;
	import flash.text.*;
	import flash.utils.Timer;
	
    [SWF(width="1366", height="768", backgroundColor="#000000", frameRate="60")]
	public class Huyifan extends Sprite
	{
	    private var stageWidth:int=1366;
	    
	    private var stageHeight:int=768;
		
		private var edges:Object=new Object();
		
		private var edgeIdx:Object = new Object();
		
		private var nodesX:Array = new Array();
		
		private var nodesY:Array = new Array();
		
		private var nodeArr:Array = new Array();
		
		private var edgeArr:Array = new Array();
		
		private var nodesName:Array = new Array();
		
		private var nodesInner:Array = new Array();
		
		private var nodesCt:Array = new Array();
		
		private var edgesCt:Array = new Array();
		
		private var K:Number=300;
		
		private var C:Number=0.2;
		
		private var P:Number=1;
		
		private var T:Number=0.95;
		
		private var progress:int=0;
		
		private var step:Number=30;
		
		private var cov:Number=0.2;
		
		private var converged:Boolean=false;
		private	var E:Number=999999999;
		
		private var init:int = 200;
		
		private var timer:Timer;
		
		private var glowNd:GlowFilter;
		private var glowOuterNd:GlowFilter;
		
		private var glowEg:GlowFilter;
		
		private var glowPar:GlowFilter;
		
		private var glowMarker:GlowFilter;
		
		private var filterNdArr:Array;
		private var filterOuterNdArr:Array;
		
		private var filterEgArr:Array;
		
		private var filterParArr:Array;
		
		private var filterMarker:Array;
		
		private var colorTransform:ColorTransform;
		private var particleTransform:ColorTransform;
		
		private var origin:Point;
		
		private var bitmapData:BitmapData;
		
		private var bitmap:Bitmap;
		
		private var particleBMData:BitmapData;
		
		private var particleBM:Bitmap;
		
		private var blur:BlurFilter;
		private var blurPar:BlurFilter;
		private var blurP:BlurFilter;
		
		private var gridY:Array;
		
		private var swfURL:String;       
		private var endIndex:int;      
		private var baseURL:String; 
		
		private var transLoader:URLLoader;
		
		private var transXML:XML;
		
		private var window:int=40;
		
		private var trans:Array=new Array();
		
		private var lowB:int=0;
		private var uppB:int;
		private var trId:int=0;
		
		private var ticker:int=0;
		
		private var dragSig:Boolean = false;
		private var dragStartP:Point;
		
		private var maxDis:int = 300;
		private var tinyForce:Number = -1;
		
		private var weight:Number = 1;
		
		private var transfer:Array = new Array();
		private var transferFrame:Array = new Array();
		private var transferArr:Array = new Array();
		private var transferTm:Number = 1;
		
		private var textArr:Array = new Array();
		private var metaFormat:TextFormat;
		
		private var bar:Sprite = new Sprite();
		private var date:TextField = new TextField();
		private var titleFormat:TextFormat;
		
		private var dateContainer:Sprite = new Sprite();
		
		private var oriTm:Number;
		private var dt:TextField = new TextField();
		
		private var transLn:Sprite = new Sprite();
		private var marker:Sprite = new Sprite();
		private var trXLim:Number=0;
		private var trYLim:Number=0;
		
		private var trAmt:Number=0;
		private var trX:Number=10;
		private var trY:Number=0;
		private var trYSpd:Number=0;
		private var trYTar:Number=0;
		
		private var speed:Number = 2; 
		
		private var debug:TextField = new TextField();
		
		public function Huyifan()
		{	
			metaFormat = new TextFormat('微软雅黑', 11, 0xec8524, true);
			titleFormat = new TextFormat('微软雅黑',15,0xffffff,true);
			TweenPlugin.activate([GlowFilterPlugin,AutoAlphaPlugin]);
			stage.scaleMode = StageScaleMode.NO_SCALE;
	        stage.align = StageAlign.TOP_RIGHT;
	        glowNd = new GlowFilter(0xff2525,1,10,10);
	        glowOuterNd = new GlowFilter(0x235cd8,1,10,10);
	        glowEg = new GlowFilter(0xec8524,1,10,10);
	        glowPar = new GlowFilter(0xf4c824,5,20,20);
	        glowMarker = new GlowFilter(0xffffff,5,10,10);
	        blur = new BlurFilter(4,4);
			blurPar = new BlurFilter(6,6);
			blurP = new BlurFilter(11,11);
	        filterNdArr=[glowNd];
	        filterOuterNdArr=[glowOuterNd];
	        filterEgArr=[glowEg];
	        filterParArr=[glowPar,blurP];
	        filterMarker=[glowMarker,blur];
	        origin = new Point(0,0);
	        bitmapData = new BitmapData(stageWidth,stageHeight,true,0xffffff);
			bitmap = new Bitmap(bitmapData);
			bitmap.x=0;
			bitmap.y=0;
			particleBMData = new BitmapData(stageWidth,stageHeight,true,0xffffff);
			particleBM = new Bitmap(particleBMData);
			particleBM.x=0;
			particleBM.y=0;	
			colorTransform = new ColorTransform(0,0,0,0);
			particleTransform = new ColorTransform(1,1,1,0.95);
	      
	        this.addChild(bitmap);
	        this.addChild(particleBM);
	        bar.graphics.beginFill(0xffffff,0);
	        bar.graphics.drawRoundRect(0,0,stageWidth-200,stageHeight*0.1,20);
	        bar.graphics.endFill();
	        bar.x=100;
	        bar.y=stageHeight-stageHeight*0.3;
	 
	        date.text='Date:'
	        //date.cacheAsBitmap=true;
	        //bar.cacheAsBitmap=true;
	        //dateContainer.cacheAsBitmap=true;
	        dateContainer.blendMode=BlendMode.LAYER;
	        date.setTextFormat(titleFormat);
	        dateContainer.addChild(date);
	        dateContainer.x=bar.width-110;
	        dateContainer.y=bar.height*0.125;
	        //dateContainer.blendMode=BlendMode.ALPHA;
	        //dateContainer.alpha=0;
	        date.height=bar.height*0.25;
	        date.width=bar.width*0.085;
	        dt.text='--';
	        dt.y=bar.height*0.35;
	        dt.width=bar.width*0.085;
	        dt.height=bar.height*0.4;
	     	//dt.cacheAsBitmap=true;
	     	dt.setTextFormat(titleFormat);
	     	dateContainer.addChild(dt);
	 
			
	    	transLn.x=(bar.width-dateContainer.x)*0.1;
	    	transLn.y=bar.height*0.11;
	    	transLn.filters=filterEgArr;
	    	//transLn.cacheAsBitmap=true;
	    	//transLn.blendMode=BlendMode.ALPHA;
	    	//transLn.graphics.beginFill(0xB5D53A,0);
	    	//transLn.graphics.drawRect(0,0,(bar.width-dateContainer.width)*0.95,bar.height*0.78);
	    	//transLn.graphics.endFill();
	    	drawBar();
	    	trXLim = (bar.width-dateContainer.width)*0.93;
	    	trYLim = (bar.height*0.65);
	    	trY=trYLim;
	    	bar.addChild(transLn);
	        bar.addChild(dateContainer);
	        this.addChild(bar);
	        marker.graphics.lineStyle(3,0xffffff,0.3);
	        marker.graphics.moveTo((bar.width-dateContainer.x)*0.1,0);
	        marker.graphics.lineTo((bar.width-dateContainer.x)*0.1,bar.height*0.78+20);
	        marker.filters=filterMarker;
	        bar.addChild(marker);
	        initGraph();
	        
	        /*debug.x=50;
	        debug.y=50;
	       	this.addChild(debug);*/
	        }
		
		public function dragStart(event:MouseEvent):void{
			dragSig=true;
			dragStartP=new Point(event.stageX,event.stageY);
		}
		
		public function dragOver(event:MouseEvent):void{
			dragSig=false;
			dragStartP=null;
		}
		
		public function dragging(event:MouseEvent):void{
			if(dragSig==true){
				var diffX:Number=Number(event.stageX-dragStartP.x);
				var diffY:Number=Number(event.stageY-dragStartP.y);
				this.x += diffX;
				this.y += diffY;
				bitmap.x = bitmap.x-diffX;
				bitmap.y = bitmap.y-diffY;
				particleBM.x = particleBM.x-diffX;
				particleBM.y = particleBM.y-diffY;
				bar.x=bar.x-diffX;
				bar.y=bar.y-diffY;
				dragStartP = new Point(event.stageX,event.stageY);
				event.updateAfterEvent();
			}else return;			
		}
		
		public function drawBar():void{
			bar.graphics.lineStyle(0.5,0xffffff,0.3);
			bar.graphics.moveTo(5,transLn.y);
			bar.graphics.lineTo((bar.width-dateContainer.width)*0.95,transLn.y);
			bar.graphics.moveTo(5,bar.height*0.78+5);
			bar.graphics.lineTo((bar.width-dateContainer.width)*0.95,bar.height*0.78+5);
		}
		
		public function duplicate(o:Object,a:int,b:int):Boolean{
			for(var prop:String in o){
				if((o[prop])[0]==a&&(o[prop])[1]==b) return true;
			}
			return false;
		}
		
		public function initGraph():void {
			swfURL=this.parent.loaderInfo.url;
			endIndex=swfURL.indexOf("Huyifan.swf");
			baseURL=swfURL.substring(0,endIndex);
			var urlRequest:URLRequest = new URLRequest(baseURL+'tmAnimationhalf.xml');
			transLoader = new URLLoader();
			transLoader.addEventListener(Event.COMPLETE,onLoadGraph);
			transLoader.load(urlRequest);
		}
		
		public function onLoadGraph(e:Event):void{
			transXML=new XML(e.target.data);	
			for each(var w:* in transXML.transaction) {
				trans.push(new Transaction(w.date,w.idfrom,w.idto,w.acctnamefrom,w.acctnameto,w.insidefrom,w.insideto,w.amount,w.txn_frame));
			}
			oriTm=Date.parse(trans[0].date+' 00:00:00');
			dt.text=getDateStr(new Date(oriTm));
			dt.setTextFormat(titleFormat);
			uppB = Math.min(window-1,trans.length-1);
			for(var i:int=0;i<=uppB;i++){
				var idf:int=int(trans[i].idFrom);
				if(nodeArr[idf-1]==null) {
					nodesName[idf]=trans[i].acctNameFrom
					nodesInner[idf]=trans[i].insideFrom;
					nodesCt[idf] = 1;
					var node:Sprite=new Sprite();
					if(nodesInner[idf]==1){
						node.graphics.beginFill(0xcc0025,0.6);
						node.filters=filterNdArr;
					}
					else if(nodesInner[idf]==0){
						node.graphics.beginFill(0x65e7fe,0.6);
						node.filters=filterOuterNdArr;
					}
					node.graphics.drawCircle(0,0,8);
					node.graphics.endFill();
					node.x=200+Math.random()*880;
					node.y=200+Math.random()*624;
					nodesX[idf]=node.x;
					nodesY[idf]=node.y;
					nodeArr[idf-1]=node;
				}else {
					nodesCt[idf] += 1;
				}
				var idt:int=int(trans[i].idTo);
				if(nodeArr[idt-1]==null) {
					nodesName[idt]=trans[i].acctNameTo
					nodesInner[idt]=trans[i].insideTo;
					nodesCt[idt] = 1;
					var node:Sprite=new Sprite();
					if(nodesInner[idt]==1){
						node.graphics.beginFill(0xcc0025,0.6);
						node.filters=filterNdArr;
					}
					else if(nodesInner[idt]==0){
						node.graphics.beginFill(0x65e7fe,0.6);
						node.filters=filterOuterNdArr;
					}
					node.graphics.drawCircle(0,0,8);
					node.graphics.endFill();
					node.x=200+Math.random()*880;
					node.y=200+Math.random()*624;
					nodesX[idt]=node.x;
					nodesY[idt]=node.y;
					nodeArr[idt-1]=node;	
				}else {
					nodesCt[idt] += 1;
				}
				
				if(directedContainsItem(idf,idt,edgeIdx,edges)==false){
					var pair:Array=new Array();
					pair.push(idf);
					pair.push(idt);
					edges[i+1]=pair;
					if(edgeIdx[idf]==null||edgeIdx[idf]==undefined) edgeIdx[idf]=new Array();
	        		if(edgeIdx[idt]==null||edgeIdx[idt]==undefined) edgeIdx[idt]=new Array();
	        		edgeIdx[idf].push(i+1);
	        		edgeIdx[idt].push(i+1);
	        		var edgeSp:Shape = new Shape();
	        		var x1:int=nodesX[idf];
	        		var y1:int=nodesY[idf];
	        		var x2:int=nodesX[idt];
	        		var y2:int=nodesY[idt];	        	
	        		edgeSp.graphics.lineStyle(1,0xf4c824);
	        		edgeSp.graphics.moveTo(x1,y1);
	        		edgeSp.graphics.lineTo(x2,y2);
	        		edgeSp.filters=filterEgArr;
	        		edgeSp.alpha=0.2
	        		addChildAt(edgeSp,0);
	        		edgesCt[i+1]=1;
	        		edgeArr[i]=edgeSp;   
				}else{
					var fd:int=directedFindEdge(idf,idt,edgeIdx,edges);
					edgesCt[fd] += 1;
				}		     
			}
			stage.addEventListener(Event.ENTER_FRAME,forceDirected);
			stage.addEventListener(MouseEvent.MOUSE_DOWN,dragStart);
	        stage.addEventListener(MouseEvent.MOUSE_UP,dragOver);
	        stage.addEventListener(MouseEvent.MOUSE_MOVE,dragging);
		}
		
		
		public function forceDirected(e:Event):void{
				ticker++;
				if(ticker==int((trans[trId].frame+init)*speed)) {
					trAmt=trans[trId].amount;
					trYTar = trYLim-Math.min(trAmt*0.000001*trYLim,trYLim-5);
					trYSpd=(trYTar-trY)*0.05;
					if(trId>window*0.5){
						if(uppB<=trans.length-2){
							uppB++;
							var idf:int=int(trans[uppB].idFrom);
							if(nodesCt[idf]==null) {
								nodesName[idf]=trans[uppB].acctNameFrom
								nodesInner[idf]=trans[uppB].insideFrom;
								nodesCt[idf] = 1;
								var node:Sprite=new Sprite();
								if(nodesInner[idf]==1){
									node.graphics.beginFill(0xcc0025,0.6);
									node.filters=filterNdArr;}
								else if(nodesInner[idf]==0){
									node.graphics.beginFill(0x65e7fe,0.6);
									node.filters=filterOuterNdArr;
								}
								node.graphics.drawCircle(0,0,8);
								node.graphics.endFill();
								node.x=200+Math.random()*880;
								node.y=200+Math.random()*624;
								nodesX[idf]=node.x;
								nodesY[idf]=node.y;
								nodeArr[idf-1]=node;
								converged=false;
								step=6;
							}else {
								nodesCt[idf] += 1;
							}
							var idt:int=int(trans[uppB].idTo);
							if(nodesCt[idt]==null) {
								nodesName[idt]=trans[uppB].acctNameTo
								nodesInner[idt]=trans[uppB].insideTo;
								nodesCt[idt] = 1;
								var node:Sprite=new Sprite();
								if(nodesInner[idt]==1){
									node.graphics.beginFill(0xcc0025,0.6);
									node.filters=filterNdArr;}
								else if(nodesInner[idt]==0){
									node.graphics.beginFill(0x65e7fe,0.6);
									node.filters=filterOuterNdArr;
								}
								node.graphics.drawCircle(0,0,8);
								node.graphics.endFill();
								node.x=200+Math.random()*880;
								node.y=200+Math.random()*624;
								nodesX[idt]=node.x;
								nodesY[idt]=node.y;
								nodeArr[idt-1]=node;
								converged=false;	
								step=6;		
							}else {
								nodesCt[idt] += 1;
							}
							if(directedContainsItem(idf,idt,edgeIdx,edges)==false){
								var pair:Array=new Array();
								pair.push(idf);
								pair.push(idt);
								edges[uppB+1]=pair;
								if(edgeIdx[idf]==null||edgeIdx[idf]==undefined) edgeIdx[idf]=new Array();
	        					if(edgeIdx[idt]==null||edgeIdx[idt]==undefined) edgeIdx[idt]=new Array();
	        					edgeIdx[idf].push(uppB+1);
	        					edgeIdx[idt].push(uppB+1);
	        					var edgeSp:Shape = new Shape();
	        					var x1:int=nodesX[idf];
	        					var y1:int=nodesY[idf];
	        					var x2:int=nodesX[idt];
	        					var y2:int=nodesY[idt];	        	
	        					edgeSp.graphics.lineStyle(1,0xf4c824);
	        					edgeSp.graphics.moveTo(x1,y1);
	        					edgeSp.graphics.lineTo(x2,y2);
	        					edgeSp.filters=filterEgArr;
	        					edgeSp.alpha=0.2
	        					addChildAt(edgeSp,0);
	        					edgesCt[uppB+1]=1;
	        					edgeArr[uppB]=edgeSp;   
							}else{
								var fd:int=directedFindEdge(idf,idt,edgeIdx,edges);
								edgesCt[fd] += 1;
							}	     
						}
						if(lowB<=trans.length-window-1){
							var idf:int=int(trans[lowB].idFrom);
							var idt:int=int(trans[lowB].idTo);
							nodesCt[idf]=nodesCt[idf]-1;
							nodesCt[idt]=nodesCt[idt]-1;
							var fd:int=directedFindEdge(idf,idt,edgeIdx,edges);
							edgesCt[fd]=edgesCt[fd]-1;
							if(nodesCt[idf]==0) {
								nodesCt[idf]=null;
								nodeArr[idf-1]=null;
								step=6;
							}
							if(nodesCt[idt]==0) {
								nodesCt[idt]=null;
								nodeArr[idt-1]=null;
								step=6;
							}
							if(edgesCt[fd]==0) {
								edgesCt[fd]=null;
								step=6;
							}
							converged=false;
							lowB++;	
						}
					}
					var idf:int=int(trans[trId].idFrom);
					var idt:int=int(trans[trId].idTo);
					var particle:Sprite=new Sprite();
					if(trans[trId].insideFrom==1){
						particle.graphics.lineStyle(2,0xff2525);
						particle.graphics.beginFill(0xff2525,2);
					}
					else if(trans[trId].insideFrom==0){
						particle.graphics.lineStyle(2,0x65e7fe);
						particle.graphics.beginFill(0x65e7fe,2);
					}
					particle.graphics.drawCircle(0,0,2.5);
					particle.graphics.endFill();
					particle.x=nodesX[idf];
					particle.y=nodesY[idf];
					particle.filters=filterParArr;
					var fd:int=directedFindEdge(idf,idt,edgeIdx,edges);
					transfer.push(fd);
					transferArr.push(particle);
					transferFrame.push(0);
					if(textArr[idf]==null){
						textArr[idf]=new TextField();
						textArr[idf].text=nodesName[idf];
						textArr[idf].setTextFormat(metaFormat);
						textArr[idf].width=textArr[idf].textWidth+20;
						textArr[idf].x = nodesX[idf] + 5;
						textArr[idf].y = nodesY[idf] + 5;
						textArr[idf].alpha=0;
						addChild(textArr[idf]);
					}
					textArr[idf].x = nodesX[idf] + 5;
					textArr[idf].y = nodesY[idf] + 5;
					TweenLite.to(textArr[idf],1.2,{autoAlpha:0.6,glowFilter:{alpha:0.6},onComplete:fadeText,onCompleteParams:[idf]});
					if(trId<=trans.length-2)
					trId = trId+1;	
				}
				if(ticker>=init*speed&&ticker<=(init+trans[trans.length-1].frame)*speed){
					oriTm += 24*1000*60*(1/speed);
					dt.text=getDateStr(new Date(oriTm));
					dt.setTextFormat(titleFormat);
					trX++;
					if(trY<=trYTar) {
						trYTar=trYLim;
						trYSpd=(trYTar-trY)*0.05;
					}
					trY += trYSpd;
					transLn.graphics.beginFill(0xffffff,0.5);
					transLn.graphics.lineStyle(0.5,0xffffff,0);
					transLn.graphics.drawCircle(trX,trY,1.6);
					transLn.graphics.endFill();
					marker.x=trX;
					if(trX>=trXLim){
						transLn.graphics.clear();
						//drawBar();	
						//transLn.graphics.beginFill(0xB5D53A,0);
	    				//transLn.graphics.drawRect(0,0,(bar.width-dateContainer.width)*0.95,bar.height*0.78);
	    				//transLn.graphics.endFill();
	    				trX=10;
	    				marker.x=10;
					}	
				}
			    if(converged==false){							
				var oriE:Number=E;
				E=0;
				var centerX:Number=0;
				var centerY:Number=0;
				var centerCt:int=0;
				var offset:Number=0;
				for(var i:String in nodesCt){
					if(nodesCt[i]!=null){
					var forceX:Number=0;
					var forceY:Number=0;
					for(var j:String in nodesCt){
						var distance:Number=Math.sqrt(Math.pow((nodesX[int(i)]-nodesX[int(j)]),2)+Math.pow((nodesY[int(i)]-nodesY[int(j)]),2));
						if(containsItem(int(i),int(j),edgeIdx,edges)==true){
							forceX += attractive(distance)*(nodesX[int(j)]-nodesX[int(i)])/distance;
							forceY += attractive(distance)*(nodesY[int(j)]-nodesY[int(i)])/distance;
						}
						if(int(j)!=int(i)){
							//forceX += distance>maxDis?tinyForce:repulsive(distance)*(nodesX[int(j)]-nodesX[int(i)])/distance;
							//forceY += distance>maxDis?tinyForce:repulsive(distance)*(nodesY[int(j)]-nodesY[int(i)])/distance;
							forceX += repulsive(distance)*(nodesX[int(j)]-nodesX[int(i)])/distance;
							forceY += repulsive(distance)*(nodesY[int(j)]-nodesY[int(i)])/distance;
						}
					}
					/*for(var idx:int=0;idx<edgeIdx[i].length;idx++){
						var edgeId:int = edgeIdx[i][idx];
						var j:int;
						if(edges[edgeId][0]==i) j=edges[edgeId][1];
						else j=edges[edgeId][0];
						var distance:Number=Math.sqrt(Math.pow((nodesX[i]-nodesX[j]),2)+Math.pow((nodesY[i]-nodesY[j]),2));
						forceX += attractive(distance)*(nodesX[j]-nodesX[i])/distance;
						forceY += attractive(distance)*(nodesY[j]-nodesY[i])/distance;
					}	
					var gy:int=int(nodesY[i]/100);
					var gx:int=int(nodesX[i]/100);				
					for(var tileY:String in gridY){
						var tX:Array = gridY[int(tileY)];
						for(var tileX:String in tX){
							var j:int;
							var weight:int;
							if(gridY[int(tileY)]!=null&&gridY[int(tileY)][int(tileX)]!=null&&gridY[int(tileY)][int(tileX)]!=undefined&&gridY[int(tileY)][int(tileX)].count!=0){
								if(Math.abs(gridY[int(tileY)][int(tileX)].coordinateY-gy)>0&&Math.abs(gridY[int(tileY)][int(tileX)].coordinateX-gx)>0){
									var crX:Number=gridY[int(tileY)][int(tileX)].centerX;
									var crY:Number=gridY[int(tileY)][int(tileX)].centerY;
									weight=gridY[int(tileY)][int(tileX)].count;
									var distance:Number=Math.sqrt(Math.pow((nodesX[i]-crX),2)+Math.pow((nodesY[i]-crY),2));
									forceX += repulsive(distance)*(crX-nodesX[i])/distance;
									forceY += repulsive(distance)*(crY-nodesY[i])/distance;
								}
								else{
									var innerNd:Array = gridY[int(tileY)][int(tileX)].nodes;
									for(var inside:int=0;inside<innerNd.length;inside++){
										j=innerNd[inside];
										if(i!=int(j)){
										var distance:Number=Math.sqrt(Math.pow((nodesX[i]-nodesX[j]),2)+Math.pow((nodesY[i]-nodesY[j]),2));
										forceX += repulsive(distance)*(nodesX[j]-nodesX[i])/distance;
										forceY += repulsive(distance)*(nodesY[j]-nodesY[i])/distance;
										}
									}
								}
							}
						}
					}*/
					//minusGrid(i);
					var norm:Number=Math.sqrt(Math.pow(forceX,2)+Math.pow(forceY,2));
					//if(nodesX[int(i)]<50||nodesX[int(i)]>stageWidth-50||nodesY[int(i)]<50||nodesY[int(i)]>stageHeight-50)	
					//weight=0.1
					nodesX[int(i)]=nodesX[int(i)]+step*(forceX/norm);
					nodesY[int(i)]=nodesY[int(i)]+step*(forceY/norm);				
					//plusGrid(i);		
					offset=offset+step*(Math.abs(forceX/norm)+Math.abs(forceY/norm));
					//weight=1;
					centerX += nodesX[int(i)];
					centerY += nodesY[int(i)];
					centerCt++;
					E=E+norm*norm;
				}
				}
				//if(offset<cov*K)
				//converged=true;
				step=updateStep(step,E,oriE);
				centerX=centerX/centerCt;
				centerY=centerY/centerCt;
				for(var i:String in nodesCt){
					if(nodesCt[int(i)]!=null){
						//minusGrid(i);				
						nodesX[int(i)]=nodesX[int(i)]-centerX+stageWidth/2;
						nodesY[int(i)]=nodesY[int(i)]-centerY+stageHeight/2;							
						//plusGrid(i);					
					}
				}
			    }
			    redraw();
			    if(transferFrame[0]==60*transferTm||edgesCt[transfer[0]]==null){
			    	if(edgesCt[transfer[0]]!=null){
						TweenLite.to(nodeArr[edges[transfer[0]][1]-1],0.6,{glowFilter:{blurX:100,blurY:100,strength:20}});					
						TweenLite.to(nodeArr[edges[transfer[0]][1]-1],1,{glowFilter:{blurX:10,blurY:10,strength:2},overwrite:false});	
						var idt:int = edges[transfer[0]][1];
						if(textArr[idt]==null){
						textArr[idt]=new TextField();
						textArr[idt].text=nodesName[idt];
						textArr[idt].setTextFormat(metaFormat);
						textArr[idt].width=textArr[idt].textWidth+20;
						textArr[idt].x = nodesX[idt] + 5;
						textArr[idt].y = nodesY[idt] + 5;
						textArr[idt].alpha=0;
						addChild(textArr[idt]);
						}
						textArr[idt].x = nodesX[idt] + 5;
						textArr[idt].y = nodesY[idt] + 5;
						TweenLite.to(textArr[idt],1.2,{autoAlpha:0.6,glowFilter:{alpha:0.6},onComplete:fadeText,onCompleteParams:[idt]});
					}
					transferFrame.shift();
					transfer.shift();
					transferArr.shift();
				}
				for(var par:int=0;par<transferArr.length;par++){
					transferFrame[par]++;
					var sX:Number=nodesX[edges[transfer[par]][0]];
					var sY:Number=nodesY[edges[transfer[par]][0]];
					var tX:Number=nodesX[edges[transfer[par]][1]];
					var tY:Number=nodesY[edges[transfer[par]][1]];
					transferArr[par].x=sX+((tX-sX)/(60*transferTm))*transferFrame[par];
					transferArr[par].y=sY+((tY-sY)/(60*transferTm))*transferFrame[par];	
				}			
		}
		
	
		
		public function fadeText(idf:int):void{
			TweenLite.to(textArr[idf],1.2,{autoAlpha:0,glowFilter:{alpha:0},overwrite:false});
		}		
		
		public function repulsive(distance:	Number):Number{
			return -C*Math.pow(K,1+P)/Math.pow(distance,P);
		}
		
		public function attractive(distance:Number):Number{
			return Math.pow(distance,2)/K;
		}
		
		public function updateStep(step:Number,oriE:Number,newE:Number):Number{
			if(newE<oriE){
				progress++;
				if(progress>=5){
					progress=0;
					step=step/T;
				}
			}else {
				progress=0;
				step=T*step;
			}
			return step;
		}
		
		public function redraw():void{
			bitmapData.applyFilter(bitmapData,bitmapData.rect,origin,blur);
			bitmapData.colorTransform(bitmapData.rect,colorTransform);
			var p:Point=new Point();		
			for(var nd:String in nodeArr){
				if(nodesCt[int(nd)+1]!=null){
					nodeArr[int(nd)].x=nodesX[int(nd)+1];
	        		nodeArr[int(nd)].y=nodesY[int(nd)+1];
	        		p.x=nodesX[int(nd)+1];
	        		p.y=nodesY[int(nd)+1];
	        		p=this.localToGlobal(p);
	        		if(edgeIdx[int(nd)+1]!=null){
	        			bitmapData.draw(nodeArr[int(nd)],new Matrix(1,0,0,1,p.x,p.y));	
	        		}	
				}		 	
	        }
	        reline(); 
	        repar();      
		}
		
		public function repar():void{
			particleBMData.applyFilter(particleBMData,particleBMData.rect,origin,blurPar);
			particleBMData.colorTransform(particleBMData.rect,particleTransform);	
			var p:Point = new Point();
			for(var par:int=0;par<transfer.length;par++){
				p.x=transferArr[par].x
				p.y=transferArr[par].y;
				p=this.localToGlobal(p);
				particleBMData.draw(transferArr[par],new Matrix(1,0,0,1,p.x,p.y));
			}
		}
		
		public function sample(prob:Array):int {
			var sum:int=0;
			for(var i:int=0;i<prob.length;i++){
				sum+=Math.pow(prob[i],3);
			}
			for(var i:int=0;i<prob.length-1;i++){
				var ran:int=Math.random()*sum;
				if(ran<=Math.pow(prob[i],3)) return i;
				else sum-=Math.pow(prob[i],3);
			}
			return prob.length-1;
		}
		
		public function reline():void{
			for(var edgeId:String in edges){
				edgeArr[int(edgeId)-1].graphics.clear();
				if(edgesCt[int(edgeId)]!=null){	
					//debug.text=nodesCt[8].toString()+"\n"+nodesCt[12].toString()+"\n"+edgesCt[26];
					//debug.setTextFormat(metaFormat);	
					edgeArr[int(edgeId)-1].graphics.lineStyle(1.5,0xf4c824);
					var x1:int=nodeArr[(edges[edgeId])[0]-1].x;
	        		var y1:int=nodeArr[(edges[edgeId])[0]-1].y;
	        		var x2:int=nodeArr[(edges[edgeId])[1]-1].x;
	        		var y2:int=nodeArr[(edges[edgeId])[1]-1].y; 
	        		edgeArr[int(edgeId)-1].graphics.moveTo(x1,y1);
	        		edgeArr[int(edgeId)-1].graphics.lineTo(x2,y2);
				}
			}
		}
		
		public function containsItem(source:int,item:int,idx:Object,eg:Object):Boolean{
			if(source==item) return false;
			if(idx[source]==null) return false; 
			var edgeSet:Array=idx[source];
			for(var i:int=0;i<edgeSet.length;i++){
				var id:int=edgeSet[i];
				if(((eg[id])[0]==item)||((eg[id])[1]==item))
				return true;
			}
			return false;
		}
		
		public function directedContainsItem(source:int,item:int,idx:Object,eg:Object):Boolean{
			if(source==item) return false;
			if(idx[source]==null) return false; 
			var edgeSet:Array=idx[source];
			for(var i:int=0;i<edgeSet.length;i++){
				var id:int=edgeSet[i];
				if(((eg[id])[0]==source)&&((eg[id])[1]==item))
				return true;
			}
			return false;
		}
		
		public function findEdge(source:int,item:int,idx:Object,eg:Object):int{
			var edgeSet:Array=idx[source];
			for(var i:int=0;i<edgeSet.length;i++){
				var id:int=edgeSet[i];
				if(((eg[id])[0]==item)||((eg[id])[1]==item))
				return id;
			}
			return -1;
		}
		
		public function directedFindEdge(source:int,item:int,idx:Object,eg:Object):int{
			var edgeSet:Array=idx[source];
			for(var i:int=0;i<edgeSet.length;i++){
				var id:int=edgeSet[i];
				if(((eg[id])[0]==source)&&((eg[id])[1]==item))
				return id;
			}
			return -1;
		}
		
		public function minusGrid(i:int):void{
			var gy:int=int(nodesY[i]/100);
			var gx:int=int(nodesX[i]/100);
			(gridY[gy])[gx].del(i);
		}	
		
		public function plusGrid(i:int):void{
			var gy:int=int(nodesY[i]/100);
			var gx:int=int(nodesX[i]/100);
			if(gridY[gy]==null||gridY[gy]==undefined) gridY[gy]=new Array();
			var gridX:Array=gridY[gy];
			if(gridX[gx]==null||gridX[gx]==undefined) (gridY[gy])[gx]=new Grid(gx,gy);
			(gridY[gy])[gx].insert(i);
		}	
		
		public function incDt(dt:Date):Date {
			var ms:Number = dt.getTime();
			ms += 24*3600*1000;
			return new Date(ms);
		}
		
		public function getDateStr(dt:Date):String{
			var cat:String = dt.getFullYear()+"-"+(dt.getMonth()+1)+"-"+(dt.getDate()); 
			return cat;
		}
	}
}
