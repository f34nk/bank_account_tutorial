/**
 * jquery placeholder
 *
 *	Helper function that works as a jquery '$' placeholder.
 *	Load jquery with document/ready like always.
 *	Use the 'defer' attribute to enable asnyc loading of jquery and other javascript.
 *
 *	https://www.w3schools.com/tags/att_script_defer.asp
 * 	"When present, it specifies that the script is executed when the page has finished parsing."
 *
 * usage:
 *
 * <head>
 * 	...
 * 	<script src="jquery_placeholder.js"></script>
 * <head>
 * <body>
 * 	...
 * 		<!-- user anywhere in the code -->
 * 		$(document).ready(function(){ ... })
 * 	...
 * 	<!-- load javascript at the bottom of the page -->
 * 	<script defer="true" src="jquery.js"></script>
 * 	<script defer="true" src="another.js"></script>
 * </body>
 *
 */
/**
 * [_methods_ description]
 * @type {Array}
 */
var _methods_ = [];
/**
 * [$ description]
 * @param  {[type]} target [description]
 * @return {[type]}        [description]
 */
var $ = function(target){
	var that = this;
	// console.log('$ = ', target);
	that.ready = function(callback){
		// console.log('ready = ', callback);
		_methods_.push(callback);
	}
	that.onload = function(){
		// console.log('methods', _methods_.length);
		$.each(_methods_, function(i, e){
			e();
		})
	}
	return that;
}