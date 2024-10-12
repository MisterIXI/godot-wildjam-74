def hex_to_rgba(hex_color):
    hex_color = hex_color.lstrip('#')
    r, g, b = int(hex_color[0:2], 16), int(hex_color[2:4], 16), int(hex_color[4:6], 16)
    a = int(hex_color[6:8], 16) if len(hex_color) == 8 else 255
    return r / 255.0, g / 255.0, b / 255.0, a / 255.0

def process_hex_file(input_file, output_file):
    with open(input_file, 'r') as infile, open(output_file, 'w') as outfile:
        rgba_colors = []
        for line in infile:
            hex_color = line.strip()
            rgba_color = hex_to_rgba(hex_color)
            rgba_colors.append(f"{rgba_color[0]:.3f},{rgba_color[1]:.3f},{rgba_color[2]:.3f},{rgba_color[3]:.3f}")
        outfile.write(','.join(rgba_colors))

if __name__ == "__main__":
    input_file = 'colors.hex'
    output_file = 'colors_rgba.txt'
    process_hex_file(input_file, output_file)