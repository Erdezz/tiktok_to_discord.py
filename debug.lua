import requests
import time
from TikTokApi import TikTokApi

# === CONFIG ===
WEBHOOK_URL = "MET_TON_WEBHOOK_DISCORD_ICI"

HASHTAGS = [
    "hacco",
    "hacoo",
    "haccolinks"
]

DELAY_BETWEEN_VIDEOS = 20
CHECK_INTERVAL = 60

sent_videos = set()


def send_to_discord(video_url, author):
    data = {
        "content": f"📱 Nouveau TikTok trouvé !\n👤 {author}\n{video_url}"
    }

    requests.post(WEBHOOK_URL, json=data)


def search_tiktoks():
    with TikTokApi() as api:
        for tag in HASHTAGS:
            videos = api.hashtag(name=tag).videos(count=5)

            for video in videos:
                video_id = video.id
                video_url = f"https://www.tiktok.com/@{video.author.username}/video/{video_id}"

                if video_id not in sent_videos:
                    sent_videos.add(video_id)

                    send_to_discord(video_url, video.author.username)

                    print("Envoyé :", video_url)

                    # ⏳ attendre 20 secondes entre chaque vidéo
                    time.sleep(DELAY_BETWEEN_VIDEOS)


while True:
    try:
        search_tiktoks()
        print("Scan terminé")
    except Exception as e:
        print("Erreur :", e)

    time.sleep(CHECK_INTERVAL)