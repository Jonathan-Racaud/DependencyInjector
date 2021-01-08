using System;
using System.Collections;

namespace DependencyInjector
{
	public static class Injector
	{
		private static Dictionary<Type, Object> _singletons = new .() ~ delete _;
		private static Dictionary<Type, Type> _container = new .() ~ delete _;

		public static ~this()
		{
			for (var item in _singletons)
			{
				delete item.value;
			}
		}

		public static Result<void> Register<TType, TInstance>()
		{
			var type = typeof(TType);
			var instance = typeof(TInstance);

			_container.Add(type, instance);
			return .Ok;
		}

		public static Result<void> RegisterSingleton<TType, TInstance>()
			where TType: class
			where TInstance : class, new
		{
			var type = typeof(TType);
			var value = new TInstance();

			_singletons.Add(type, value);
			return .Ok;
		}

		public static Result<T, void> Get<T>() where T : class
		{
			let type = typeof(T);

			if (_container.ContainsKey(type))
			{
				let instanceType = _container[type];

				if (instanceType.CreateObject() case .Ok(let val))
				{
					return val as T;
				}
				else
				{
					Console.Error.WriteLine("Error creating object of type {}", instanceType);
					return .Err;
				}
			}

			if (_singletons.ContainsKey(type))
			{
				return _singletons[type] as T;
			}

			return .Err;
		}
	}
}
