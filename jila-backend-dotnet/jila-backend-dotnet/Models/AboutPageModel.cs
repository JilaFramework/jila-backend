using System;
namespace jila_backend_dotnet.Models
{
    public class AboutPageModel
    {
        public int id { get; set; }
        public string AboutUs { get; set; }
        public string ContactUs { get; set; }
        public string Partners { get; set; }
        public DateTime published_at { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
    }
}
