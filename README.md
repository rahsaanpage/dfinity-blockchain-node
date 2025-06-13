# DFINITY Blockchain Node

A Docker-based implementation of a DFINITY Internet Computer (IC) blockchain node running the Rosetta API server.

## Overview

This project provides a containerized DFINITY blockchain node that exposes the Rosetta API for interacting with the Internet Computer network. It builds the `ic-rosetta-api` binary from the official DFINITY IC source code and provides health checking capabilities.

## Components

### Core Services
- **IC Rosetta API Server**: The main blockchain node service built from DFINITY's IC source
- **Health Check**: Lua-based health monitoring that checks network status and block information
- **Logging**: Structured logging with file rotation for both API and background processes

### Files Structure
```
├── Dockerfile              # Multi-stage build for IC Rosetta API
├── scripts/
│   ├── entrypoint.sh       # Node startup script with readiness checks
│   └── log_config.yml      # Logging configuration with rotation
└── healthcheck/
    └── healthcheck.lua     # Network status monitoring script
```

## Features

- **Multi-stage Docker build** using Rust 1.67 for optimal image size
- **Health monitoring** via Rosetta API network status endpoints
- **Structured logging** with configurable levels and file rotation
- **Readiness checks** to ensure proper node initialization
- **Network status tracking** including block height, hash, and peer count

## Environment Variables

- `NODE_ENTRYPOINT`: Required. Command to execute the node service
- `NODE_ARGS`: Optional. Additional arguments for the node service
- `RPCBaseURL`: Base URL for Rosetta API endpoints (used by health check)

## Health Check

The health check script monitors:
- Network connectivity via `/network/list` endpoint
- Current block information (height, hash, timestamp)
- Peer count
- Node synchronization status

## Logging

Configured with multiple appenders:
- **Console output**: Warnings and above to stdout
- **API logs**: Detailed Rosetta API logs with 100MB rotation
- **Background logs**: System-level logs with 10MB rotation

## Building

```bash
docker build -t dfinity-node .
```

## Running

```bash
docker run -e NODE_ENTRYPOINT="ic-rosetta-api" \
           -e NODE_ARGS="--config /app/assets/log_config.yml" \
           -p 8080:8080 \
           dfinity-node
```

## Version

Current version: 1.8.0