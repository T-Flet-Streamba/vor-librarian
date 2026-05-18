# Vor Librarian — future container runtime (orchestrator TBD)
FROM alpine:3.20

WORKDIR /app

ENV VOR_LIBRARIAN_ROOT=/app

COPY prompts/ /app/prompts/
COPY skill/remote/ /app/skill/remote/

# Future: COPY orchestrator and set ENTRYPOINT
CMD ["sh", "-c", "echo 'vor-librarian container: orchestrator not yet implemented' && ls -la /app/prompts /app/skill/remote"]
