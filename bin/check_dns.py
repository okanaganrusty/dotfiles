#!/usr/bin/env python3

import dns
import dns.resolver
import dns.rdatatype

import argparse

parser = argparse.ArgumentParser()
parser.add_argument(
    '--verbose',
    action='store_true',
    required=False,
    default=False)

parser.add_argument(
    '--resolver',
    help='Change the resolver if you want to use a different one (default is OpenDNS)',
    action='store',
    required=False,
    default='208.67.220.220')

parser.add_argument(
    '--follow-result',
    help='Follows the DNS result making sure all referenced DNS RRs exist',
    action='store_true',
    required=False,
    default=True)

parser.add_argument(
    '--validate-ssl-certificates',
    help='Validates SSL/TLS certificates by verifying all DNS names exist in the X.509 common name or subject alternative names',
    action='store_true',
    required=False,
    default=False)

record_type = parser.add_mutually_exclusive_group()
record_type.add_argument('--naptr-record', action='store', required=False)
record_type.add_argument('--srv-record', action='store', required=False)
record_type.add_argument('--anchor-record', action='store', required=False)

args = parser.parse_args()

resolver = dns.resolver.Resolver(configure=False)
resolver.nameservers = (args.resolver, )

try:
    naptr_recursive_result = False
    naptr_entries = []
    
    srv_recursive_result = False
    srv_entries = []
    
    anchor_recursive_result = False
    anchor_entries = []
    
    if args.naptr_record:
        # flags, order, preference, regexp, replacement, service = rr
        if args.verbose:
            print("Querying for NAPTR record ({text})".format(text=args.naptr_record))
        
        answer = resolver.query(args.naptr_record, 'NAPTR')
        
        for rr in answer:
            naptr_entries.append((args.naptr_record, rr))
            
        naptr_recursive_result = True

    if args.verbose:
        print("NAPTR RR length ({rr_length})".format(rr_length=len(naptr_entries)))
    
    if args.srv_record or (args.follow_result and naptr_recursive_result):
        entries = []

        if args.srv_record:
            entries.append(args.srv_record)
            
        if args.follow_result and naptr_recursive_result:
            entries = entries + [naptr_record.replacement for request, naptr_record in naptr_entries]
            
        for entry in entries:
            if args.verbose:
                print("Querying for SRV record ({text})".format(text=entry.to_text()))
            
            answer = resolver.query(entry.to_text(), 'SRV')
            
            for rr in answer:
                srv_entries.append((entry.to_text(), rr))

        srv_recursive_result = True

    if args.verbose:
        print("SRV RR length ({rr_length})".format(rr_length=len(srv_entries)))
    
    if args.anchor_record or (args.follow_result and srv_recursive_result):
        entries = []

        if args.anchor_record:
            entries.append(args.srv_record)
            
        if args.follow_result and srv_recursive_result:
            entries = entries + [srv_record.target for request, srv_record in srv_entries]
            
        for entry in entries:
            if args.verbose:
                print("Querying for A (anchor) record ({text})".format(text=entry.to_text()))
            
            answer = resolver.query(entry.to_text(), 'A')
            
            for rr in answer:
                anchor_entries.append((entry.to_text(), rr))

        anchor_recursive_result = True

    if args.verbose:
        print("A (anchor) RR length ({rr_length})".format(rr_length=len(anchor_entries)))

    for entry in naptr_entries + srv_entries + anchor_entries:
      request, rr = entry

      print("{:16s}: {}".format(dns.rdatatype.to_text(rr.rdtype) + " Question", request))
      print("{:16s}: {}".format(dns.rdatatype.to_text(rr.rdtype) + " Answer", rr.to_text()))
    
except dns.resolver.NXDOMAIN as e:
    print(e)

