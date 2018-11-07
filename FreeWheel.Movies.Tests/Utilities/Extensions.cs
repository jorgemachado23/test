using FreeWheel.Movies.Services.Interfaces;
using FreeWheel.Movies.Services.Model;
using Moq;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace FreeWheel.Movies.Tests.Utilities
{
    public static class Extensions
    {
        public static Mock<IStoreService> SetupQuery(this Mock<IStoreService> mockService, IEnumerable<Movie> movies)
        {
            mockService.Setup(s => s.QueryAsync<Movie>(It.IsAny<string>(), It.IsAny<object>()))
                        .Returns(Task.FromResult(movies));
            return mockService;
        }

        public static Mock<IMovieService> SetupMoviesByTitle(this Mock<IMovieService> mockMovieService, IEnumerable<Movie> movies)
        {
            mockMovieService.Setup(rep => rep.GetMoviesByTitle(It.IsAny<string>()))
                            .Returns(Task.FromResult<IEnumerable<Movie>>(movies));
            return mockMovieService;
        }
    }
}
