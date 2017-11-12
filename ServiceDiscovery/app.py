# compose_flask/app.py
from flask import Flask, abort
from flask import request
from flask import Response

import json

import sys

app = Flask(__name__)

db = {'endpoints' : []}


@app.route('/', methods=['GET'])
def list():
    return json.dumps (db)



@app.route('/service/<service>/instance/<instance>', methods=[ 'PUT', 'POST', 'DELETE'])
def entries_for_instance(service, instance):
  print (service, file=sys.stderr)
  print (instance, file=sys.stderr)
  print (request, file=sys.stderr)
  print (request.json, file=sys.stderr)
  try:
    verb = request.method
  except:
    abort_503

  handler = entry_handler(verb)
  return handler(service, instance, request)

def entry_handler(verb):
  handler = { 'GET' : get_entries_for_instance
            , 'PUT' : put_entries
            , 'POST' : put_entries
            , 'DELETE' : delete_entries
            }.get(verb, abort_503)
  return handler


@app.route('/service/<service>', methods=['GET'])
def entries_for_service(service):
  print (service, file=sys.stderr)
  print (request, file=sys.stderr)
  print (request.json, file=sys.stderr)

  return get_entries_for_service(instance, request)

def get_entries_for_service(service, req):
    endpoints = [entry for entry in db['endpoints'] if (entry['service'] == service)]
    db2 = db
    db2['endpoints'] = endpoints
    return json.dumps (db2)

def get_entries_for_instance(service, instance, req):
    endpoints = [entry for entry in db['endpoints'] if (entry['instance'] == instance) and (entry['service'] == service)]
    db2 = db
    db2['endpoints'] = endpoints
    return json.dumps (db2)

def put_entries(service, instance, req):

    try:
      structure = req.json
    except:
      print (req, file=sys.stderr)
      abort(423)

    endpoints = db['endpoints']

    clr_endpoints = [endpoint for endpoint in endpoints if (endpoint['instance'] != instance)]
    new_endpoints = make_endpoints(service, instance, structure)
    new_endpoints.extend(clr_endpoints)

    print ("endpoints", file=sys.stderr)
    print (endpoints, file=sys.stderr)
    print ("cleared endpoints", file=sys.stderr)
    print (clr_endpoints, file=sys.stderr)
    print ("new_endpoints", file=sys.stderr)
    print (new_endpoints, file=sys.stderr)

    db['endpoints'] = new_endpoints

    print ("db", file=sys.stderr)
    print (db, file=sys.stderr)

    return json.dumps (db)

def delete_entries(service, instance, req):
    endpoints = [entry for entry in db['endpoints'] if (entry['instance'] != instance)]
    db['endpoints'] = endpoints
    return json.dumps (db2)

def abort_503(instance, req):
  abort(503)

# {'ip': '10.36.0.36'
# , 'version': '0.0.1'
# , 'hostname': 'permissions-3104710343-qdsw0'
# , 'endpoints': [{'method': '/', 'path': 'GET'}]
# }

def make_endpoints(service_name, instance, json):
    try:
      endpoints_ = json['endpoints']
      host = json['hostname']
      ip_address = json['ip']
      service_version = json['version']
      service = {'name': service_name, 'version': service_version}
      endpoints = [make_endpoint(instance, host, ip_address, service, endpoint) for endpoint in endpoints_]
      return endpoints
    except :
      abort(422)


def make_endpoint(instance, host, ip_address, service, endpoint):
  return {'instance': instance, 'host': host, 'ip': ip_address, 'service' : service, 'method': endpoint['method'], 'path':endpoint['path']}

def validate(structure):

  keys = ['host', 'endpoints']
  main_ok = all([(key in structure) for key in keys])

  if ('endpoints' in structure):
    endpoints_ok = all([validate_endpoint (endpoint) for endpoint in structure['endpoints']])
  else:
    endpoints_ok = False

  return (main_ok and endpoints_ok)


def validate_endpoint(structure):
  return ('endpoint' in structure) and ('method' in structure)


@app.route('/health', methods=['GET', 'POST'])
def health():
  r = Response(response="UP", status=200, mimetype="application/xml")
  r.headers["Content-Type"] = "text/xml; charset=utf-8"
  return r


if __name__ == "__main__":
    db = { 'endpoints' : [] }
    app.run(host="0.0.0.0", debug=True)
