# GSP layouts with Sitemesh 3

Grails use [SiteMesh 2.4.2](https://github.com/sitemesh/sitemesh2) as a decorator engine to support view layouts.

[Grace](https://github.com/graceframework/grace-framework) is a fork of Grails 5, version 2022.1.0 has been released last month.

This guide walks you through the process of creating a "Hello World" site, and integrate SiteMesh 3.1.0 with your Grace app.

### Creating a new app

```bash
grace create-app grace.guides.gs-sitemesh3-layout
```

Grace will generate a web app for you as below,

```base
.
├── app
│   ├── assets
│   ├── conf
│   ├── controllers
│   ├── domain
│   ├── i18n
│   ├── init
│   ├── services
│   ├── taglib
│   ├── utils
│   └── views
├── gradle
│   └── wrapper
├── src
│   ├── integration-test
│   ├── main
│   └── test
├── README.md
├── build.gradle
├── gradle.properties
├── gradlew
├── gradlew.bat
└── settings.gradle

```

### Installing SiteMesh 3

Grace is a framework built on Spring Boot, so it could use SiteMesh starter just as you using Spring Boot.

Add `spring-boot-starter-sitemesh` to your build.gradle,

```gradle
dependencies {
    // ... other dependencies
    implementation "org.sitemesh:spring-boot-starter-sitemesh:3.1.0"
}
```

### Creating a decorator

Create the file `decorator.html` in your web-app `src/webapp/decorators`, containing:

```html
<html>
  <head>
    <title>SiteMesh example: <sitemesh:write property="title"/></title>
    <style>
      /* Some CSS */
     body { font-family: arial, sans-serif; background-color: #ffffcc; }
     h1, h2, h3, h4 { text-align: center; background-color: #ccffcc;
                      border-top: 1px solid #66ff66; }
     .mainBody { padding: 10px; border: 1px solid #555555; }
     .disclaimer { text-align: center; border-top: 1px solid #cccccc;
                   margin-top: 40px; color: #666666; font-size: smaller; }
    </style>
    <sitemesh:write property="head"/>
  </head>
  <body>

    <h1 class="title">SiteMesh example site: <sitemesh:write property="title"/></h1>

    <div class="col-12">
      <sitemesh:write property="body"/>
    </div>

    <div class="disclaimer">Site disclaimer. This is an example.</div>

  </body>
</html>
```

In this example, the decorator is a static `.html` file, but we will show you how to use GSP as decorator later.

### Creating some content

Create `hello.html` in the `src/webapp`, this is very simple plain HTML content,

```html
<html>
  <head>
    <title>Hello World</title>
    <meta name="description" content="A simple page">
  </head>
  <body>
    <p>Hello <strong>world</strong>!</p>
  </body>
</html>
```

### The result

Now let's run the app,

```bash
./gradlew bootRun
```

Open the browser `http://localhost:8080/hello.html`, you will see the result,

```html
<html>
  <head>
    <title>SiteMesh example: Hello World</title>
    <style>
      /* Some CSS */
     body { font-family: arial, sans-serif; background-color: #ffffcc; }
     h1, h2, h3, h4 { text-align: center; background-color: #ccffcc;
                      border-top: 1px solid #66ff66; }
     .mainBody { padding: 10px; border: 1px solid #555555; }
     .disclaimer { text-align: center; border-top: 1px solid #cccccc;
                   margin-top: 40px; color: #666666; font-size: smaller; }
    </style>
    
    
    <meta name="description" content="A simple page">
  
  </head>
  <body>

    <h1 class="title">SiteMesh example site: Hello World</h1>

    <div class="mainBody">
      
    <p>Hello <strong>world</strong>!</p>
  
    </div>

    <div class="disclaimer">Site disclaimer. This is an example.</div>

  </body>
</html>
```

### Creating a Controller

Execute the `create-controller` command to create a controller `DemoController`, 

```bash
grace create-controller Demo
```

```groovy
package grace.guides

class DemoController {

    def index() { }

    def list() { }

    def show() { }

}
```

Then create three GSP views `index.gsp`, `list.gsp`, `show.gsp` for `DemoController` in `app/views`.

### Creating a GSP decorator

```html
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
```

### Creating a taglib

The `<sitemesh:write property="..."/>` tag will be rewritten by SiteMesh to include properties extracted from the content. But the `<sitemesh:write/>` tags is not exist in GSP, so we should create a taglib for it.

```groovy
package grace.guides

class SitemeshTagLib {

    static namespace = 'sitemesh'
    static defaultEncodeAs = [taglib:'none']

    Closure write = { attrs ->
        def property = attrs.property
        out << "<sitemesh:write property=\"$property\" />"
    }

}
```

### Configuring Sitemesh 3

In the `app/conf/application.yml`, I change the `sitemesh.decorator.prefix` (default: `/decorators/`) to `/layouts/`, because GSP use `app/views/layouts` as the default layout directory.

I also add some mappings for the `/demo` path as below.

- `/demo/` and `/demo/index` will use decorator `sitemesh.gsp`,
- `/demo/list` will use chained decorators `sitemesh.gsp` and `default.gsp`,
- `/demo/show` will use SiteMesh 2 decorator `main.gsp`.

```
sitemesh:
  decorator:
    prefix: /layouts/
    metaTag: decorator
    exclusions: /assets/*
    mappings:
      - path: /demo/
        decorator: sitemesh.gsp
      - path: /demo/index
        decorator: sitemesh.gsp
      - path: /*.html
        decorator: decorator.html
```

### Running and Checking

```bash
./gradlew bootRun
```

Also you can run in the production,

```bash
$ ./gradlew assemble -Dgrails.env=dev
$ cd build/libs
$ java -jar gs-sitemesh3-layout-0.0.1-SNAPSHOT.war
```

## Why use SiteMesh 3?

> SiteMesh 3 has been completely rebuilt from the ground up. It's more efficient, easier to use and extensible. While the code is new, it still holds the same values of SiteMesh 2, namely simplicity, robustness and performance.

If you'd like to learn more about SiteMesh 3, check it out [here](https://github.com/sitemesh/sitemesh3/tree/master?tab=readme-ov-file#sitemesh-3-overview).

Grace plans to release in [2022.6.x](https://github.com/graceframework/grace-framework/wiki/Roadmap#20226x) with full support for SiteMesh 3, providing the same functionality as SiteMesh 2.

## Links

- [Grace Framework](https://github.com/graceframework/grace-framework)
- [Grace SiteMesh 3 Layout Guide](https://github.com/grace-guides/gs-sitemesh3-layout)
- [SiteMesh 3](https://github.com/sitemesh/sitemesh3/)
