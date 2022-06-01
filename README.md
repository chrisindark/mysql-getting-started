# Commands for DBA tasks

show variables like 'innodb_file_per_table';
show variables like 'innodb_buffer_pool_size';
show variables like 'innodb_log_file_size';
SELECT @@innodb_buffer_pool_size/1024/1024/1024;
SELECT @@innodb_buffer_pool_instances;
SELECT @@innodb_buffer_pool_chunk_size/1024/1024/1024;

SELECT count(*) tables,
concat(round(sum(table_rows)/1000000,2),'M') rows,
concat(round(sum(data_length)/(1024*1024*1024),2),'G') data,
concat(round(sum(index_length)/(1024*1024*1024),2),'G') idx,
concat(round(sum(data_length+index_length)/(1024*1024\*1024),2),'G') total_size,
round(sum(index_length)/sum(data_length),2) idxfrac
FROM information_schema.TABLES;

SELECT
count(*) tables,
table_schema,concat(round(sum(table_rows)/1000000,2),'M') rows,
concat(round(sum(data_length)/(1024*1024*1024),2),'G') data,
concat(round(sum(index_length)/(1024*1024*1024),2),'G') idx,
concat(round(sum(data_length+index_length)/(1024*1024\*1024),2),'G') total_size,
round(sum(index_length)/sum(data_length),2) idxfrac
FROM information_schema.TABLES
GROUP BY table_schema
ORDER BY sum(data_length+index_length) DESC LIMIT 10;

SELECT engine,
count(*) tables,
concat(round(sum(table_rows)/1000000,2),'M') rows,
concat(round(sum(data_length)/(1024*1024*1024),2),'G') data,
concat(round(sum(index_length)/(1024*1024*1024),2),'G') idx,
concat(round(sum(data_length+index_length)/(1024*1024\*1024),2),'G') total_size,
round(sum(index_length)/sum(data_length),2) idxfrac
FROM information_schema.TABLES
GROUP BY engine
ORDER BY sum(data_length+index_length) DESC LIMIT 10;

SHOW STATUS WHERE `variable_name` = 'Threads_connected';

SELECT table_schema, table_name, ROUND(SUM(data_length+index_length+data_free)/1024/1024/1024, 2) as SIZE_GB,
ROUND(SUM(data_free)/1024/1024/1024, 2) as DATA_FREE_SIZE_GB,
ROUND(SUM(index_length)/1024/1024/1024, 2) as DATA_INDEX_SIZE_GB,
ROUND(SUM(data_length - (AVG_ROW_LENGTH\*TABLE_ROWS))/1024/1024/1024, 2) as APPROXIMATED_FRAGMENTED_SPACE_GB
from information_schema.tables
where TABLE_SCHEMA not in ("mysql")
GROUP BY 1,2
ORDER BY APPROXIMATED_FRAGMENTED_SPACE_GB DESC;
