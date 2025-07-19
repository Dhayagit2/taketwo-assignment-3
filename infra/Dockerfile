FROM python:3.9-slim

WORKDIR /app

COPY python_script.py .

RUN pip install boto3

CMD ["python", "python_script.py", "test.txt"]
