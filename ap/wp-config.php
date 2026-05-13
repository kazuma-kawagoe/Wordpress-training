<?php
// データベース設定
define( 'DB_NAME', 'wordpress-database' )
define( 'DB_USER', 'wordpress-user' );
define( 'DB_PASSWORD', 'wordpress-password' );
define( 'DB_HOST', '10.10.10.13' );
define( 'DB_CHARSET', 'utf8' );
define( 'DB_COLLATE', '' );
//
define( 'AUTH_KEY',         'training-auth-key-0001' );
define( 'SECURE_AUTH_KEY',  'training-secure-auth-key-0002' );
define( 'LOGGED_IN_KEY',    'training-logged-in-key-0003' );
define( 'NONCE_KEY',        'training-nonce-key-0004' );
define( 'AUTH_SALT',        'training-auth-salt-0005' );
define( 'SECURE_AUTH_SALT', 'training-secure-auth-salt-0006' );
define( 'LOGGED_IN_SALT',   'training-logged-in-salt-0007' );
define( 'NONCE_SALT',       'training-nonce-salt-0008' );
//
$table_prefix = 'wp_';
//
define( 'WP_DEBUG', false );
//
if ( ! defined( 'ABSPATH' ) ) {
    define( 'ABSPATH', __DIR__ . '/' );
}
//
require_once ABSPATH . 'wp-settings.php';
