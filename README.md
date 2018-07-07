# Jekyll::Gists::Meta

A simple plugin for Jekyll that makes a call to the GitHub GraphQL API v4 to collect metadata for a user's gists and store it in a json file (`gists-meta-data.json`) in the Jekyll site `data_dir`.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'jekyll-gists-meta', group: :jekyll-plugins
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install jekyll-gists-meta

Then add the following to your site's `_config.yml`:

```
plugins:
  - jekyll-gists-meta
```

## Usage

Because the GitHub GraphQL API requires an authorization token for access, you will need to ensure that the enviroment variable `JEKYLL_GITHUB_TOKEN` is set, i.e.

```
JEKYLL_GITHUB_TOKEN=<token string here>
```

in order for the query to work and make the metadata available.

By default the plugin will attempt to source a GitHub user login via the `github-metadata` plugin if installed. A user login may alternately be specified in the `_config.yml` file as `gists_user`. Any value here will supersede any value sourced from `github-metadata`.

The plugin will run when the server is started and create a JSON data file, `gists-meta-data.json`, of select GitHub metadata fields for a user's gists in the site's data directory, which is `./_data` by default. Gists appear in the file in descending order by creation date. The plugin overwrites any existing file of the same name.

Once the datafile is populated, you may access its contents within Jekyll using Liquid. For example, to list all gists in the file and linkify them:

```liquid
{% if site.data.gists-meta-data %}
  <section>
    <h2>Gists</h2>
    <ul>
      {% for myedge in site.data.gists-meta-data.data.user.gists.edges %}
        <li>
          <a href="https://gist.github.com/{{ myedge.node.name }}">{{myedge.node.description}}</a>
        </li>
      {% endfor %}
    </ul>
  </section>
{% endif %}
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jamesluberda/jekyll-gists-meta. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Jekyll::Gists::Meta project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/jamesluberda/jekyll-gists-meta/blob/master/CODE_OF_CONDUCT.md).
