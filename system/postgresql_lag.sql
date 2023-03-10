-- from https://severalnines.com/blog/what-look-if-your-postgresql-replication-lagging/
-- Step 1.  determine if there's a lag

select pg_is_in_recovery(),pg_is_wal_replay_paused(), pg_last_wal_receive_lsn(), pg_last_wal_replay_lsn(), pg_last_xact_replay_timestamp();
