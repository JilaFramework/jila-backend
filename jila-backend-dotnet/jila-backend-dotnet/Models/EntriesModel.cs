using System;
namespace jila_backend_dotnet.Models
{
    public class Audio
    {
        public int id { get; set; }
        public string name { get; set; }
        public string alternativeText { get; set; }
        public string caption { get; set; }
        public object width { get; set; }
        public object height { get; set; }
        public object formats { get; set; }
        public string hash { get; set; }
        public string ext { get; set; }
        public string mime { get; set; }
        public double size { get; set; }
        public string url { get; set; }
        public object previewUrl { get; set; }
        public string provider { get; set; }
        public object provider_metadata { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
    }

    public class EntriesModel
    {
        public int id { get; set; }
        public string entry_word { get; set; }
        public string word_type { get; set; }
        public string translation { get; set; }
        public object alternate_translations { get; set; }
        public object alternate_spellings { get; set; }
        public string description { get; set; }
        public string image_thumbnail { get; set; }
        public string image_full { get; set; }
        public DateTime published_at { get; set; }
        public DateTime created_at { get; set; }
        public DateTime updated_at { get; set; }
        public string category { get; set; }
        public Audio audio { get; set; }
    }
}
