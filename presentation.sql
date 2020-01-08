CREATE TABLE name_popularity (nconst VARCHAR(255) PRIMARY KEY, year INT, popularity_as_actor FLOAT, popularity_as_director FLOAT, primary_name VARCHAR(255));
CREATE TABLE series_popularity (tconst VARCHAR(255) PRIMARY KEY, popularity FLOAT, primary_title VARCHAR(255), season_number INT, episode_number INT);
