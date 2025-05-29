-- Agora que foi exemplificado como fazer buscas do tipo full-text, vamos voltar para a tabela e esquema criados no início deste artigo e fazer consultas no documento.


SELECT pid, p_title
FROM (SELECT post.id as pid,
         	post.title as p_title,
         	to_tsvector(post.title) ||
         	to_tsvector(post.content) ||
         	to_tsvector(author.name) ||
         	to_tsvector(coalesce(string_agg(tag.name, ' '))) as document
  	FROM post
  	JOIN author ON author.id = post.author_id
  	JOIN posts_tags ON posts_tags.post_id = posts_tags.tag_id
  	JOIN tag ON tag.id = posts_tags.tag_id
  	GROUP BY post.id, author.id) p_search
WHERE p_search.document @@ to_tsquery('Endangered & Species');


-- O resultado da consulta vai retornar o documento que contém como título 'Endangered species' ou lexemas que estejam o suficientemente próximos ao procurado.