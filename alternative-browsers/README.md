# Tool to launch URLs in alternative browsers based on matching patterns

## Use cases

* Some applications require settings, e.g., cookies, which I only have in one browser.
* Some applications are optimized for a certain browser.
* Some applications do not work in a certain browser.
* Some URLs are better handled by entirely different applications, even if they are not browsers.

## How to use

1. adjust paths in `alternative-browsers.reg` and `alternative-browsers.bat`
1. make sure you have Python with [PyYAML](https://pyyaml.org/) installed and registered to open `*.py` files, or otherwise modify `alternative-browsers.bat` to explicitly invoke Python
1. import `alternative-browsers.reg` into your registry to make this tool known to Windows as a browser
1. make it your default browser, either manually via "Default Apps", or using a tool such as [SetDefaultBrowser](https://kolbi.cz/blog/2017/11/10/setdefaultbrowser-set-the-default-browser-per-user-on-windows-10-and-server-2016-build-1607/)
1. copy `alternative-browsers.yaml` to `~/.config/alternative-browsers` and adjust to your needs
1. open URLs
