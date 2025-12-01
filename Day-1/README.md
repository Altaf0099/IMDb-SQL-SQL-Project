# 🎬 IMDb SQL Analytics Project — Day 1
Part of my **31-Days SQL & Data Analytics Journey (#DataDecember)**

This project analyzes an **IMDb-style relational database** containing movies, actors, and cast relationships.  
It was developed collaboratively with **Anuj Gamare** and showcases real SQL analysis, joins, ranking logic, and data modeling concepts.

## 📁 Dataset Used
### imdb_movies.csv
- movie_id
- title
- genre
- release_year
- rating
- duration

### imdb_actors.csv
- actor_id
- name
- gender
- birth_year
- nationality

### imdb_cast.csv
- movie_id
- actor_id
- role

## 🛠️ SQL Concepts Used
- INNER JOIN, LEFT JOIN
- GROUP BY, HAVING
- WHERE, IN, BETWEEN, LIKE
- DISTINCT, NULL handling
- CTE (WITH)
- ROW_NUMBER()

## 🔍 Key Insights Extracted
- Lead actors per movie
- Movies with >5 actors
- Actor filmography counts
- Top 10 lead-role actors
- Action + Drama actors
- Post-2010 movies with young actors
- Actors with no lead roles
- Cast size per movie
- Actors in 5+ genres
- Youngest actor per genre
- Actor age at release
- Sci-Fi specialist

## 📊 Project Structure
data/, sql/, ppt/, images/, README.md

## 🤝 Collaboration
Built with **Anuj Gamare**
