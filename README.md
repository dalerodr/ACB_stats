![](https://img.shields.io/badge/R-276DC3?style=for-the-badge&logo=r&logoColor=white)
![](https://img.shields.io/badge/Google_Cloud-4285F4?style=for-the-badge&logo=google-cloud&logoColor=white)
[![Render R Markdown every 30 minutes](https://github.com/dalerodr/acb-stats/actions/workflows/render_report.yml/badge.svg)](https://github.com/dalerodr/acb-stats/actions/workflows/render_report.yml)
[![pages-build-deployment](https://github.com/dalerodr/acb-stats/actions/workflows/pages/pages-build-deployment/badge.svg)](https://github.com/dalerodr/acb-stats/actions/workflows/pages/pages-build-deployment)

# **ACB dashboard** :basketball:
* [**Basketball dashboard with ACB data**](https://dalerodr.github.io/acb-stats/)
## ✨ Key Features
### 🤜 Team Stats 🤛
ACB team analysis from the 1983-84 season through 2023-24. Season-by-season and team charts, comparing home vs. away performance.

<a href="https://dalerodr.github.io/acb-stats/#team-stats"><img src="https://github.com/dalerodr/acb-stats/blob/main/docs/image/acb_dashboard_image-team_stats.jpg" alt="team_stats" style="width: 35%; height: auto;"></a>

### 📈 Player Stats 📉
Embedded Looker dashboard with individual player, season, and team statistics.

<a href="https://dalerodr.github.io/acb-stats/#player-stats"><img src="https://github.com/dalerodr/acb-stats/blob/main/docs/image/acb_dashboard_image-player_stats.jpg" alt="player_stats" style="width: 35%; height: auto;"></a>

---
## 🎢 Workflow
The project is structured according to the following points:
- **1**: Scraping of current season games, where we insert the data into a BigQuery table.
- **2**: Call Google Workflow with:
  - **2.1**: Dataform process with tag to get new games IDs.
  - **2.2**: Call Cloud Function to scrape new games and insert data into BigQuery tables.
  - **2.3**: Dataform process without tag to load and transform new data into final tables.

<a href="https://github.com/dalerodr/acb-stats/blob/main/docs/image/acb_workflow.jpg"><img src="https://github.com/dalerodr/acb-stats/blob/main/docs/image/acb_workflow.jpg" alt="acb_workflow" style="width: 35%; height: auto;"></a>
