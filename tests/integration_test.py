"""
Integration tests for the lambda-application.

These tests verify the application works end-to-end in a local environment.
"""
import requests

INVOKE_URL = "http://localhost:9000/2015-03-31/functions/function/invocations"

class TestIntegration:
    """Test the complete integration workflow."""

    def test_handler_function_integration(self):
        """Test the handler function works as expected in integration context."""

        # Test with None parameters (as used in main block)
        response = requests.post(INVOKE_URL, json={"foo": "bar"})

        # Check if the request was successful
        #assert response.status_code == 200, f"Request failed with status {response.status_code}: {response.text}"

        # Parse the JSON response
        result = response.json()

        # Verify response structure
        assert isinstance(result, dict), "Handler should return a dictionary"
        assert "statusCode" in result, "Response should contain statusCode"
        assert "body" in result, "Response should contain body"
        assert result["statusCode"] == 200, "Status code should be 200"
        assert result["body"] == "Hello from lambda-application!", "Body should match expected message"
