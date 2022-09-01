<?php
$full_path = realpath($argv[1]);

if (!$full_path) {
	file_put_contents('php://stderr', "Invalid script directory!\n");
	exit(2);
}

echo "# Created by crontab_builder \n";
echo "# Scripts should use first line to provide cron schedule.\n";
foreach (array_diff(scandir($full_path), ['.', '..']) as $script) {
	$schedule = null;

	if (substr($script, 0, 1) === '.') {
		// Starts with a dot, it's a hidden file
		continue;
	}
	
	// try to find cron schedule in the first line
	if ($handle = fopen($full_path . '/' . $script, 'r')) {
		$header = fread($handle, 4096);
		fclose($handle);

		$lines = explode("\n", $header);
		$lines = array_filter(array_map('trim', $lines));

		// Exclude <?php and "#!/bin/bash" line
		$lines = array_filter($lines, function($value) {
			if (strtolower($value) === '<?php') {
				return false;
			}

			if (mb_substr($value, 0, 2) === '#!') {
				return false;
			}

			return true;
		});

		// Reset keys after filtering
		$lines = array_values($lines);

		if (count($lines)) {
			// https://stackoverflow.com/a/57639657
			if (preg_match('/\#{1}\s?((?:[\*\d](?:\/\d{1,2}){0,1}\s){4}[\*\d])/', $lines[0], $matches)) {
				echo "Matched: " . $matches[0] . PHP_EOL;
				$schedule = $matches[1];
			}
		}
	}

	if (!$schedule) {
		// default to once an hour at random minute
		$schedule = rand(0, 59) . ' * * * *';
	}

	$name_parts = explode('.', $script);
	$binary = end($name_parts);
	$name = reset($name_parts);

	printf("%s %s %s/%s > /tmp/cron_scripts/%s.log 2>&1 \n", $schedule, $binary, $full_path, $script, $name);
}

// Crontab requires new line at end of file
echo "\n";