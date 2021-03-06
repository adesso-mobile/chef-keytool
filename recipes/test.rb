#
# Cookbook Name:: keytool
# Recipe:: test
#
# Copyright (C) 2014 Jean-Francois Theroux
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Test keystore - store password is 1qaz2wsx
cookbook_file '/tmp/keystore.jks' do
  action :create_if_missing
end

file '/tmp/storepass' do
  content 'supersecretsauce'
end

# Clean up before each run
%w(/tmp/thawtepremiumserverca.crt /var/tmp/extra-cnnicroot.crt).each do |e|
  file e do
    action :delete
  end
end

# Change keystore password tests
keytool_manage 'cacerts' do
  action :storepasswd
  keystore '/etc/pki/java/cacerts'
  storepass 'changeit'
  new_pass 'supersecretsauce'
end

# Export tests
keytool_manage 'export thawtepremiumserverca' do
  cert_alias 'thawtepremiumserverca'
  keystore '/etc/pki/java/cacerts'
  storepass_file '/tmp/storepass'
end

keytool_manage 'export extra-cnnicroot' do
  cert_alias 'extra-cnnicroot'
  file '/var/tmp/extra-cnnicroot.crt'
  keystore '/etc/pki/java/cacerts'
  storepass 'supersecretsauce'
  additional '-v'
end

# Delete tests
keytool_manage 'delete thawtepremiumserverca' do
  cert_alias 'thawtepremiumserverca'
  action :deletecert
  keystore '/tmp/keystore.jks'
  storepass '1qaz2wsx'
end

keytool_manage 'delete extra-cnnicroot' do
  cert_alias 'extra-cnnicroot'
  action :deletecert
  keystore '/tmp/keystore.jks'
  storepass '1qaz2wsx'
end

# Import tests
keytool_manage 'import thawtepremiumserverca' do
  cert_alias 'thawtepremiumserverca'
  action :importcert
  keystore '/tmp/keystore.jks'
  storepass '1qaz2wsx'
end

keytool_manage 'import extra-cnnicroot' do
  cert_alias 'extra-cnnicroot'
  action :importcert
  file '/var/tmp/extra-cnnicroot.crt'
  keystore '/tmp/keystore.jks'
  storepass '1qaz2wsx'
end
