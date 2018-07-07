# frozen_string_literal: true

RSpec.describe Jekyll::Gists::Meta do
  it "has a version number" do
    expect(Jekyll::Gists::Meta::VERSION).not_to be nil
  end
end
