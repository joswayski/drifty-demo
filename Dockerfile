# Build stage
FROM rust:1.87-slim AS builder

WORKDIR /app

# Install musl tools for static linking
RUN apt-get update && apt-get install -y musl-tools && rm -rf /var/lib/apt/lists/*
RUN rustup target add aarch64-unknown-linux-musl

# Copy manifests
COPY Cargo.toml Cargo.lock ./

# Create a dummy main.rs to cache dependencies
RUN mkdir src && echo "fn main() {}" > src/main.rs
RUN cargo build --release --target aarch64-unknown-linux-musl
RUN rm -rf src

# Copy actual source code
COPY src ./src

# Build the application (touch to invalidate the cached dummy)
RUN touch src/main.rs && cargo build --release --target aarch64-unknown-linux-musl

# Runtime stage - scratch for minimal size
FROM scratch

# Copy the statically linked binary from builder
COPY --from=builder /app/target/aarch64-unknown-linux-musl/release/drifty-demo /drifty-demo

CMD ["/drifty-demo"]
