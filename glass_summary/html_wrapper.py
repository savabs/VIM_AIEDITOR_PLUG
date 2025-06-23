HTML_WRAPPER = """\
<html>
    <head>
        <meta charset="utf-8">
        <style>
            body {{
                margin: 0;
                padding: 1em 2em;
                background: rgba(255, 255, 255, 0.08);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                color: #eaeaea;
                font-family: 'Segoe UI', 'Fira Sans', 'Helvetica Neue', Arial, sans-serif;
                line-height: 1.6;
                font-size: 16px;
            }}

            h1 {{
                font-size: 1.8em;
                margin: 0.8em 0 0.4em;
                color: #00bfff;
                font-weight: bold;
            }}

            h2 {{
                font-size: 1.4em;
                margin: 0.7em 0 0.4em;
                color: #1e90ff;
                font-weight: bold;
            }}

            p {{
                margin: 0.5em 0;
                color: #f0f0f0;
            }}

            pre {{
                background: #1e1e1e;
                color: #dcdcdc;
                padding: 1em;
                border-radius: 8px;
                font-family: 'Fira Code', 'Menlo', 'Courier New', monospace;
                font-size: 14px;
                overflow-x: auto;
                line-height: 1.5;
                border: 1px solid rgba(255,255,255,0.1);
            }}

            code {{
                background: rgba(50, 50, 50, 0.7);
                color: #ffae57;
                font-family: 'Fira Code', 'Menlo', 'Courier New', monospace;
                padding: 0.2em 0.4em;
                border-radius: 4px;
                font-size: 0.95em;
            }}

            strong {{
                font-weight: bold;
                color: #ff6666;
            }}

            a {{
                color: #61dafb;
                text-decoration: none;
            }}

            a:hover {{
                text-decoration: underline;
            }}
        </style>
    </head>
    <body>
        {content}
    </body>
</html>
"""
