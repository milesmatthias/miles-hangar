*This repository is for demo purposes only.*

# Miles' Hangar

Hey, I'm Miles. I own a bunch of planes and would love to offer them to you for charter!
This website allows you to purchase whole plane charter flight hours in blocks of 50 hours.

After you pre-pay for time on a specific plane, one of our friendly account executives will reach out
to schedule and coordinate your travel. Happy flying!


## Yay! How do I buy flight time?

We're a new company, so currently we are only allowing prospective customers to do the following:

* View our selection of planes
* Add 1 block of 10 flight hours for the selected plane to your cart
* P

You can add multiple planes to your cart, but currently we're only allowing customers to purchase
1 block of 10 flight hours per plane.

Note that all prices are in USD.

## Running our website

You'll need to ensure you have Ruby 2.6+ installed. ([See install instructions.](https://www.ruby-lang.org/en/documentation/installation/))

To prepare to run our application, open a terminal, change to the directory where `app.rb` is located, and run the following:

1. `gem install bundler`
  * You can skip this step if you already have bundler installed for your version of Ruby)
1. `bundle install`
  * You'll only need to run this once.

You are now ready to run our application, so simply run:

`bundle exec ruby app.rb`

Open a browser to [http://localhost:4567](http://localhost:4567) to check out our awesome site!


## Looking to buy a plane from me? Enable Mark Cuban mode!

If you'd like to purchase an entire plane over our website, you can! [Mark Cuban was the first person to do this.](https://beam.land/aviation/e-commerce-how-mark-cuban-bought-a-private-jet-online-1208)

In this mode, your payment will be a down-payment on the full cost of the plane, and one of our account executives will reach out to coordinate payment for the remaining balance and schedule delivery of your new plane.

`CUBAN_MODE=true bundle exec ruby app.rb`


## Miles' internal notes to the hangar dev team

This is a great start. I'm really excited to get this in front of potential customers.
In the future, let's make some improvements:

### Usability

* Currently we only support a user clicking "buy" on the purchase button, but a better UI experience would allow users to press enter while using the form as well. For brevity, we ignored that little bit of browser fun.
* Let's make it pretty :)

### Payments

* Credit cards are quick to get up and running with, but let's more cost-effective payment options like ACH.
* Some customers may want to use a credit card for CC points, but when we offer more payment options, let's ask them to split the merchant fee with us. (Or possibly pay it all)
* Ideally we'd allow customers to purchase planes on our site too, but for such large transactions, not only we should only allow ACH, but we'll need to think about quite a few things:
  * Coordinating with our payment provider to get their thoughts since their maximum charge amount is $999,999.99 (support for increase? recommend multiple charges? how often?)
  * Evaluate multi-step purchases on a schedule via invoicing, allowing for smaller purchases but time to collect KYC information and possibly notify the customer's bank of such a large transaction
  * If we can do things in one charge, we may need to partner with an escrow service to make customers feel safer sending such a large payment.

### Technical notes

* We should store client & payment information in a database for us to reference later
  * So customer service can lookup information about a client or charge
  * We can track state of payments in case of refunds, chargebacks, payments to outstanding balances, etc.
  * We can track state of flight hour redemption per plane
* We currently stuff everything into a session cookie, but as we grow & users add more and more to their session/cart, it will create large network payloads, so let's use a session store. Also ensure that session store can be shared across multiple instances of our application at some point.
