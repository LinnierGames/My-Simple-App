# Weather app `weather-app`

<p float="left">
    <img src="https://github.com/SamuelFolledo/My-Simple-App/blob/weather-app/static/weatherAppDemo.gif?raw=true" width="300"/>
    <img src="https://github.com/SamuelFolledo/My-Simple-App/blob/weather-app/static/weatherApp.png?raw=true" width="300" /> 
</p>

- view the weather in a table view
- user can enter an address
- each address and weather is persisted
- invalid addresses are displayed in a separate section
- **Note**: the weather data is mocked locally through a custom URLSession class [here](https://github.com/LinnierGames/My-Simple-App/blob/weather-app/My%20Simple%20App/URLSession%2BFake.swift)

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

ps: I'm open to any and all suggestions on how to best help others see what industry level code looks like
