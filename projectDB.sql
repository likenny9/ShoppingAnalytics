--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: categories; Type: TABLE; Schema: public; Owner: kenny; Tablespace: 
--

CREATE TABLE categories (
    id integer NOT NULL,
    name text NOT NULL,
    description text
);


ALTER TABLE public.categories OWNER TO kenny;

--
-- Name: categories_id_seq; Type: SEQUENCE; Schema: public; Owner: kenny
--

CREATE SEQUENCE categories_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.categories_id_seq OWNER TO kenny;

--
-- Name: categories_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kenny
--

ALTER SEQUENCE categories_id_seq OWNED BY categories.id;


--
-- Name: products; Type: TABLE; Schema: public; Owner: kenny; Tablespace: 
--

CREATE TABLE products (
    id integer NOT NULL,
    name text NOT NULL,
    sku text NOT NULL,
    category integer NOT NULL,
    price numeric(15,2),
    owner integer NOT NULL,
    CONSTRAINT products_price_check CHECK ((price > (0)::numeric))
);


ALTER TABLE public.products OWNER TO kenny;

--
-- Name: products_id_seq; Type: SEQUENCE; Schema: public; Owner: kenny
--

CREATE SEQUENCE products_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.products_id_seq OWNER TO kenny;

--
-- Name: products_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kenny
--

ALTER SEQUENCE products_id_seq OWNED BY products.id;


--
-- Name: purchases; Type: TABLE; Schema: public; Owner: kenny; Tablespace: 
--

CREATE TABLE purchases (
    id integer NOT NULL,
    name integer NOT NULL,
    product integer NOT NULL,
    quantity integer NOT NULL
);


ALTER TABLE public.purchases OWNER TO kenny;

--
-- Name: purchases_id_seq; Type: SEQUENCE; Schema: public; Owner: kenny
--

CREATE SEQUENCE purchases_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.purchases_id_seq OWNER TO kenny;

--
-- Name: purchases_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kenny
--

ALTER SEQUENCE purchases_id_seq OWNED BY purchases.id;


--
-- Name: signup; Type: TABLE; Schema: public; Owner: kenny; Tablespace: 
--

CREATE TABLE signup (
    id integer NOT NULL,
    name text NOT NULL,
    role text NOT NULL,
    age integer NOT NULL,
    state text NOT NULL
);


ALTER TABLE public.signup OWNER TO kenny;

--
-- Name: signup_id_seq; Type: SEQUENCE; Schema: public; Owner: kenny
--

CREATE SEQUENCE signup_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.signup_id_seq OWNER TO kenny;

--
-- Name: signup_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kenny
--

ALTER SEQUENCE signup_id_seq OWNED BY signup.id;


--
-- Name: students; Type: TABLE; Schema: public; Owner: kenny; Tablespace: 
--

CREATE TABLE students (
    id integer NOT NULL,
    pid integer,
    first_name text,
    middle_name text,
    last_name text
);


ALTER TABLE public.students OWNER TO kenny;

--
-- Name: students_id_seq; Type: SEQUENCE; Schema: public; Owner: kenny
--

CREATE SEQUENCE students_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.students_id_seq OWNER TO kenny;

--
-- Name: students_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: kenny
--

ALTER SEQUENCE students_id_seq OWNED BY students.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY categories ALTER COLUMN id SET DEFAULT nextval('categories_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY products ALTER COLUMN id SET DEFAULT nextval('products_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY purchases ALTER COLUMN id SET DEFAULT nextval('purchases_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY signup ALTER COLUMN id SET DEFAULT nextval('signup_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY students ALTER COLUMN id SET DEFAULT nextval('students_id_seq'::regclass);


--
-- Data for Name: categories; Type: TABLE DATA; Schema: public; Owner: kenny
--

COPY categories (id, name, description) FROM stdin;
1	cars	place to buy motor vehicles
16	food	noms
2	books	stuff to read
18	planes	magical
19	money	$$$$$$$$$$$$$$$$$$
24	beverages	slurpeeeee
\.


--
-- Name: categories_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kenny
--

SELECT pg_catalog.setval('categories_id_seq', 24, true);


--
-- Data for Name: products; Type: TABLE DATA; Schema: public; Owner: kenny
--

COPY products (id, name, sku, category, price, owner) FROM stdin;
3	BoxCar	A100	1	299.00	11
16	Nomnoms	NOM	16	10.00	30
20	fighter jet	MZ11	18	10000.91	11
11	AAA	SKUUUA	16	992.00	11
21	$20 bill	LINCOLN	19	20.00	11
23	777	BESTPLANES	18	1000000000.00	11
22	paper	eat paper	16	1.00	11
35	water	yums	24	2.00	11
\.


--
-- Name: products_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kenny
--

SELECT pg_catalog.setval('products_id_seq', 37, true);


--
-- Data for Name: purchases; Type: TABLE DATA; Schema: public; Owner: kenny
--

COPY purchases (id, name, product, quantity) FROM stdin;
10	16	22	1
11	36	35	2
12	36	35	2
13	36	20	1
\.


--
-- Name: purchases_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kenny
--

SELECT pg_catalog.setval('purchases_id_seq', 13, true);


--
-- Data for Name: signup; Type: TABLE DATA; Schema: public; Owner: kenny
--

COPY signup (id, name, role, age, state) FROM stdin;
11	Kenny	owner	19	California
1	Yolo	owner	1	California
3	Karen	owner	21	Alaska
15	Brandon	owner	19	Alabama
16	Eugene Lee	customer	19	South Dakota
4	John	owner	21	Montana
25	Johnny	owner	2	Kentucky
26	Johnson	owner	2	Kentucky
27	JohnsonR	owner	2	Kentucky
28	Andrea	owner	2	Alaska
29	Ab	owner	5	Delaware
30	Abe	owner	5	Delaware
31	Abes	owner	5	Delaware
32	Oh	owner	20	Connecticut
33	Ohe	owner	20	Connecticut
34	Aka	owner	90	Washington
35	Yu	owner	22	Colorado
36	KennyC	customer	19	California
\.


--
-- Name: signup_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kenny
--

SELECT pg_catalog.setval('signup_id_seq', 36, true);


--
-- Data for Name: students; Type: TABLE DATA; Schema: public; Owner: kenny
--

COPY students (id, pid, first_name, middle_name, last_name) FROM stdin;
1	77777777	Mary		Doe
3	1234	Bob	Super	Man
4	0	A	B	C
5	10	BB	ASD	ASD
6	1	asd	asd	asd
7	11	asd	asd	\N
2	88888888	Johnny	T	Smith
\.


--
-- Name: students_id_seq; Type: SEQUENCE SET; Schema: public; Owner: kenny
--

SELECT pg_catalog.setval('students_id_seq', 7, true);


--
-- Name: categories_name_key; Type: CONSTRAINT; Schema: public; Owner: kenny; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_name_key UNIQUE (name);


--
-- Name: categories_pkey; Type: CONSTRAINT; Schema: public; Owner: kenny; Tablespace: 
--

ALTER TABLE ONLY categories
    ADD CONSTRAINT categories_pkey PRIMARY KEY (id);


--
-- Name: products_pkey; Type: CONSTRAINT; Schema: public; Owner: kenny; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_pkey PRIMARY KEY (id);


--
-- Name: products_sku_key; Type: CONSTRAINT; Schema: public; Owner: kenny; Tablespace: 
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_sku_key UNIQUE (sku);


--
-- Name: purchases_pkey; Type: CONSTRAINT; Schema: public; Owner: kenny; Tablespace: 
--

ALTER TABLE ONLY purchases
    ADD CONSTRAINT purchases_pkey PRIMARY KEY (id);


--
-- Name: signup_name_key; Type: CONSTRAINT; Schema: public; Owner: kenny; Tablespace: 
--

ALTER TABLE ONLY signup
    ADD CONSTRAINT signup_name_key UNIQUE (name);


--
-- Name: signup_pkey; Type: CONSTRAINT; Schema: public; Owner: kenny; Tablespace: 
--

ALTER TABLE ONLY signup
    ADD CONSTRAINT signup_pkey PRIMARY KEY (id);


--
-- Name: students_pkey; Type: CONSTRAINT; Schema: public; Owner: kenny; Tablespace: 
--

ALTER TABLE ONLY students
    ADD CONSTRAINT students_pkey PRIMARY KEY (id);


--
-- Name: products_category_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_category_fkey FOREIGN KEY (category) REFERENCES categories(id);


--
-- Name: products_owner_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY products
    ADD CONSTRAINT products_owner_fkey FOREIGN KEY (owner) REFERENCES signup(id);


--
-- Name: purchases_name_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY purchases
    ADD CONSTRAINT purchases_name_fkey FOREIGN KEY (name) REFERENCES signup(id);


--
-- Name: purchases_product_fkey; Type: FK CONSTRAINT; Schema: public; Owner: kenny
--

ALTER TABLE ONLY purchases
    ADD CONSTRAINT purchases_product_fkey FOREIGN KEY (product) REFERENCES products(id);


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- PostgreSQL database dump complete
--

