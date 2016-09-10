-- Create the schema and the table

DROP SCHEMA IF EXISTS movieRatings;

CREATE SCHEMA `movieRatings`;

-- Create the table for movie ratings

CREATE TABLE movieRatings.ratings (
    ts VARCHAR(50),
    star_trek VARCHAR(2) NULL,
    suicide_squad VARCHAR(2) NULL,
    the_lobster VARCHAR(2) NULL,
    pets VARCHAR(2) NULL,
    deadpool VARCHAR(2) NULL,
    batman_the_dark_knight VARCHAR(2) NULL,
    pulp_fiction VARCHAR(2) NULL,
    the_lord_of_the_rings VARCHAR(2) NULL
);
  
-- Populate the table with survey responses
  
LOAD DATA LOCAL INFILE 'C:/Users/dima/Google\ Drive/CUNY\ MSDA/IS\ 607\ Data\ Acquisition/Week_2/Movie_Rating_Responses.csv' 
INTO TABLE movieRatings.ratings 
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

