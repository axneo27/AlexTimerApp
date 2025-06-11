
# AlexTimer
(Have not come up with an icon idea yet)

A speedcubing timer & utility app

## Overview
### Information

* Fully built with Swift and SwiftUI, modern app architecture
* Uses CoreData for storing solves information and statistics
* Simple and modern user interface
* Has two themes available
* Fully works offline
* Can take scramble data from my tnoodle API (provided user has access to internet connection)
* Uses Firebase Google OAuth (for future network actions)

## Screenshots
### IOS

<img src="https://github.com/axneo27/AlexTimerApp/blob/main/.github/images/timer_orange.png?raw=true?token=GHSAT0AAAAAAC5AIL2ORTUXDMGAMWEI25IK2BS2WRA" alt="timer orange" width="150"/> <img src="https://raw.githubusercontent.com/axneo27/AlexTimerApp/refs/heads/main/.github/images/timer_puzzles.png?" alt="timer puzzles" width="150"/> <img src="https://raw.githubusercontent.com/axneo27/AlexTimerApp/refs/heads/main/.github/images/timer_visual_3x3.png?" alt="timer puzzles" width="150"/> <img src="https://raw.githubusercontent.com/axneo27/AlexTimerApp/refs/heads/main/.github/images/records.png?" alt="timer puzzles" width="150"/>


<img src="https://raw.githubusercontent.com/axneo27/AlexTimerApp/refs/heads/main/.github/images/stats_all.png?" alt="timer puzzles" width="150"/> <img src="https://raw.githubusercontent.com/axneo27/AlexTimerApp/refs/heads/main/.github/images/stats_4x4visual.png?" alt="timer puzzles" width="150"/> <img src="https://raw.githubusercontent.com/axneo27/AlexTimerApp/refs/heads/main/.github/images/graph_2x2.png?" alt="timer puzzles" width="150"/> <img src="https://raw.githubusercontent.com/axneo27/AlexTimerApp/refs/heads/main/.github/images/settings.png?" alt="timer puzzles" width="150"/>

## Features
### App features

* Essential timing functionalities:
  * Press mode
  * 15-second inspection mode
  * Check scramble by visual representation
  * Scramble generation:
    * Custom algorithms
    * Taking them from my deployed tnoodle API

* Simple design for viewing statistics
  * Sorting by puzzle
  * Looking for additional info
  * Deleting solves 
    * by category
    * one by one

* Other statistics and solve analysis methods:
  * Graph with different properties and puzzles

* Standart calculations:
  * Current and best average of 5
  * Current and best average of 12

* Settings. Here you can change
  * Timer mode
  * Color theme for you preferences

## Possible fututre improvements

* More timer customization tools

* Better control of statistics (e. g. multiple deletion)

* Adding sharing records functionality that uses Firestore with already implemented Google OAuth

* Improving performance and just refactoring code
