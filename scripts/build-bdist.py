import os
import shutil
import subprocess
import sys
from itertools import chain
from pathlib import Path

PROJECT_DIR = Path(__file__).parent.parent
PROJECTION_PATH = (PROJECT_DIR / "projection").resolve()
WEBVIEW2_PATH = (PROJECT_DIR / "_tools/Microsoft.Web.WebView2").resolve()
MICROSOFT_UI_XAML_PATH = (PROJECT_DIR / "_tools/Microsoft.UI.Xaml").resolve()
WINDOWS_APP_SDK_PATH = (PROJECT_DIR / "_tools/Microsoft.WindowsAppSDK").resolve()

os.environ["WEBVIEW2_PATH"] = os.fspath(WEBVIEW2_PATH)
os.environ["MICROSOFT_UI_XAML_PATH"] = os.fspath(MICROSOFT_UI_XAML_PATH)
os.environ["WINDOWS_APP_SDK_PATH"] = os.fspath(WINDOWS_APP_SDK_PATH)

winml_packages = [
    PROJECTION_PATH / "winrt-runtime",
    PROJECTION_PATH / "winrt" / "winrt-Windows.Foundation",
    PROJECTION_PATH / "winrt" / "winrt-Windows.Foundation.Collections",
    PROJECTION_PATH / "winui3" / "winui3-Microsoft.Windows.AI.MachineLearning",
    PROJECTION_PATH / "interop" / "winui3-Microsoft.Windows.ApplicationModel.DynamicDependency.Bootstrap"
]

# for package_path in chain(
#     [PROJECTION_PATH / "winrt-runtime"],
#     (PROJECTION_PATH / "interop").glob("winrt-*"),
#     (PROJECTION_PATH / "interop").glob("winui3-*"),
#     (PROJECTION_PATH / "webview2").glob("webview2-*"),
#     (PROJECTION_PATH / "winui2").glob("winui2-*"),
#     (PROJECTION_PATH / "winui3").glob("winui3-*"),
#     (PROJECTION_PATH / "winrt").glob("winrt-*"),
# ):
for package_path in winml_packages:
    subprocess.check_call(
        [
            "cibuildwheel",
            os.fspath(package_path),
        ]
        + (sys.argv[1:] or ["--platform", "windows"])
    )

    # Build directories are 10s of MBs and will cause CI to run out of space!
    shutil.rmtree(package_path / "build")
