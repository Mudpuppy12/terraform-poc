resource "aws_ssm_document" "session_manager_prefs" {
  name            = "SSM-SessionManagerRunShell"
  document_type   = "Session"
  document_format = "JSON"

  content = <<DOC
{
    "schemaVersion": "1.0",
    "description": "SSM document to house preferences for session manager",
    "sessionType": "Standard_Stream",
    "inputs": {
        "s3BucketName": "${aws_s3_bucket.ssm_s3_bucket.id}",
        "s3KeyPrefix": "AWSLogs/${data.aws_caller_identity.current.account_id}/ssm_session_logs",
        "s3EncryptionEnabled": false,
        "cloudWatchLogGroupName": "${aws_cloudwatch_log_group.ssm_logs.name}",
        "cloudWatchEncryptionEnabled": false,
        "runAsEnabled": false,
        "kmsKeyId": "${aws_kms_key.ssm_access_key.id}",
        "cloudWatchStreamingEnabled": true,
        "idleSessionTimeout": "20"
    }
}
DOC
}