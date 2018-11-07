using System;
using System.Collections.Generic;
using System.Text;
using System.Threading.Tasks;

namespace FreeWheel.Movies.Services.Interfaces
{
    public interface IStoreService: IDisposable
    {
        Task<IEnumerable<T>> QueryAsync<T>(string command, object param = null);
        Task<int> Save<T>(T t) where T : class;
        Task<T> QueryFirst<T>(string command, object param = null);
    }
}
