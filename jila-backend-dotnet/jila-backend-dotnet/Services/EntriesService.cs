using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using jila_backend_dotnet.Models;
using Newtonsoft.Json;
using Microsoft.Extensions.Configuration;

namespace jila_backend_dotnet.Services
{
    public class EntriesService : IEntriesService
    {
        private readonly IHttpClientFactory _client;
        private readonly IConfiguration _config;
        private string STRAPI_ENDPOINT = string.Empty;

        public EntriesService(IHttpClientFactory client, IConfiguration config)
        {
            _client = client;
            _config = config;
            STRAPI_ENDPOINT = _config["STRAPI_ENDPOINT"];
        }

        public enum EntriesCategories
        {
            REPTILES,
            COMMON_PHRASES
        }

        public async Task<List<EntriesModel>> GetEntriesAsync(EntriesCategories categories = default)
        {
            var client = _client.CreateClient();

            HttpResponseMessage res = null;
            if(categories == EntriesCategories.COMMON_PHRASES)
            {
                res = await client.GetAsync(STRAPI_ENDPOINT + "/entries" + "?category=common_phrases");
            }
            else
            {
                res = await client.GetAsync(STRAPI_ENDPOINT + "/entries" + "?category=reptiles");
            }

            if (res.IsSuccessStatusCode)
            {
                return JsonConvert.DeserializeObject<List<EntriesModel>>(await res.Content.ReadAsStringAsync());
            }

            return null;
        }

        public async Task<List<EntriesModel>> SearchWord(string searchWord)
        {
            if(string.IsNullOrEmpty(searchWord))
            {
                return null;
            }

            var client = _client.CreateClient();
            HttpResponseMessage res = await client.GetAsync(STRAPI_ENDPOINT + "/entries" + $"?translation={searchWord}");

            if (res.IsSuccessStatusCode)
            {
                return JsonConvert.DeserializeObject<List<EntriesModel>>(await res.Content.ReadAsStringAsync());
            }

            return null;
        }
    }
}
