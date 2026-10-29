# Synthetic container fixture for PR review. Never build or deploy.
FROM python:3.9-slim
USER root
WORKDIR /fixture
COPY unsafe_inputs.py /fixture/unsafe_inputs.py
CMD ["python", "-c", "print('scan fixture only')"]
