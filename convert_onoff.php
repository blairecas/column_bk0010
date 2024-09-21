<?php
    $img = imagecreatefrompng('./graphics/onoff.png');
    $width = imagesx($img);
    $height = imagesy($img);
    echo "Image: $width x $height\n";
    $bytes_dx = intval($width / 4);	// BK byte is 4pix in color mode
    
    // tiles array
    $bgrArray = Array();
    
    // scan image and create array
    for ($y=0; $y<$height; $y++)
    {
        for ($bytex=0; $bytex<$bytes_dx; $bytex++)
        {
            $res = 0; 
            for ($x=0; $x<4; $x++)
            {
                $py = $y;
                $px = $bytex*4 + $x;
                $res = ($res >> 2) & 0xFF;
                $rgb_index = imagecolorat($img, $px, $py);
                $rgba = imagecolorsforindex($img, $rgb_index);
                $r = $rgba['red'];
                $g = $rgba['green'];
                $b = $rgba['blue'];
		// blue pixel
		if ($b > 127 && $r < 127 && $g < 127) $res = $res | 0b01000000;
		// green pixel
		if ($b > 127 && $r < 127 && $g > 127) $res = $res | 0b10000000;
		if ($b > 127 && $r > 127 && $g > 127) $res = $res | 0b10000000;
		// red pixel
		if ($b < 127 && $r > 127 && $g < 127) $res = $res | 0b11000000;
            }
            array_push($bgrArray, $res);
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////
    
    $f = fopen("inc_onoff.mac", "w");
    fputs($f, "SprOnOff:\n");
    $n = 0;
    for ($i=0; $i<count($bgrArray); $i++)
    {
	if ($i==90) fputs($f, "SprOffOn:\n");
	if ($n==0) fputs($f, "\t.byte\t");
        $b = $bgrArray[$i] &0xFF;
        fputs($f, decoct($b)); if ($n<8) { fputs($f, ", "); $n++; } else { fputs($f, "\n"); $n=0; }
    }
    fclose($f);
