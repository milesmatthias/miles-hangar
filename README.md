*This repository is for demo purposes only.*

# Miles' Hangar

Hey, I'm Miles. I own a bunch of planes and would love to offer them to you for charter!
This website allows you to purchase whole plane charter flight hours in blocks of 10 hours.

After you pre-pay for time on a specific plane, one of our friendly account executives will reach out
to schedule and coordinate your travel. Happy flying!


## Yay! How do I buy flight time?

We're a new company, so currently we are only allowing prospective customers to do the following:

* View our selection of planes
* Add 1 block of 10 flight hours for the selected plane to your cart
* Purchase your cart

Note that all prices are in USD.


## Running our website

You'll need to ensure you have Ruby 2.6+ installed. ([See install instructions.](https://www.ruby-lang.org/en/documentation/installation/))

To prepare to run our application, open a terminal, change to the directory where you've unpacked this repository, and run the following:

1. `gem install bundler`
  * (You can skip this step if you already have bundler installed for your version of Ruby)
1. `bundle install`
  * You'll only need to run this once.

You are now ready to run our application, so simply run:

`bundle exec ruby app.rb`

Open a browser to [http://localhost:4567](http://localhost:4567) to check out our awesome site!


## Looking to buy a plane from me? Enable Mark Cuban mode!

If you'd like to purchase an entire plane over our website, you can! [Mark Cuban holds the record for largest e-commerce purchase, a $40M jet!](https://beam.land/aviation/e-commerce-how-mark-cuban-bought-a-private-jet-online-1208)

In this mode, your payment will be a down-payment on the full cost of the plane, and one of our account executives will reach out to coordinate payment for the remaining balance and schedule delivery of your new plane.

Run our application in Mark Cuban mode with the following command:

`CUBAN_MODE=true bundle exec ruby app.rb`


## Required questions

> An overview of your application in 1 page or less: how does it work? What does it do? Which Stripe APIs does it use?

See above for the user facing explanation of what this app does & how to run it. This demo uses the PaymentIntent Stripe API on the server side to create the initial PI & retrieve information about the completed PI. On the client, this demo uses StripeJS to add UI elements which capture & validate credit card input, and then complete the payment with the given credit card. The Stripe integration very closely follows [one of Stripe's official tutorials](https://stripe.com/docs/payments/accept-a-payment).

> A paragraph or two about how you approached this problem.

Before I spent any time coding, I first spent a little time browsing the Sinatra & Stripe docs to get myself up-to-date on the APIs available. This allowed me to form the architecture & routes needed in my head. Obviously there would be routes for viewing products, adding them to a cart, checking out with a credit card payment, and viewing a receipt. Re-reading the Stripe docs to understand the payment flow was really important to understand any changes needed to be made to the typical e-commerce architecture. This is a demo, so I kept the architecture as simple as possible, skipping things like a CSS or JS framework or interacting with a database for data persistence.

When I sat down to code this, I wrote the README first, clarifying to myself (and to the future reader) what the goal of this demo was and what it would do. Then I incrementally worked on each component of the system in small, manually testable commits, building upon each until I was satisfied with the finished product. The general order of these components was:

1. Stubbing out my routes/pages
1. Loading & presenting my sample data
1. Adding session state for a cart
1. Stubbing out the purchase flow without an actual payment
1. Adding a payment to the checkout flow

> A paragraph about why you picked the language/framework you did.

Ruby is my favorite language, and most of my experience working with Stripe is in Rails. It's been a while since I've used Sinatra, so I actually enjoyed the fact that it was recommended and getting reacquainted with it.

> A paragraph or two about how you might extend this if you were building a more robust instance of the same application.

This demo is more of a webform than it is an application that manages state. There are several technical improvements that could be made (add a session store instead of stuffing the cart into a cookie, move credentials to environment variables for security & to support staging/production environments, support older browsers, better error handling & input validation, etc.), but the biggest extension to be made here is adding persistent state.

For example, there is no concept of a "signed in" user, because we don't have a place to store user registrations. With a database for state storage, we could allow users to view past purchases, view order status, ask for refunds, etc. Data persistence would also enable our company's administration team to view orders and manipulate their state (ex: issue refunds, mark them as fulfilled, add related travel trip records for a user's flight hour balance for a plane, etc.). Data persistence and a Stripe Connect integration could also allow our business to let other plane owners offer their planes on our platform for sale, allowing us to take a financial share of those transactions.

Lastly, there is the purely financial concern to consider here for the business. Credit card fees will be very large for these large purchases, so using ACH where the fee is capped at $5 is really the direction to go. This business may also need to look into breaking up larger payments into small, scheduled payments to allow customers financial flexibility, but also to give the business time to address any KYC or regulatory concerns. Some customers may even want an escrow service, especially if they're buying a plane from us and want to make sure we deliver the plane before completely letting go of millions of dollars.
