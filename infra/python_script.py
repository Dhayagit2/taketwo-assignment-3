import boto3
import logging
import sys
from botocore.exceptions import BotoCoreError, ClientError

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def upload_to_s3(bucket_name, file_path, key=None):
    s3 = boto3.client('s3')
    if not key:
        key = file_path

    try:
        s3.upload_file(file_path, bucket_name, key)
        logger.info(f"File '{file_path}' uploaded successfully to '{bucket_name}/{key}'.")
    except (BotoCoreError, ClientError) as e:
        logger.error(f"Failed to upload file: {e}")
        sys.exit(1)

if __name__ == "__main__":
    # Example usage: python python_script.py test.txt
    if len(sys.argv) != 2:
        logger.error("Usage: python python_script.py <file_path>")
        sys.exit(1)
    upload_to_s3("example-bucket-taketwo", sys.argv[1])
