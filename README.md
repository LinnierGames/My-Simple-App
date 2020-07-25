# Welcome to the repo of repos!

Here are projects that are setup in a way that leaves room for improvement and get feedback on your changes

This can include:
- readable code
- separation of concern
- UI is responsive
- architecture between the UI and business logic
- object-oriented design
- handle errors and edge cases
- design is not tightly cuppled
- depdancy injection
- testable code

### You a student?

- This is a way you can take the things you know and practice refactoring an existing code base
- Get feedback from folks in industry on your PRs

### You got a job?

Share with students what you've learned in industry, provide different approaches to solve common challenges

### What else could you change

- designing the network layer
- designing the persistence layer
- using protocols to hide implementation
- update the UI when data models change
- how to layout the UI (use xib, storyboards, or only code)

# The Projects

Each project is in its own branch (master is an empty xcode project)

For each project:
- use only first-party tools
- do not add or change any features
- add, remove as many files, lines of code as you want
- introduce new things (generic network layer)
- copy and paste from your other projects
- comment, write unit or UI tests

### Weather app
- view the weather in a table view
- user can enter an address
- each address and weather is persisted
- invalid addresses are displayed in a separate section
- **Note**: the weather data is mocked locally through a custom URLSession class [here](https://github.com/LinnierGames/My-Simple-App/blob/fc812957e8ca8f184838214870af7c50afcdf681/My%20Simple%20App/URLSession%2BFake.swift#L11)

# How to submit your revison

1. Fork this repo
1. Make commits as normally on the `weather-app` branch
1. Push the branch and make a Pull request as such:
   - Set the **base repository** to *LinnierGames/My-Sample-App*
   - Set the **base** to *master*
   - Set the **head repository** to *<your github username>/My-Sample-App*
   - Set the **compare** to *weather-app*
1. In the dscription of your PR, mention:
   - What parts did you change (how UI is laid out, networking layer, etc)
   - What did you introduce (new services, used Combine framework)
   - What did you leave out but would love to change
1. Send your PR and post a link in the MakeSchool group and share the love :D

ps: I'm open to any and all suggestions on how to best help others see what industry level code looks like
