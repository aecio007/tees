CREATE TABLE author(
   id SERIAL PRIMARY KEY,
   name TEXT NOT NULL
);

CREATE TABLE post(
   id SERIAL PRIMARY KEY,
   title TEXT NOT NULL,
   content TEXT NOT NULL,
   author_id INT NOT NULL references author(id)
);

CREATE TABLE tag(
   id SERIAL PRIMARY KEY,
   name TEXT NOT NULL
);

CREATE TABLE posts_tags(
   post_id INT NOT NULL references post(id),
   tag_id INT NOT NULL references tag(id)
 );

INSERT INTO author (id, name)
VALUES (1, 'Pete Graham'),
   	(2, 'Rachid Belaid'),
   	(3, 'Robert Berry');

INSERT INTO tag (id, name)
VALUES (1, 'scifi'),
   	(2, 'politics'),
   	(3, 'science');

INSERT INTO post (id, title, content, author_id)
VALUES (1, 'Endangered species',
    	'Pandas are an endangered species', 1 ),
   	(2, 'Freedom of Speech',
    	'Freedom of speech is a necessary right', 2),
   	(3, 'Star Wars vs Star Trek',
    	'Few words from a big fan', 3);

INSERT INTO posts_tags (post_id, tag_id)
VALUES (1, 3),
   	(2, 2),
   	(3, 1);