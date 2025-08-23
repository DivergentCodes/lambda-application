import json
import logging
import os

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def handler(event, context):
    """
    Basic Lambda function handler

    Args:
        event: AWS Lambda event data
        context: AWS Lambda context object

    Returns:
        dict: Response with status code and message
    """

    try:
        APP_NAME = os.environ["APP_NAME"]
        APP_VERSION = os.environ["APP_VERSION"]
        COMMIT_SHA = os.environ["COMMIT_SHA"]
        BRANCH = os.environ["BRANCH"]
        BUILD_DATE = os.environ["BUILD_DATE"]

        logger.debug(f"APP_NAME: {APP_NAME}")
        logger.debug(f"APP_VERSION: {APP_VERSION}")
        logger.debug(f"COMMIT_SHA: {COMMIT_SHA}")
        logger.debug(f"BRANCH: {BRANCH}")
        logger.debug(f"BUILD_DATE: {BUILD_DATE}")

    except KeyError as e:
        logger.error(f"Missing environment variable: {e}")
        # Set default values if environment variables are missing
        APP_NAME = os.environ.get("APP_NAME", "unknown")
        APP_VERSION = os.environ.get("APP_VERSION", "unknown")
        COMMIT_SHA = os.environ.get("COMMIT_SHA", "unknown")
        BRANCH = os.environ.get("BRANCH", "unknown")
        BUILD_DATE = os.environ.get("BUILD_DATE", "unknown")

    try:
        # Log the incoming event
        logger.info(f"Event received: {json.dumps(event)}")

        # Extract name from event if available, otherwise use default
        name = event.get("name", "World") if event else "World"

        function_name = "unknown"
        if context and hasattr(context, "function_name"):
            function_name = context.function_name

        function_version = "unknown"
        if context and hasattr(context, "function_version"):
            function_version = context.function_version

        # Create response with proper structure
        response = {
            "statusCode": 200,
            "body": {
                "message": f"Hello, {name}!",
                "metadata": {
                    "function_name": function_name,
                    "function_version": function_version,
                    "app_name": APP_NAME,
                    "app_version": APP_VERSION,
                    "commit_sha": COMMIT_SHA,
                    "branch": BRANCH,
                    "build_date": BUILD_DATE,
                },
            },
        }

        logger.info(f"Response: {json.dumps(response)}")
        return response

    except Exception as e:
        logger.error(f"Error: {str(e)}")
        return {
            "statusCode": 500,
            "body": {"error": "Internal server error", "message": str(e)},
        }


if __name__ == "__main__":
    handler(None, None)
