# Welcome to the repo of repos!

Here are iOS projects that are set up in a way that leaves room for improvement. I wanted to give everyone the chance to refactor a simple app and get feedback on your changes

Some improvements can include:
- readable code
- separation of concern
- UI is responsive
- architecture between the UI and business logic
- object-oriented design
- handle errors and edge cases
- design is not tightly coupled
- dependency injection
- testable code

:warning: **Note**: PRs are not intended to be merged since the PR would instill a certain way of doing things (use stack views for everything, use generics for decoding networking models, etc). Instead, PRs will be left open for others to learn and provide feedback

If you'd like for your PR to be merged into a project (start with programic code since it's basically industry standard to not use storyboards), send your PR with the **Amend Sample Project** label attached. More on this below

### You a student making apps?

- this is a way you can take the things you know and practice refactoring an existing codebase. And,
- get feedback from folks in industry on your PRs

### You got a job making apps?

- share with students what you've learned in industry
- provide different approaches to solve common challenges

### What else could you change

- designing the network layer
- designing the persistence layer
- using protocols to hide implementation
- update the UI when data models change
- how to layout the UI (use xib, storyboards, or only code)
- use Swift UI!

# The Projects

Each project is in its own branch (master is an empty Xcode project)

For each project:
- use only first-party tools
- do not add or change any features
- add, remove as many files, lines of code as you want
- introduce new things (generic network layer)
- copy and paste from your other projects
- comment, write unit or UI tests

### Weather app
![weather-app-1](https://user-images.githubusercontent.com/1758210/92414838-da244b00-f10a-11ea-85bc-60ec5f2a101f.png)
- view the weather in a table view
- user can enter an address
- each address and weather is persisted
- invalid addresses are displayed in a separate section
- **Note**: the weather data is mocked locally through a custom URLSession class [here](https://github.com/LinnierGames/My-Simple-App/blob/weather-app/My%20Simple%20App/URLSession%2BFake.swift)

### Todo app

- TBD

### Chat app

- TBD

### Got an idea for a project?

Reach out to me on [LinkedIn](https://www.linkedin.com/in/e-sanchez-e/) and we can chat about creating a branch with the project so you can upload your project. The project idea doesn't have to be iOS. It could be:

- Express backend API
- web app writen with Angular
- even an Android app 🙃

# How to submit your revision

1. fork this repo to your GitHub
1. make commits as normally on the `weather-app` branch **from your GitHub** 
   - do not clone the repo from LinnierGames otherwise, you won't have permission to push your commits
   - do not create a new branch
1. push the branch to your GitHub and **from your GitHub** make a Pull request as such:
   - set the **base repository** to *LinnierGames/My-Sample-App*
   - set the **base** to *weather-app*
   - set the **head repository** to *<your GitHub username>/My-Sample-App*
   - set the **compare** to *weather-app*
1. in the description of your PR, mention:
   - what parts did you change (e.g. removed storyboards, made networking layer generic using protocols, etc.)
   - what did you introduce (e.g. new services, used Combine framework)
   - what did you leave out but would love to change (e.g. refactor using SwiftUI)
   - add/create labels to your PR
1. send your PR and post a link in the [MakeSchool group](https://www.facebook.com/groups/2046538988893010) on Facebook, or on MakeSchool's [#resources channel](https://app.slack.com/client/TBQLGLFL7/CR23T2BHV) on Slack and share the love :D

- feel free to separate different refactorings in multiple PRs (e.g. one PR for the networking layer refactor and another PR for laying UI using code instead of Interface Builder) You could even chain the branches and PRs to reuse your work from a pervious PR
- feel free to refactor the whole project into one PR! Just be sure to include what you've changed in the description 😊

# How to propose an amend PR to a project

Got an idea on how a project should start out with? Like no storyboards, or non-private methods should have docs, or even no force unwrapping? If so, follow the steps in **How to submit your revision** and:
1. use [this](https://github.com/LinnierGames/My-Simple-App/blob/master/.github/PULL_REQUEST_TEMPLATE/project_addition.md) PR template by adding `?template=project_addition.md` to the url
1. add the **Amend Sample Project** label to your PR
1. add **ErickES7** as a reviewer

Your PR should not:
1. introduce something that can be deemed as not common iOS knowledge (e.g. using type-erasures)
1. use a Swift or iOS library/framework/tool that just came out within the month
1. perform operations multi-threaded

ps: I'm open to any and all suggestions on how to best help others see what industry level code looks like
