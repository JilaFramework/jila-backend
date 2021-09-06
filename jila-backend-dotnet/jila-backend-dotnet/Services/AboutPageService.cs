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
    /// Returns info to draw about page tabs in app
    /// </summary>
    public class AboutPageService : IAboutPageService
    {
        private readonly IHttpClientFactory _client;
        private readonly IConfiguration _config;
        private string STRAPI_ENDPOINT = string.Empty;
        private readonly ILogger<AboutPageService> _logger;

        public AboutPageService(IHttpClientFactory client, IConfiguration config,
                                ILogger<AboutPageService> logger)
        {
            _client = client;
            _config = config;
            STRAPI_ENDPOINT = _config["STRAPI_ENDPOINT"];
            _logger = logger;
        }

        /// <summary>
        /// Returns info to draw about page tabs in app
        /// </summary>
        /// <returns>an array of information from Strapi CMS /about-pages endpoint. <see cref="AboutPageModel"/></returns>
        public async Task<List<AboutPageModel>> GetAboutPageDetailsAsync()
        {
            var client = _client.CreateClient();
            var res = await client.GetAsync(STRAPI_ENDPOINT + "/about-pages");

            if(res.IsSuccessStatusCode)
            {
                return JsonConvert.DeserializeObject<List<AboutPageModel>>(await res.Content.ReadAsStringAsync());
            }

            _logger.LogError($"Failed to return successful response from Strapi {nameof(GetAboutPageDetailsAsync)} endpoint. Response code: {res.StatusCode} - Response message: {await res.Content?.ReadAsStringAsync()}");
            return null;
        }
    }
}
