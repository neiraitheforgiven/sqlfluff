DELETE FROM query.o_customer
WHERE ObjectId = a_ObjectId;

DELETE query.o_customer
WHERE ObjectId = a_ObjectId;

DELETE BillingRunObject_t q
WHERE q.billingrunjobid = a_JobId;

DELETE app.BillingRunObject_t "q"
WHERE "q".billingrunjobid = a_JobId;

DELETE BillingRunObject_t@remote_db q
WHERE q.billingrunjobid = a_JobId;

DELETE BillingRunObject_t q
WHERE q.billingrunjobid = a_JobId
RETURNING q.ReferenceObjectId INTO t_ReferenceObjectId;

BEGIN
  DELETE BillingRunObject_t q
  WHERE q.billingrunjobid = a_JobId;
END;
/
