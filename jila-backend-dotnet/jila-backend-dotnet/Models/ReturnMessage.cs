using System.Collections.Generic;

namespace jila_backend_dotnet.Models
{
    public class ReturnMessage
    {
        public List<EntriesModel> EntriesModels { get; set; }
        public string ErrorMessage { get; set; }
    }
}
