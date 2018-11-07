using Dapper.Contrib.Extensions;

namespace FreeWheel.Movies.Services.Model
{
    [Table("Movie")]
    public class Movie
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public int YearRelease { get; set; }
        public int RunningTime { get; set; }
        public string Genres { get; set; }
        public decimal AverageRating { get; set; }
    }
}
