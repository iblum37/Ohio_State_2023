# Pitch Comparison Tool @ Ohio State 2023
R Shiny App, Code, and CSVs for the Ohio State Sports Analytics Conference April 2023

Link to the App here: [Pitcher Comparision Tool (PCT)](https://7dej8y-isaac-blumhoefer.shinyapps.io/PitchComparisonTool/)

Disclaimer: May take minutes to initially load, including initial visuals, due to large amounts of data

### App Usage
The Pitch Comparison Tool (PCT) is an application that allows users to input a pitcher and pitch from the 2022 MLB season and observe the 5 most similar pitches in history (2015-2022, excluding 2020) to that pitch. There is also an option to observe the 5 most similar pitches from just the 2022 year.

Included in the application are visuals depicting where the chosen pitch was most commonly thrown, details about the other pitches in that pitcher's arsenal, and a direct comparison of all of these features to the top 5 most similar pitches that the algorithm generates.

Finally, a percentage is generated detailing how close the pitches are to each other using the algorithm detailed below.

### Algorithm
A variety of features were used to determine the "closest" 5 pitches to each inputted pitch. These features included but were not limited to release point, velocity, spin rate, and break. Then, a simple sum of differences (after normalization of each difference) between each of these features was used to determine "closeness", with the smallest sum being the "closest" pitch. This is a simple, high-level description of the algorithm.

Note: Some minor weights were used for some features via common baseball knowledge, but for the most part each feature was weigthed similarly because no learning algorithm could accurately determine the correct weight since there is no outcome to base "closeness" on and generate output coefficients.


