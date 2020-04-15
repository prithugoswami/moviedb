DELIMITER $$

DROP PROCEDURE IF EXISTS set_fav_genre $$
/* This procedure takes a 'user_id' and updates the 'fav_genre' of the useri
   depending on the favourite'd movies he has in 'fav' */
CREATE PROCEDURE set_fav_genre(
    IN u_id INT
)
BEGIN
    declare fav_genre varchar(100) DEFAULT NULL;
    drop temporary table if exists temp_genre;
    create temporary table temp_genre(
        tconst int,
        genres text
    );

    insert into temp_genre(tconst, genres)
    select tconst, genres
    from title_basics
    where tconst in (
        select tconst
        from fav
        where user_id=u_id
    );

    select genres
    into fav_genre
    from (
        select count(genres) as c, genres
        from (

            select temp_genre.tconst,
            substring_index(substring_index(temp_genre.genres, ',', numbers.n), ',', -1) genres
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
        ) as G1
        group by G1.genres
    ) as G2
    order by G2.c desc
    limit 1;

    update user_info
    set fav_genre = fav_genre
    where user_id = u_id;
END $$
DELIMITER ;

/* OLD PROCEDURE (USING CURSORS) */

/* CREATE PROCEDURE set_fav_genre( */
/*     IN u_id INT */
/* ) */
/* BEGIN */
/*     DECLARE finished INT DEFAULT 0; */
/*     DECLARE genre varchar(100) DEFAULT ""; */

/*     DECLARE curGenre */
/*         CURSOR FOR */
/*             SELECT genres FROM title_basics where tconst in ( */
/*                 SELECT tconst from fav where user_id=u_id); */

/*     DECLARE CONTINUE HANDLER FOR NOT FOUND SET finished = 1; */
/*     TRUNCATE TABLE tmp_store; */
/*     OPEN curGenre; */
/*     getGenre: LOOP */
/*         FETCH curGenre INTO genre; */
/*         if finished = 1 then */
/*             leave getGenre; */
/*         END IF; */
/*         call split_string(genre); */
/*     end loop getGenre; */
/*     close curGenre; */
/*     update user_info */
/*     set fav_genre = ( */
/*         select allValues from ( */
/*             select count(allValues) as c, allValues */
/*             from tmp_store */
/*             group by allValues) as line */
/*         order by c desc */
/*         limit 1) */
/*     where user_id=u_id; */
/* END$$ */
/* DELIMITER ; */
