/* After a user adds a favorite movie or after he deletes one,
   update his fav_genre
*/

DELIMITER $$
   
DROP TRIGGER IF EXISTS after_fav_insert_fg $$
CREATE TRIGGER after_fav_insert_fg
AFTER INSERT
ON fav FOR EACH ROW
BEGIN
    call set_fav_genre(NEW.user_id);
END $$

DROP TRIGGER IF EXISTS after_fav_delete_fg $$
CREATE TRIGGER after_fav_delete_fg
AFTER DELETE
ON fav FOR EACH ROW
BEGIN
    call set_fav_genre(OLD.user_id);
END $$
DELIMITER ;
