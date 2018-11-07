using FreeWheel.Movies.Services.Interfaces;
using System.Collections.Generic;
using System.Data;
using System.Threading.Tasks;
using Dapper;
using Dapper.Contrib.Extensions;
using System;

namespace FreeWheel.Movies.Services.Services
{
    public class StoreService : IStoreService
    {
        readonly IDbConnection _connection;
        
        public StoreService(IDbConnection connection)
        {
            _connection = connection;
            _connection.Open();
        }
        
        public virtual Task<IEnumerable<T>> QueryAsync<T>(string command, object param = null)
        {
            return _connection.QueryAsync<T>(command, param);
        }

        public virtual Task<T> QueryFirst<T>(string command, object param = null)
        {
            return _connection.QuerySingleOrDefaultAsync<T>(command, param);
        }

        public virtual Task<int> Save<T>(T t) where T : class
        {
            return _connection.InsertAsync(t);
        }

        protected virtual void Dispose(bool dispose)
        {
            if (!dispose)
                return;

            _connection.Close();
            _connection.Dispose();
        }

        public void Dispose()
        {
            Dispose(true);
            GC.SuppressFinalize(this);
        }
    }
}
