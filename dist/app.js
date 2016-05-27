(function(){var t=function(t,e){var n="http://localhost:8084/Scagnostics/rest/scagnostics_service/scagnostics",o=new XMLHttpRequest;o.open("POST",n),o.setRequestHeader("Content-Type","application/json"),o.onload=function(){e(o.status>=200&&o.status<300?JSON.parse(o.response):{status:o.status,statusText:o.statusText})},o.onerror=function(){e({status:o.status,statusText:o.statusText})},o.send(t)},e,n;n=function(){function e(t,e,n){var o,a;this.parent=null!=t?t:"body",this.width=null!=e?e:900,this.height=null!=n?n:810,o=this,this.frequency=100,this.data=[],this.latLngData=[],this.scagnosticsData={points:[]},this.downloads=document.getElementById("downloads"),this.scag=d3.select("#scag table"),a=d3.select(this.parent).append("svg").attr({width:this.width-350,height:this.height}).style({border:"1px solid darkgray",display:"inline-block"}),this.g=a.append("g"),a.on("mousemove",function(){return o.pos=d3.mouse(this),d3.event.shiftKey&&!this.interval?this.interval=setInterval(function(){return o.draw()},o.frequency):!d3.event.shiftKey&&this.interval?(clearInterval(this.interval),this.interval=null):void 0}),document.onkeypress=function(t){return function(e){return 32===e.which?(t.clear(),t.printPxData(),t.convertToLatLngData(),t.convertToGeoJSON(),t.convertToScagnosticsData(),t.getScagnostics()):void 0}}(this)}return e.prototype.draw=function(){return this.data.push(this.pos),this.g.selectAll("circle").data(this.data).enter().append("circle").attr({cx:function(t){return t[0]},cy:function(t){return t[1]},r:5,fill:"blue",opacity:.3,stroke:"darkblue"})},e.prototype.clear=function(){return d3.selectAll("a, br").remove()},e.prototype.convertToLatLngData=function(){var t,e,n,o,a,s,i;for(a=this.data,e=0,n=a.length;n>e;e++)o=a[e],s=o[0],i=o[1],this.latLngData.push([Math.round10(-(i-this.height/2)*(180/this.height),-4),Math.round10((s-this.width/2)*(360/this.width),-4)]);return console.log("latLng-data output:"),console.log(this.latLngData),t=document.createElement("a"),t.download="latLng.json",t.textContent="lat-lng file",t.href="data:application/json;base64,"+window.btoa(unescape(encodeURIComponent(JSON.stringify(this.latLngData)))),this.downloads.appendChild(t),this.downloads.appendChild(document.createElement("br"))},e.prototype.convertToGeoJSON=function(){var t,e,n,o,a,s,i,r;for(this.geoJSON={type:"FeatureCollection",features:[]},s=this.data,n=0,o=s.length;o>n;n++)a=s[n],i=a[0],r=a[1],t={type:"Feature",geometry:{type:"Point",coordinates:[Math.round10((i-this.width/2)*(360/this.width),-4),Math.round10(-(r-this.height/2)*(180/this.height),-4)]}},this.geoJSON.features.push(t);return console.log("GeoJSON output:"),console.log(this.geoJSON),e=document.createElement("a"),e.download="geoJSON.json",e.textContent="GeoJSON file",e.href="data:application/json;base64,"+window.btoa(unescape(encodeURIComponent(JSON.stringify(this.geoJSON)))),this.downloads.appendChild(e),this.downloads.appendChild(document.createElement("br"))},e.prototype.convertToScagnosticsData=function(){var t,e,n,o,a,s,i;for(a=this.data,e=0,n=a.length;n>e;e++)o=a[e],s=o[0],i=o[1],this.scagnosticsData.points.push({x:s,y:i});return console.log("scagnostics-data output:"),console.log(this.scagnosticsData),t=document.createElement("a"),t.download="scagnosticsData.json",t.textContent="scagnostics-data file",t.href="data:application/json;base64,"+window.btoa(unescape(encodeURIComponent(JSON.stringify(this.scagnosticsData)))),this.downloads.appendChild(t),this.downloads.appendChild(document.createElement("br"))},e.prototype.printPxData=function(){var t;return console.log("pixel-data output:"),console.log(this.data),t=document.createElement("a"),t.download="pixelData.json",t.textContent="pixel-data file",t.href="data:application/json;base64,"+window.btoa(unescape(encodeURIComponent(JSON.stringify(this.data)))),this.downloads.appendChild(t),this.downloads.appendChild(document.createElement("br"))},e.prototype.getScagnostics=function(){return t(JSON.stringify(this.scagnosticsData),function(t){var e,n,o,a;return console.log(t),e=function(){var e;e=[];for(n in t)a=t[n],e.push({property:n,value:a});return e}(),o=d3.select("#scag tbody").selectAll("tr").data(e).html(function(t){return"<td>"+t.property.toLowerCase()+"</td><td>"+t.value+"</td>"}),o.enter().append("tr").html(function(t){return"<td>"+t.property.toLowerCase()+"</td><td>"+t.value+"</td>"}),o.exit().remove()})},e}(),e=new n("main",document.body.clientWidth,document.documentElement.clientHeight-22)}).call(this);
//# sourceMappingURL=./app.js.map