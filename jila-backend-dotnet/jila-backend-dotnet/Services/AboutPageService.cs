using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using jila_backend_dotnet.Models;
using Newtonsoft.Json;

namespace jila_backend_dotnet.Services
{
    public class AboutPageService : IAboutPageService
    {
        private readonly IHttpClientFactory _client;
        private string STRAPI_ENDPOINT = "http://strapi.home/about-pages";

        public AboutPageService(IHttpClientFactory client)
        {
            _client = client;
        }

        public async Task<List<AboutPageModel>> GetAboutPageDetailsAsync()
        {
            var client = _client.CreateClient();
            var res = await client.GetAsync(STRAPI_ENDPOINT);

            if(res.IsSuccessStatusCode)
            {
                return JsonConvert.DeserializeObject<List<AboutPageModel>>(await res.Content.ReadAsStringAsync());
            }

            return null;
        }
    }
}
