# SetSwiftUI

![Usage gif](usage.gif)

## Overview

Mota an iOS application that allows users to quickly create, modify and share workouts using an in-built exercise bank. The objective for this app is to use the most modern developement approaches available for user interface (**SwiftUI**), data persistence (**SwiftData**), data management (**@Observable**, **@Bindable**, **@Environment**), architecture (**MV design pattern**) and testing (**mocks**, **page objects** and **custom test classes**). 

The Model layer is built using a Test-Driven-Development (TDD) approach. User authorization is implemented using Firebase and the login flow is supported by automated UI-tests including both pure UI (FireBase independent) and full end-to-end tests.  

## Implementation details

### 🖥️ UI Tests
- **Mocking**: Two types of UI tests have been implemented to validate the app's 'login flow: pure UI (FireBase independent) and full end-to-end tests. This achieved by defining classes for both a real authenication service, using FireBase Auth, and a mock authentication service. Both classes are required to conform to the AuthenticationService protocol, and then an AuthenticationService object is inserted into the relevant view hierarchies via dependency injection. This approach was chosen so that the navigation logic can be tested independently of the choice of authentication service provider (or availability of internet connection) in order to identify errors that are purely UI based, and to accomodate any future decision to use an alterntive to Firebase. 
- **Page Object Model**: Page Objects used to define the specific interactions that a user may perform on each of the corresponding screens involved in the login flow. For example the LoginPageObject provides a function `typeEmail(_:)` which can be used to simulate a user typing in their email on the login page. UI tests depending on this interaction may then simply call this function with the arguments relevant to the test at hand. This makes tests much more readable and succinct. 
- **Custom test classes**: To implement reusable test logic such as setup and teardown functions that can be inhereted into test subclasses.

### ✅  Unit Tests
- ** SwiftData compatability**: In order to create SwiftData model class instances and perform operations on them, a mock Model Container is created "by-hand". This container is configured such that persistent storage is ephemeral and exists only in memory in order to prevent objects created during testing from accumlating on the test device.   
- **TDD**:  The model layer was built using a Test-Driven-Development (TDD) approach. 
- **Test Coverage**: Tests related to the model layer achieve a coverage of 40%.

### 📊 SwiftData
- ** Ordered to-Many Relationships**: SwiftData to-Many relationships are declared directly using arrays. However the order of items when the array is created in memory is not preserved when that array is persisted into storage or reloaded. For ordered One-to-Many relationships in the Mota app, creation order is preserved using a computed var that returns the items from the to-Many array sorted by their creation timestamp. This implementation was chosen in preference to using e.g. a doubly-linked list since SwiftUI's .onMove modifier for reordering List items uses their position in an array for the reordering, rather than directly inserting items into an underlying linked-list.
- **Handling JSON Data**: The exercise bank is stored in JSON form and exercises are decoded into Swift objects using Codable. However, adding the SwiftData macro `@Model` to the `DatabaseExercise` model adds boilerplate code to the model including properties which are not Codable. In general, this means that SwiftData models that would otherwise Codable, are not Codeable by default. The `DatabaseExercise` therefore achieves Codeable conformance through custom implementations of `init(from:)` and `encode(to:)`.


### 🖌️ SwiftUI
- **Observation**: Data is managed within Mota using the new Observation feature introduced to SwiftUI in WWDC23. The property wrappers `@Observable`, `@Bindable` and `@Environment` are used to track changes to data models across views and ensure automatic UI updates, to create two-way bindings to model properties, and to retrieve model objects from a view's' environment, respectively.
- **List manipulations**: Reordering and deleting elements in lists is implemented using the `ForEach` modifiers `.onMove(peform:)` and `.onDelete(perform:)`, repsectively.
- **Collapsed representation of SuperSets**: One of the main problems solved by Mota's data model is how to represent `SuperSet` objects in collapsed form (i.e. using a single `ExerciseRound` object to represent all rounds in a `SuperSet`), and how to set the expanded form when the user updates UI elements that represent the collapsed form.  

### 🏗️ MV Architecture
- **Model-View**: This architecture was chosen because it is simpler than MVVM, requires fewer layers, and is the design pattern used by Apple in all of their latest SwiftUI apps. SwiftUI inherently supports state management through its built-in binding mechanisms. The central idea of the MV pattern is to take advantage of that built in state management and use Views to also serve as View Models. 

<! -- PUT ARCHITECTURE DIAGRAM HERE ![MVVM Architecture Diagram](SetSwiftUIStructure.png) -- >

<! -- ### 🔁 Networking -- >
<! -- - **Handling JSON Data**: The exercise bank is stored in JSON form and exercises are decoded into Swift objects using Codable. SwiftData does not provide automatic Codeable conformance Model classes even where all properties are Codeable. Protocol conformance was achieved through custom implementations of `init(from:)` and `encode(to:)`. -- >

### 🔑 User authorization
- **FireBase Auth**: Chosen because: cross platform compatibility (iOS and Android), support for and easy implementation of additional login approaches (sign in googlemail, facebook, apple.)


