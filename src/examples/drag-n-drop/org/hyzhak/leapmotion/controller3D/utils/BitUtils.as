package org.hyzhak.leapmotion.controller3D.utils
{
	import flash.display.BitmapData;

	public class BitUtils {
		
		/**
		 * Return true if value is power of two 
		 *  http://en.wikipedia.org/wiki/Power_of_two#Fast_algorithm_to_find_a_number_modulo_a_power_of_two
		 * 
		 * @param value
		 * @return 
		 * 
		 */
		public static function isPowOf2(value:int):Boolean {
			return (value && (value - 1)) > 0;
		}
		
		public static function isBitmapDataPowOf2(value:BitmapData):Boolean {
			if(value == null) {
				return false;
			}
			
			return isPowOf2(value.width) && isPowOf2(value.height);
		}
	}
}