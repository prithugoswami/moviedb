/* Given :
   +----------------------------+
   |           genres           |
   +----------------------------+
   | Action, Adventure          |
   +----------------------------+
   | Comedy, Drama              |
   +----------------------------+
   | Action, Romance            |
   +----------------------------+
   | Comedy, Mystery, Adventure |
   ------------------------------

   we should be able to produce a list like this:
   Action
   Adventure
   Comedy
   Drama
   Action
   Romance
   Comedy
   Mystery
   Adventure

   and this is what this query does
   (split.sql does the same in a different way)
*/
select temp_genre.tconst, substring_index(substring_index(temp_genre.genres, ',', numbers.n), ',', -1) genres
from (
    select 1 n union all
    select 2 union all select 3 union all
    select 4 union all select 5 union all
    select 6) numbers 
INNER JOIN temp_genre
ON
CHAR_LENGTH(temp_genre.genres)-CHAR_LENGTH(REPLACE(temp_genre.genres, ',', ''))>=numbers.n-1
ORDER by
tconst, n
