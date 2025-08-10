def handler(event, context):
    print("Hello from lambda-application!")

    return {
        "statusCode": 200,
        "body": "Hello from lambda-application!",
    }


if __name__ == "__main__":
    handler(None, None)
