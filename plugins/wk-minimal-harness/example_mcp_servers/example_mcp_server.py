from mcp.server.fastmcp import FastMCP

mcp = FastMCP("WkExampleStdio")

@mcp.tool()
def add(a: int, b: int) -> int:
    """Add two integers."""
    return a + b

@mcp.tool()
def echo(message: str) -> str:
    """Echo a string."""
    return message

if __name__ == "__main__":
    mcp.run()
