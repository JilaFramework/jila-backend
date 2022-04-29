using System.Collections.Generic;
using System.Net.Http;
using System.Threading.Tasks;
using jila_backend_dotnet.Models;
using Newtonsoft.Json;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;

namespace jila_backend_dotnet.Services
{
    /// <summary>
    /// Fetchs "Entries" array from Strapi CMS endpoints.
    /// </summary>
    public class EntriesService : IEntriesService
    {
        private readonly IHttpClientFactory _client;
        private readonly IConfiguration _config;
        private string STRAPI_ENDPOINT = string.Empty;
        private readonly ILogger<EntriesService> _logger;

        public EntriesService(IHttpClientFactory client, IConfiguration config,
                              ILogger<EntriesService> logger)
        {
            _client = client;
            _config = config;
            STRAPI_ENDPOINT = _config["STRAPI_ENDPOINT"];
            _logger = logger;
        }

        public enum EntriesCategories
        {
            REPTILES,
            COMMON_PHRASES
        }

        /// <summary>
        /// Fetchs all or some entries from Strapi CMS depending on <see cref="EntriesCategories"/>
        /// </summary>
        /// <param name="categories"> Define what to filter search on. </param>
        /// <returns> List of <see cref="EntriesModel"/> </returns>
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

            _logger.LogError($"Failed to return successful response from Strapi {nameof(GetEntriesAsync)} endpoint. Response code: {res.StatusCode} - Response message: {await res.Content?.ReadAsStringAsync()}");
            return null;
        }

        /// <summary>
        /// Search a single word or phrase from <see cref="EntriesModel"/>
        /// </summary>
        /// <param name="searchWord"></param>
        /// <returns><see cref="EntriesModel"/></returns>
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

            _logger.LogError($"Failed to return successful response from Strapi {nameof(SearchWord)} endpoint. Response code: {res.StatusCode} - Response message: {await res.Content?.ReadAsStringAsync()}");
            return null;
        }
    }
}
