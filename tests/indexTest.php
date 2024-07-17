<?php

require_once __DIR__ . '/../src/index.php';

class indexTest extends PHPUnit\Framework\TestCase
{
    public function testOutput()
    {
        // Capture the output of index.php
        ob_start();
        include __DIR__ . '/../src/index.php';
        $output = ob_get_clean();
        
        // Print the output with the desired string
        echo "output string is " . $output;

        // Assert that the output is "I am a simple PHP web application running on apache 8.2 through docker compose"
        $this->assertEquals("I am a simple PHP web application running on apache 8.2 through docker compose", $output);
    }
}
?>
