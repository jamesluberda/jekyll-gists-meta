# frozen_string_literal: true

# this started out as a Generator, but I quickly realized that
# the processing of the data directory takes place before any
# generators run, thus recast it with an after_init hook

# see how github-metadata fails gracefully when it cannot reach github

require "jekyll/gists/meta/version"
require "net/http"

NoUserError = Class.new(Jekyll::Errors::FatalException)
NoTokenError = Class.new(Jekyll::Errors::FatalException)
NoDataDirError = Class.new(Jekyll::Errors::FatalException)

module Jekyll
  module Gists
    module Meta
      class << self
        def generate(site)
          validate_environment(site)
          filename = "gists-meta-data.json"
          file = File.new(File.join(site.config["data_dir"], filename), "w")
          file.write fetch_data(build_gists_query(site))
          file.close
        end

        private

        def validate_environment(site)
          if ENV["JEKYLL_GITHUB_TOKEN"].to_s.empty?
            raise NoTokenError, "No GitHub Token found. Cannot query the API. " \
                                "Specify JEKYLL_GITHUB_TOKEN in environment."
          end
          unless Dir.exist?(site.config["data_dir"])
            raise NoDataDirError, "Data directory does not exist. Jekyll reports " \
                                  "directory should be: #{site.config["data_dir"]}."
          end
        end

        def fetch_data(query)
          url = "https://api.github.com/graphql"
          uri = URI(url)
          Net::HTTP.start(uri.host, uri.port,
                          :use_ssl => uri.scheme == "https",
                          :read_timeout => 3, :open_timeout => 3) do |http|
                            request = Net::HTTP::Post.new uri.to_s
                            request.add_field "Authorization", \
                                              "bearer #{ENV["JEKYLL_GITHUB_TOKEN"]}"
                            request.body = query
                            response = http.request(request)
                            response.body
                          end
        rescue Timeout::Error, SocketError, Net::HTTPError
          nil
        end

        # rubocop:disable Metrics/MethodLength
        def build_gists_query(site)
          user = find_user(site)
          query = +<<-ENDQUERY
            {
              "query":  "query {
                user (login: #{user} ) {
                  gists (first: 100, orderBy: {field: CREATED_AT, direction: DESC} ) {
                    edges {
                      node {
                        comments (first: 100) {
                          totalCount
                        }
                        createdAt
                        description
                        isPublic
                        name
                        pushedAt
                        stargazers (first: 100) {
                          totalCount
                        }
                        updatedAt
                      }
                    }
                  }
                }
              }"
            }
          ENDQUERY
          query.tr!("\n", " ").freeze
        end
        # rubocop:enable Metrics/MethodLength

        # rubocop:disable Style/MultilineTernaryOperator
        def find_user(site)
          site.config["gists_user"] || \
            (site.config.has_key?("github") ? \
            site.config["github"]["contributors"][0]["login"] : nil) || \
            proc do
              raise NoUserError, "No user name found. " \
                                 "Specify using 'gists_user' in your configuration, " \
                                 "or ensure the github-metadata gem is installed. "
            end.call
        end
        # rubocop:enable Style/MultilineTernaryOperator
      end
    end
  end
end

Jekyll::Hooks.register :site, :after_init, :priority => :low do |site|
  Jekyll.logger.debug "Jekyll-Gists-Meta:", \
                      "Generating gists data file in #{site.config["data_dir"]}"
  Jekyll::Gists::Meta.generate(site)
end
