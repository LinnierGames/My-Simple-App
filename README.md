# Share what you know with some peeps!

Here are projects that are setup in a way that leaves room for improvement. This can include:
- readable code
- separation of concern
- UI is responsive
- architecture between the UI and business logic
- object-oriented design
- handle errors and edge cases
- design is not tightly cuppled
- depdancy injection
- testable code

The sole purpose of sharing what you know is to provide different approaches to solve common challenges like:
- designing the network layer
- designing the presistent layer
- using protocols to hide implementation
- update the UI when data models change
- how to layout the UI (use xib, storyboards, or only code)

For each project:
- use only first-party tools
- do not add or change any features
- add, remove as many files, lines of code as you want
- comment, write unit or UI tests

# Projects

### Weather app `weather-app`
- view the weather in a table view
- user can enter an address
- each address and weather is persisted
- invalid addresses are displayed in a separate section
- **Note**: the weather data is mocked locally through a custom URLSession class [here](https://github.com/LinnierGames/My-Simple-App/blob/fc812957e8ca8f184838214870af7c50afcdf681/My%20Simple%20App/URLSession%2BFake.swift#L11)

### How to submit your revison

1. Fork this repo
1. Make commits as normally on the `weather-app` branch
1. Push the branch and make a Pull request as such:
   - Set the **base repository** to *LinnierGames/My-Sample-App*
   - Set the **base** to *master*
   - Set the **head repository** to *<your github username>/My-Sample-App*
   - Set the **compare** to *master*
1. Post your PR in the MakeSchool group and share the love :D

ps: I'm open to any and all suggestions on how to best help others see what industry level code looks like
