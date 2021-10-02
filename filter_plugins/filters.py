def dict2opts(d):
    """
    converts a dictionary to cmdline arguments

    prepends each key with -- and then optionally outputs the value
    """

    opts = []

    for key, value in d.items():
        option = '--{}'.format(key)
        if value:
            option = '{}={}'.format(option, value)
        opts.append(option)

    return " ".join(opts)


class FilterModule(object):
    ''' Ansible core jinja2 filters '''

    def filters(self):
        return {
            'dict2opts': dict2opts,
        }
