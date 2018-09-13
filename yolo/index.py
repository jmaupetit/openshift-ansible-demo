"""
Yolo cat demo app

Requirements:

    - create a Giphy API key
    - create a .env file at the project's root
    - add an entry to this .env file:

        YOLO_GIPHY_API_KEY=foo

      (replace foo with your API key)
"""
import json
import logging
import os

import giphy_client

from dotenv import load_dotenv
from flask import Flask, render_template


app = Flask(__name__)


@app.route("/")
def index():
    """Application index"""

    # Load environment variables
    load_dotenv()

    application_name = os.environ.get("YOLO_APP_NAME", "Yolo cat")
    header_bg_color = os.environ.get("YOLO_HEADER_BG_COLOR", "red")
    header_color = os.environ.get("YOLO_HEADER_COLOR", "white")
    api_key = os.environ.get("YOLO_GIPHY_API_KEY")

    client = giphy_client.DefaultApi()

    gif_id = None
    errors = []
    try:
        response = client.gifs_random_get(
            api_key, tag=application_name, rating="g", fmt="json"
        )
        gif_id = response.data.id
    except giphy_client.rest.ApiException as err:
        logging.error(
            "An exception occurred while calling Giphy API: %s\n" % err
        )
        errors.append(json.loads(err.body).get("message"))

    return render_template(
        "index.html",
        header_bg_color=header_bg_color,
        header_color=header_color,
        application_name=application_name,
        gif_id=gif_id,
        errors=errors,
    )
