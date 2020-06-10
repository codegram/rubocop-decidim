# frozen_string_literal: true

RSpec.describe RuboCop::Cop::Decidim::TranslatedAttribute do
  subject(:cop) { described_class.new(config) }

  let(:config) { RuboCop::Config.new }

  it 'registers an offense when using `#translated_attribute(resource)`' do
    expect_offense(<<~RUBY)
      translated_attribute(resource)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#translated(resource, :field)` instead of `#translated_attribute(resource.field)`.
    RUBY
  end

  it 'registers an offense when using `#translated_attribute(resource.field)`' do
    expect_offense(<<~RUBY)
      translated_attribute(resource.field)
      ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ Use `#translated(resource, :field)` instead of `#translated_attribute(resource.field)`.
    RUBY
  end

  it 'autocorrects `#translated_attribute(resource.field)` to `#translated(resource, :field)`' do
    expect(
      autocorrect_source('translated_attribute(resource.field)')
    ).to eq('translated(resource, :field)')
  end

  it 'autocorrects `#translated_attribute(a.b.c.d.e)` to `#translated(a.b.c.d, :e)`' do
    expect(
      autocorrect_source('translated_attribute(resource.field)')
    ).to eq('translated(resource, :field)')
  end

  it 'does not autocorrect `#translated_attribute(resource)`' do
    expect(
      autocorrect_source('translated_attribute(resource)')
    ).to eq('translated_attribute(resource)')
  end

  it 'does not register an offense when using `#translated`' do
    expect_no_offenses(<<~RUBY)
      translated(resource, :field)
    RUBY
  end
end
