FROM python:3.10.7
ADD eh-fileupload.py .
RUN pip install azure-eventhub
CMD ["python", "./eh-fileupload.py"]