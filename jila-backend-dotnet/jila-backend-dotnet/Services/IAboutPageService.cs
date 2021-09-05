using System.Collections.Generic;
using System.Threading.Tasks;
using jila_backend_dotnet.Models;

namespace jila_backend_dotnet.Services
{
    public interface IAboutPageService
    {
        Task<List<AboutPageModel>> GetAboutPageDetailsAsync();
    }
}
