$ ->
  my.initAjax()

  Glob = window.Glob || {}

  apiUrl =
    send: '/create'
    get: '/get'
    delete: '/delete'
    update: '/update'

  vm = ko.mapping.fromJS
    name: ''
    getList: []
    id: 0
    tel: ''
    age: ''
    address: ''

  handleError = (error) ->
    if error.status is 500 or (error.status is 400 and error.responseText)
      toastr.error(error.responseText)
    else
      toastr.error('Something went wrong! Please try again.')

  vm.onSubmit = ->
    toastr.clear()
    if (!vm.name())
      toastr.error("Please enter a name")
      return no
    else if(!vm.tel())
      toastr.error("Please enter a tel")
      return no
    else if (!vm.age())
      toastr.error("Please enter a age")
      return no
    else if (!vm.address())
      toastr.error("Please enter a address")
      return no
    else
      data =
        name: vm.name()
        tel: vm.tel()
        age: vm.age()
        address: vm.address()
      $.ajax
        url: apiUrl.send
        type: 'POST'
        data: JSON.stringify(data)
        dataType: 'json'
        contentType: 'application/json'
      .fail handleError
      .done (response) ->
        toastr.success(response)



  vm.getAllNames = ->
    $.ajax
      url: apiUrl.get
      type: 'GET'
    .fail handleError
    .done (response) ->
      console.log('1: ', vm.getList().length)
      vm.getList(response)
      console.log('2: ', vm.getList().length)

  vm.delete = ->
    if window.confirm(" Do you want to delete it?" )
      data =
        id: parseInt(vm.id())
      $.ajax
        url: apiUrl.delete
        type: 'DELETE'
        data: JSON.stringify(data)
        dataType: 'json'
        contentType: 'application/json'
      .fail handleError
      .done (response) ->
        toastr.success(response)

  vm.update = ->
    data =
      id: parseInt(vm.id())
      name: vm.name()
      tel: vm.tel()
      age: vm.age()
      address: vm.address()
    $.ajax
      url: apiUrl.update
      type: 'POST'
      data: JSON.stringify(data)
      dataType: 'json'
      contentType: 'application/json'
    .fail handleError
    .done (response) ->
      toastr.success(response)


  ko.applyBindings {vm}