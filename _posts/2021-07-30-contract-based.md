---
layout: post
title:  Let's talk contract-based
date:   "2021-07-26"
categories: software development contract based end to end testing elixir ruby
---
But first let's talk dirty about testing 🐛

Why do we need them? What are they? Which types are they? Why the !$@* should I write them every time I develop something new?

Moreover why should I take care of the existing ones regarding old code. This case is the worst one if the logic is hard to understand... 🤦 

If you want to get the grasp about why this is important please read
[Clean Code: A Handbook of Agile Software Craftsmanship][clean-code]
from Robert C. Martin. Research a bit about the scout rule inside the book.

Moreover if you feel like you need more knowledge for tackling big legacy code please read [Working Effectively with Legacy Code][legacy-code] from Michael Feathers.

## What is a test 🤔

A test is a reusable code from your application which returns the same result over and over again. This means tests are idempotent, it doesn't matter how many times you run the test suite from your service.

The result from running your tests the first time and the 147092380th time should be the exact same result ✅. If the test suite fails 🚫 at the 10th run it means you have a 🐛 somewhere. This bug might be related to concurrency, shadowing, etc you name it 🤷

There are lot of programming languages and lots of testing frameworks. Let's illustrate one simple test making use of one of the best testing frameworks out there from [Ruby programming language][Ruby]. The framework from this example is [Rspec][Rspec]. The following code should give you a more detailed example 😄:

![rspec](/images/contract-based/rspec.png)

## Why do we need testing 👮

Lets expose a possible scenario where you can end up being. This scenario isn't true luckily for Coverwallet developers 🚀 Our mental health is relieved to not be in this scenario 🤣 Let's see how many of you can echo or feel that had been in this situation 💀

Imagine entering a new job. All the software tooling you are surrounded with, it's the one you are familiar with. You have all the technical knowledge required to work with the stack. Although the codebase has around 3000 lines of code. Moreover, no testing can be found. The documentation you are striving for is shinning by its absence.

Now that you are inside the company you are in charge of the huge codebase they have. They ask you to implement some new business logic into the bright new codebase you have now inherited.

What are you going to do now? How will you deliver new business logic? How can you be sure that the new logic is not going to have side effects? Are you confident enough to deliver the required new business logic without testing?

Your software developer guts already are telling you to start things slow and steady. This means to start writing tests for the side business logic affected by this new requirement. You have the approval from product to spend some huge extra time doing this task. We will focus in this first test existing behavior from the existing codebase.

Now that we have a firm determination towards the creation of a healthy codebase. How are we going to do it? 🤷 

First of all let's talk a bit on which types of testing we have. Let's just talk about the mainstream tests used among all developers.

## Which types of testing there are? 🤔

There are three types of testing you can develop taken into account always your use case. We will give a brief explanation about all of them.

### Unit testing

This type of testing focus on the smallest parts of your codebase. Most commonly the public functions you expose into your public service behaviors.

### Integration testing

The integration testing aims to check for more than one layer of dependency inside your codebase. All external requests into any dependency like another service, or a database. As the dependencies can have latency this kind of testing might run a lot slower compared to unit testing.

### End to end testing or functional

This last tests can be seen as chained integration testing. The focus of this testing is to check your whole application works as expected. Checking everything you can pull the thread from one end into the start.

You can think an example of this testing as tests which checks app the user interface any user can make use of. The goal of this testing is to actually corroborate that the end user can perform what she wants.

## How am I going to test it? 😓

Now it's time to decide how we want to test the existing huge codebase we have to maintain. Te new business request involves some changes in an existing endpoint from the service.

To test this existing code we would follow the London TDD approach. I know we have already the code and how TDD clashes with existing code. If you want to learn more about London TDD approach you can checkout: [blog post][TDD]. Moreover to learn more about TDD you can check the video: [TDD, Where Did It All Go Wrong][TDD-Where-Did-It-All-Go-Wrong] or the book: [Test Driven Development: By Example][Test-Driven-Development:-By-Example] from Kent Beck.

To wrap up the important thing we want to highlight from the London TDD approach is to test from the outside in. Test things from the outside of the service towards the business logic into the core.

## Service example

Let's give an example on how is the existing service. Although I would just highlight the code we are going to work with. This will make it somewhat easier as the goal of this post is to learn how to test making use of a type of mocks.

The service we have inherited is in charge of dealing with the adoption of animals from a local shelter. The service is a [Phoenix][Phoenix] application which makes use of [Elixir programing language][Elixir].

The first and only part we will start testing is for the adoption of an animal from the foster local shelter. 

## Elixir coding example

This is the sample code from the controller file: `lib/foster_shelter_bigotitos_web/controllers/animal_controller.ex`

![controller_generator](/images/contract-based/controller_generator.png)

This code is a piece of smelly cheese as you all can see. All the logic is inside the controller from the [Phoenix][Phoenix] application. Although we will try to test the existing code making a segregation from the different layers we have in the shown example.

## Lets start testing! 🚀

The code we want to test is a request into our server. Lets see from the available routes which is the path for the request:

![controller_generator](/images/contract-based/phx_routes.png)

As we can see [Phoenix][Phoenix] works with paths: `animal_path` is the only path we will be interested in. Both PATCH and PUT HTTP requests go through the same controller update/2 method. Now that we now how the users enter our service lets test the controller from the service.

### Testing errors from controller - Green

In this first approach we will test the existing behavior from the controller. It doesn't matter the parameters from the shelter animal from the adoption request. The only important thing from the actual adoption request is the customer email. This information will allow us to retrieve all the customer information from the service. If we can't make this relationship the adoption request will fail.

I have put as an example below a possible testing suite which more less fits the actual behavior from the legacy codebase we have inherited. The code needed for this test suite is massive. Moreover we need to actually create the database items for the controller testing. This means we have database dependency inside our testing suite.

There is a lot of code from the actual test suite which is screaming to be moved out of this context. The way a test needs to be structured, all the dependencies it requires it will also tell you where it really needs to be. Without further ado check in the example below a simple testing for this legacy codebase. 

![test_controller_generator](/images/contract-based/test_controller_generators.png)

### Refactor

If we were following TDD now would be a good time to apply the refactor step. In a proper TDD flow we would have done this tests first (red step). Afterwards we would have done the implementation for the behavior (green step). Finally we would follow a last refactor step. 

We have the confidence from the fresh new tests to back our refactor approaches. We have now captured all the tests from the controller from the service. Now would be a good opportunity to move all that fat logic away from the controller and put it somewhere else.

This step will involve the creation of a new test suite regarding the required business logic which is actually not fully being tested right now. If we see the logic from the controller the only thing being displayed is the animal being adopted. On the other hand if we do not find the user we retrieve a nil which the controller then parses into a error tuple.

#### Special refactor step

In this special case we already have the logic we need to move from the controller into a new module. In one hand we could move the logic from the controller into a new module and check if controller tests had been broken. On the other hand we can define the test suite covering the new module containing all the moved logic.

I prefer to do the latter option so lets define the test suite. This suite is going to cover the logic from the adoption request from our foster shelter.

![action_logic_test](/images/contract-based/action_logic_test.png)

#### Real refactor step

Lets move all the logic from the controller into another module keeping all the behavior as expected already being tested in the previous test suite.

![action_logic](/images/contract-based/action_logic.png)

After running the previously created for the new module we can see the behavior has been captured.

![check_testing_action](/images/contract-based/check_testing_action.png)

Now that we have defined the logic inside another module lets call from the controller the new module with the existing logic:

![clean_controller](/images/contract-based/clean_controller.png)

Now how can be sure we have the expected behavior from our service? Let's make a quick call for the controller tests.

![check_controller_test](/images/contract-based/check_controller_test.png)

What happens if my controller tests failed in this last step? This means you did more than just refactor in this step. Also could be you missed some behavior from the logic from the adoption request from the users of the service.

## Contract based testing 📑

As far as we have got right now we didn't change the logic itself. Just rearrange the parameters from one place into another. Lets move a bit the dependency modules we have right now. We can spot we are making use of the database calls from the next modules:

![database_modules](/images/contract-based/database_modules.png)

If we check the `Animals` and `Customers` modules we can see the modules are also making calls into the Repo module. I will not dive into what exactly is. The important here is that Repo module makes calls into the database. In our testing environment the Repo module will make calls into the testing database.

For the next steps we will move the database dependencies into the function parameters itself. We can see the adoption business action logic being applied contracts inside the own business action module. The following code would represent the abstraction from the database modules:

![action_contract_logic](/images/contract-based/action_contract_logic.png)

If we run again the tests from before we can still see that the tests are still running. We didn't change anything yet 🤓

## Test dependencies

As we have spotted previously we have some database dependency for the testing. Right now our [Phoenix][Phoenix] service is quite smart. In the tasks our service performs we can see the following ones:

![mix_exs](/images/contract-based/mix_exs.png)

We can spot there the `mix test` task does not only perform the test task. It also performs the creation for the test database. Moreover the migrations for the test database. This means before running the tests the application sets up the test database.

Lets see what happens if we make the [Phoenix][Phoenix] application dumb. Lets make the testing dependency raise issues. For this purposes we have to delete the test alias and make it only perform the tests. We have to change the test mix alias:

`test: ["test"]`

Lets now perform a test correlated mix task. Right afterwards lets perform again: `mix test` again and see what happens.

![db_not_working](/images/contract-based/db_not_working.png)

As we can see we didn't change anything from the test files themselves. We just deleted the database related for the testing. This would relate as if we had a request into another service and the other service was down.

We didn't change the tests from our service by any means. Although we changed the configuration required for the tests. Now we have to question ourselves if the testing we have right now is the testing we want to perform for our service.

## Mocking time! 🚀

Now its time to give a reshape for our testing suite. We will not change the test implementation itself. Although we will mock the database dependency. This will mean we have to create the module mocks for this purpose. The following modules have to be defined in a place were elixir compiles, as we need them available for the tests. We can put this modules inside: `test/support` for example. The module mocks would look something like:

![mocks](/images/contract-based/mocks.png)

Please bear in mind that you can check with the database dependency how the output for the required methods is required. Like any other testing dependency you have to double check the contract you will be mocking.

Now we can change the testing suite and make it use our own mocks. This will mean we don't need the database connection for passing our tests. The code changed for this will be the following:

![action_contract_test](/images/contract-based/action_contract_test.png)

This has been quite a journey for decoupling the database dependency out from the test suite. If you run the tests again you can see the [Phoenix][Phoenix] application still tries to check the database connection. Although afterwards the tests end up all green to our liking.

[clean-code]: https://www.amazon.com/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882
[legacy-code]: https://www.amazon.com/Working-Effectively-Legacy-Michael-Feathers/dp/0131177052
[TDD-Where-Did-It-All-Go-Wrong]: https://www.youtube.com/watch?v=EZ05e7EMOLM&ab_channel=DevTernity
[Test-Driven-Development:-By-Example]: https://www.amazon.com/Test-Driven-Development-Kent-Beck/dp/0321146530
[TDD]: https://team-agile.com/2021/02/06/chicago-and-london-style-tdd/
[Rspec]: https://rspec.info/
[Ruby]: https://www.ruby-lang.org/en/
[Phoenix]: https://phoenixframework.org/
[Elixir]: https://elixir-lang.org/