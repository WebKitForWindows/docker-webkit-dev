from string import Template

def templated_file(input, output, options):
    input_file = open(input)
    output_file = open(output, 'w')

    template = Template(input_file.read())
    result = template.substitute(options)

    output_file.write(result)
