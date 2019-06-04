--
-- PostgreSQL database dump
--

-- Dumped from database version 11.3
-- Dumped by pg_dump version 11.3

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: my_aum; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA my_aum;


ALTER SCHEMA my_aum OWNER TO postgres;

--
-- Name: commits_approval_status; Type: TYPE; Schema: my_aum; Owner: postgres
--

CREATE TYPE my_aum.commits_approval_status AS ENUM (
    '0',
    '1',
    '-1'
);


ALTER TYPE my_aum.commits_approval_status OWNER TO postgres;

--
-- Name: requests_approval_status; Type: TYPE; Schema: my_aum; Owner: postgres
--

CREATE TYPE my_aum.requests_approval_status AS ENUM (
    '-1',
    '0',
    '1',
    '2'
);


ALTER TYPE my_aum.requests_approval_status OWNER TO postgres;

--
-- Name: requests_clients_install_status; Type: TYPE; Schema: my_aum; Owner: postgres
--

CREATE TYPE my_aum.requests_clients_install_status AS ENUM (
    '-1',
    '0',
    '1'
);


ALTER TYPE my_aum.requests_clients_install_status OWNER TO postgres;

--
-- Name: requests_install_type; Type: TYPE; Schema: my_aum; Owner: postgres
--

CREATE TYPE my_aum.requests_install_type AS ENUM (
    '0',
    '1'
);


ALTER TYPE my_aum.requests_install_type OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: areas; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.areas (
    area_id integer NOT NULL,
    area_name character varying(50) NOT NULL
);


ALTER TABLE my_aum.areas OWNER TO postgres;

--
-- Name: areas_area_id_seq; Type: SEQUENCE; Schema: my_aum; Owner: postgres
--

CREATE SEQUENCE my_aum.areas_area_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_aum.areas_area_id_seq OWNER TO postgres;

--
-- Name: areas_area_id_seq; Type: SEQUENCE OWNED BY; Schema: my_aum; Owner: postgres
--

ALTER SEQUENCE my_aum.areas_area_id_seq OWNED BY my_aum.areas.area_id;


--
-- Name: branches; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.branches (
    branch_id integer NOT NULL,
    branch_name character varying(50) NOT NULL
);


ALTER TABLE my_aum.branches OWNER TO postgres;

--
-- Name: branches_branch_id_seq; Type: SEQUENCE; Schema: my_aum; Owner: postgres
--

CREATE SEQUENCE my_aum.branches_branch_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_aum.branches_branch_id_seq OWNER TO postgres;

--
-- Name: branches_branch_id_seq; Type: SEQUENCE OWNED BY; Schema: my_aum; Owner: postgres
--

ALTER SEQUENCE my_aum.branches_branch_id_seq OWNED BY my_aum.branches.branch_id;


--
-- Name: commits; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.commits (
    commit_id integer NOT NULL,
    creation_timestamp timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    title character varying(100) NOT NULL,
    description text NOT NULL,
    author_user_id integer NOT NULL,
    components text NOT NULL,
    branch_id integer NOT NULL,
    approval_status my_aum.commits_approval_status DEFAULT '0'::my_aum.commits_approval_status NOT NULL,
    approvation_timestamp timestamp with time zone,
    approvation_comment text,
    approver_user_id integer
);


ALTER TABLE my_aum.commits OWNER TO postgres;

--
-- Name: commits_commit_id_seq; Type: SEQUENCE; Schema: my_aum; Owner: postgres
--

CREATE SEQUENCE my_aum.commits_commit_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_aum.commits_commit_id_seq OWNER TO postgres;

--
-- Name: commits_commit_id_seq; Type: SEQUENCE OWNED BY; Schema: my_aum; Owner: postgres
--

ALTER SEQUENCE my_aum.commits_commit_id_seq OWNED BY my_aum.commits.commit_id;


--
-- Name: requests; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.requests (
    request_id integer NOT NULL,
    title character varying(100) NOT NULL,
    description text NOT NULL,
    components text NOT NULL,
    branch_id integer NOT NULL,
    author_user_id integer NOT NULL,
    creation_timestamp timestamp with time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    approval_status my_aum.requests_approval_status DEFAULT '0'::my_aum.requests_approval_status NOT NULL,
    approvation_timestamp timestamp with time zone,
    approvation_comment text,
    approver_user_id integer,
    sender_user_id integer,
    send_timestamp timestamp with time zone,
    install_type my_aum.requests_install_type NOT NULL,
    install_link character varying(255) DEFAULT NULL::character varying
);


ALTER TABLE my_aum.requests OWNER TO postgres;

--
-- Name: requests_clients; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.requests_clients (
    request_id integer NOT NULL,
    client_user_id integer NOT NULL,
    install_timestamp timestamp with time zone,
    install_status my_aum.requests_clients_install_status DEFAULT '0'::my_aum.requests_clients_install_status NOT NULL,
    comment text
);


ALTER TABLE my_aum.requests_clients OWNER TO postgres;

--
-- Name: requests_commits; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.requests_commits (
    request_id integer NOT NULL,
    commit_id integer NOT NULL
);


ALTER TABLE my_aum.requests_commits OWNER TO postgres;

--
-- Name: requests_request_id_seq; Type: SEQUENCE; Schema: my_aum; Owner: postgres
--

CREATE SEQUENCE my_aum.requests_request_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_aum.requests_request_id_seq OWNER TO postgres;

--
-- Name: requests_request_id_seq; Type: SEQUENCE OWNED BY; Schema: my_aum; Owner: postgres
--

ALTER SEQUENCE my_aum.requests_request_id_seq OWNED BY my_aum.requests.request_id;


--
-- Name: roles; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.roles (
    role_id integer NOT NULL,
    role_name character varying(25) NOT NULL,
    role_string character varying(50) NOT NULL
);


ALTER TABLE my_aum.roles OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE; Schema: my_aum; Owner: postgres
--

CREATE SEQUENCE my_aum.roles_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_aum.roles_role_id_seq OWNER TO postgres;

--
-- Name: roles_role_id_seq; Type: SEQUENCE OWNED BY; Schema: my_aum; Owner: postgres
--

ALTER SEQUENCE my_aum.roles_role_id_seq OWNED BY my_aum.roles.role_id;


--
-- Name: users; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.users (
    user_id integer NOT NULL,
    username character varying(30) NOT NULL,
    hash_pass character varying(255) NOT NULL,
    email character varying(50) NOT NULL,
    name character varying(50) NOT NULL,
    area_id integer
);


ALTER TABLE my_aum.users OWNER TO postgres;

--
-- Name: users_roles; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.users_roles (
    user_id integer NOT NULL,
    role_id smallint NOT NULL
);


ALTER TABLE my_aum.users_roles OWNER TO postgres;

--
-- Name: users_tokens; Type: TABLE; Schema: my_aum; Owner: postgres
--

CREATE TABLE my_aum.users_tokens (
    token character varying(100) NOT NULL,
    user_id integer NOT NULL,
    token_expire bigint NOT NULL
);


ALTER TABLE my_aum.users_tokens OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE; Schema: my_aum; Owner: postgres
--

CREATE SEQUENCE my_aum.users_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE my_aum.users_user_id_seq OWNER TO postgres;

--
-- Name: users_user_id_seq; Type: SEQUENCE OWNED BY; Schema: my_aum; Owner: postgres
--

ALTER SEQUENCE my_aum.users_user_id_seq OWNED BY my_aum.users.user_id;


--
-- Name: areas area_id; Type: DEFAULT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.areas ALTER COLUMN area_id SET DEFAULT nextval('my_aum.areas_area_id_seq'::regclass);


--
-- Name: branches branch_id; Type: DEFAULT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.branches ALTER COLUMN branch_id SET DEFAULT nextval('my_aum.branches_branch_id_seq'::regclass);


--
-- Name: commits commit_id; Type: DEFAULT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.commits ALTER COLUMN commit_id SET DEFAULT nextval('my_aum.commits_commit_id_seq'::regclass);


--
-- Name: requests request_id; Type: DEFAULT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests ALTER COLUMN request_id SET DEFAULT nextval('my_aum.requests_request_id_seq'::regclass);


--
-- Name: roles role_id; Type: DEFAULT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.roles ALTER COLUMN role_id SET DEFAULT nextval('my_aum.roles_role_id_seq'::regclass);


--
-- Name: users user_id; Type: DEFAULT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users ALTER COLUMN user_id SET DEFAULT nextval('my_aum.users_user_id_seq'::regclass);


--
-- Data for Name: areas; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.areas (area_id, area_name) FROM stdin;
1	Area 1
\.


--
-- Data for Name: branches; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.branches (branch_id, branch_name) FROM stdin;
1	Tres-Zap
2	Pannier
3	Y-find
4	Wrapsafe
5	Aerified
\.


--
-- Data for Name: commits; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.commits (commit_id, creation_timestamp, title, description, author_user_id, components, branch_id, approval_status, approvation_timestamp, approvation_comment, approver_user_id) FROM stdin;
1	2018-11-07 11:45:31+01	Michaux's Stitchwort	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.	2	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.	2	0	\N	\N	\N
2	2019-02-27 01:09:02+01	Western Black Currant	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	2	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	1	1	2018-05-13 09:49:05+02		2
3	2018-09-23 13:17:51+02	Papery Schiedea	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	2	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	2	-1	2019-03-14 23:20:28+01		2
4	2018-12-10 21:19:47+01	Smooth Strongbark	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.	1	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	4	-1	2018-08-01 01:16:22+02	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.	2
5	2018-12-27 05:17:05+01	Viscid Acacia	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	2	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.	1	0	\N	\N	\N
6	2018-11-13 17:14:10+01	Myelochroa Lichen	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	2	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.	5	-1	2018-06-17 00:47:23+02	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	2
7	2019-03-04 20:34:51+01	Prostrate Yellowcress	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	2	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.	4	0	\N	\N	\N
8	2018-05-03 19:29:02+02	Flowery Phlox	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.	1	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	1	-1	2018-10-13 02:41:22+02		2
9	2019-02-19 16:18:52+01	Spreading Bladderpod	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	1	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.	2	-1	2018-11-21 17:16:55+01		2
10	2018-06-09 08:47:58+02	Malheur Penstemon	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	1	Phasellus in felis. Donec semper sapien a libero. Nam dui.	4	-1	2018-10-23 01:12:14+02	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	2
11	2018-05-30 01:05:06+02	Box Bedstraw	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	1	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	2	1	2019-03-19 16:22:18+01		2
12	2019-01-01 03:54:09+01	Australian Tallowwood	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	1	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.	4	-1	2018-07-16 08:42:16+02		2
13	2018-07-27 17:04:24+02	Bioletti's Rush Broom	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	1	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.	5	-1	2019-04-13 02:27:03+02		2
14	2018-05-09 10:43:35+02	Broadleaf Maidenhair	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.	1	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	1	1	2019-03-29 12:20:53+01		2
15	2018-08-05 07:40:15+02	Capeweed	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	1	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	3	-1	2019-02-22 12:37:14+01		2
16	2019-01-03 05:00:14+01	Narrow-leaf Bottlebrush	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.	1	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	3	1	2018-10-09 09:54:50+02	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	2
17	2019-02-11 15:22:37+01	Cracked Lichen	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	1	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	1	0	\N	\N	\N
18	2018-11-22 00:26:26+01	Tall Alumroot	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	2	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	4	1	2018-08-23 22:32:26+02		2
19	2019-01-26 07:38:07+01	Longtongue Muhly	Phasellus in felis. Donec semper sapien a libero. Nam dui.	1	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.	3	-1	2019-04-05 00:46:56+02		2
20	2018-12-29 22:20:02+01	American Bellflower	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	2	Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.	2	-1	2018-09-25 02:03:26+02	In congue. Etiam justo. Etiam pretium iaculis justo.	2
21	2018-04-28 02:57:09+02	Northern Selaginella	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	2	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.	3	1	2018-11-22 15:01:11+01		2
22	2018-07-01 02:32:32+02	Sarsparilla Vine	Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.	2	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	2	1	2018-08-12 00:31:19+02		2
23	2018-06-18 17:44:24+02	South Idaho Onion	In congue. Etiam justo. Etiam pretium iaculis justo.	2	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	1	-1	2018-05-10 15:19:35+02	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	2
24	2019-03-02 00:28:54+01	Cajeput	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	2	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	3	-1	2018-09-16 14:50:52+02		2
25	2019-03-04 14:06:47+01	Poranopsis	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	1	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	3	1	2018-06-20 21:00:39+02		2
26	2018-12-21 17:41:51+01	Woolly Bluestar	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	1	Fusce consequat. Nulla nisl. Nunc nisl.	4	-1	2018-05-16 13:28:37+02	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	2
27	2018-12-08 15:57:59+01	Newberry's Cinquefoil	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.	1	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.	4	0	\N	\N	\N
28	2018-08-12 18:30:18+02	Yampa Beardtongue	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	1	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	2	-1	2018-05-10 10:21:53+02	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	2
29	2018-12-28 16:39:57+01	Mameyuelo	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	2	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	1	1	2018-05-14 12:08:22+02		2
30	2018-05-31 20:45:27+02	White Leadtree	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	2	Fusce consequat. Nulla nisl. Nunc nisl.	4	1	2018-05-15 16:16:08+02	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	2
31	2018-09-04 19:14:48+02	Nodding Chickweed	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	2	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	3	0	\N	\N	\N
32	2018-11-08 09:48:28+01	Mat Penstemon	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.	2	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.	1	0	\N	\N	\N
33	2018-06-18 14:40:15+02	Fitch's Tarweed	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.	2	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	4	1	2019-03-19 18:07:30+01		2
34	2018-06-15 11:27:40+02	Hawkweed	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	1	Sed ante. Vivamus tortor. Duis mattis egestas metus.	3	1	2018-04-24 14:02:54+02	Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.	2
35	2018-05-03 20:21:47+02	Cereal Rye	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	1	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.	2	1	2018-10-21 03:29:59+02	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	2
36	2019-02-20 16:23:47+01	Arizona Sycamore	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	2	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	1	0	\N	\N	\N
37	2019-03-14 00:54:28+01	Black Highbush Blueberry	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	1	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	1	-1	2018-11-21 20:28:11+01		2
38	2018-12-04 08:00:38+01	Clustered Thistle	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	1	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	4	-1	2018-06-23 04:34:16+02		2
39	2018-07-31 08:27:58+02	Threelocule Corchorus	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	2	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	2	1	2019-02-28 15:24:17+01	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	2
40	2018-12-07 22:53:25+01	Slender Monkeyflower	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	2	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.	3	0	\N	\N	\N
41	2018-05-05 12:43:59+02	Pitseed Goosefoot	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	2	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.	5	0	\N	\N	\N
42	2019-02-25 09:43:51+01	Gregg's Prairie Clover	Fusce consequat. Nulla nisl. Nunc nisl.	1	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	4	-1	2018-07-06 17:34:21+02	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.	2
43	2019-03-29 09:40:21+01	Island Sand Pea	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	1	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	5	1	2018-07-20 05:05:41+02	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	2
44	2018-11-17 00:33:10+01	Madiera Cranesbill	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	2	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	4	0	\N	\N	\N
45	2018-05-15 03:22:54+02	Tomcat Clover	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	1	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.	3	1	2018-10-03 04:03:19+02	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	2
46	2019-04-06 21:10:29+02	Mountain Monardella	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	2	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	1	1	2018-11-15 13:12:40+01		2
47	2019-01-02 08:31:07+01	Hoover's Woollystar	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.	1	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	1	1	2018-12-31 01:56:29+01	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	2
48	2018-05-04 07:54:43+02	Ivy Buttercup	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.	2	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	5	1	2018-09-14 07:04:44+02		2
49	2019-01-27 14:32:23+01	Rattan's Monkeyflower	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	2	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	1	0	\N	\N	\N
50	2018-09-16 22:02:47+02	Dragon Milkvetch	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	1	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.	5	0	\N	\N	\N
51	2018-12-02 12:30:02+01	Royal Adder's-mouth Orchid	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.	1	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	3	-1	2018-08-10 22:34:02+02	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.	2
52	2018-06-25 21:30:53+02	Oahu Wild Coffee	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	1	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.	3	-1	2018-06-01 09:42:22+02		2
53	2018-07-19 07:23:03+02	Del Norte Pea	Phasellus in felis. Donec semper sapien a libero. Nam dui.	2	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.	4	0	\N	\N	\N
54	2019-03-01 15:17:05+01	Desert Aspicilia	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.	1	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	1	0	\N	\N	\N
55	2018-05-09 18:17:14+02	Leptodontium Moss	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	2	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.	4	-1	2019-04-18 07:30:52+02		2
56	2018-12-16 07:07:00+01	Stiff Tonguefern	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	1	In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.	3	0	\N	\N	\N
57	2018-11-25 02:14:50+01	Sharp's Club Lichen	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	1	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	5	-1	2019-01-15 07:41:53+01	Fusce consequat. Nulla nisl. Nunc nisl.	2
58	2018-09-13 21:46:02+02	Desert Willow	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	1	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	1	0	\N	\N	\N
59	2018-11-21 15:19:38+01	Phoenician Juniper	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	2	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.	5	0	\N	\N	\N
60	2018-09-15 10:19:51+02	Venturiella Moss	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	2	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.	2	0	\N	\N	\N
61	2018-05-19 09:34:31+02	False Foxglove	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.	2	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	1	1	2019-01-16 08:15:48+01	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	2
62	2018-04-30 16:38:48+02	Kern Plateau Bird's-beak	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.	1	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.	1	0	\N	\N	\N
63	2018-07-04 03:15:44+02	Drepanocladus Moss	In congue. Etiam justo. Etiam pretium iaculis justo.	1	Sed ante. Vivamus tortor. Duis mattis egestas metus.	5	-1	2019-01-26 02:52:05+01		2
64	2019-03-05 09:57:00+01	Ring Muhly	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.	2	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	4	-1	2019-01-16 09:21:31+01	Sed ante. Vivamus tortor. Duis mattis egestas metus.	2
65	2018-12-17 07:20:35+01	Gadellia	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	1	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	4	0	\N	\N	\N
66	2018-08-08 11:51:14+02	Leichhardt's Duboisia	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	1	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	5	1	2019-04-10 04:25:50+02	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.	2
67	2018-11-03 20:15:04+01	Sensitive Partridge Pea	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.	2	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	1	-1	2018-08-01 10:11:01+02	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	2
68	2018-10-17 01:36:20+02	Pinellia	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	1	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.	3	-1	2018-07-07 06:11:08+02	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	2
69	2018-06-08 10:55:48+02	Ironweed	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.	1	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.	2	1	2019-02-21 22:47:52+01		2
70	2018-08-07 02:43:20+02	Streamside Leptodictyum Moss	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	1	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.	1	-1	2018-10-14 12:57:34+02	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	2
71	2019-02-02 17:21:27+01	Clubmoss Mousetail	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.	2	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	3	1	2018-12-19 00:16:21+01		2
72	2018-07-15 01:21:41+02	Long's Blackberry	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.	2	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	1	1	2018-07-23 19:28:26+02		2
73	2018-05-13 07:48:57+02	Scaly Polypody	In congue. Etiam justo. Etiam pretium iaculis justo.	2	Fusce consequat. Nulla nisl. Nunc nisl.	5	1	2018-06-02 12:10:49+02		2
74	2018-11-19 11:23:59+01	Florida Anisetree	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	2	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	5	0	\N	\N	\N
75	2018-05-21 04:54:26+02	Kaholuamanu Schiedea	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	1	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.	1	1	2019-03-03 15:52:17+01		2
76	2019-03-31 19:38:47+02	European Hawkweed	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	1	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	3	0	\N	\N	\N
77	2018-07-29 13:59:51+02	Hulten's Crabseye Lichen	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.	2	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	3	-1	2018-11-23 00:54:24+01	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.	2
78	2018-05-21 01:59:19+02	Giant Blue Iris	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	1	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	1	-1	2018-07-31 08:59:54+02		2
79	2018-05-25 14:16:50+02	Grugru Palm	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	1	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	4	1	2018-05-26 20:56:02+02		2
80	2018-08-02 19:41:22+02	Orange Lichen	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.	1	In congue. Etiam justo. Etiam pretium iaculis justo.	5	1	2018-07-18 09:57:01+02		2
81	2019-02-18 07:35:15+01	Spanish False Fleabane	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.	1	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	2	1	2019-02-11 09:33:21+01	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	2
82	2019-02-05 03:14:53+01	King Protea	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	1	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	2	0	\N	\N	\N
83	2018-11-20 05:12:01+01	Bull's Coraldrops	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.	2	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.	5	-1	2018-06-06 06:13:19+02		2
84	2019-02-15 05:32:40+01	Wall Germander	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	2	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	3	1	2018-07-27 05:15:23+02	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	2
85	2018-10-24 07:47:06+02	Jelly Lichen	In congue. Etiam justo. Etiam pretium iaculis justo.	2	In congue. Etiam justo. Etiam pretium iaculis justo.	1	0	\N	\N	\N
86	2018-05-26 09:01:26+02	Pepperweed	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.	2	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	5	-1	2018-06-21 17:48:13+02	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.	2
87	2019-03-16 23:20:25+01	Polyblastia Lichen	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	2	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	4	0	\N	\N	\N
88	2019-01-19 07:47:17+01	Koaoha	Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.	1	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	2	1	2018-12-19 20:43:04+01	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	2
89	2018-10-31 05:47:57+01	Sticky Whiteleaf Manzanita	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	2	Phasellus in felis. Donec semper sapien a libero. Nam dui.	1	0	\N	\N	\N
90	2018-08-06 05:59:23+02	Buckroot	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	1	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.	4	0	\N	\N	\N
91	2019-03-13 01:30:51+01	Blue Elderberry	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.	2	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	3	-1	2018-11-07 14:32:36+01	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	2
92	2018-10-20 10:26:41+02	Late Snakeweed	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	1	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	1	0	\N	\N	\N
93	2019-04-08 07:42:41+02	Wahiawa Cyanea	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	1	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	3	1	2019-05-14 10:29:17+02		1
94	2019-01-18 10:05:53+01	Cavedwelling Evening Primrose	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	2	In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.	3	-1	2018-07-28 05:22:02+02	Phasellus in felis. Donec semper sapien a libero. Nam dui.	2
95	2018-08-12 00:49:53+02	Appalachian Avens	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	2	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.	4	0	\N	\N	\N
96	2018-05-15 17:37:40+02	Sycamore Fig	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	2	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	5	0	\N	\N	\N
97	2018-07-02 10:49:13+02	Capejewels	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.	2	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.	4	0	\N	\N	\N
98	2019-04-20 22:10:45+02	Clovenlip Toadflax	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	2	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	5	1	2018-11-27 23:25:10+01		2
99	2018-10-08 17:09:07+02	Bigpod Ceanothus	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	2	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.	5	0	\N	\N	\N
100	2018-05-12 23:44:22+02	Holboell's Rockcress	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	1	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	3	1	2018-07-20 07:58:32+02		2
\.


--
-- Data for Name: requests; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.requests (request_id, title, description, components, branch_id, author_user_id, creation_timestamp, approval_status, approvation_timestamp, approvation_comment, approver_user_id, sender_user_id, send_timestamp, install_type, install_link) FROM stdin;
1	Red-hot Cat's Tail	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	1	1	2019-04-07 04:32:50+02	2	2018-12-27 09:23:24+01	Fusce consequat. Nulla nisl. Nunc nisl.	2	5	2018-11-08 14:26:33+01	1	http://163.com/faucibus/orci/luctus/et.png
2	Bachmanniomyces Lichen	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	5	1	2018-11-09 21:42:47+01	2	2018-07-30 18:27:35+02		2	5	2018-09-27 07:58:38+02	0	https://usda.gov/sit/amet.jpg
3	Southwestern White Pine Dwarf Mistletoe	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.	5	1	2018-06-05 14:54:28+02	2	2019-03-21 03:48:19+01		2	5	2018-08-08 10:30:06+02	1	https://upenn.edu/non/velit/donec.xml
4	Branched Tearthumb	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	Duis bibendum. Morbi non quam nec dui luctus rutrum. Nulla tellus.	5	1	2018-11-22 03:12:33+01	-1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
5	Touret's Scleropodium Moss	In sagittis dui vel nisl. Duis ac nibh. Fusce lacus purus, aliquet at, feugiat non, pretium quis, lectus.	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.	5	2	2019-04-01 16:53:17+02	-1	2019-05-13 17:20:35+02	Fusce consequat. Nulla nisl. Nunc nisl.	2	\N	\N	0	\N
6	Maemon Valley Maiden Fern	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.	4	1	2018-07-02 14:17:55+02	1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
7	Caliche Sandmat	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	5	1	2018-12-03 17:31:07+01	0	\N	\N	\N	\N	\N	0	\N
8	Barnacle Lichen	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	4	1	2018-08-28 07:59:16+02	0	\N	\N	\N	\N	\N	0	\N
9	Serrate Spurge	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	1	2	2019-03-27 12:48:41+01	2	2019-02-07 16:48:08+01		2	5	2019-04-13 23:16:53+02	0	https://friendfeed.com/aliquet/at/feugiat/non/pretium/quis.jsp
10	Hitchcock's Mock Orange	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	1	2	2019-03-10 19:37:28+01	2	2019-05-13 17:20:35+02	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	2	1	2019-05-14 14:19:52+02	0	hhhh
11	Northern Catalpa	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	2	1	2018-05-18 04:28:28+02	1	2019-05-13 17:20:35+02	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	2	\N	\N	0	\N
12	Harvey's Hawthorn	Phasellus in felis. Donec semper sapien a libero. Nam dui.	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	4	2	2018-12-08 13:17:53+01	0	\N	\N	\N	\N	\N	1	\N
13	Uinta Mountain Beardtongue	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	2	1	2018-11-11 22:06:01+01	-1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
14	Alabama Azalea	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.	5	2	2018-12-30 11:27:08+01	0	\N	\N	\N	\N	\N	0	\N
15	Polytrichum Moss	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	Sed ante. Vivamus tortor. Duis mattis egestas metus.	1	2	2018-12-26 14:12:01+01	1	2019-05-13 17:20:35+02	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	2	\N	\N	1	\N
16	Roundleaf Candyleaf	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	4	2	2018-10-24 09:28:45+02	0	\N	\N	\N	\N	\N	0	\N
17	Velvetpod Mimosa	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	3	2	2018-09-14 23:23:51+02	0	\N	\N	\N	\N	\N	0	\N
18	Forest Snakevine	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	2	1	2018-09-16 03:57:07+02	-1	2019-05-13 17:20:35+02	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	2	\N	\N	0	\N
19	Roundleaf Thoroughwort	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	1	2	2018-05-24 11:28:31+02	1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
20	Rimmed Navel Lichen	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	Phasellus in felis. Donec semper sapien a libero. Nam dui.	1	1	2018-12-14 10:02:23+01	2	2019-01-17 18:59:32+01		2	5	2019-02-23 08:54:35+01	1	http://java.com/nulla/facilisi/cras/non/velit/nec.aspx
40	Mecca Woodyaster	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	1	1	2018-08-06 20:13:47+02	1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
21	Obscure Shield Lichen	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	5	1	2018-08-23 16:28:23+02	1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
22	Widow's-thrill	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	Fusce consequat. Nulla nisl. Nunc nisl.	3	1	2018-09-24 01:06:14+02	-1	2019-05-13 17:20:35+02	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	2	\N	\N	1	\N
23	Akolea	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	5	1	2019-02-05 17:15:02+01	1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
24	Cracked Lichen	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	3	1	2018-06-08 18:34:33+02	0	\N	\N	\N	\N	\N	1	\N
25	Whitewhorl Lupine	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	2	2	2018-11-01 10:13:59+01	-1	2019-05-13 17:20:35+02	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	2	\N	\N	0	\N
26	Wright's Cudweed	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	In congue. Etiam justo. Etiam pretium iaculis justo.	2	2	2018-11-17 23:10:23+01	1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
27	Texas Xanthopsorella Lichen	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	In congue. Etiam justo. Etiam pretium iaculis justo.	5	2	2018-06-28 04:13:41+02	-1	2019-05-13 17:20:35+02	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.	2	\N	\N	0	\N
28	Stebbins' Lewisia	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	2	2	2018-07-16 18:53:57+02	-1	2019-05-13 17:20:35+02	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	2	\N	\N	0	\N
29	Clamshell Orchid	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	1	2	2019-01-29 11:43:20+01	1	2019-05-13 17:20:35+02	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	2	\N	\N	1	\N
30	Blue-fly Honeysuckle	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	5	2	2019-01-05 10:27:17+01	0	\N	\N	\N	\N	\N	0	\N
31	Shortstalk Bristle Fern	In congue. Etiam justo. Etiam pretium iaculis justo.	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	3	2	2019-04-04 10:10:11+02	1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
32	Narrowleaf Dock	Phasellus in felis. Donec semper sapien a libero. Nam dui.	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	4	1	2018-12-15 08:48:49+01	0	\N	\N	\N	\N	\N	0	\N
33	Clinton's Bulrush	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	1	2	2018-05-28 06:20:36+02	2	2018-11-20 16:52:39+01	Phasellus in felis. Donec semper sapien a libero. Nam dui.	2	5	2018-05-30 10:15:42+02	1	https://ovh.net/ut/rhoncus/aliquet.aspx
34	Soldierwood	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	1	2	2018-11-06 17:50:41+01	1	2019-05-13 17:20:35+02	Fusce consequat. Nulla nisl. Nunc nisl.	2	\N	\N	0	\N
35	Horsehair Lichen	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	3	2	2018-09-08 15:11:38+02	0	\N	\N	\N	\N	\N	0	\N
36	Ehrenberg's Vervain	Phasellus in felis. Donec semper sapien a libero. Nam dui.	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.	1	1	2018-05-04 03:50:41+02	2	2019-02-25 09:34:46+01		2	5	2018-11-26 23:38:20+01	0	http://vk.com/egestas/metus.html
37	Rimmed Lichen	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	1	1	2018-12-01 02:00:59+01	1	2019-05-13 17:20:35+02	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	2	\N	\N	1	\N
38	High Mountain Penstemon	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	3	1	2018-09-29 03:38:17+02	2	2019-03-12 07:08:36+01		2	5	2019-02-13 13:47:30+01	0	https://ted.com/eget/orci.png
39	Rosette Lichen	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	2	2	2019-01-29 03:01:02+01	2	2019-02-07 02:47:43+01	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.	2	5	2018-05-13 03:12:06+02	0	http://facebook.com/sapien/urna/pretium/nisl.html
41	California Biddy-biddy	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.	1	2	2018-05-29 07:09:10+02	1	2019-05-13 17:20:35+02	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.	2	\N	\N	0	\N
42	Black Crowberry	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	3	2	2019-04-14 18:24:35+02	1	2019-05-13 17:20:35+02	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	2	\N	\N	0	\N
43	Hooker's Scratchdaisy	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	Sed ante. Vivamus tortor. Duis mattis egestas metus.	3	2	2018-10-20 00:18:49+02	2	2019-01-09 15:44:18+01		2	5	2019-02-18 14:28:26+01	0	https://disqus.com/odio.jpg
44	Shortspur Seablush	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	3	2	2018-11-11 09:02:22+01	1	2019-05-13 17:20:35+02	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	2	\N	\N	1	\N
45	Calthaleaf Phacelia	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.	5	1	2018-10-25 12:27:15+02	2	2019-01-03 19:32:31+01	Fusce consequat. Nulla nisl. Nunc nisl.	2	5	2018-10-17 12:17:43+02	0	https://goo.ne.jp/ut/ultrices.jsp
46	Florida Keys Indian Mallow	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	Aenean fermentum. Donec ut mauris eget massa tempor convallis. Nulla neque libero, convallis eget, eleifend luctus, ultricies eu, nibh.	1	1	2018-06-18 11:53:01+02	2	2018-07-08 20:19:39+02	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.	2	5	2018-05-17 04:40:33+02	0	https://google.ru/molestie/hendrerit/at/vulputate/vitae/nisl/aenean.jpg
47	Hairy Cupgrass	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	1	1	2019-03-25 20:21:59+01	1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
48	Dracontomelon	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	3	1	2019-02-01 11:56:28+01	1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
49	Marsh Mermaidweed	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	4	1	2018-05-22 21:26:38+02	0	\N	\N	\N	\N	\N	0	\N
50	Pergularia	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat.	2	1	2018-10-18 22:48:03+02	-1	2019-05-13 17:20:35+02	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.	2	\N	\N	1	\N
51	Schistophragma	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	3	2	2018-04-25 00:50:01+02	2	2018-08-18 04:32:15+02		2	5	2018-08-14 15:21:08+02	1	https://icq.com/vestibulum/sit/amet/cursus.png
52	Oldpasture Bluegrass	Pellentesque at nulla. Suspendisse potenti. Cras in purus eu magna vulputate luctus.	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	1	1	2018-07-21 20:42:13+02	1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
53	Colorado Xanthoparmelia Lichen	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	1	2	2019-02-15 07:35:07+01	-1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
54	Geyer's Oniongrass	Sed ante. Vivamus tortor. Duis mattis egestas metus.	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	1	1	2019-03-29 13:38:27+01	2	2019-02-28 15:48:29+01	Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis.	2	5	2018-07-06 06:10:48+02	0	http://globo.com/proin/eu/mi.html
55	Stebbins' Desertdandelion	Nullam sit amet turpis elementum ligula vehicula consequat. Morbi a ipsum. Integer a nibh.	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	5	1	2018-07-14 03:51:20+02	0	\N	\N	\N	\N	\N	0	\N
56	Pondweed	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.	2	1	2018-04-26 04:11:53+02	-1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
57	Rock Indian Breadroot	Nullam porttitor lacus at turpis. Donec posuere metus vitae ipsum. Aliquam non mauris.	Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.	2	2	2018-12-02 03:57:20+01	1	2019-05-13 17:20:35+02	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	2	\N	\N	0	\N
58	Yellow Loosestrife	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	2	1	2019-04-14 08:00:13+02	0	\N	\N	\N	\N	\N	0	\N
59	Red Baneberry	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.	1	1	2018-07-21 07:19:47+02	2	2018-05-02 14:44:59+02	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	2	5	2018-06-08 07:44:57+02	0	http://bing.com/fusce/lacus/purus/aliquet/at/feugiat/non.aspx
60	Pinewoods Drymary	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	Phasellus in felis. Donec semper sapien a libero. Nam dui.	5	1	2018-05-09 06:38:10+02	-1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
61	Hedge False Bindweed	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	5	1	2018-05-09 11:20:48+02	2	2018-08-16 03:10:08+02		2	5	2018-09-10 14:36:07+02	0	http://ocn.ne.jp/morbi/vel/lectus/in.html
62	Northwestern Twayblade	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	2	1	2019-01-05 04:39:07+01	-1	2019-05-13 17:20:35+02	Proin eu mi. Nulla ac enim. In tempor, turpis nec euismod scelerisque, quam turpis adipiscing lorem, vitae mattis nibh ligula nec sem.	2	\N	\N	1	\N
63	Paperflower	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	Cras non velit nec nisi vulputate nonummy. Maecenas tincidunt lacus at velit. Vivamus vel nulla eget eros elementum pellentesque.	5	1	2018-12-08 19:04:23+01	1	2019-05-13 17:20:35+02	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	2	\N	\N	0	\N
64	Sweetpotato	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem.	1	1	2018-10-12 11:20:36+02	-1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
65	Chiricahua Mountain Dock	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	2	2	2018-09-15 02:05:44+02	0	\N	\N	\N	\N	\N	0	\N
66	Chrysothemis	In quis justo. Maecenas rhoncus aliquam lacus. Morbi quis tortor id nulla ultrices aliquet.	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	2	1	2018-07-11 17:04:44+02	2	2018-06-11 02:05:20+02	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.	2	5	2018-09-13 19:36:12+02	1	https://prlog.org/tortor/id.jpg
67	Blair's Wirelettuce	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.	5	1	2018-07-27 13:42:31+02	2	2019-04-15 05:01:56+02		2	5	2018-07-12 12:02:09+02	1	http://mozilla.org/morbi/vel/lectus/in/quam/fringilla.json
68	Manchurian Honeysuckle	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	4	1	2018-10-21 21:51:35+02	-1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
69	Fierce Spaniard	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	5	1	2018-08-08 15:37:42+02	1	2019-05-13 17:20:35+02	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	2	\N	\N	1	\N
70	Britton's Shadow Witch	Duis bibendum, felis sed interdum venenatis, turpis enim blandit mi, in porttitor pede justo eu massa. Donec dapibus. Duis at velit eu est congue elementum.	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.	4	1	2019-03-07 14:14:16+01	-1	2019-05-13 17:20:35+02	Fusce consequat. Nulla nisl. Nunc nisl.	2	\N	\N	1	\N
71	Yellow Willowherb	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	Nam ultrices, libero non mattis pulvinar, nulla pede ullamcorper augue, a suscipit nulla elit ac nulla. Sed vel enim sit amet nunc viverra dapibus. Nulla suscipit ligula in lacus.	4	2	2019-04-06 12:16:24+02	-1	2019-05-13 17:20:35+02	Proin leo odio, porttitor id, consequat in, consequat ut, nulla. Sed accumsan felis. Ut at dolor quis odio consequat varius.	2	\N	\N	1	\N
72	Florida Star Orchid	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	1	2	2018-11-11 04:25:48+01	2	2018-07-02 13:15:10+02	Curabitur at ipsum ac tellus semper interdum. Mauris ullamcorper purus sit amet nulla. Quisque arcu libero, rutrum ac, lobortis vel, dapibus at, diam.	2	5	2019-02-23 14:11:15+01	0	https://diigo.com/in/tempus/sit.js
73	Graceful Fern	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	4	1	2019-01-19 01:47:06+01	1	2019-05-13 17:20:35+02	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	2	\N	\N	0	\N
74	California Polypody	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	Praesent id massa id nisl venenatis lacinia. Aenean sit amet justo. Morbi ut odio.	3	1	2018-04-29 22:27:28+02	1	2019-05-13 17:20:35+02	Phasellus in felis. Donec semper sapien a libero. Nam dui.	2	\N	\N	1	\N
75	Belembe Silvestre	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	4	1	2018-06-07 02:03:16+02	0	\N	\N	\N	\N	\N	0	\N
76	Tuberous Springbeauty	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	4	2	2019-02-12 14:39:46+01	-1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
77	California Eryngo	In hac habitasse platea dictumst. Morbi vestibulum, velit id pretium iaculis, diam erat fermentum justo, nec condimentum neque sapien placerat ante. Nulla justo.	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.	4	2	2019-01-28 14:51:17+01	0	\N	\N	\N	\N	\N	1	\N
78	Lophospermum	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	2	2	2019-02-11 08:54:15+01	-1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
79	Fivelobe St. Johnswort	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.	5	2	2018-12-25 07:46:37+01	1	2019-05-13 17:20:35+02	Fusce consequat. Nulla nisl. Nunc nisl.	2	\N	\N	1	\N
80	Tulare Cryptantha	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	1	1	2018-11-26 22:10:22+01	1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
81	Littleleaf Pixiemoss	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	1	2	2019-03-10 13:16:29+01	2	2019-03-19 11:06:35+01	Phasellus in felis. Donec semper sapien a libero. Nam dui.	2	5	2018-08-10 16:48:58+02	0	http://geocities.com/cubilia/curae/duis/faucibus/accumsan/odio/curabitur.png
82	Montagne's Cartilage Lichen	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	Phasellus in felis. Donec semper sapien a libero. Nam dui.	2	1	2018-05-24 20:15:58+02	1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
83	Pear-leaf Nightshade	Donec diam neque, vestibulum eget, vulputate ut, ultrices vel, augue. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Donec pharetra, magna vestibulum aliquet ultrices, erat tortor sollicitudin mi, sit amet lobortis sapien sapien non mi. Integer ac neque.	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	5	1	2018-05-08 23:37:21+02	1	2019-05-13 17:20:35+02	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	2	\N	\N	0	\N
84	Yellow And Purple Monkeyflower	Vestibulum ac est lacinia nisi venenatis tristique. Fusce congue, diam id ornare imperdiet, sapien urna pretium nisl, ut volutpat sapien arcu sed augue. Aliquam erat volutpat.	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	1	2	2018-11-02 12:22:31+01	0	\N	\N	\N	\N	\N	1	\N
85	Emory's Barrel Cactus	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	In hac habitasse platea dictumst. Etiam faucibus cursus urna. Ut tellus.	5	2	2019-03-02 23:18:38+01	1	2019-05-13 17:20:35+02	Maecenas leo odio, condimentum id, luctus nec, molestie sed, justo. Pellentesque viverra pede ac diam. Cras pellentesque volutpat dui.	2	\N	\N	0	\N
86	Wiegand's Wildrye	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	1	1	2018-10-29 11:38:12+01	0	\N	\N	\N	\N	\N	0	\N
87	Bailey's Sedge	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.	Suspendisse potenti. In eleifend quam a odio. In hac habitasse platea dictumst.	3	1	2018-06-06 15:21:55+02	1	2019-05-13 17:20:35+02	Quisque porta volutpat erat. Quisque erat eros, viverra eget, congue eget, semper rutrum, nulla. Nunc purus.	2	\N	\N	1	\N
88	Needle Lichen	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	5	1	2018-07-17 21:31:52+02	-1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
89	Juan Tomas	Etiam vel augue. Vestibulum rutrum rutrum neque. Aenean auctor gravida sem.	Morbi porttitor lorem id ligula. Suspendisse ornare consequat lectus. In est risus, auctor sed, tristique in, tempus sit amet, sem.	3	1	2019-02-23 00:30:08+01	-1	2019-05-13 17:20:35+02	Duis aliquam convallis nunc. Proin at turpis a pede posuere nonummy. Integer non velit.	2	\N	\N	0	\N
90	Redroot Amaranth	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	4	2	2018-08-06 21:05:15+02	-1	2019-05-13 17:20:35+02	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.	2	\N	\N	1	\N
91	Stahl's Valamuerto	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.	Fusce posuere felis sed lacus. Morbi sem mauris, laoreet ut, rhoncus aliquet, pulvinar sed, nisl. Nunc rhoncus dui vel sem.	3	2	2018-12-09 00:22:20+01	1	2019-05-13 17:20:35+02	Nulla ut erat id mauris vulputate elementum. Nullam varius. Nulla facilisi.	2	\N	\N	0	\N
92	Gaspè Peninsula Bluegrass	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	Morbi non lectus. Aliquam sit amet diam in magna bibendum imperdiet. Nullam orci pede, venenatis non, sodales sed, tincidunt eu, felis.	5	1	2018-06-24 17:14:55+02	-1	2019-05-13 20:41:10+02		2	\N	\N	0	\N
93	California Jointfir	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	Curabitur in libero ut massa volutpat convallis. Morbi odio odio, elementum eu, interdum eu, tincidunt in, leo. Maecenas pulvinar lobortis est.	1	1	2018-11-15 02:38:04+01	1	2019-05-13 17:20:35+02	Cras mi pede, malesuada in, imperdiet et, commodo vulputate, justo. In blandit ultrices enim. Lorem ipsum dolor sit amet, consectetuer adipiscing elit.	2	\N	\N	0	\N
94	Elmer's Erigeron	Mauris enim leo, rhoncus sed, vestibulum sit amet, cursus id, turpis. Integer aliquet, massa id lobortis convallis, tortor risus dapibus augue, vel accumsan tellus nisi eu orci. Mauris lacinia sapien quis libero.	Phasellus sit amet erat. Nulla tempus. Vivamus in felis eu sapien cursus vestibulum.	3	2	2018-05-06 22:51:32+02	2	2018-11-16 07:07:42+01		2	5	2019-01-10 13:16:29+01	0	https://answers.com/at/ipsum/ac/tellus/semper/interdum.aspx
95	Poeltinula Lichen	Vestibulum quam sapien, varius ut, blandit non, interdum in, ante. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Duis faucibus accumsan odio. Curabitur convallis.	Praesent blandit. Nam nulla. Integer pede justo, lacinia eget, tincidunt eget, tempus vel, pede.	1	1	2018-10-13 07:38:41+02	0	\N	\N	\N	\N	\N	1	\N
96	Northpark Phacelia	Integer ac leo. Pellentesque ultrices mattis odio. Donec vitae nisi.	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	3	1	2018-07-12 05:59:31+02	1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
97	Feltleaf Willow	Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Vivamus vestibulum sagittis sapien. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.	Maecenas tristique, est et tempus semper, est quam pharetra magna, ac consequat metus sapien ut nunc. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Mauris viverra diam vitae quam. Suspendisse potenti.	3	1	2018-05-24 16:32:12+02	0	\N	\N	\N	\N	\N	0	\N
98	Hairy Gumweed	Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Proin risus. Praesent lectus.	Integer tincidunt ante vel ipsum. Praesent blandit lacinia erat. Vestibulum sed magna at nunc commodo placerat.	4	1	2018-06-16 16:35:34+02	0	\N	\N	\N	\N	\N	1	\N
99	Rim Lichen	Quisque id justo sit amet sapien dignissim vestibulum. Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nulla dapibus dolor vel est. Donec odio justo, sollicitudin ut, suscipit a, feugiat et, eros.	Sed sagittis. Nam congue, risus semper porta volutpat, quam pede lobortis ligula, sit amet eleifend pede libero quis orci. Nullam molestie nibh in lectus.	4	2	2019-01-16 21:01:27+01	-1	2019-05-13 17:20:35+02		2	\N	\N	0	\N
100	Oahu Stenogyne	Fusce consequat. Nulla nisl. Nunc nisl.	Proin interdum mauris non ligula pellentesque ultrices. Phasellus id sapien in sapien iaculis congue. Vivamus metus arcu, adipiscing molestie, hendrerit at, vulputate vitae, nisl.	4	1	2018-11-28 03:47:22+01	-1	2019-05-13 17:20:35+02		2	\N	\N	1	\N
\.


--
-- Data for Name: requests_clients; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.requests_clients (request_id, client_user_id, install_timestamp, install_status, comment) FROM stdin;
2	3	2019-05-08 16:11:04+02	1	Test Feedback
36	3	2019-05-13 06:18:20+02	-1	\N
43	3	2018-07-02 11:51:06+02	1	Duis consequat dui nec nisi volutpat eleifend. Donec ut dolor. Morbi vel lectus in quam fringilla rhoncus.
45	3	\N	0	\N
59	3	2018-12-18 07:44:00+01	1	Aenean lectus. Pellentesque eget nunc. Donec quis orci eget orci vehicula condimentum.
72	3	\N	0	\N
\.


--
-- Data for Name: requests_commits; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.requests_commits (request_id, commit_id) FROM stdin;
1	41
1	68
1	69
1	71
3	30
3	93
4	34
5	3
5	4
5	34
5	47
6	14
6	46
6	96
7	45
7	67
7	84
8	36
8	48
8	67
8	100
9	14
9	33
9	71
10	10
11	18
11	90
11	92
12	40
12	100
13	33
13	80
13	87
14	50
15	62
16	21
16	68
16	100
17	69
17	87
18	32
18	48
19	29
19	96
20	50
21	53
21	87
22	65
23	28
23	34
23	65
24	52
25	41
25	51
25	53
25	57
25	65
26	76
27	19
27	52
28	3
28	96
29	9
29	37
29	90
29	97
31	43
32	14
33	13
33	69
34	37
35	88
35	90
37	79
38	88
38	93
39	32
40	49
40	50
41	4
41	14
42	11
42	69
43	66
44	21
44	73
44	97
46	31
47	39
47	78
48	25
48	60
49	39
49	63
50	23
50	75
51	24
52	51
52	60
53	30
54	74
54	86
54	91
55	36
55	94
55	98
57	14
57	62
57	64
58	6
58	11
58	99
59	52
60	8
62	94
63	65
64	9
64	95
65	22
66	41
66	56
69	28
69	30
70	2
70	3
70	4
70	17
70	74
71	61
71	76
72	11
72	52
72	79
72	98
73	19
73	23
73	49
73	61
73	62
73	63
73	82
75	9
76	17
76	34
76	89
77	92
78	20
78	89
79	9
79	96
80	63
81	11
81	25
81	27
81	45
81	55
82	46
82	72
82	77
82	80
83	19
83	46
83	81
83	99
84	4
84	71
85	18
85	74
85	75
87	45
87	53
87	58
87	77
88	39
88	47
88	91
89	24
91	81
92	19
92	82
92	83
93	45
94	57
95	23
96	2
96	60
97	7
98	23
99	14
99	64
100	20
100	26
100	76
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.roles (role_id, role_name, role_string) FROM stdin;
1	programmer	Programmer
2	technicalAreaManager	Technical Area Manager
3	revisionOfficeManager	Revision Office Manager
4	client	Client
5	powerUser	Power User
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.users (user_id, username, hash_pass, email, name, area_id) FROM stdin;
1	admin	$2y$10$autYx1CjNHiMTaMst4d/3u801S17cocdlVRle217eNjJh2b7Mff.K	admin@aum.com	Test Admin	1
2	dev.test	$2y$10$Gg0OqF4eAldpoVWXXUmYhOIKLrTPb16Fi6ep/abA1WRDyTFIG5XO6	dev@aum.com	Test Developer	1
3	client.test	$2y$10$dsomsW5qwK/zouHftaRCw.JsdQZbPDhikljNc/TYPjF7TXjXY2BP2	client@aum.com	Test Client User	\N
4	repTech.test	$2y$10$RjgQcskq7ud8/VRQCb5Ecu7Wc.gBIBYqPNaXpKFWDTep72R8wVJdy	repTech@aum.com	Test Tech Area User	1
5	rev.test	$2y$10$OUHuTMosbb0ICAPoy9xcfeznZ2Wdnt7cPg53Z6kDvxtuec.t8WVrG	revOffice@aum.com	Revision Office Test	1
\.


--
-- Data for Name: users_roles; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.users_roles (user_id, role_id) FROM stdin;
1	1
1	2
1	3
1	4
1	5
2	1
3	4
4	2
5	3
\.


--
-- Data for Name: users_tokens; Type: TABLE DATA; Schema: my_aum; Owner: postgres
--

COPY my_aum.users_tokens (token, user_id, token_expire) FROM stdin;
\.


--
-- Name: areas_area_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.areas_area_id_seq', 1, true);


--
-- Name: branches_branch_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.branches_branch_id_seq', 5, true);


--
-- Name: commits_commit_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.commits_commit_id_seq', 100, true);


--
-- Name: requests_request_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.requests_request_id_seq', 100, true);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.roles_role_id_seq', 5, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.users_user_id_seq', 5, true);


--
-- Name: areas idx_18055_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.areas
    ADD CONSTRAINT idx_18055_primary PRIMARY KEY (area_id);


--
-- Name: branches idx_18061_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.branches
    ADD CONSTRAINT idx_18061_primary PRIMARY KEY (branch_id);


--
-- Name: commits idx_18067_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.commits
    ADD CONSTRAINT idx_18067_primary PRIMARY KEY (commit_id);


--
-- Name: requests idx_18078_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests
    ADD CONSTRAINT idx_18078_primary PRIMARY KEY (request_id);


--
-- Name: requests_clients idx_18088_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_clients
    ADD CONSTRAINT idx_18088_primary PRIMARY KEY (request_id, client_user_id);


--
-- Name: requests_commits idx_18095_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_commits
    ADD CONSTRAINT idx_18095_primary PRIMARY KEY (request_id, commit_id);


--
-- Name: roles idx_18100_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.roles
    ADD CONSTRAINT idx_18100_primary PRIMARY KEY (role_id);


--
-- Name: users idx_18106_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users
    ADD CONSTRAINT idx_18106_primary PRIMARY KEY (user_id);


--
-- Name: users_roles idx_18110_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users_roles
    ADD CONSTRAINT idx_18110_primary PRIMARY KEY (user_id, role_id);


--
-- Name: users_tokens idx_18113_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users_tokens
    ADD CONSTRAINT idx_18113_primary PRIMARY KEY (user_id, token);


--
-- Name: idx_18067_approver_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18067_approver_user_id ON my_aum.commits USING btree (approver_user_id);


--
-- Name: idx_18067_author_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18067_author_user_id ON my_aum.commits USING btree (author_user_id);


--
-- Name: idx_18067_branch_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18067_branch_id ON my_aum.commits USING btree (branch_id);


--
-- Name: idx_18078_approver_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18078_approver_user_id ON my_aum.requests USING btree (approver_user_id);


--
-- Name: idx_18078_author_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18078_author_user_id ON my_aum.requests USING btree (author_user_id);


--
-- Name: idx_18078_branch_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18078_branch_id ON my_aum.requests USING btree (branch_id);


--
-- Name: idx_18078_sender_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18078_sender_user_id ON my_aum.requests USING btree (sender_user_id);


--
-- Name: idx_18088_client_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18088_client_user_id ON my_aum.requests_clients USING btree (client_user_id);


--
-- Name: idx_18088_request_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18088_request_id ON my_aum.requests_clients USING btree (request_id);


--
-- Name: idx_18095_commit_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18095_commit_id ON my_aum.requests_commits USING btree (commit_id);


--
-- Name: idx_18095_request_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18095_request_id ON my_aum.requests_commits USING btree (request_id);


--
-- Name: idx_18106_area_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18106_area_id ON my_aum.users USING btree (area_id);


--
-- Name: idx_18110_role_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_18110_role_id ON my_aum.users_roles USING btree (role_id);


--
-- Name: commits commits_ibfk_1; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.commits
    ADD CONSTRAINT commits_ibfk_1 FOREIGN KEY (author_user_id) REFERENCES my_aum.users(user_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commits commits_ibfk_3; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.commits
    ADD CONSTRAINT commits_ibfk_3 FOREIGN KEY (branch_id) REFERENCES my_aum.branches(branch_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: commits commits_ibfk_4; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.commits
    ADD CONSTRAINT commits_ibfk_4 FOREIGN KEY (approver_user_id) REFERENCES my_aum.users(user_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: requests_clients requests_clients_ibfk_1; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_clients
    ADD CONSTRAINT requests_clients_ibfk_1 FOREIGN KEY (client_user_id) REFERENCES my_aum.users(user_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: requests_clients requests_clients_ibfk_2; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_clients
    ADD CONSTRAINT requests_clients_ibfk_2 FOREIGN KEY (request_id) REFERENCES my_aum.requests(request_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: requests_commits requests_commits_ibfk_1; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_commits
    ADD CONSTRAINT requests_commits_ibfk_1 FOREIGN KEY (commit_id) REFERENCES my_aum.commits(commit_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: requests_commits requests_commits_ibfk_2; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_commits
    ADD CONSTRAINT requests_commits_ibfk_2 FOREIGN KEY (request_id) REFERENCES my_aum.requests(request_id) ON UPDATE RESTRICT ON DELETE CASCADE;


--
-- Name: requests requests_ibfk_1; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests
    ADD CONSTRAINT requests_ibfk_1 FOREIGN KEY (author_user_id) REFERENCES my_aum.users(user_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: requests requests_ibfk_2; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests
    ADD CONSTRAINT requests_ibfk_2 FOREIGN KEY (approver_user_id) REFERENCES my_aum.users(user_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: requests requests_ibfk_4; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests
    ADD CONSTRAINT requests_ibfk_4 FOREIGN KEY (branch_id) REFERENCES my_aum.branches(branch_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: requests requests_ibfk_5; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests
    ADD CONSTRAINT requests_ibfk_5 FOREIGN KEY (sender_user_id) REFERENCES my_aum.users(user_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: users users_ibfk_1; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users
    ADD CONSTRAINT users_ibfk_1 FOREIGN KEY (area_id) REFERENCES my_aum.areas(area_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: users_roles users_roles_ibfk_1; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users_roles
    ADD CONSTRAINT users_roles_ibfk_1 FOREIGN KEY (user_id) REFERENCES my_aum.users(user_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: users_roles users_roles_ibfk_2; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users_roles
    ADD CONSTRAINT users_roles_ibfk_2 FOREIGN KEY (role_id) REFERENCES my_aum.roles(role_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: users_tokens users_tokens_ibfk_1; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users_tokens
    ADD CONSTRAINT users_tokens_ibfk_1 FOREIGN KEY (user_id) REFERENCES my_aum.users(user_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- PostgreSQL database dump complete
--

