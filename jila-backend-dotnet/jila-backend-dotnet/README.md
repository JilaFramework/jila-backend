#### What is this?

In line with current industry standards for performance and security, I have attempted to re-write the Jila back end using Microsoft's web framework ASP.NET, targeting .NET 5. The .NET 5 REST API is used as a transport layer for the Flutter mobile application located [here](https://github.com/JilaFramework/jila-mobile) and talks to a Strapi CMS. Strapi is a user-friendly, scalable, performant and secure CMS that provides awesome features out of the box, such as media management, including images, video and audio.

#### But we already have a back end why this?

.NET 5 and Microsoft .NET in general is performant and secure out of the box. It has been battled tested in Production for decades by larger fortune 500 companies and offers excellent performance and security.
	
#### Cool, so how do I get started?
You will require .NET 5 installed locally first, VS code or Visual Studio, either for Mac or Windows, paid or community version it does not matter (depending if you're an enterprise, otherwise please respect Microsoft's licensing rules).

###### Strapi CMS
	
You will also require a hosted version of Strapi, you can easily spin this up locally in Docker or host it for pennies on Heroku or DigitalOcean.
	
[Strapi getting started](https://strapi.io/documentation/developer-docs/latest/getting-started/quick-start.html)
	
###### Populating Strapi CMS with required fields/collections
	
At the moment for testing, this is the schema I have configured for Strapi (for the entries schema):

![[strapi-cms-fields.png]]
	
Refer to the above getting started guide to determine how to create a new collection that matches the above screenshot.
	
Ensure that you also set your newly created collection to 'public' for the find and find_one actions, so that you can retrieve records publicly, otherwise you will receive a 401 error.
	
You will also need the below schema for the about page information:

![[strapi-cms-fields-about-page.png]]
	
###### Configuring and running the API
	
Great, now Strapi is configured, simply navigate to the appsettings.Development.json file, and update the "STRAPI_ENDPOINT" variable to your locally or remotely accessible version of Strapi CMS.

Once you have done this, simple navigate to the root of the project and run `dotnet run` and the API should be running locally on `http://localhost:5000`
	
#### Future state/project goals
	
Ideally to stay in touch with the theme of low-code/no-code aspects of this solution, this can all be wrapped up in a custom 'deploy to Heroku' or something similar script so that less tech savvy users can get up and running with no custom configuration.
	
#### TODOs
	
As I wrote this entire stack by myself in two days, there is a bit of work to do before this could be considered production ready.
	
- General tidy up of code, more focus on DRY principals
- Move service endpoint URLs into env variables or config file
- If deployed in prod, consider making Strapi authenticated so that the API can pass creds to the Strapi endpoint for better security
- Determine what is needed in terms of a 'bootstrap' script, so this solution can ship as a single packaged solution, without any configuration needed