def get_command_line_argument
  # ARGV is an array that Ruby defines for us,
  # which contains all the arguments we passed to it
  # when invoking the script from the command line.
  # https://docs.ruby-lang.org/en/2.4.0/ARGF.html
  if ARGV.empty?
    puts "Usage: ruby lookup.rb <domain>"
    exit
  end
  ARGV.first
end

# `domain` contains the domain name we have to look up.
domain = get_command_line_argument

# File.readlines reads a file and returns an
# array of string, where each element is a line
# https://www.rubydoc.info/stdlib/core/IO:readlines
dns_raw = File.readlines("zone")

def parse_dns(dns)
  # parse_dns returns all the dns records in the given array (dns)
  # The records will contain 2 types of records, A and CNAME
  # For A type, we can directly map it to the IP
  # For CNAME type, we can map it to a different domain
  # We will return a dict of records from this function

  # Using a fold_left alternative of ruby
  dns.inject({}) do |accumulator, elem|
    # First clean the whitespace and then split for ','
    dns_split = elem.gsub(/\s+/, "").split(",")

    # Fetch A and CNAME records else ignore
    if dns_split[0] == "A" or dns_split[0] == "CNAME"
      accumulator[dns_split[1]] = dns_split[2]
    end

    # Return accumulator
    accumulator
  end

end


## NOTE: We are taking an assumption that an IP address will
# never be looked up. Only, domain names will be resolved with this function

def resolve(dns_records, lookup_chain, domain)
  # Here, we will recursively check it the given domain is mapped or not
  # If the domain is not mapped, we will return the domain
  # Else recursively resolve the doman

  # Check if the domain is mapped
  if dns_records.key?(domain)
    # If mapped, it will be either A or CNAME record
    # In both the cases, push the result and resolve recursively
    next_domain = dns_records.fetch(domain)
    lookup_chain.append(next_domain)
    resolve(dns_records,lookup_chain,next_domain)
  else
    # If the domain is not mapped
    # It may be an IP address, in that case return the lookup_chain
    # OR the record may not exist, print the error
    if lookup_chain.length() == 1
      ["Error: record not found for " + domain]
    else
      lookup_chain
    end
  end
end

# To complete the assignment, implement `parse_dns` and `resolve`.
# Remember to implement them above this line since in Ruby
# you can invoke a function only after it is defined.
dns_records = parse_dns(dns_raw)
lookup_chain = [domain]
lookup_chain = resolve(dns_records, lookup_chain, domain)
puts lookup_chain.join(" => ")
