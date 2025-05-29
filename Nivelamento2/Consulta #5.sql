SELECT 'impossible'::tsquery, to_tsquery('impossible');

SELECT 'dream'::tsquery, to_tsquery('dream');

SELECT to_tsvector('It''s kind of fun to do the impossible') @@ to_tsquery('impossible');