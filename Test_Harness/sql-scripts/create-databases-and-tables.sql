--CREATE DATABASE mosip_esignet;

CREATE DATABASE mosip_esignet
	ENCODING = 'UTF8' 
	LC_COLLATE = 'en_US.UTF-8' 
	LC_CTYPE = 'en_US.UTF-8' 
	TABLESPACE = pg_default 
	OWNER = postgres
	TEMPLATE  = template0;

--COMMENT ON DATABASE mosip_idp IS 'e-Signet related data is stored in this database';

\c mosip_esignet postgres

DROP SCHEMA IF EXISTS esignet CASCADE;
CREATE SCHEMA esignet;
ALTER SCHEMA esignet OWNER TO postgres;
ALTER DATABASE mosip_esignet SET search_path TO esignet,pg_catalog,public;
-- create user
CREATE ROLE esignetuser WITH
	PASSWORD :Mosip@123;

-- Create tables for mosip_esignet

-- Creating table with name = client_details
CREATE TABLE IF NOT EXISTS esignet.client_detail
(
    id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    name character varying(256) COLLATE pg_catalog."default" NOT NULL,
    rp_id character varying(100) COLLATE pg_catalog."default" NOT NULL,
    logo_uri character varying(2048) COLLATE pg_catalog."default" NOT NULL,
    redirect_uris character varying COLLATE pg_catalog."default" NOT NULL,
    claims character varying COLLATE pg_catalog."default" NOT NULL,
    acr_values character varying COLLATE pg_catalog."default" NOT NULL,
    public_key character varying COLLATE pg_catalog."default" NOT NULL,
    grant_types character varying COLLATE pg_catalog."default" NOT NULL,
    auth_methods character varying COLLATE pg_catalog."default" NOT NULL,
    status character varying(20) COLLATE pg_catalog."default" NOT NULL,
    cr_dtimes timestamp without time zone NOT NULL,
    upd_dtimes timestamp without time zone,
    CONSTRAINT pk_clntdtl_id PRIMARY KEY (id),
    CONSTRAINT uk_clntdtl_key UNIQUE (public_key)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS esignet.client_detail
    OWNER to postgres;

REVOKE ALL ON TABLE esignet.client_detail FROM esignetuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE esignet.client_detail TO esignetuser;

GRANT ALL ON TABLE esignet.client_detail TO postgres;

COMMENT ON TABLE esignet.client_detail
    IS 'Contains key alias and  metadata of all the keys used in MOSIP system.';

COMMENT ON COLUMN esignet.client_detail.id
    IS 'Client ID: Unique id assigned to registered OIDC client.';

COMMENT ON COLUMN esignet.client_detail.name
    IS 'Client Name: Registered name of OIDC client.';

COMMENT ON COLUMN esignet.client_detail.rp_id
    IS 'relying Party Id: Id of the relying Party who has created this OIDC client.';

COMMENT ON COLUMN esignet.client_detail.logo_uri
    IS 'Client Logo URL: Client logo to be displayed on IDP UI.';

COMMENT ON COLUMN esignet.client_detail.redirect_uris
    IS 'Recirect URLS: Comma separated client redirect URLs.';

COMMENT ON COLUMN esignet.client_detail.claims
    IS 'Requested Claims: claims json as per policy defined for relying party, comma separated string.';

COMMENT ON COLUMN esignet.client_detail.acr_values
    IS 'Allowed Authentication context References(acr), comma separated string.';

COMMENT ON COLUMN esignet.client_detail.public_key
    IS 'Public key: JWK format.';

COMMENT ON COLUMN esignet.client_detail.grant_types
    IS 'Grant Types: Allowed grant types for the client, comma separated string.';

COMMENT ON COLUMN esignet.client_detail.auth_methods
    IS 'Client Auth methods: Allowed token endpoint authentication methods, comma separated string.';

COMMENT ON COLUMN esignet.client_detail.status
    IS 'Client status: Allowed values - ACTIVE / INACTIVE.';

COMMENT ON COLUMN esignet.client_detail.cr_dtimes
    IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';

COMMENT ON COLUMN esignet.client_detail.upd_dtimes
    IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';

-- Creating table with name = key_alias
CREATE TABLE IF NOT EXISTS esignet.key_alias
(
    id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    app_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    ref_id character varying(128) COLLATE pg_catalog."default",
    key_gen_dtimes timestamp without time zone,
    key_expire_dtimes timestamp without time zone,
    status_code character varying(36) COLLATE pg_catalog."default",
    lang_code character varying(3) COLLATE pg_catalog."default",
    cr_by character varying(256) COLLATE pg_catalog."default" NOT NULL,
    cr_dtimes timestamp without time zone NOT NULL,
    upd_by character varying(256) COLLATE pg_catalog."default",
    upd_dtimes timestamp without time zone,
    is_deleted boolean DEFAULT false,
    del_dtimes timestamp without time zone,
    cert_thumbprint character varying(100) COLLATE pg_catalog."default",
    uni_ident character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT pk_keymals_id PRIMARY KEY (id),
    CONSTRAINT uni_ident_const UNIQUE (uni_ident)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS esignet.key_alias
    OWNER to postgres;

REVOKE ALL ON TABLE esignet.key_alias FROM esignetuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE esignet.key_alias TO esignetuser;

GRANT ALL ON TABLE esignet.key_alias TO postgres;

COMMENT ON TABLE esignet.key_alias
    IS 'Contains key alias and  metadata of all the keys used in MOSIP system.';

COMMENT ON COLUMN esignet.key_alias.id
    IS 'Unique identifier (UUID) used for referencing keys in key_store table and HSM';

COMMENT ON COLUMN esignet.key_alias.app_id
    IS 'To reference a Module key';

COMMENT ON COLUMN esignet.key_alias.ref_id
    IS 'To reference a Encryption key ';

COMMENT ON COLUMN esignet.key_alias.key_gen_dtimes
    IS 'Date and time when the key was generated.';

COMMENT ON COLUMN esignet.key_alias.key_expire_dtimes
    IS 'Date and time when the key will be expired. This will be derived based on the configuration / policy defined in Key policy definition.';

COMMENT ON COLUMN esignet.key_alias.status_code
    IS 'Status of the key, whether it is active or expired.';

COMMENT ON COLUMN esignet.key_alias.lang_code
    IS 'For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';

COMMENT ON COLUMN esignet.key_alias.cr_by
    IS 'ID or name of the user who create / insert record';

COMMENT ON COLUMN esignet.key_alias.cr_dtimes
    IS 'Date and Timestamp when the record is created/inserted';

COMMENT ON COLUMN esignet.key_alias.upd_by
    IS 'ID or name of the user who update the record with new values';

COMMENT ON COLUMN esignet.key_alias.upd_dtimes
    IS 'Date and Timestamp when any of the fields in the record is updated with new values.';

COMMENT ON COLUMN esignet.key_alias.is_deleted
    IS 'Flag to mark whether the record is Soft deleted.';

COMMENT ON COLUMN esignet.key_alias.del_dtimes
    IS 'Date and Timestamp when the record is soft deleted with is_deleted=TRUE';


-- Creating table with name = key_policy_def
CREATE TABLE IF NOT EXISTS esignet.key_policy_def
(
    app_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    key_validity_duration smallint,
    is_active boolean NOT NULL,
    pre_expire_days smallint,
    access_allowed character varying(1024) COLLATE pg_catalog."default",
    cr_by character varying(256) COLLATE pg_catalog."default" NOT NULL,
    cr_dtimes timestamp without time zone NOT NULL,
    upd_by character varying(256) COLLATE pg_catalog."default",
    upd_dtimes timestamp without time zone,
    is_deleted boolean DEFAULT false,
    del_dtimes timestamp without time zone,
    CONSTRAINT pk_keypdef_id PRIMARY KEY (app_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS esignet.key_policy_def
    OWNER to postgres;

REVOKE ALL ON TABLE esignet.key_policy_def FROM esignetuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE esignet.key_policy_def TO esignetuser;

GRANT ALL ON TABLE esignet.key_policy_def TO postgres;

COMMENT ON TABLE esignet.key_policy_def
    IS 'Key Policy Defination: Policy related to encryption key management is defined here. For eg. Expiry duration of a key generated.';

COMMENT ON COLUMN esignet.key_policy_def.app_id
    IS 'Application ID: Application id for which the key policy is defined';

COMMENT ON COLUMN esignet.key_policy_def.key_validity_duration
    IS 'Key Validity Duration: Duration for which key is valid';

COMMENT ON COLUMN esignet.key_policy_def.is_active
    IS 'IS_Active : Flag to mark whether the record is Active or In-active';

COMMENT ON COLUMN esignet.key_policy_def.cr_by
    IS 'Created By : ID or name of the user who create / insert record';

COMMENT ON COLUMN esignet.key_policy_def.cr_dtimes
    IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';

COMMENT ON COLUMN esignet.key_policy_def.upd_by
    IS 'Updated By : ID or name of the user who update the record with new values';

COMMENT ON COLUMN esignet.key_policy_def.upd_dtimes
    IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';

COMMENT ON COLUMN esignet.key_policy_def.is_deleted
    IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';

COMMENT ON COLUMN esignet.key_policy_def.del_dtimes
    IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';

-- Creating table with name = key_store
CREATE TABLE IF NOT EXISTS esignet.key_store
(
    id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    master_key character varying(36) COLLATE pg_catalog."default" NOT NULL,
    private_key character varying(2500) COLLATE pg_catalog."default" NOT NULL,
    certificate_data character varying COLLATE pg_catalog."default" NOT NULL,
    cr_by character varying(256) COLLATE pg_catalog."default" NOT NULL,
    cr_dtimes timestamp without time zone NOT NULL,
    upd_by character varying(256) COLLATE pg_catalog."default",
    upd_dtimes timestamp without time zone,
    is_deleted boolean DEFAULT false,
    del_dtimes timestamp without time zone,
    CONSTRAINT pk_keystr_id PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS esignet.key_store
    OWNER to postgres;

REVOKE ALL ON TABLE esignet.key_store FROM esignetuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE esignet.key_store TO esignetuser;

GRANT ALL ON TABLE esignet.key_store TO postgres;

COMMENT ON TABLE esignet.key_store
    IS 'Stores Encryption (Base) private keys along with certificates';

COMMENT ON COLUMN esignet.key_store.id
    IS 'Unique identifier (UUID) for referencing keys';

COMMENT ON COLUMN esignet.key_store.master_key
    IS 'UUID of the master key used to encrypt this key';

COMMENT ON COLUMN esignet.key_store.private_key
    IS 'Encrypted private key';

COMMENT ON COLUMN esignet.key_store.certificate_data
    IS 'X.509 encoded certificate data';

COMMENT ON COLUMN esignet.key_store.cr_by
    IS 'ID or name of the user who create / insert record';

COMMENT ON COLUMN esignet.key_store.cr_dtimes
    IS 'Date and Timestamp when the record is created/inserted';

COMMENT ON COLUMN esignet.key_store.upd_by
    IS 'ID or name of the user who update the record with new values';

COMMENT ON COLUMN esignet.key_store.upd_dtimes
    IS 'Date and Timestamp when any of the fields in the record is updated with new values.';

COMMENT ON COLUMN esignet.key_store.is_deleted
    IS 'Flag to mark whether the record is Soft deleted.';

COMMENT ON COLUMN esignet.key_store.del_dtimes
    IS 'Date and Timestamp when the record is soft deleted with is_deleted=TRUE';

-- Creating table with name = public_key_registry
CREATE TABLE IF NOT EXISTS esignet.public_key_registry
(
    id_hash character varying(100) COLLATE pg_catalog."default" NOT NULL,
    auth_factor character varying(25) COLLATE pg_catalog."default" NOT NULL,
    psu_token character varying(256) COLLATE pg_catalog."default" NOT NULL,
    public_key character varying COLLATE pg_catalog."default" NOT NULL,
    expire_dtimes timestamp without time zone NOT NULL,
    wallet_binding_id character varying(256) COLLATE pg_catalog."default" NOT NULL,
    public_key_hash character varying(100) COLLATE pg_catalog."default" NOT NULL,
    certificate character varying COLLATE pg_catalog."default" NOT NULL,
    cr_dtimes timestamp without time zone NOT NULL,
    CONSTRAINT pk_public_key_registry PRIMARY KEY (id_hash, auth_factor)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS esignet.public_key_registry
    OWNER to postgres;

REVOKE ALL ON TABLE esignet.public_key_registry FROM esignetuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE esignet.public_key_registry TO esignetuser;

GRANT ALL ON TABLE esignet.public_key_registry TO postgres;

COMMENT ON TABLE esignet.public_key_registry
    IS 'Contains id_hash and their respective PSU Tokens,public keys and wallet binding ids.';

COMMENT ON COLUMN esignet.public_key_registry.id_hash
    IS 'Contains Id hash.';

COMMENT ON COLUMN esignet.public_key_registry.auth_factor
    IS 'Supported auth factor type.';

COMMENT ON COLUMN esignet.public_key_registry.psu_token
    IS 'PSU Token: Partner Specific User Token.';

COMMENT ON COLUMN esignet.public_key_registry.public_key
    IS 'Public Key: Used to validate JWT signature and encrypt Wallet Binding Id.';

COMMENT ON COLUMN esignet.public_key_registry.expire_dtimes
    IS 'Expiry DateTimestamp : Date and Timestamp of the expiry of the binding entry.';

COMMENT ON COLUMN esignet.public_key_registry.wallet_binding_id
    IS 'Wallet Binding Id: hash of PSU  Token and salt.';

COMMENT ON COLUMN esignet.public_key_registry.public_key_hash
    IS 'Public Key Hash: Hash of  Public Key.';

COMMENT ON COLUMN esignet.public_key_registry.certificate
    IS 'Signed certificate';

COMMENT ON COLUMN esignet.public_key_registry.cr_dtimes
    IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted.';

-- INSERT DATA IN ESIGNET DATABASE
INSERT INTO esignet.KEY_POLICY_DEF(APP_ID,KEY_VALIDITY_DURATION,PRE_EXPIRE_DAYS,ACCESS_ALLOWED,IS_ACTIVE,CR_BY,CR_DTIMES) VALUES ('ROOT', 1095, 50, 'NA', true, 'mosipadmin', now());
INSERT INTO esignet.KEY_POLICY_DEF(APP_ID,KEY_VALIDITY_DURATION,PRE_EXPIRE_DAYS,ACCESS_ALLOWED,IS_ACTIVE,CR_BY,CR_DTIMES) VALUES ('OIDC_SERVICE', 1095, 50, 'NA', true, 'mosipadmin', now());
INSERT INTO esignet.KEY_POLICY_DEF(APP_ID,KEY_VALIDITY_DURATION,PRE_EXPIRE_DAYS,ACCESS_ALLOWED,IS_ACTIVE,CR_BY,CR_DTIMES) VALUES ('OIDC_PARTNER', 1095, 50, 'NA', true, 'mosipadmin', now());
INSERT INTO esignet.KEY_POLICY_DEF(APP_ID,KEY_VALIDITY_DURATION,PRE_EXPIRE_DAYS,ACCESS_ALLOWED,IS_ACTIVE,CR_BY,CR_DTIMES) VALUES ('BINDING_SERVICE', 1095, 50, 'NA', true, 'mosipadmin', now());
INSERT INTO esignet.KEY_POLICY_DEF(APP_ID,KEY_VALIDITY_DURATION,PRE_EXPIRE_DAYS,ACCESS_ALLOWED,IS_ACTIVE,CR_BY,CR_DTIMES) VALUES ('MOCK_BINDING_SERVICE', 1095, 50, 'NA', true, 'mosipadmin', now());

-- Create mosip_mockidentitysystem
CREATE DATABASE mosip_mockidentitysystem
	ENCODING = 'UTF8' 
	LC_COLLATE = 'en_US.UTF-8' 
	LC_CTYPE = 'en_US.UTF-8' 
	TABLESPACE = pg_default 
	OWNER = postgres
	TEMPLATE  = template0;

COMMENT ON DATABASE mosip_mockidentitysystem IS 'Mock identity related data is stored in this database';

\c mosip_mockidentitysystem postgres

DROP SCHEMA IF EXISTS mockidentitysystem CASCADE;
CREATE SCHEMA mockidentitysystem;
ALTER SCHEMA mockidentitysystem OWNER TO postgres;
ALTER DATABASE mosip_mockidentitysystem SET search_path TO mockidentitysystem,pg_catalog,public;

-- create user
CREATE ROLE mockidsystemuser WITH
        PASSWORD :Mosip@123;


-- Creating table with name = key_alias
CREATE TABLE IF NOT EXISTS mockidentitysystem.key_alias
(
    id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    app_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    ref_id character varying(128) COLLATE pg_catalog."default",
    key_gen_dtimes timestamp without time zone,
    key_expire_dtimes timestamp without time zone,
    status_code character varying(36) COLLATE pg_catalog."default",
    lang_code character varying(3) COLLATE pg_catalog."default",
    cr_by character varying(256) COLLATE pg_catalog."default" NOT NULL,
    cr_dtimes timestamp without time zone NOT NULL,
    upd_by character varying(256) COLLATE pg_catalog."default",
    upd_dtimes timestamp without time zone,
    is_deleted boolean DEFAULT false,
    del_dtimes timestamp without time zone,
    cert_thumbprint character varying(100) COLLATE pg_catalog."default",
    uni_ident character varying(50) COLLATE pg_catalog."default",
    CONSTRAINT pk_keymals_id PRIMARY KEY (id),
    CONSTRAINT uni_ident_const UNIQUE (uni_ident)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS mockidentitysystem.key_alias
    OWNER to postgres;

REVOKE ALL ON TABLE mockidentitysystem.key_alias FROM mockidsystemuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE mockidentitysystem.key_alias TO mockidsystemuser;

GRANT ALL ON TABLE mockidentitysystem.key_alias TO postgres;

COMMENT ON TABLE mockidentitysystem.key_alias
    IS 'Contains key alias and  metadata of all the keys used in MOSIP system.';

COMMENT ON COLUMN mockidentitysystem.key_alias.id
    IS 'Unique identifier (UUID) used for referencing keys in key_store table and HSM';

COMMENT ON COLUMN mockidentitysystem.key_alias.app_id
    IS 'To reference a Module key';

COMMENT ON COLUMN mockidentitysystem.key_alias.ref_id
    IS 'To reference a Encryption key ';

COMMENT ON COLUMN mockidentitysystem.key_alias.key_gen_dtimes
    IS 'Date and time when the key was generated.';

COMMENT ON COLUMN mockidentitysystem.key_alias.key_expire_dtimes
    IS 'Date and time when the key will be expired. This will be derived based on the configuration / policy defined in Key policy definition.';

COMMENT ON COLUMN mockidentitysystem.key_alias.status_code
    IS 'Status of the key, whether it is active or expired.';

COMMENT ON COLUMN mockidentitysystem.key_alias.lang_code
    IS 'For multilanguage implementation this attribute Refers master.language.code. The value of some of the attributes in current record is stored in this respective language. ';

COMMENT ON COLUMN mockidentitysystem.key_alias.cr_by
    IS 'ID or name of the user who create / insert record';

COMMENT ON COLUMN mockidentitysystem.key_alias.cr_dtimes
    IS 'Date and Timestamp when the record is created/inserted';

COMMENT ON COLUMN mockidentitysystem.key_alias.upd_by
    IS 'ID or name of the user who update the record with new values';

COMMENT ON COLUMN mockidentitysystem.key_alias.upd_dtimes
    IS 'Date and Timestamp when any of the fields in the record is updated with new values.';

COMMENT ON COLUMN mockidentitysystem.key_alias.is_deleted
    IS 'Flag to mark whether the record is Soft deleted.';

COMMENT ON COLUMN mockidentitysystem.key_alias.del_dtimes
    IS 'Date and Timestamp when the record is soft deleted with is_deleted=TRUE';

-- Creating table with name = key_policy_def
CREATE TABLE IF NOT EXISTS mockidentitysystem.key_policy_def
(
    app_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    key_validity_duration smallint,
    is_active boolean NOT NULL,
    pre_expire_days smallint,
    access_allowed character varying(1024) COLLATE pg_catalog."default",
    cr_by character varying(256) COLLATE pg_catalog."default" NOT NULL,
    cr_dtimes timestamp without time zone NOT NULL,
    upd_by character varying(256) COLLATE pg_catalog."default",
    upd_dtimes timestamp without time zone,
    is_deleted boolean DEFAULT false,
    del_dtimes timestamp without time zone,
    CONSTRAINT pk_keypdef_id PRIMARY KEY (app_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS mockidentitysystem.key_policy_def
    OWNER to postgres;

REVOKE ALL ON TABLE mockidentitysystem.key_policy_def FROM mockidsystemuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE mockidentitysystem.key_policy_def TO mockidsystemuser;

GRANT ALL ON TABLE mockidentitysystem.key_policy_def TO postgres;

COMMENT ON TABLE mockidentitysystem.key_policy_def
    IS 'Key Policy Defination: Policy related to encryption key management is defined here. For eg. Expiry duration of a key generated.';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.app_id
    IS 'Application ID: Application id for which the key policy is defined';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.key_validity_duration
    IS 'Key Validity Duration: Duration for which key is valid';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.is_active
    IS 'IS_Active : Flag to mark whether the record is Active or In-active';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.cr_by
    IS 'Created By : ID or name of the user who create / insert record';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.cr_dtimes
    IS 'Created DateTimestamp : Date and Timestamp when the record is created/inserted';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.upd_by
    IS 'Updated By : ID or name of the user who update the record with new values';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.upd_dtimes
    IS 'Updated DateTimestamp : Date and Timestamp when any of the fields in the record is updated with new values.';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.is_deleted
    IS 'IS_Deleted : Flag to mark whether the record is Soft deleted.';

COMMENT ON COLUMN mockidentitysystem.key_policy_def.del_dtimes
    IS 'Deleted DateTimestamp : Date and Timestamp when the record is soft deleted with is_deleted=TRUE';

-- Creating table with name =key_store
CREATE TABLE IF NOT EXISTS mockidentitysystem.key_store
(
    id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    master_key character varying(36) COLLATE pg_catalog."default" NOT NULL,
    private_key character varying(2500) COLLATE pg_catalog."default" NOT NULL,
    certificate_data character varying COLLATE pg_catalog."default" NOT NULL,
    cr_by character varying(256) COLLATE pg_catalog."default" NOT NULL,
    cr_dtimes timestamp without time zone NOT NULL,
    upd_by character varying(256) COLLATE pg_catalog."default",
    upd_dtimes timestamp without time zone,
    is_deleted boolean DEFAULT false,
    del_dtimes timestamp without time zone,
    CONSTRAINT pk_keystr_id PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS mockidentitysystem.key_store
    OWNER to postgres;

REVOKE ALL ON TABLE mockidentitysystem.key_store FROM mockidsystemuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE mockidentitysystem.key_store TO mockidsystemuser;

GRANT ALL ON TABLE mockidentitysystem.key_store TO postgres;

COMMENT ON TABLE mockidentitysystem.key_store
    IS 'Stores Encryption (Base) private keys along with certificates';

COMMENT ON COLUMN mockidentitysystem.key_store.id
    IS 'Unique identifier (UUID) for referencing keys';

COMMENT ON COLUMN mockidentitysystem.key_store.master_key
    IS 'UUID of the master key used to encrypt this key';

COMMENT ON COLUMN mockidentitysystem.key_store.private_key
    IS 'Encrypted private key';

COMMENT ON COLUMN mockidentitysystem.key_store.certificate_data
    IS 'X.509 encoded certificate data';

COMMENT ON COLUMN mockidentitysystem.key_store.cr_by
    IS 'ID or name of the user who create / insert record';

COMMENT ON COLUMN mockidentitysystem.key_store.cr_dtimes
    IS 'Date and Timestamp when the record is created/inserted';

COMMENT ON COLUMN mockidentitysystem.key_store.upd_by
    IS 'ID or name of the user who update the record with new values';

COMMENT ON COLUMN mockidentitysystem.key_store.upd_dtimes
    IS 'Date and Timestamp when any of the fields in the record is updated with new values.';

COMMENT ON COLUMN mockidentitysystem.key_store.is_deleted
    IS 'Flag to mark whether the record is Soft deleted.';

COMMENT ON COLUMN mockidentitysystem.key_store.del_dtimes
    IS 'Date and Timestamp when the record is soft deleted with is_deleted=TRUE';

-- Creating table with name = kyc_auth
CREATE TABLE IF NOT EXISTS mockidentitysystem.kyc_auth
(
    kyc_token character varying(255) COLLATE pg_catalog."default",
    individual_id character varying(255) COLLATE pg_catalog."default",
    partner_specific_user_token character varying(255) COLLATE pg_catalog."default",
    response_time timestamp without time zone,
    transaction_id character varying(255) COLLATE pg_catalog."default",
    validity integer
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS mockidentitysystem.kyc_auth
    OWNER to postgres;

REVOKE ALL ON TABLE mockidentitysystem.kyc_auth FROM mockidsystemuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE mockidentitysystem.kyc_auth TO mockidsystemuser;

GRANT ALL ON TABLE mockidentitysystem.kyc_auth TO postgres;

-- Creating table with name = mock_identity
CREATE TABLE IF NOT EXISTS mockidentitysystem.mock_identity
(
    individual_id character varying(36) COLLATE pg_catalog."default" NOT NULL,
    identity_json character varying(2048) COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT pk_mock_id_code PRIMARY KEY (individual_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE IF EXISTS mockidentitysystem.mock_identity
    OWNER to postgres;

REVOKE ALL ON TABLE mockidentitysystem.mock_identity FROM mockidsystemuser;

GRANT SELECT, INSERT, TRUNCATE, REFERENCES, UPDATE, DELETE ON TABLE mockidentitysystem.mock_identity TO mockidsystemuser;

GRANT ALL ON TABLE mockidentitysystem.mock_identity TO postgres;
