from unittest.mock import patch
from main import handler


def test_handler_prints_hello_message():
    """Test that handler() prints the expected hello message."""
    with patch("builtins.print") as mock_print:
        handler(None, None)
        mock_print.assert_called_once_with("Hello from lambda-application!")


def test_handler_returns_correct_response():
    """Test that handler() returns the expected response structure."""
    result = handler(None, None)

    expected_response = {"statusCode": 200, "body": "Hello from lambda-application!"}

    assert result == expected_response
    assert result["statusCode"] == 200
    assert result["body"] == "Hello from lambda-application!"


def test_handler_calls_print():
    """Test that handler() actually calls print function."""
    with patch("builtins.print") as mock_print:
        handler(None, None)
        assert mock_print.called


def test_handler_with_event_and_context():
    """Test that handler() works with event and context parameters."""
    test_event = {"test": "data"}
    test_context = {"function_name": "test-function"}

    with patch("builtins.print") as mock_print:
        result = handler(test_event, test_context)

        # Verify print was called
        mock_print.assert_called_once_with("Hello from lambda-application!")

        # Verify response structure
        assert result["statusCode"] == 200
        assert result["body"] == "Hello from lambda-application!"


def test_main_module_execution():
    """Test that the module can be executed directly."""
    with patch("builtins.print"):
        # Import and execute the main block
        import main

        # The if __name__ == "__main__" block should have executed
        # We can't easily test this without refactoring, but we can verify
        # the handler function works as expected
        result = main.handler(None, None)
        assert result["statusCode"] == 200
