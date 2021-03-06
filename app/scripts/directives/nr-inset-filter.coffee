angular.module('onoSendai')
  .directive('insetFilter', ($parse) ->
    template: '<div class="input"></div>'
    restrict: 'E'
    require: 'ngModel'
    link: (scope, element, attrs, ngModelCtrl) ->
      inputElement = element.find('.input')

      # Attach an ID for the label
      inputElement.attr('id', attrs.id)

      # Initializes select2 with the provided data
      initSelect = (data) ->
        inputElement.select2(
          placeholder: attrs.placeholder
          data: data
          openOnEnter: false)

      # Grab the data
      data = $parse(attrs.insetFilterSource)(scope) ? []

      # Select2-ify the input element
      initSelect(data)

      # Watch for data source changes
      scope.$watch(attrs.insetFilterSource, dataChanged = (newVal, oldVal) ->
        if newVal == oldVal
          return
        initSelect(newVal).select2('val', ngModelCtrl.$modelValue).val(ngModelCtrl.$modelValue).change())

      # Model -> UI
      ngModelCtrl.$render = ->
        inputElement.select2('val', ngModelCtrl.$modelValue)

      # UI -> Model
      inputElement.on('change', selectChanged = (e) ->
        if scope.$$phase or scope.$root.$$phase
          return

        scope.$apply ->
          ngModelCtrl.$setViewValue(inputElement.val()))

      # Clear the select's value on escape press
      element.keydown(jwerty.event('esc', (e) ->
        inputElement.select2('val', '').change())
      )
  )
