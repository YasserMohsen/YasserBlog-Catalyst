CREATE TABLE `users` (
	`id` INT(10) NOT NULL  AUTO_INCREMENT,
	`fname` varchar(20) NOT NULL,
	`lname` varchar(20) NOT NULL,
	`username` varchar(30) NOT NULL UNIQUE,
	`email` varchar(40) NOT NULL UNIQUE,
	`password` varchar(42) NOT NULL,
	`gender` varchar(10) NOT NULL,
	`role` varchar(10) NOT NULL,
	`avatar` varchar(40) NOT NULL,
	`regDate` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `posts` (
	`id` INT(10) NOT NULL  AUTO_INCREMENT,
	`userId` INT(10) NOT NULL,
	`title` varchar(30) NOT NULL,
	`content` varchar(1000) NOT NULL,
	`postDate` DATETIME NOT NULL,
	`editDate` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

CREATE TABLE `comments` (
	`id` INT(10) NOT NULL  AUTO_INCREMENT,
	`userId` INT(10) NOT NULL,
	`postId` INT(10) NOT NULL,
	`content` varchar(200) NOT NULL,
	`commentDate` DATETIME NOT NULL,
	`editDate` DATETIME NOT NULL,
	PRIMARY KEY (`id`)
);

ALTER TABLE `posts` ADD CONSTRAINT `posts_fk0` FOREIGN KEY (`userId`) REFERENCES `users`(`id`);

ALTER TABLE `comments` ADD CONSTRAINT `comments_fk0` FOREIGN KEY (`userId`) REFERENCES `users`(`id`);

ALTER TABLE `comments` ADD CONSTRAINT `comments_fk1` FOREIGN KEY (`postId`) REFERENCES `posts`(`id`);

