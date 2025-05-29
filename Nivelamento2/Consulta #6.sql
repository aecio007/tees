SELECT to_tsvector('If the facts don''t fit the theory, change the facts') @@ to_tsquery('! fact');

SELECT to_tsvector('If the facts don''t fit the theory, change the facts') @@ to_tsquery('theory & !fact');



SELECT to_tsvector('If the facts don''t fit the theory, change the facts.') @@ to_tsquery('fiction | theory');