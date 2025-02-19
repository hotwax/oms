-- SQL query to delete OmsProduct Data Feed and related data as we are not using this feature at this time due to performance issues
delete from data_feed_document where data_feed_id = 'OmsProduct';
delete from data_feed where data_feed_id = 'OmsProduct';