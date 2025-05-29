-- Erros de ortografia


-- O PostgreSQL possui uma extensão de nome pg_trgm.

CREATE EXTENSION pg_trgm;

-- A extensão pg_trgm fornece suporte para trigram que nada mais é que um N-gram com N == 3. N-grams são úteis porque permitem encontrar strings com caracteres semelhantes e, em essência, é o que representa um erro de ortografia - uma palavra que é parecida, mas não igual.


SELECT similarity('Something', 'something');

SELECT similarity('Something', 'samething');


SELECT similarity('Something', 'unrelated');


SELECT similarity('Something', 'everything');


SELECT similarity('Something', 'omething');



-- Pode-se constatar que 0,5 seja um bom número para testar a similaridade de erro de ortografia. Para isto, primeiramente é preciso criar uma lista de lexemas exclusivos usados pelos documentos.

CREATE MATERIALIZED VIEW unique_lexeme AS
SELECT word, ndoc, nentry
FROM ts_stat(
  $$
  SELECT to_tsvector('simple',
           coalesce(public.post.title, '') || ' ' ||
           coalesce(public.post.content, '') || ' ' ||
           coalesce(public.author.name, '') || ' ' ||
           coalesce(string_agg(public.tag.name, ' '), '')
         )
  FROM public.post
  JOIN public.author ON public.author.id = public.post.author_id
  JOIN public.posts_tags ON public.posts_tags.post_id = public.post.id
  JOIN public.tag ON public.tag.id = public.posts_tags.tag_id
  GROUP BY public.post.id, public.author.id
  $$
);


CREATE INDEX words_idx ON unique_lexeme USING gin(word gin_trgm_ops);

-- Caso seja necessário uma atualização, pode-se utilizar o comando:

REFRESH MATERIALIZED VIEW unique_lexeme;




--Uma vez que o objetivo de construir esta tabela era o de localizar a correspondência mais próxima para o texto, a busca se torna muito simples.

SELECT word
FROM unique_lexeme
WHERE similarity(word, 'spech') > 0.5
ORDER BY word <-> 'spech'
LIMIT 1;