#!/usr/bin/env python3

import re
import OpenSSL

from OpenSSL import crypto

import ssl, socket
import argparse

parser = argparse.ArgumentParser()

parser.add_argument(
    "--host", action='store', required=True)

parser.add_argument(
    "--port", action='store', required=False, default=443)

args = parser.parse_args()

# Get the server certificate
certificate = ssl.get_server_certificate((args.host, args.port))

# Load the SSL certificate
x509 = crypto.load_certificate(
    crypto.FILETYPE_PEM,
    certificate)

# Get the SSL certificate subject (X509Name)
subject = x509.get_subject()
print("Common Name: {name}".format(name=subject.commonName))

# Collect X.509 Extensions Count
extension_count = x509.get_extension_count()
extensions = { }

# Iterate through all SSL/X.509 extensions
for index in range(0, extension_count):
    extension = x509.get_extension(index)
    extensions[extension.get_short_name().decode('utf-8')] = str(extension)

subject_alternate_name_re = re.compile('DNS:([^,]+)')

# Handle Subject Alternative Names
if 'subjectAltName' in extensions.keys():
    matches = subject_alternate_name_re.findall(
        extensions['subjectAltName'])

    for index, match in enumerate(matches):
        print("Subject Alternative Name ({index}/{total}): {name}".format(
            index=index + 1,
            total=len(matches),
            name=match))

x509info = x509.get_notAfter()

expiry_day = x509info[6:8].decode('utf-8')
expiry_month = x509info[4:6].decode('utf-8')
expiry_year = x509info[:4].decode('utf-8')
expiry_date = str(expiry_year) + "-" + str(expiry_month) + "-" + str(expiry_day)

print("SSL Certificate Expires On: {expiry_date}".format(
    expiry_date=expiry_date
))


