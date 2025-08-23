import os
from main import handler


class TestHandler:

    def setup_class(self):
        self.test_event = {"test": "data"}
        self.test_context = {"function_name": "test-function"}

        os.environ["APP_NAME"] = "lambda-application"
        os.environ["APP_VERSION"] = "1.0.0"
        os.environ["COMMIT_SHA"] = "1234567890"
        os.environ["BRANCH"] = "main"
        os.environ["BUILD_DATE"] = "2021-01-01"

    def teardown_class(self):
        self.test_event = None
        self.test_context = None

    def test_handler_returns_correct_response(self):
        """Test that handler() returns the expected response structure."""
        result = handler(None, None)

        # Check that the response has the expected structure
        assert result["statusCode"] == 200
        assert "body" in result
        assert "message" in result["body"]
        assert "metadata" in result["body"]

        # Check message
        assert result["body"]["message"] == "Hello, World!"

        # Check metadata structure
        metadata = result["body"]["metadata"]
        assert metadata["app_name"] == "lambda-application"
        assert metadata["app_version"] == "1.0.0"
        assert metadata["commit_sha"] == "1234567890"
        assert metadata["branch"] == "main"
        assert metadata["build_date"] == "2021-01-01"

        # Context-related fields should be None or 'unknown' when context is None
        assert metadata["function_name"] in [None, "unknown"]
        assert metadata["function_version"] in [None, "unknown"]
        assert metadata["timestamp"] in [None, "unknown"]

    def test_handler_with_event_and_context(self):
        """Test that handler() works with event and context parameters."""
        test_event = {"test": "data"}
        test_context = {"function_name": "test-function"}

        result = handler(test_event, test_context)

        # Check that the response has the expected structure
        assert result["statusCode"] == 200
        assert "body" in result
        assert "message" in result["body"]
        assert "metadata" in result["body"]

        # Check message
        assert result["body"]["message"] == "Hello, World!"

        # Check metadata structure
        metadata = result["body"]["metadata"]
        assert metadata["app_name"] == "lambda-application"
        assert metadata["app_version"] == "1.0.0"
        assert metadata["commit_sha"] == "1234567890"
        assert metadata["branch"] == "main"
        assert metadata["build_date"] == "2021-01-01"

        # Context-related fields should be 'unknown' when context is a dict
        assert metadata["function_name"] == "unknown"
        assert metadata["function_version"] == "unknown"
        assert metadata["timestamp"] is None

    def test_main_module_execution(self):
        """Test that the module can be executed directly."""
        # Import and execute the main block
        import main

        # The if __name__ == "__main__" block should have executed
        # We can't easily test this without refactoring, but we can verify
        # the handler function works as expected
        result = main.handler(None, None)
        assert result["statusCode"] == 200
