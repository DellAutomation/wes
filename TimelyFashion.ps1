# Author : Wesley Dev Andrew
# Code Name : TimelyFashion
# Version : 1.0
# Purpose : A desktop application to relieve user from the task of calculating efforts spent on different projects, so that they can focus on things that actually matter.

# Methodology/Logic : User would create separate virtual desktops for each project as per their convenience.
# Methodology/Logic : The program is scheduled using windows scheduler to start everyday automatically before user's workday timings.
# Methodology/Logic : Once started, it runs in background and for every 30 seconds the program takes note of the active virtual Desktop and application that's in the foreground. It then writes this information along with timestamp into a log file.
# Methodology/Logic : At the specified end time, the program comes out of the loop and processes the log file and calculates total time per app and virtual desktop and save in a csv file. Then it proceeds to create a visualization in MS Excel.

# Requirement1 : MS Powershell
# Requirement2 : Output of the command "Get-ExecutionPolicy" should not be "Restricted" in Powershell. If restricted, check for your local process to get enabled.
# Requirement3 : Windows 10 or 11 where "Multiple Desktops" feature is enabled. Please refer Microsoft article for more information on how to use multiple desktops. https://support.microsoft.com/en-us/windows/configure-multiple-desktops-in-windows-36f52e38-5b4a-557b-2ff9-e1a60c976434

# Fixed issue1 : This program now takes into account idle time so that any idle time beyond 60 seconds is ignored (Hence total of calculated utilization duration may be less than the program runtime duration).

# Limitation1 : Only MS Windows for now because of powershell.  
# Limitation2 : Not of this tool but some applications like PDF readers dont work well with multiple virtual desktops. With some workarounds, it is possible to create separate windows of same application in multiple desktops. We shall add a tips section later to documentation.

# Planned Improvement1 : Need to scale the program to prepare weekly and monthly reports.
# Planned Improvement2 : Replace some hardcoded values like endtime, outputpath with variables that can be recieved as input parameters during next phase of Testing and optimization
# Planned Improvement3 : More user friendly documentation.
# Planned Improvement4 : Better graph in Excel
# Planned Improvement5 : Need to automate Multiple Desktop Initialization wizard to assist new users.
# Planned Improvement6 : Need to migrate to platform independant coding to accommodate other operating systems like MacOS and Linux.
# Planned Improvement7 : Try to provide a Heads-Up Display on live status of work hours spent to help plan remaining time of day accordingly or to better accomplish time goals.

# Feedbacks : Please feel free to send in your valuable feedbacks to wesley.andrew@dell.com


# Ensure the VirtualDesktop module is available
Import-Module VirtualDesktop

# Define output paths
$outputDir = "$PSScriptRoot"
$logPath = Join-Path $outputDir "DesktopLog.txt"
$csvPath = Join-Path $outputDir "DesktopUsageSummary.csv"

# Create output directory if it doesn't exist
if (-not (Test-Path $outputDir)) {
    New-Item -ItemType Directory -Path $outputDir -Force | Out-Null
}

# Add Win32 API definitions for foreground window
Add-Type @"
using System;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Text;

public class Win32 {
    [DllImport("user32.dll")]
    public static extern IntPtr GetForegroundWindow();

    [DllImport("user32.dll")]
    public static extern int GetWindowThreadProcessId(IntPtr hWnd, out int lpdwProcessId);

    [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
    public static extern int GetWindowText(IntPtr hWnd, StringBuilder lpString, int nMaxCount);

    [DllImport("user32.dll", SetLastError = true)]
    public static extern int GetWindowTextLength(IntPtr hWnd);
}
"@

# Add Win32 API definitions for idle time detection
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class IdleTime {
    [StructLayout(LayoutKind.Sequential)]
    public struct LASTINPUTINFO {
        public uint cbSize;
        public uint dwTime;
    }

    [DllImport("user32.dll")]
    public static extern bool GetLastInputInfo(ref LASTINPUTINFO plii);

    public static uint GetIdleTime() {
        LASTINPUTINFO lii = new LASTINPUTINFO();
        lii.cbSize = (uint)Marshal.SizeOf(lii);
        GetLastInputInfo(ref lii);
        return ((uint)Environment.TickCount - lii.dwTime);
    }
}
"@

function Get-IdleTimeSeconds {
    return [IdleTime]::GetIdleTime() / 1000
}

# Function to get foreground window info
function Get-ForegroundWindowInfo {
    $hwnd = [Win32]::GetForegroundWindow()
    if ($hwnd -eq [IntPtr]::Zero) {
        return $null
    }

    [int]$procId = 0
    [Win32]::GetWindowThreadProcessId($hwnd, [ref]$procId)

    $length = [Win32]::GetWindowTextLength($hwnd)
    $title = ""
    if ($length -gt 0) {
        $sb = New-Object System.Text.StringBuilder ($length + 1)
        [Win32]::GetWindowText($hwnd, $sb, $sb.Capacity) | Out-Null
        $title = $sb.ToString()
    }

    $process = Get-Process -Id $procId -ErrorAction SilentlyContinue
    $processName = if ($process) { $process.ProcessName } else { "Unknown" }

    return [PSCustomObject]@{
        ProcessName = $processName
        WindowTitle = $title
    }
}

# Start logging
$endTime = (Get-Date).AddHours(5)
while ((Get-Date) -lt $endTime) {
    $idleSeconds = Get-IdleTimeSeconds
    if ($idleSeconds -lt 60) {
        $desktop = (Get-DesktopList | Where-Object { $_.Visible -eq $true }).Name
        $info = Get-ForegroundWindowInfo
        if ($info) {
            $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
            "{0} - Current Desktop: {1}:{2}:{3}" -f $timestamp, $desktop, $info.ProcessName, $info.WindowTitle | Out-File -FilePath $logPath -Append -Encoding UTF8
        }
    }
    Start-Sleep -Seconds 30
}

# Parse log and generate CSV
$entries = @()
Get-Content $logPath | ForEach-Object {
    if ($_ -match "^(?<ts>\d{4}-\d{2}-\d{2} \d{2}:\d{2}:\d{2}) - Current Desktop: (?<desktop>[^:]+):(?<app>[^:]*):(?<title>.*)$") {
        $entries += [PSCustomObject]@{
            Timestamp = [datetime]$matches['ts']
            Desktop = $matches['desktop']
            App = $matches['app']
            Title = $matches['title']
        }
    }
}

$grouped = $entries | Sort-Object Timestamp | ForEach-Object -Begin {
    $prev = $null
    $durations = @{}
} -Process {
    if ($prev) {
        $key = "$($prev.Desktop)|$($prev.App)|$($prev.Title)"
        $delta = ($_.Timestamp - $prev.Timestamp).TotalSeconds
        if ($durations.ContainsKey($key)) {
            $durations[$key] += [int]$delta
        } else {
            $durations[$key] = [int]$delta
        }
    }
    $prev = $_
} -End {
    $durations.GetEnumerator() | ForEach-Object {
        $parts = $_.Key -split '\|', 3
        [PSCustomObject]@{
            'Desktop Name' = $parts[0]
            'Application Name' = $parts[1]
            'Titlebar Text' = $parts[2]
            'Duration (seconds)' = $_.Value
            'Duration (minutes)' = [math]::Round($_.Value / 60, 2)
            'Duration (hours)' = [math]::Round($_.Value / 3600, 2)
        }
    } | Export-Csv -Path $csvPath -NoTypeInformation -Encoding UTF8
}

# Create Excel chart
$excel = New-Object -ComObject Excel.Application
$excel.Visible = $false
$workbook = $excel.Workbooks.Open($csvPath)
$worksheet = $workbook.Sheets.Item(1)

$chartSheet = $workbook.Charts.Add()
$chartSheet.ChartType = 51  # xlColumnClustered
$chartSheet.SetSourceData($worksheet.Range("B2:B100"))  # Adjust range as needed
$chartSheet.HasTitle = $true
$chartSheet.ChartTitle.Text = "Total Usage per Application"

$excelPath = Join-Path $outputDir "DesktopUsageSummary_Visualized.xlsx"
$workbook.SaveAs($excelPath, 51)  # 51 = xlOpenXMLWorkbook (.xlsx)
$workbook.Close($true)
$excel.Quit()
[System.Runtime.Interopservices.Marshal]::ReleaseComObject($excel) | Out-Null
