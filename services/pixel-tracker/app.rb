# frozen_string_literal: true

require 'sinatra'
require 'json'
require 'base64'
require 'time'

# Minimal 43-byte transparent 1x1 GIF
TRANSPARENT_GIF_1X1 = Base64.decode64('R0lGODlhAQABAIAAAAAAAP///yH5BAEAAAAALAAAAAABAAEAAAIBRAA7').freeze

set :port, ENV.fetch('PORT', 8080)
set :bind, '0.0.0.0'
set :logging, false # We handle structured JSON logging manually

helpers do
  def client_ip
    request.env['HTTP_X_FORWARDED_FOR']&.split(',')&.first&.strip || request.ip
  end

  def client_country
    # Headers populated by Cloudflare or GCP Load Balancer / Cloud CDN
    request.env['HTTP_CF_IPCOUNTRY'] ||
      request.env['HTTP_X_CLIENT_GEO_COUNTRY'] ||
      request.env['HTTP_X_COUNTRY_CODE'] ||
      'UNKNOWN'
  end
end

get '/healthz' do
  content_type :json
  { status: 'ok', time: Time.now.utc.iso8601 }.to_json
end

get ['/', '/pixel.gif', '/p.gif', '/track'] do
  page = params['p'] || params['page'] || '/'
  ref  = params['ref'] || request.referrer || ''
  ua   = request.user_agent || ''
  ip   = client_ip
  geo  = client_country

  # Structured JSON log for Google Cloud Logging
  log_payload = {
    severity: 'INFO',
    message: "Pageview on #{page}",
    event: 'pageview',
    page: page,
    referrer: ref,
    user_agent: ua,
    country: geo,
    client_ip: ip,
    timestamp: Time.now.utc.iso8601,
    query_params: params
  }

  $stdout.puts log_payload.to_json
  $stdout.flush

  # Return 1x1 transparent GIF with cache-busting headers
  headers(
    'Content-Type'                 => 'image/gif',
    'Cache-Control'                => 'no-store, no-cache, must-revalidate, max-age=0, post-check=0, pre-check=0',
    'Pragma'                       => 'no-cache',
    'Expires'                      => 'Wed, 11 Jan 1984 05:00:00 GMT',
    'Access-Control-Allow-Origin'  => '*'
  )
  body TRANSPARENT_GIF_1X1
end
