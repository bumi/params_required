require 'test/unit'
require 'rubygems'
require 'action_controller'
require "params_required"
ActionController::Base.send(:include, Railslove::ParamsRequired)