using Dapper.Contrib.Extensions;

namespace FreeWheel.Movies.Services.Model
{
    [Table("Rating")]
    public class Rating
    {
        [Key]
        public int RatingId { get; set; }
        public int MovieId { get; set; }
        public int UserId { get; set; }
        public int Value { get; set; }
    }
}
