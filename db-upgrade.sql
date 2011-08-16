CREATE TABLE databasechangelog (
    id character varying(63) NOT NULL,
    author character varying(63) NOT NULL,
    filename character varying(200) NOT NULL,
    dateexecuted timestamp with time zone NOT NULL,
    md5sum character varying(32),
    description character varying(255),
    comments character varying(255),
    tag character varying(255),
    liquibase character varying(10)
);


ALTER TABLE public.databasechangelog OWNER TO postgres;

--
-- TOC entry 1326 (class 1259 OID 197545)
-- Dependencies: 3
-- Name: databasechangeloglock; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE databasechangeloglock (
    id integer NOT NULL,
    locked boolean NOT NULL,
    lockgranted timestamp with time zone,
    lockedby character varying(255)
);


ALTER TABLE public.databasechangeloglock OWNER TO postgres;

insert into databasechangelog values ('1','adam (generated)','classpath:db-changelog.xml','2009-06-14 13:47:38.197665+07','2df5f9f5203c21333a3134aec78acf2','Create Table (x9), Create Index, Add Foreign Key Constraint (x11)','','','1.9.1');