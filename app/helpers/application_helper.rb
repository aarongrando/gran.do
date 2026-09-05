module ApplicationHelper
  def canonical_page_url
    paths = {
      "index" => "/", "resume" => "/resume", "nexus" => "/nexus",
      "geo" => "/geo", "launchpad" => "/launchpad", "mod_heat" => "/mod-heat"
    }
    "https://gran.do#{paths.fetch(action_name, request.path)}"
  end

  def page_structured_data(title:, description:)
    # content_for stores HTML-escaped strings; JSON needs their plain-text values.
    title = CGI.unescapeHTML(title.to_s)
    description = CGI.unescapeHTML(description.to_s)
    person_id = "https://gran.do/#aaron-grando"
    website_id = "https://gran.do/#website"
    page_url = canonical_page_url
    profile = %w[index resume].include?(action_name)

    person = {
      "@type" => "Person",
      "@id" => person_id,
      "name" => "Aaron Grando",
      "url" => "https://gran.do/",
      "sameAs" => ["https://www.linkedin.com/in/aarongrando"]
    }
    website = {
      "@type" => "WebSite",
      "@id" => website_id,
      "url" => "https://gran.do/",
      "name" => "Aaron Grando",
      "inLanguage" => "en",
      "publisher" => { "@id" => person_id }
    }
    page = {
      "@type" => profile ? "ProfilePage" : "WebPage",
      "@id" => "#{page_url}#webpage",
      "url" => page_url,
      "name" => title,
      "description" => description,
      "inLanguage" => "en",
      "isPartOf" => { "@id" => website_id },
      "mainEntity" => { "@id" => profile ? person_id : "#{page_url}#article" }
    }
    graph = [person, website, page]

    unless profile
      graph << {
        "@type" => "Article",
        "@id" => "#{page_url}#article",
        "url" => page_url,
        "headline" => CGI.unescapeHTML(content_for(:title).to_s),
        "description" => description,
        "inLanguage" => "en",
        "genre" => "Case study",
        "author" => { "@id" => person_id },
        "mainEntityOfPage" => { "@id" => "#{page_url}#webpage" }
      }
    end

    { "@context" => "https://schema.org", "@graph" => graph }
  end
end
