using System.Linq;
using System.Threading.Tasks;
using jila_backend_dotnet.Services;
using Microsoft.AspNetCore.Mvc;


namespace jila_backend_dotnet.Controllers
{
    [Route("api/[controller]")]
    public class AboutPageController : Controller
    {
        private readonly IAboutPageService _aboutPageService;

        public AboutPageController(IAboutPageService aboutPageService)
        {
            _aboutPageService = aboutPageService;
        }

        [HttpGet]
        public async Task<IActionResult> Get()
        {
            var aboutPage = await _aboutPageService.GetAboutPageDetailsAsync();
            if(aboutPage != null)
            {
                return new JsonResult(aboutPage.ToList().FirstOrDefault());
            }

            return new JsonResult("There was an error fetching about page contents.") { StatusCode = 500 };
        }
    }
}
