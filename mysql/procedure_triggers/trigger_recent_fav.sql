/* recent_fav is exactly what it sounds like - its the recent most
   favourited movie of the user.
*/
DELIMITER $$
DROP TRIGGER IF EXISTS after_fav_insert $$
CREATE TRIGGER after_fav_insert
AFTER INSERT
ON fav FOR EACH ROW
BEGIN
    update user_info
    set recent_fav = (
        select concat(primaryTitle, ' (', startYear, ')')
        from title_basics
        where tconst=NEW.tconst
    )
    where user_id=new.user_id;
END $$
DELIMITER ;
