# Stein

Stein is a super simple robot framework to automate the tasks that I do not like
doing. 'Stein, get it? Like Franken-stein? Hah, ok nvm. You write 'robots' and
execute them within the Stein framework.

The goal is to create robots with a readable set of instructions / code.

At the moment, I'm automating my tasks with following platforms:

* ClientExec
* Wordpress
* InfiniteWP

Since these integrations are all through the browser, I'm using the awesome
watir and webdrivers gems!

I also suck at documentation, so... there's that too :)

## Installation

Install it yourself:

    $ gem install stein

Then... write your robot.

## Usage

If I wrote a robot called sendinvoices.rb, you can start this robot in the
following manner.

```ruby
ruby bin/stein.rb --robot=example.rb
```

I use rbenv, so I tend to use it as follows:

```ruby
rbenv exec ruby bin/stein.rb --robot=example.rb
```

### Building robots

See the example.rb file to see the framework.

A few notes though...
* Install the 'dotenv' gem for any usernames and passwords

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).


### Todo

[ ] RSpec tests
[ ] Check email

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rsmacapinlac/stein. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Stein project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rsmacapinlac/stein/blob/master/CODE_OF_CONDUCT.md).
