-- To allow storage of special characters in keywords, otherwise decisions based on keywords may be inaccurate.
ALTER TABLE PRODUCT_KEYWORD_NEW MODIFY COLUMN KEYWORD VARCHAR(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin;
-- Increase the character limit for DETAIL_IMAGE_URL field to accommodate longer image URLs.
ALTER TABLE PRODUCT MODIFY COLUMN DETAIL_IMAGE_URL VARCHAR(4095);