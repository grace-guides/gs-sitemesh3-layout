<!doctype html>
<html>
  <head>
    <title>SiteMesh layout: <sitemesh:write property="title"/></title>
    <sitemesh:write property="head"/>

    <asset:stylesheet src="application.css"/>
  </head>
  <body>

    <h2 class="fs-2">SiteMesh 3 page title: <sitemesh:write property="title"/></h2>

    <div class="col-12">
      <sitemesh:write property="body"/>
    </div>

    <div class="disclaimer">Sitemesh 3 layout footer. &copy<g:meta name="info.app.name" /> v<g:meta name="info.app.version" /></div>

  </body>
</html>