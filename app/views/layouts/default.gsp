<!doctype html>
<html>
  <head>
    <title>SiteMesh default: <sitemesh:write property="title"/></title>
    <sitemesh:write property="head"/>

    <asset:stylesheet src="application.css"/>
  </head>
  <body>

  <div id="content" role="main">
    <div class="container">
      <section class="row">

        <h1 class="fs-1">SiteMesh default layout: <sitemesh:write property="title"/></h1>

        <sitemesh:write property="body"/>

        <div class="footer">Powered by Grace v<g:meta name="info.app.grailsVersion" /></div>

      </section>

    </div>
  </div>

  </body>
</html>