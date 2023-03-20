<?php
/**
 * Plugin Name: Content Warning Shortcode
 * Version: 0.1.0
 * Description: Add content warnings to posts.
 * Author: Ethan Corey for The Appeal Inc.,
 * License: MIT License
 */
namespace TheAppeal\ContentWarningWP;


function content_warning_wp_add_shortcode() {
    add_shortcode( 'apl_content_warning', __NAMESPACE__ . '\content_warning_wp_shortcode' );
}
add_action( 'init', __NAMESPACE__ . '\content_warning_wp_add_shortcode' );


function content_warning_wp_shortcode( $attrs, $content ) {
    $warning_intro = $attrs["warning_intro"] ?? 'Content warning: ';
    $warning_message = $attrs['warning_message'] ?? 'The following section contains content that may be disturbing to some readers.';
    $skip_link = '#skip-' . (string) mt_rand();
    ob_start();
    ?>
    <p class="content-warning"><em><strong><?php echo $warning_intro; ?></strong><?php echo $warning_message; ?> Click </em><a href="<?php echo $skip_link ?>"><em>here</em></a><em> if you would like to skip this section.</em></p>
    <?php echo $content; ?>
    <span id="<?php echo substr( $skip_link, 1 ); ?>"></span>
    <?php
    return ob_get_clean();
}
