# R Research Assistant — Plumber API

This is the R execution backend for the R Research Assistant app.
It receives R scripts from the Next.js frontend, executes them, and returns the output.

## Endpoints

| Method | Path | Description |
|--------|------|-------------|
| GET | /health | Health check — returns R version and status |
| POST | /execute | Execute an R script, returns raw console output |
| GET | /packages | Lists all installed R packages and versions |

## POST /execute

Request body (JSON):
```json
{
  "script": "cat('Hello from R\\n')",
  "excelData": "<base64-encoded Excel file>",
  "fileName": "data.xlsx"
}
```

Response:
```json
{
  "success": true,
  "raw_output": "Hello from R",
  "error_message": null,
  "execution_time_ms": 342
}
```

## Deploy to Render.com

1. Push this folder to a GitHub repository
2. Go to https://render.com → New → Web Service
3. Connect your GitHub repo
4. Set these options:
   - **Environment**: Docker
   - **Instance Type**: Free
   - **Name**: r-research-api (or any name)
5. Click Deploy
6. Copy the public URL (e.g. https://r-research-api.onrender.com)
7. Add it to your Next.js app's .env.local:
   R_API_URL=https://r-research-api.onrender.com

## Keep Alive (important for free tier)

Render.com free tier spins down after 15 minutes of inactivity.
The Next.js app sends a /health ping before every analysis to wake it up.
First analysis after inactivity may take 30-60 seconds while the server wakes.

To avoid this, use UptimeRobot (free) to ping /health every 10 minutes:
- Sign up at https://uptimerobot.com
- Add monitor: HTTP, URL = https://your-api.onrender.com/health, interval = 10 min
