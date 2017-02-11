# mailcraft

Make the mail WebAPI.

However, it is under development.

## Usage

```
$ docker-compose up
```

### API

```
curl -X POST http://localhost:3000/register \
  -d "domain=example.com" -d "email=relay@example.net" \
  -d "webhook=http://example.net/callback"
```