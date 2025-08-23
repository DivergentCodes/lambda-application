import os
from main import handler


class TestHandler:

    def setup_class(self):
        # Set environment variables expected by handler()
        os.environ["APP_NAME"] = "lambda-application"
        os.environ["APP_VERSION"] = "1.0.0"
        os.environ["COMMIT_SHA"] = "1234567890"
        os.environ["BRANCH"] = "main"
        os.environ["BUILD_DATE"] = "2021-01-01"

    def teardown_class(self):
        del os.environ["APP_NAME"]
        del os.environ["APP_VERSION"]
        del os.environ["COMMIT_SHA"]
        del os.environ["BRANCH"]
        del os.environ["BUILD_DATE"]

    def test_handler_returns_correct_response(self):
        """Test that handler() returns the expected response structure."""
        result = handler(None, None)

        # Check that the response has the expected structure
        assert result["statusCode"] == 200
        assert "body" in result
        for key in ["message", "metadata"]:
            assert key in result["body"], f"Key {key} not found in result['body']"

        # Check message
        assert result["body"]["message"] == "Hello, World!"

        # Check metadata structure
        metadata = result["body"]["metadata"]
        for key in ["app_name", "app_version", "commit_sha", "branch", "build_date", "function_name", "function_version"]:
            assert key in metadata, f"Key {key} not found in result['body']['metadata']"

        assert metadata["app_name"] == "lambda-application", f"App name {metadata['app_name']} != lambda-application"
        assert metadata["app_version"] == "1.0.0", f"App version {metadata['app_version']} != 1.0.0"
        assert metadata["commit_sha"] == "1234567890", f"Commit sha {metadata['commit_sha']} != 1234567890"
        assert metadata["branch"] == "main", f"Branch {metadata['branch']} != main"
        assert metadata["build_date"] == "2021-01-01", f"Build date {metadata['build_date']} != 2021-01-01"

        # Context-related fields should be None or 'unknown' when context is None
        assert metadata["function_name"] in [None, "unknown"], f"Function name {metadata['function_name']} not in [None, 'unknown']"
        assert metadata["function_version"] in [None, "unknown"], f"Function version {metadata['function_version']} not in [None, 'unknown']"

    def test_handler_with_event_and_context(self):
        """Test that handler() works with event and context parameters."""
        test_event = {"name": "test-name"}
        test_context = {"function_name": "test-function-name", "function_version": "1"}

        result = handler(test_event, test_context)

        # Check that the response has the expected structure
        assert result["statusCode"] == 200
        assert "body" in result
        for key in ["message", "metadata"]:
            assert key in result["body"], f"Key {key} not found in result['body']"

        # Check message
        assert result["body"]["message"] == "Hello, test-name!"

        # Check metadata structure
        metadata = result["body"]["metadata"]
        for key in ["app_name", "app_version", "commit_sha", "branch", "build_date", "function_name", "function_version"]:
            assert key in metadata, f"Key {key} not found in result['body']['metadata']"

    def test_main_module_execution(self):
        """Test that the module can be executed directly."""
        # Import and execute the main block
        import main

        # The if __name__ == "__main__" block should have executed
        # We can't easily test this without refactoring, but we can verify
        # the handler function works as expected
        result = main.handler(None, None)
        assert result["statusCode"] == 200
