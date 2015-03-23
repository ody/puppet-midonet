Puppet::Type.newtype(:midolman_config) do
  ensurable
  newparam(:name, :namevar => true) do
    desc 'section/setting name to manage midolman.conf'
    newvalues(/\S+\/\S+/)
  end
  newproperty(:value) do
    desc 'The value of the setting to be defined.'
    munge do |v|
      v.to_s.strip
    end
  end
end