def fraction(a, b):
    """ This function referenced from the following link
        http://vimcasts.org/episodes/ultisnips-python-interpolation/
    """
    try:
        return "%.1f" % (float(a)/float(b))
    except (ValueError, ZeroDivisionError):
        return "ERR"
