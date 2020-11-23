![License: MIT](https://img.shields.io/badge/License-MIT-green.svg)

# CurrencyCalculator

This repository covers following functional requirements:
* Exchange rates must be fetched from: https://currencylayer.com/documentation
* Use free API Access Key for using the API
* User must be able to select a currency from a list of currencies provided by the API(for currencies that are not available, convert them on the app side. When converting, floating-point error is acceptable)
* User must be able to enter desired amount for selected currency
* User should then see a list of exchange rates for the selected currency
* Rates should be persisted locally and refreshed no more frequently than every 30 minutes (to limit bandwidth usage)

Also taken care of following things:

* Clean, flexible, easy to maintain and readable business process
* Clear UI or App flow
* Performed UI Test
* Used SwiftUI, Combine & MVVM
    * Repo have three main layers: Presentation layer (View), Business Logic(View Model), Data Access (Repository)
* SOLID Principle - Tried to cover following SOLID Principles
    * Single Responsibility - Each software component should have only one reason to change – one responsibility.
    * Dependency Inversion - Components depend on abstractions rather than concrete implementations. Also higher level modules doesn’t depend on lower level modules
* Added Core data support for data persistence.
* Used free package from https://currencylayer.com/  to fetch data from API’s. Base currency is fixed as “USD” in the free package.
* User can select the currency from the dropdown and the respective exchange rates will be displayed under Expense rates section for the selected currency and a list of exchange rates will be displayed for all the countries.

Future Scope:

* Try to cover Uncle Bob’s clean swift architecture(Introduce Clean Swift)
* Apply all the five design principles( currently covered 2 principles only) of SOLID principles to make software design more flexible, maintainable and scalable.

---

## Contributors

- Vijay Patel <patel.vij05@gmail.com>

---

## License & copyright

© Vijay Patel

Licensed under the [MIT License](LICENSE).
