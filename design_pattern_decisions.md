Designing a Clinic for untrusting Care Providers/Doctors

Synopsis: 

To many the consideration of using BlockChain is most obvious for 2 apparent industries. One of them being Health Care. The other is the Financial sector. Imagine physicians are forming partnership for various reason such as cost saving. However, the collaborating doctors may trust very little of their business partners. Limited partnership (LLP) is often the legal and accounting arranagement. For technology sharing a Dapp running on Blockchain could be an ideal system for the untrusting doctors. 

Design considerations: 

Physcian, Medical Records and Patients etc ... are some of the most well studied data models in software and database engineering, I need not to re-invent the wheels on the object models. More focus was placed on the interaction between objects and some requirements as they are deemed appropriate for a Dapp/DLT implementation. 

In addition the following areas of software design are considered.
- Requirements driven
- Tests driven
- Dapp Performance and Security
- Agile development

Requirements Driven:

There are checks and balances in the contract to prevent frauds. Such as admins have the ability to remove enrolled doctors, and doctors are to submit medical record which must be verified by the patient. 

Tests Driven:

Validation tests are developed before the programming is complete. This maintains the stability of the development and could mitigate  design and implementation frauds before the final updates are released for production.

Dapp Performance and Security:

Due to the cost of keeping storages on the Blockchain, solution designers must pay attention to the code and variable mechanics. When to use mappings and indexed variables to avoid iterating code. While there is the built-in immutability feature of the Blockchain, prevention of rogue contracts or 50% rules attacks are some of the security issues common with Dapp.

Agile development:

Develop systems' functions in discreet groups. First have the most viable environment and add to the system functions that would not or have little chance breaking the existing functions. While working on the doctor functions the patient related functions can remain operations. Use circuit breakers to disable a group or certain parts of the contract systems while those parts are getting maintained.

