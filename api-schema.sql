create sequence tx_map_seq;

create table if not exists blocks
(
    hash                    varchar not null
        primary key,
    accepted_id_merkle_root varchar,
    difficulty              double precision,
    is_chain_block          boolean,
    merge_set_blues_hashes  character varying[],
    merge_set_reds_hashes   character varying[],
    selected_parent_hash    varchar,
    bits                    integer,
    blue_score              bigint,
    blue_work               varchar,
    daa_score               bigint,
    hash_merkle_root        varchar,
    nonce                   varchar,
    parents                 character varying[],
    pruning_point           varchar,
    timestamp               timestamp,
    utxo_commitment         varchar,
    version                 integer
);

create index if not exists block_chainblock
    on blocks (is_chain_block);

create index if not exists idx_blue_score
    on blocks (blue_score);

create table if not exists transactions
(
    subnetwork_id        varchar,
    transaction_id       varchar not null
        primary key,
    hash                 varchar,
    mass                 varchar,
    block_hash           character varying[],
    block_time           bigint,
    is_accepted          boolean,
    accepting_block_hash varchar
);

create index if not exists block_time_idx
    on transactions (block_time desc);

create index if not exists idx_block_hash
    on transactions using gin (block_hash);

create index if not exists idx_accepting_block
    on transactions (accepting_block_hash);

create table if not exists transactions_outputs
(
    id                        serial
        primary key,
    transaction_id            varchar,
    index                     integer,
    amount                    bigint,
    script_public_key         varchar,
    script_public_key_address varchar,
    script_public_key_type    varchar,
    accepting_block_hash      varchar,
    block_time                bigint
);

create index if not exists idx_txouts
    on transactions_outputs (transaction_id);

create index if not exists idx_txouts_addr
    on transactions_outputs (script_public_key_address);

create index if not exists block_time_outputs_idx
    on transactions_outputs (block_time desc);

create index if not exists idx_addr_bt
    on transactions_outputs (script_public_key_address, block_time);

create index if not exists tx_id_and_index
    on transactions_outputs (transaction_id, index);

create table if not exists transactions_inputs
(
    id                      serial
        primary key,
    transaction_id          varchar,
    index                   integer,
    previous_outpoint_hash  varchar,
    previous_outpoint_index integer,
    signature_script        varchar,
    sig_op_count            integer,
    block_time              bigint
);

create index if not exists idx_txinp
    on transactions_inputs (transaction_id);

create index if not exists idx_txin_prev
    on transactions_inputs (previous_outpoint_hash);

create table if not exists vars
(
    key   varchar not null
        primary key,
    value varchar
);

create table if not exists addresses
(
    address varchar not null
        primary key,
    balance bigint
);

create table if not exists tx_id_address_mapping
(
    transaction_id varchar(64),
    address        varchar(70),
    block_time     bigint,
    is_accepted    boolean,
    id             bigint default nextval('tx_map_seq'::regclass) not null
        primary key,
    unique (transaction_id, address)
);

create index if not exists idx_tx_id_address_mapping
    on tx_id_address_mapping (address, is_accepted, block_time);

create index if not exists idx_block_time
    on tx_id_address_mapping (block_time);

create index if not exists idx_address_block_time
    on tx_id_address_mapping (address, block_time);

create index if not exists idx_tx_id
    on tx_id_address_mapping (transaction_id);
