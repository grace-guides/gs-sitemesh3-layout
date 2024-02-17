package grace.guides;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import org.sitemesh.grails.plugins.sitemesh3.GrailsLayoutHandlerMapping;

@Configuration(proxyBeanMethods = false)
public class SiteMeshConfiguration {

    @Bean
    public GrailsLayoutHandlerMapping grailsLayoutHandlerMapping() {
        return new GrailsLayoutHandlerMapping();
    }
}
