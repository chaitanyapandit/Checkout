# Checkout Demo
This is a sample app that demonstrates use of Stripe API for checkout and use of [Card.io](https://www.card.io) to scan your credit card during checkout process.

It also implements Unit Tests and UIAutomation Tests.

# Installation
This project uses Cocoapods for dependencies.
Run `pod install` to fetch all the dependencies.

# Unit Tests and UIAutomation Tests
Just hit `Command + u` to run Unit Tests and UIAutomation Tests.

- Unit tests are implemented to verify the logic for computing cart total and application of discounts and taxes.

- UIAutomation Test will simulate the entire checkout process including making a dummy Stripe payment.