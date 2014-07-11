package
{
	public final class ShapeData
	{
		public function ShapeData() {}
		
		// ::
		private static function p_get_sweetData(source:String, sn:uint):Array
		{
			var t_rv:Array = null;
			
			for
			(
				var
					t_sps:Array = source.split('-'),
					t_la:uint = t_sps.length,
					i:uint = 0;
				i < t_la; i++
			)
			{
				var t_sp:String = t_sps[i];
				var t_lb:uint = t_sp.length;
				for (var j:uint = 0; j < t_lb; j++)
				{
					var t_ab:String = t_sp.charAt(j);
					if (t_ab == 'o')
					{
						var t_hn:uint = j + 1;
						var t_vn:uint = i + 1;
						//trace('t_hn: ' + t_hn + ', ' + 't_vn: ' + t_vn);
						var t_co:CellObj = new CellObj(j + 1, i + 1, sn);
						
						if (t_rv == null)
							t_rv = [];
							
						t_rv.push(t_co);
					}	
				}
			}
			
			return t_rv;
		}
		
		// ::
		private static function p_get_sweetData_all():Array
		{
			var t_rv:Array = null;
			
			for (var t_la:uint = TYPE_SOURCES.length,
					i:uint = 0;
					i < t_la; i++)
			{
				var t_rvs:Array = null;				
					
				var t_ts:Array = TYPE_SOURCES[i];				
				for (var t_lb:uint = t_ts.length,
					j:uint = 0;
					j < t_lb; j++)
				{
					var t_ti:String = t_ts[j];

					if (t_rvs == null)
						t_rvs = [];
					t_rvs.push(p_get_sweetData(t_ti, i + 1));
				}
				
				if (t_rv == null)
					t_rv = [];
				t_rv.push(t_rvs);
			}
			
			return t_rv;
		}
		

		// - 데이터 소스 이거만 수정하면 됨 (3차원 행렬)
		private static const TYPE_SOURCES:Array =
		[
		 	// Type 1
			[
				'xxxx-' +
				'oooo-' +
				'xxxx-' +
				'xxxx-'
				
				,
				'xoxx-' +
				'xoxx-' +
				'xoxx-' +
				'xoxx-'
			]
			
			,
			// Type 2
			[
				'xxx-' +
				'ooo-' +
				'xox-'
				
				,
				'xox-' +
				'oox-' +
				'xox-'
				
				,
				'xxx-' +
				'xox-' +
				'ooo-'
				
				,
				'xox-' +
				'xoo-' +
				'xox-'
			]
			
			,
			// Type 3
			[
				'xxx-' +
				'ooo-' +
				'oxx-'
				
				,
				'oox-' +
				'xox-' +
				'xox-'
				
				,
				'xxx-' +
				'xxo-' +
				'ooo-'
				
				,
				'xox-' +
				'xox-' +
				'xoo-'
			]
			
			,
			// Type 4
			[
				'xxx-' +
				'ooo-' +
				'xxo-'
				
				,
				'xox-' +
				'xox-' +
				'oox-'
				
				,
				'xxx-' +
				'oxx-' +
				'ooo-'
				
				,
				'xoo-' +
				'xox-' +
				'xox-'
			]
			
			,
			// Type 5
			[
				'xxx-' +
				'xoo-' +
				'oox-'
				
				,
				'oxx-' +
				'oox-' +
				'xox-'
			]
			
			,
			// Type 6
			[
				'xxx-' +
				'oox-' +
				'xoo-'
				
				,
				'xxo-' +
				'xoo-' +
				'xox-'
			]
			
			,
			// Type 7
			[
				'oo-' +
				'oo-'
			]
		];

		// -
		public static const TYPES:Array = p_get_sweetData_all();
	}
}
