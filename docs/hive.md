# LimaCharlie Config Hive

The Config Hive (or Hive for short) is a generic set of APIs used by LimaCharlie to maintain
the configuration of various systems.

Hive is the main system of configuration for LimaCharlie.

The Hive system helps you configure the wide range of systems, features and extensions in LimaCharlie in
a cohesive way. Each feature or system's configuration lives in its own "hive".

Currently managed through Hive:
- Detection & Response Rules
- False Positive Rules
- Cloud Adapters/Sensors

## Core Concepts

The Hive contains configuration records organized as a simple hierarchy: `/hive/{hive_name}/{oid}/{record_name}`.

The `hive_name` represents the type of records it contains. For example, the `cloud_sensor` hive name will
contain all records relating to cloud sensors (cloud hosted [LimaCharlie Adapters](lc_adapter.md)).

The `oid` is a partition for the records, in this case an Organization ID (oid).

The `record_name` is simple the unique name for the record.

Setting and updating records in Hive will automatically orchestrate the necessary changes in the relevant
service. For example, updating a `cloud_sensor` record will automatically reapply the new configurations
to the cloud hosted LimaCharlie Adapter. Deleting the same record will stop the Adapter.

The record data itself will be dependant on the hive name, but it will always be a JSON dictionary.

## Record Structure

Records contain 3 components:
* The record data itself, who's format is dependant on the hive where it lives.
* User Metadata. As outlined below, this is metadata that can modified directly by you and can be exposed to users using specific permissions without giving access to the full record data.
* System Metadata. This is metadata that is generated and maintained by the Hive system.

### User Metadata

The user metadata format is the following:
```json
{
    "expiry": 123, // a milisecond epoch time when the record will automatically expire and be deleted.
    "tags": ["abc", "def"], // a list of tags on this record.
    "enabled": true // a boolean indicating whether the record is in an "enabled" state or not.
}
```

### System Metadata

The system metadata format is the following:
```json
{
    "etag": "abc", // a unique tag representing the current state of data of the record. Can be used for optimistic transactions: https://en.wikipedia.org/wiki/HTTP_ETag
    "last_author": "abc", // the identity of the last entity having modified the record.
    "last_mod": 123, // a milisecond epoch of the last time the record was modified.
    "guid": "abc", // a globally unique identifier of the record (not its data).
    "last_error": "abc", // the contents of the last error related to the record.
    "last_error_ts": 123 // the milisecond epoch of the last time an error occured relating to the record.
}
```

## Accessing

The permissions required for various operations will vary based on the specific hive. For example, the `cloud_sensor` hive
will use the following permissions:

* `cloudsensor.get`
* `cloudsensor.set`
* `cloudsensor.del`
* `cloudsensor.get.mtd`
* `cloudsensor.set.mtd`

### REST

The config hive can be accessed through the LimaCharlie REST API (https://api.limacharlie.io/static/swagger/).

#### Listing Records

You can list all the records in a given partition by issuing an HTTP GET to `https://api.limacharlie.io/v1/hive/{hive_name}/{oid}`.

#### Getting Record Data

You can retrieve the full contents of a record by issuing an HTTP GET to `https://api.limacharlie.io/v1/hive/{hive_name}/{oid}/{record_name}/data`.

#### Setting Record Data

You can set the contents of a record by issuing an HTTP POST to `https://api.limacharlie.io/v1/hive/{hive_name}/{oid}/{record_name}/data` and including
a REST parameter of `data={record_data}`.

#### Getting Record Metadata

You can retrieve the metadata of a record by issuing an HTTP GET to `https://api.limacharlie.io/v1/hive/{hive_name}/{oid}/{record_name}/mtd`.

#### Setting Record Metadata

You can set the metadata of a record by issuing an HTTP POST to `https://api.limacharlie.io/v1/hive/{hive_name}/{oid}/{record_name}/mtd` and including
a REST parameter of `usr_mtd={record_metadata}`.

#### Deleting a Record

You can delete a record by issuing an HTTP DELETE to `https://api.limacharlie.io/v1/hive/{hive_name}/{oid}/{record_name}`.

#### Full Documentation

For details, see the Swagger documentation: https://api.limacharlie.io/static/swagger/

### Python CLI

Install the Python LimaCharlie CLI using `pip install limacharlie`.

Possible operations: `limacharlie hive --help`

Repository: https://github.com/refractionPOINT/python-limacharlie/

## Conditional Update

You may perform conditional record updates using the `etag` parameter. When set during an update, the hive system will verify that
the record it is about to update currently has the etag provided. If the etags do not match, the update is not performed. This allows
you to:

1. Get a Record X
1. Update some values of X locally
1. Set the updated Record X, including the etag received during the Get

This enables you to detect when "update collision" occur.