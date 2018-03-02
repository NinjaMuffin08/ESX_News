USE `essentialmode`;

CREATE TABLE `news_main` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` VARCHAR(100) COLLATE utf8mb4_bin,
  `bait_title` VARCHAR(100) COLLATE utf8mb4_bin,
  `content` VARCHAR(1000) COLLATE utf8mb4_bin,
  `author_name` VARCHAR(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `author_id` VARCHAR(60) NOT NULL,
  `news_type` VARCHAR(60) NOT NULL,
  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;


CREATE TABLE `news_likes` (
  
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `news_id` int(11) NOT NULL,
  `author_id` VARCHAR(60) NOT NULL,
  `liker_id` VARCHAR(60) NOT NULL,
  
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=266 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;
