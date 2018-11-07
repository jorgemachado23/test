using FreeWheel.Movies.Api.Controllers;
using FreeWheel.Movies.Services.Interfaces;
using FreeWheel.Movies.Services.Model;
using FreeWheel.Movies.Tests.Utilities;
using Moq;
using System.Collections.Generic;
using Xunit;

namespace FreeWheel.Movies.Tests.Controllers
{
    public class MovieControllerTests
    {
        Mock<IMovieService> _movieService = new Mock<IMovieService>();

        [Fact]
        public void Should_Verify_Get_Movies_By_Title()
        {
            _movieService.SetupMoviesByTitle(new List<Movie>() { new Movie() });
            var controller = new MoviesController(_movieService.Object);
            //todo: finish controller tests
        }
    }

}
