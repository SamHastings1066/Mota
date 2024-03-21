# SetSwiftUI

![Usage gif](usage.gif)

## Overview

Mota an iOS application allowing users to quickly create, modify and share workouts using an in-built exercise bank. The objective for this app is to use the most modern developement approaches available: user interface (**SwiftUI**), data persistence (**SwiftData**), data management (**@Observable**, **@Bindable**, **@Environment**), architecture (**MV design pattern**) and testing (**mocks**, **page objects** and **custom test classes**). 

The Model layer is built using a Test-Driven-Development (TDD) approach. User authorization is implemented using Firebase and the login flow is supported by automated UI-tests including both pure UI (FireBase independent) and full end-to-end tests.  

## Implementation details

### 🔁 UI Tests
- **Mocking**: Two types of UI tests have been implemented to validate the app's 'login flow: pure UI (FireBase independent) and full end-to-end tests. This achieved by defining classes for both a real authenication service, using FireBase Auth, and a mock authentication service. Both classes are required to conform to the AuthenticationService protocol, and then an AuthenticationService object is inserted into the relevant view hierarchies via dependency injection. This approach was chosen so that the navigation logic can be tested independently of the choice of authentication service provider (or availability of internet connection) in order to identify errors that are purely UI based, and to accomodate any future decision to use an alterntive to Firebase. 
- **Page Object Model**: Page Objects used to define the specific interactions that a user may perform on each of the corresponding screens involved in the login flow. For example the LoginPageObject provides a function `typeEmail(_:)` which can be used to simulate a user typing in their email on the login page. UI tests depending on this interaction may then simply call this function with the arguments relevant to the test at hand. This makes tests much more readable and succinct. 
- **Custom test classes**: To implement reusable test logic such as setup and teardown functions that can be inhereted into test subclasses.

### 🔁 Unit Tests
- **TDD**:  The model layer was built using a Test-Driven-Development (TDD) approach. 
- **Test Coverage**: Tests related to the model layer achieve a coverage of 40%.

### 🔁 SwiftData
- **Model-View**: @Model. ModelContext and ModelContainer.
- **Handling JSON Data**: The exercise bank is stored in JSON form and exercises are decoded into Swift objects using Codable. SwiftData does not provide automatic Codeable conformance Model classes even where all properties are Codeable. Protocol conformance was achieved through custom implementations of `init(from:)` and `encode(to:)`.

### 🔁 SwiftUI
- **Observation**: Instead of @Obseravable instead of @ObservableObject, @Bindable instead of @Binding, .environment instead of .environmentObject.

### 🔁 MV Architecture
- **Model-View**: This architexture was chosen in preference to MVVM since it is the most modern

<! -- PUT ARCHITECTURE DIAGRAM HERE ![MVVM Architecture Diagram](SetSwiftUIStructure.png) -- >

<! -- ### 🔁 Networking -- >
<! -- - **Handling JSON Data**: The exercise bank is stored in JSON form and exercises are decoded into Swift objects using Codable. SwiftData does not provide automatic Codeable conformance Model classes even where all properties are Codeable. Protocol conformance was achieved through custom implementations of `init(from:)` and `encode(to:)`. -- >

### 🔁 User authorization
- **FireBase Auth**: Chosen because: cross platform compatibility (iOS and Android), support for and easy implementation of additional login approaches (sign in googlemail, facebook, apple.)


