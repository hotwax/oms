-- SQL query to delete poll_SystemMessageFileSftp_NewProductsFeed service job and related data

delete from service_job_parameter where job_name = 'poll_SystemMessageFileSftp_NewProductsFeed'
delete from service_job_run where job_name = 'poll_SystemMessageFileSftp_NewProductsFeed'
delete from service_job where job_name = 'poll_SystemMessageFileSftp_NewProductsFeed'

-- SQL query to delete poll_SystemMessageFileSftp_ProductUpdatesFeed service job and related data

delete from service_job_parameter where job_name = 'poll_SystemMessageFileSftp_ProductUpdatesFeed'
delete from service_job_run where job_name = 'poll_SystemMessageFileSftp_ProductUpdatesFeed'
delete from service_job where job_name = 'poll_SystemMessageFileSftp_ProductUpdatesFeed'