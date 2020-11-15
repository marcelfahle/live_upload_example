import Config

config :ex_aws,
  access_key_id: "",
  secret_access_key: "",
  region: "eu-central-1",
  s3: [
    scheme: "https://",
    host: "s3.eu-central-1.amazonaws.com",
    region: "eu-central-1"
  ]

config :drops,
  bucket: "",
  path: ""
