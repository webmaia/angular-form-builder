describe 'builder.provider', ->
    beforeEach module('builder')


    describe 'fbFormObjectEditableController', ->
        $scope = null
        controller = null

        beforeEach inject ($rootScope, $controller) ->
            $scope = $rootScope.$new()
            controller = $controller 'fbFormObjectEditableController',
                $scope: $scope

        describe '$scope.setupScope', ->
            formObject = null

            beforeEach ->
                formObject =
                    $$hashKey: '007'
                    label: 'label'
                    description: 'description'
                    placeholder: 'placeholder'
                    required: no
                    options: ['value one', 'two']
                $scope.setupScope formObject

            it 'check $scope.setupScope(formObject) copy properties from formObject without `$$hashKey`', ->
                expect($scope.$$hashKey).toBeUndefined()
                expect(formObject.label).toEqual $scope.label
                expect(formObject.description).toEqual $scope.description
                expect(formObject.placeholder).toEqual $scope.placeholder
                expect(formObject.required).toBe no
                expect(formObject.options).toEqual $scope.options

            it 'check $scope.setupScope(formObject) $scope.optionsText is joined by `\\n` from options', ->
                expect($scope.optionsText).toEqual 'value one\ntwo'

            it 'check $scope.setupScope(formObject) $scope.$watch `[label, description, placeholder, required, options]`', ->
                $scope.label = 'new'
                $scope.$digest()
                expect(formObject.label).toEqual $scope.label

                $scope.description = 'new'
                $scope.$digest()
                expect(formObject.description).toEqual $scope.description

                $scope.placeholder = 'new'
                $scope.$digest()
                expect(formObject.placeholder).toEqual $scope.placeholder

                $scope.required = yes
                $scope.$digest()
                expect(formObject.required).toBe $scope.required

                $scope.options = ['value']
                $scope.$digest()
                expect(formObject.options).toEqual $scope.options

            it 'check $scope.setupScope(formObject) $scope.$watch `optionsText`', ->
                $scope.optionsText = "one\ntwo"
                $scope.$digest()
                expect(['one', 'two']).toEqual $scope.options
                expect('one').toEqual $scope.inputText

        describe '$scope.data', ->
            formObject = null

            beforeEach ->
                formObject =
                    $$hashKey: '007'
                    label: 'label'
                    description: 'description'
                    placeholder: 'placeholder'
                    required: no
                    options: ['value one', 'two']
                $scope.setupScope formObject

            it 'check $scope.data.model is null', ->
                expect($scope.data.model).toBeNull()

            it 'check $scope.data.model after call $scope.data.backup()', ->
                $scope.data.backup()
                expect
                    label: 'label'
                    description: 'description'
                    placeholder: 'placeholder'
                    required: no
                    optionsText: 'value one\ntwo'
                .toEqual $scope.data.model

            it 'check $scope after call $scope.data.rollback()', ->
                $scope.data.backup()
                $scope.label = ''
                $scope.description = ''
                $scope.placeholder = ''
                $scope.required = yes
                $scope.optionsText = ''
                $scope.data.rollback()
                $scope.$digest()
                expect(formObject.label).toEqual $scope.label
                expect(formObject.description).toEqual $scope.description
                expect(formObject.placeholder).toEqual $scope.placeholder
                expect(formObject.required).toEqual $scope.required
                expect(formObject.options.join('\n')).toEqual $scope.optionsText