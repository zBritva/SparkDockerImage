# https://dumps.wikimedia.org/other/pagecounts-raw/

$base_url = "https://dumps.wikimedia.org/other/pagecounts-raw/"

$start_date = [DateTime]"12/09/2007 06:00:00 PM";


#$end_date = [DateTime]"08/05/2016 12:00:00 AM";
$end_date = [DateTime]"12/10/2007 06:00:00 PM";
#UNCOMMENT THIS LINE TO DOWNLOAD FULL DATASET

$current_date = $start_date;

while ($current_date -le $end_date) {

    $current_date = $current_date.AddHours(1);
    $index = 0;
    while ($index -le 2) {
        try {
            $url = ($base_url + $current_date.ToString("yyyy/yyyy-MM/") + "pagecounts-" +$current_date.ToString("yyyyMMdd-HH") + "000$index.gz")
            

            #TODO skip file if downloaded
            if (-Not (Test-Path ("pagecounts-" +$current_date.ToString("yyyyMMdd-HH") + "000$index.gz")) ) {
                echo ("$url downloading...")
                $response = Invoke-WebRequest -Uri $url -OutFile ("pagecounts-" +$current_date.ToString("yyyyMMdd-HH") + "000$index.gz")
            }
            else {
                echo "$url skipped"
            }
            $index = $index + 1;
        }
        Catch [system.exception] {
            if ($_.Exception.Message -eq "The remote server returned an error: (404) Not Found." ) {
                $index = $index + 1;
                continue;
            }
            echo system.exception;
            echo $_.Exception.Message $url
        }
    }
    $current_year = $current_year + 1;

}