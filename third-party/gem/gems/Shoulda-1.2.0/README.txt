Shoulda
    by Tammer Saleh, Thoughtbot, Inc.
    http://thoughtbot.com/projects/shoulda

== DESCRIPTION:
  
The Shoulda gem makes it easy to write elegant, understandable, and maintainable tests. Shoulda consists of test macros, assertions, and helpers added on to the Test::Unit framework. It's fully compatible with your existing tests, and requires no retooling to use.  Should also comes with a complimentary Rails plugin, available here - http://thoughtbot.com/projects/shoulda

== FEATURES/PROBLEMS:
  
* wrap your tests in nested context blocks to keep them readable and dry
* write test names in english, not with_a_bunch_of_underscores
* fully compatible with your existing Test::Unit tests
* makes writing test macros simple as pie

== SYNOPSIS:

  class UserTest << Test::Unit 
    context "A User instance" do
      setup do
        @user = User.find(:first)
      end

      should "return its full name" do
        assert_equal 'John Doe', @user.full_name
      end

      context "with a profile" do
        setup do
          @user.profile = Profile.find(:first)
        end

        should "return true when sent #has_profile?" do
          assert @user.has_profile?
        end
      end
    end
  end

== REQUIREMENTS:

* Test::Unit

== INSTALL:

* sudo gem install shoulda

== LICENSE:

Copyright (c) 2007 Tammer Saleh, Thoughtbot, Inc.

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
'Software'), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
