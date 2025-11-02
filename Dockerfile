FROM ghcr.io/xu-cheng/texlive-alpine-small:20251002
USER root

RUN apk add --no-cache python3 py3-pygments
RUN tlmgr install minted titlesec