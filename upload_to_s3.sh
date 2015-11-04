#!/bin/bash
# Upload files to AWS S3 bucket

S3_KEY=$1
S3_SECRET=$2
S3_BUCKET=$3
S3_PATH=$4

FILES=${@:5}

for file in $FILES; do
  echo -n "Transfiriendo fichero $file..."

  export LC_ALL=C
  DATE=$(date +"%a, %d %b %Y %T %z")
  ACL="x-amz-acl:private"
  CONTENT_TYPE=$(file -b --mime-type $file)
  STRING="PUT\n\n$CONTENT_TYPE\n$DATE\n$ACL\n/$S3_BUCKET$S3_PATH$file"
  SIGNATURE=$(echo -en "${STRING}" | openssl sha1 -hmac "${S3_SECRET}" -binary | base64)

  curl -X PUT -T "$file" \
    -H "Host: $S3_BUCKET.s3.amazonaws.com" \
    -H "Date: $DATE" \
    -H "Content-Type: $CONTENT_TYPE" \
    -H "$ACL" \
    -H "Authorization: AWS ${S3_KEY}:$SIGNATURE" \
    "https://$S3_BUCKET.s3.amazonaws.com$S3_PATH$file"

  echo "done."
done
