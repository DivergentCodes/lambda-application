from unittest.mock import patch
from main import main


def test_main_prints_hello_message():
    """Test that main() prints the expected hello message."""
    with patch('builtins.print') as mock_print:
        main()
        mock_print.assert_called_once_with("Hello from lambda-application!")


def test_main_returns_none():
    """Test that main() returns None (implicit return)."""
    result = main()
    assert result is None


def test_main_calls_print():
    """Test that main() actually calls print function."""
    with patch('builtins.print') as mock_print:
        main()
        assert mock_print.called
