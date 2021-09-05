using System.Collections.Generic;
using System.Threading.Tasks;
using jila_backend_dotnet.Models;
using static jila_backend_dotnet.Services.EntriesService;

namespace jila_backend_dotnet.Services
{
    public interface IEntriesService
    {
        Task<List<EntriesModel>> GetEntriesAsync(EntriesCategories categories = default);
        Task<List<EntriesModel>> SearchWord(string searchWord);
    }
}
