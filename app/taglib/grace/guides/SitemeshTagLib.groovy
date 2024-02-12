package grace.guides

class SitemeshTagLib {

    static namespace = 'sitemesh'
    static defaultEncodeAs = [taglib:'none']

    Closure write = { attrs ->
        def property = attrs.property
        out << "<sitemesh:write property=\"$property\" />"
    }

}
