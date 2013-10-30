# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
angular.module('stockScouterApp').directive "tooltip", ->
  {
    restrict: 'A',
    link: (scope, element, attrs) ->
      $(element).attr('title', scope.$eval(attrs.tooltip)).tooltip({placement: "top"})
  }
