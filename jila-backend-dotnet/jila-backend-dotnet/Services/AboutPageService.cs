using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using jila_backend_dotnet.Models;
using Newtonsoft.Json;
using Microsoft.Extensions.Configuration;

namespace jila_backend_dotnet.Services
{
    public class AboutPageService : IAboutPageService
    {
        private readonly IHttpClientFactory _client;
        private readonly IConfiguration _config;
        private string STRAPI_ENDPOINT = string.Empty;

        public AboutPageService(IHttpClientFactory client, IConfiguration config)
        {
            _client = client;
            _config = config;
            STRAPI_ENDPOINT = _config["STRAPI_ENDPOINT"]; 
        }

        public async Task<List<AboutPageModel>> GetAboutPageDetailsAsync()
        {
            var client = _client.CreateClient();
            var res = await client.GetAsync(STRAPI_ENDPOINT + "/about-pages");

            if(res.IsSuccessStatusCode)
            {
                return JsonConvert.DeserializeObject<List<AboutPageModel>>(await res.Content.ReadAsStringAsync());
            }

            return null;
        }
    }
}
