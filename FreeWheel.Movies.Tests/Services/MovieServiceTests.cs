using Xunit;
using FreeWheel.Movies.Services.Interfaces;
using FreeWheel.Movies.Services.Services;
using Moq;
using FreeWheel.Movies.Services.Model;
using System.Collections.Generic;
using System.Linq;
using FreeWheel.Movies.Tests.Utilities;

namespace FreeWheel.Movies.Tests
{
    public class MovieServiceTests
    {
        IMovieService _movieService;
        Mock<IStoreService> _mockStoreService = new Mock<IStoreService>();

        [Fact]
        public void Should_Return_Movies_By_Title()
        {
            _mockStoreService.SetupQuery(new List<Movie>() { new Movie()});
            _movieService = new MovieService(_mockStoreService.Object);
            var result = _movieService.GetMoviesByTitle("test");
            Assert.NotNull(result);
            Assert.True(result.Result.Any());
            _mockStoreService.Verify(x => x.QueryAsync<Movie>(It.IsAny<string>(), It.IsAny<object>()), Times.Once());
        }

        [Fact]
        public void Should_Return_Movies_By_Genre()
        {
            _mockStoreService.SetupQuery(new List<Movie>() { new Movie() });
            _movieService = new MovieService(_mockStoreService.Object);
            var result = _movieService.GetMoviesByGenre("comedy");
            Assert.NotNull(result);
            Assert.True(result.Result.Any());
            _mockStoreService.Verify(x => x.QueryAsync<Movie>(It.IsAny<string>(), It.IsAny<object>()), Times.Once());
        }

        [Fact]
        public void Should_Return_Movies_By_Year_Of_Release()
        {
            _mockStoreService.SetupQuery(new List<Movie>() { new Movie() });
            _movieService = new MovieService(_mockStoreService.Object);
            var result =  _movieService.GetMoviesByYearRelease(1998);
            Assert.NotNull(result);
            Assert.True(result.Result.Any());
            _mockStoreService.Verify(x => x.QueryAsync<Movie>(It.IsAny<string>(), It.IsAny<object>()), Times.Once());
        }

        [Fact]
        public void Should_Return_Movies_By_User_Id()
        {
            _mockStoreService.SetupQuery(new List<Movie>() { new Movie()});
            _movieService = new MovieService(_mockStoreService.Object);
            var result = _movieService.GetTopMoviesByUser(1);
            Assert.NotNull(result);
            Assert.True(result.Result.Any());
            _mockStoreService.Verify(x => x.QueryAsync<Movie>(It.IsAny<string>(), It.IsAny<object>()), Times.Once());
        }

        [Fact]
        public void Should_Return_Movies_Top_Ratings()
        {
            _mockStoreService.SetupQuery(new List<Movie>() { new Movie() });
            _movieService = new MovieService(_mockStoreService.Object);
            var result = _movieService.GetTopRatingMovies();
            Assert.NotNull(result);
            Assert.True(result.Result.Any());
            _mockStoreService.Verify(x => x.QueryAsync<Movie>(It.IsAny<string>(), It.IsAny<object>()), Times.Once());
        }

        [Fact]
        public void Should_Return_Top_Movies_By_Rating()
        {
            _mockStoreService.SetupQuery(new List<Movie>() { new Movie() });
            _movieService = new MovieService(_mockStoreService.Object);
            var result = _movieService.GetTopRatingMovies();
            Assert.NotNull(result);
            Assert.True(result.Result.Any());
            _mockStoreService.Verify(x => x.QueryAsync<Movie>(It.IsAny<string>(), It.IsAny<object>()), Times.Once());
        }
    }
}
