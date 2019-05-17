--
-- PostgreSQL database dump
--

-- Dumped from database version 11.2
-- Dumped by pg_dump version 11.2

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
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
    token character varying(255) NOT NULL,
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
\.

--
-- Name: areas_area_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.areas_area_id_seq', 0, false);


--
-- Name: branches_branch_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.branches_branch_id_seq', 0, false);


--
-- Name: commits_commit_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.commits_commit_id_seq', 0, false);


--
-- Name: requests_request_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.requests_request_id_seq', 0, false);


--
-- Name: roles_role_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.roles_role_id_seq', 5, true);


--
-- Name: users_user_id_seq; Type: SEQUENCE SET; Schema: my_aum; Owner: postgres
--

SELECT pg_catalog.setval('my_aum.users_user_id_seq', 1, true);


--
-- Name: areas idx_17839_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.areas
    ADD CONSTRAINT idx_17839_primary PRIMARY KEY (area_id);


--
-- Name: branches idx_17845_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.branches
    ADD CONSTRAINT idx_17845_primary PRIMARY KEY (branch_id);


--
-- Name: commits idx_17851_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.commits
    ADD CONSTRAINT idx_17851_primary PRIMARY KEY (commit_id);


--
-- Name: requests idx_17862_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests
    ADD CONSTRAINT idx_17862_primary PRIMARY KEY (request_id);


--
-- Name: requests_clients idx_17872_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_clients
    ADD CONSTRAINT idx_17872_primary PRIMARY KEY (request_id, client_user_id);


--
-- Name: requests_commits idx_17879_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_commits
    ADD CONSTRAINT idx_17879_primary PRIMARY KEY (request_id, commit_id);


--
-- Name: roles idx_17884_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.roles
    ADD CONSTRAINT idx_17884_primary PRIMARY KEY (role_id);


--
-- Name: users idx_17890_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users
    ADD CONSTRAINT idx_17890_primary PRIMARY KEY (user_id);


--
-- Name: users_roles idx_17894_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users_roles
    ADD CONSTRAINT idx_17894_primary PRIMARY KEY (user_id, role_id);


--
-- Name: users_tokens idx_17897_primary; Type: CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.users_tokens
    ADD CONSTRAINT idx_17897_primary PRIMARY KEY (user_id, token);


--
-- Name: idx_17851_approver_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17851_approver_user_id ON my_aum.commits USING btree (approver_user_id);


--
-- Name: idx_17851_author_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17851_author_user_id ON my_aum.commits USING btree (author_user_id);


--
-- Name: idx_17851_branch_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17851_branch_id ON my_aum.commits USING btree (branch_id);


--
-- Name: idx_17862_approver_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17862_approver_user_id ON my_aum.requests USING btree (approver_user_id);


--
-- Name: idx_17862_author_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17862_author_user_id ON my_aum.requests USING btree (author_user_id);


--
-- Name: idx_17862_branch_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17862_branch_id ON my_aum.requests USING btree (branch_id);


--
-- Name: idx_17862_sender_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17862_sender_user_id ON my_aum.requests USING btree (sender_user_id);


--
-- Name: idx_17872_client_user_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17872_client_user_id ON my_aum.requests_clients USING btree (client_user_id);


--
-- Name: idx_17872_request_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17872_request_id ON my_aum.requests_clients USING btree (request_id);


--
-- Name: idx_17879_commit_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17879_commit_id ON my_aum.requests_commits USING btree (commit_id);


--
-- Name: idx_17890_area_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17890_area_id ON my_aum.users USING btree (area_id);


--
-- Name: idx_17894_role_id; Type: INDEX; Schema: my_aum; Owner: postgres
--

CREATE INDEX idx_17894_role_id ON my_aum.users_roles USING btree (role_id);


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
    ADD CONSTRAINT requests_clients_ibfk_2 FOREIGN KEY (request_id) REFERENCES my_aum.requests(request_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: requests_commits requests_commits_ibfk_1; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_commits
    ADD CONSTRAINT requests_commits_ibfk_1 FOREIGN KEY (commit_id) REFERENCES my_aum.commits(commit_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


--
-- Name: requests_commits requests_commits_ibfk_2; Type: FK CONSTRAINT; Schema: my_aum; Owner: postgres
--

ALTER TABLE ONLY my_aum.requests_commits
    ADD CONSTRAINT requests_commits_ibfk_2 FOREIGN KEY (request_id) REFERENCES my_aum.requests(request_id) ON UPDATE RESTRICT ON DELETE RESTRICT;


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

