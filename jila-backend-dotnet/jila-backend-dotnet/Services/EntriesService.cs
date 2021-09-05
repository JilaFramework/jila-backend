using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using jila_backend_dotnet.Models;
using Newtonsoft.Json;

namespace jila_backend_dotnet.Services
{
    public class EntriesService : IEntriesService
    {
        private readonly IHttpClientFactory _client;
        private string STRAPI_ENDPOINT = "http://strapi.home/entries";

        public EntriesService(IHttpClientFactory client)
        {
            _client = client;
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
                res = await client.GetAsync(STRAPI_ENDPOINT + "?category=common_phrases");
            }
            else
            {
                res = await client.GetAsync(STRAPI_ENDPOINT + "?category=reptiles");
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
            HttpResponseMessage res = await client.GetAsync(STRAPI_ENDPOINT + $"?translation={searchWord}");

            if (res.IsSuccessStatusCode)
            {
                return JsonConvert.DeserializeObject<List<EntriesModel>>(await res.Content.ReadAsStringAsync());
            }

            return null;
        }
    }
}
