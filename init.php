<?php /** @noinspection ForgottenDebugOutputInspection */

function pr(string $s) {
    print_r($s);
    echo("\n");
}

pr('init: start');

$domains = glob('/var/www/*', GLOB_ONLYDIR);
$domains = array_map(static fn(string $s) => basename($s), $domains);

shell_exec('/usr/bin/rm -rf /etc/nginx/sites-enabled/*');

pr('Domains:');
foreach ($domains as $domain) {
    $s = file_get_contents(__DIR__ . '/templates/nginx-domain.conf');
    $s = str_replace('{domain}', $domain, $s);

    file_put_contents(sprintf('/etc/nginx/sites-enabled/%s.conf', $domain), $s);

    pr(sprintf("  %s", $domain));
}

pr('init: finish');
