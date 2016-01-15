require 'spec_helper'

module Beaker
  describe Unix::Pkg do
    class UnixPkgTest
      include Unix::Pkg

      def initialize(hash, logger)
        @hash = hash
        @logger = logger
      end

      def [](k)
        @hash[k]
      end

      def to_s
        "me"
      end

      def exec
        #noop
      end

    end

    let (:opts)     { @opts || {} }
    let (:logger)   { double( 'logger' ).as_null_object }
    let (:instance) { UnixPkgTest.new(opts, logger) }

    context "check_for_package" do

      it "checks correctly on sles" do
        @opts = {'platform' => 'sles-is-me'}
        pkg = 'sles_package'
        expect( Beaker::Command ).to receive(:new).with("zypper se -i --match-exact #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end
 
      it "checks correctly on fedora" do
        @opts = {'platform' => 'fedora-is-me'}
        pkg = 'fedora_package'
        expect( Beaker::Command ).to receive(:new).with("rpm -q #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "checks correctly on centos" do
        @opts = {'platform' => 'centos-is-me'}
        pkg = 'centos_package'
        expect( Beaker::Command ).to receive(:new).with("rpm -q #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "checks correctly on EOS" do
        @opts = {'platform' => 'eos-is-me'}
        pkg = 'eos-package'
        expect( Beaker::Command ).to receive(:new).with("rpm -q #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "checks correctly on el-" do
        @opts = {'platform' => 'el-is-me'}
        pkg = 'el_package'
        expect( Beaker::Command ).to receive(:new).with("rpm -q #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "checks correctly on debian" do
        @opts = {'platform' => 'debian-is-me'}
        pkg = 'debian_package'
        expect( Beaker::Command ).to receive(:new).with("dpkg -s #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "checks correctly on ubuntu" do
        @opts = {'platform' => 'ubuntu-is-me'}
        pkg = 'ubuntu_package'
        expect( Beaker::Command ).to receive(:new).with("dpkg -s #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "checks correctly on cumulus" do
        @opts = {'platform' => 'cumulus-is-me'}
        pkg = 'cumulus_package'
        expect( Beaker::Command ).to receive(:new).with("dpkg -s #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "checks correctly on solaris-11" do
        @opts = {'platform' => 'solaris-11-is-me'}
        pkg = 'solaris-11_package'
        expect( Beaker::Command ).to receive(:new).with("pkg info #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "checks correctly on solaris-10" do
        @opts = {'platform' => 'solaris-10-is-me'}
        pkg = 'solaris-10_package'
        expect( Beaker::Command ).to receive(:new).with("pkginfo #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', :accept_all_exit_codes => true).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.check_for_package(pkg) ).to be === true
      end

      it "returns false for el-4" do
        @opts = {'platform' => 'el-4-is-me'}
        pkg = 'el-4_package'
        expect( instance.check_for_package(pkg) ).to be === false
      end

      it "raises on unknown platform" do
        @opts = {'platform' => 'nope-is-me'}
        pkg = 'nope_package'
        expect{ instance.check_for_package(pkg) }.to raise_error

      end

    end

    context "install_package" do

      it "uses yum on fedora-20" do
        @opts = {'platform' => 'fedora-20-is-me'}
        pkg = 'fedora_package'
        allow( instance ).to receive( :command_prefix ).and_return( '' )
        expect( Beaker::Command ).to receive(:new).with("yum -y  install #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', {}).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.install_package(pkg) ).to be == "hello"
      end

      it "uses dnf on fedora-22" do
        @opts = {'platform' => 'fedora-22-is-me'}
        pkg = 'fedora_package'
        expect( Beaker::Command ).to receive(:new).with("dnf -y  install #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', {}).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.install_package(pkg) ).to be == "hello"
      end

      it 'uses the command prefix on el-based systems' do
        @opts = {'platform' => 'fedora-20-is-me'}
        pkg = 'fedora_package'
        command_prefix_value = 'command_prefix_value_cisco'
        allow( instance ).to receive( :command_prefix ).and_return( command_prefix_value )
        expect( Beaker::Command ).to receive(:new).with("#{command_prefix_value}yum -y  install #{pkg}", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', {}).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.install_package(pkg) ).to be == "hello"
      end

    end

    context "install_package_with_rpm" do

      it "accepts a package as a single argument" do
        @opts = {'platform' => 'el-is-me'}
        pkg = 'redhat_package'
        expect( Beaker::Command ).to receive(:new).with("rpm  -ivh #{pkg} ", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', {}).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.install_package_with_rpm(pkg) ).to be == "hello"
      end

      it "accepts a package and additional options" do
        @opts = {'platform' => 'el-is-me'}
        pkg = 'redhat_package'
        cmdline_args = '--foo'
        expect( Beaker::Command ).to receive(:new).with("rpm #{cmdline_args} -ivh #{pkg} ", [], {:prepend_cmds=>nil, :cmdexe=>false}).and_return('')
        expect( instance ).to receive(:exec).with('', {}).and_return(generate_result("hello", {:exit_code => 0}))
        expect( instance.install_package_with_rpm(pkg, cmdline_args) ).to be == "hello"
      end

    end

    context 'extract_rpm_proxy_options' do

      [ 'http://myproxy.com:3128/',
        'https://myproxy.com:3128/',
        'https://myproxy.com:3128',
        'http://myproxy.com:3128',
      ].each do |url|
        it "correctly extracts rpm proxy options for #{url}" do
          expect( instance.extract_rpm_proxy_options(url) ).to be == '--httpproxy myproxy.com --httpport 3128'
        end
      end

      url = 'http:/myproxy.com:3128'
      it "fails to extract rpm proxy options for #{url}" do
        expect{
          instance.extract_rpm_proxy_options(url)
        }.to raise_error(RuntimeError, /Cannot extract host and port/)
      end

    end

  end
end

