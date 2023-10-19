# DisneyCodingExercise

Task:

• Use Marvel’s Developer API
<developer.marvel.com>

• Create a layout for characters.

• When selecting a character display a list of comics for that character.

• Implement at least one Unit test

• Upload code to Github/Gitlab or something equivalent and provide link and a README file

Requirements

• No third party frameworks

• Use both Combine and Async / Await

• UI should be in SwiftUI

Project requirements:
Xcode 14.1

Setup:
In MarvelServiceProvider.swift, add your public and private key from https://developer.marvel.com/account, I thought it'd be a bad idea to commit and push my keys to a public repo.

Notes:
Some code would normally not be grouped in the same file (e.g. models, request types, unit tests), I didn't separate them because I figured it would be a headache to look through that many files for a coding exercise.

I thought this article https://nalexn.github.io/anyview-vs-group/ was pretty interesting when I was considering whether or not InspectableView was a bad idea in the project.
