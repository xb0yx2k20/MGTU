from typing import Any

from pymongo import MongoClient
from pymongo.errors import ConnectionFailure
from celery import Celery
from celery.signals import worker_process_init, worker_process_shutdown


celery_app = Celery(__name__)
celery_app.conf.broker_url = ""
celery_app.conf.result_backend = ""

# MongoDB setup
client = None
db = None
collection = None


@worker_process_init.connect
def init_worker(**_kwargs: Any) -> None:
    """
    Will be run on initialization of each worker. When you run 12 workers, you will need to have
    12 database connections. Here you can get them.
    """
    global client, db, collection
    if client := MongoClient(""):
        db = getattr(client, "")
        collection = db[""]
    else:
        raise ConnectionFailure(
            "Cannot connect to database. Please check your config and network settings."
        )


@worker_process_shutdown.connect
def shutdown_worker(**_kwargs: Any) -> None:
    """
    Shutdown everything at the end of a worker’s lifetime, e.g. database connections
    """
    if client:
        client.close()