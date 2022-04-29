using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using jila_backend_dotnet.Models;
using jila_backend_dotnet.Services;
using Microsoft.AspNetCore.Mvc;


namespace jila_backend_dotnet.Controllers
{
    [Route("api/[controller]")]
    public class EntriesController : Controller
    {
        private readonly IEntriesService _entriesService;

        public EntriesController(IEntriesService entriesService)
        {
            _entriesService = entriesService;
        }

        [HttpGet]
        public async Task<IActionResult> Get([FromQuery] string category)
        {
            List<EntriesModel> entries = null;
            switch (category)
            {
                case "common_phrases":
                    entries = await _entriesService.GetEntriesAsync(EntriesService.EntriesCategories.COMMON_PHRASES);
                    break;
                case "reptiles":
                    entries = await _entriesService.GetEntriesAsync(EntriesService.EntriesCategories.REPTILES);
                    break;
                default:
                    entries = await _entriesService.GetEntriesAsync();
                    break;
            }

            if (entries == null || entries.Count < 1)
            {
                return new JsonResult(new ReturnMessage() { EntriesModels = null, ErrorMessage = "Failed to retrieve entries." });
                
            }

            return new JsonResult(new ReturnMessage() { EntriesModels = entries, ErrorMessage = string.Empty });
        }

        [HttpGet]
        [Route("SearchWord")]
        public async Task<IActionResult> SearchWord([FromQuery] string word)
        {
            if(string.IsNullOrEmpty(word))
            {
                return BadRequest("Missing word param.");
            }

            List<EntriesModel> entries = await _entriesService.SearchWord(word);

            if (entries == null || entries.Count < 1)
            {
                return new JsonResult(new ReturnMessage() { EntriesModels = null, ErrorMessage = "Failed to retrieve entries." });

            }

            return new JsonResult(new ReturnMessage() { EntriesModels = entries, ErrorMessage = string.Empty });
        }
    }
}
