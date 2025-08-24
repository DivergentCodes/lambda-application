"""
Integration tests for the lambda-application.

These tests verify the application works end-to-end in a local environment.
"""
import requests

INVOKE_URL = "http://localhost:9000/2015-03-31/functions/function/invocations"

class TestHandlerFunction:
    """Test the complete integration workflow."""

    def test_handler_function_returns_expected_message(self):
        """Test the handler function works as expected in integration context."""

        response = requests.post(INVOKE_URL, json={"foo": "bar"}, timeout=10)

        assert response.status_code == 200, f"Request failed with status {response.status_code}: {response.text}"

        # Parse the JSON response
        result = response.json()

        # Verify response structure
        assert isinstance(result, dict), "Handler should return a dictionary"
        assert "statusCode" in result, "Response should contain statusCode"
        assert "body" in result, "Response should contain body"

        # Check status code
        assert result["statusCode"] == 200, f"Status code should be 200, got {result['statusCode']}"

        # Check body structure
        body = result["body"]
        assert isinstance(body, dict), "Body should be a dictionary"
        assert "message" in body, "Body should contain message"
        assert "metadata" in body, "Body should contain metadata"

        # Check message content
        assert body["message"] == "Hello, World!", f"Message should be 'Hello, World!', got '{body['message']}'"

        # Check metadata structure
        metadata = body["metadata"]
        expected_metadata_keys = ["app_name", "app_version", "branch", "build_date"]
        for key in expected_metadata_keys:
            assert key in metadata, f"Metadata should contain {key}"
            assert metadata[key] is not None, f"Metadata {key} should not be None"
