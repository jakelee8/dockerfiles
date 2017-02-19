FROM python:3
WORKDIR /tmp

# Install build files.
ADD files /opt/build
WORKDIR /opt/build

# Install Python dependencies.
RUN pip install --no-cache-dir -r requirements.txt -U

# Configure entrypoint.
VOLUME /build
CMD ["make"]
