# TikTok Research API Wrapper

[![License](https://img.shields.io/badge/License-Tiktok%20-blue.svg?style=flat-square)](https://github.com/tiktok/tiktok-research-api-wrapper/blob/main/LICENSE.md)

# Introduction

The TikTok Research API Wrapper is a ToolKit built in R and Python to facilitate the use of [TikTok Research API](https://developers.tiktok.com/doc/research-api-get-started/). Our Wrapper Toolkit supports the following endpoints: Videos, User Info, Video Comments, User Liked Videos, User Pinned Videos, User Followers, User Following, and Reposted Videos.

## Quick Start
R and Python are among the most popular languages among researchers. The TikTok Research API Wrapper is a code package that provides an interface between your application and TikTok's research APIs for these two languages. This tutorial provides the basic information needed to use our wrapper and includes sample code for your reference.
# Version

- API version: 1.0.0

## Integration with R Wrapper

#### Version requirements

  - 4.0.0
  
#### Integration Steps:
1. Download the Git Wrapper
```bash
install_git("git@github.com:tiktok/tiktok-research-api-wrapper.git", , subdir = "tiktok-research-api-r")

```
2. Usage

```bash
## IMPORT
library(TikTokResearchAPI)

qps <- 5
client_key <- 'Your_client_key'
client_secret <- 'Your_client_secret'

if (client_key == "" || client_secret == "") {
  stop("CLIENT_KEY and CLIENT_SECRET environment variables must be set.")
}
## # Initialize the API client
research_api <- TikTokResearchAPI$new(client_key, client_secret, qps)
```
## Integration with Python Wrapper

#### Version requirements

  - 3.0.0
  
#### Integration Steps:
1. Download the Git Wrapper
```bash
pip install TikTokResearchAPI
```
2. Usage

```bash
from tiktok_research_api import *
qps = 5 #rate limiter
client_key = os.getenv("CLIENT_KEY", "")
client_secret = os.getenv("CLIENT_SECRET", "")
# Initialize the API client
api = TikTokResearchAPI(client_key, client_secret, qps)
```

## Give feedback

- If you want to report bugs or issues related to the wrapper, please contact us via Github [Issues](https://github.com/tiktok/tiktok-research-api-wrapper/issues) page.


## References

Here are the detailed documentation for currently supported programming languages.

- R:  please refer to [tiktok-research-api-r/README.md](https://github.com/tiktok/tiktok-research-api-wrapper/blob/main/tiktok-research-api-r/README.md))
- Python:  please refer to [tiktok-research-api-python/README.md]((https://github.com/tiktok/tiktok-research-api-wrapper/blob/main/tiktok-research-api-python/README.md))
