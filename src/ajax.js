var requestScagnostics = function(data, done) {
  var url = 'http://localhost:8084/Scagnostics/rest/scagnostics_service/scagnostics'

  var xhr = new XMLHttpRequest()

  xhr.open('POST', url)
  xhr.setRequestHeader("Content-Type", "application/json")
  xhr.onload = function() {
    if (xhr.status >= 200 && xhr.status < 300) {
      done(JSON.parse(xhr.response))
    } else {
      done({
        status: xhr.status,
        statusText: xhr.statusText
      })
    }
  }
  xhr.onerror = function() {
    done({
      status: xhr.status,
      statusText: xhr.statusText
    })
  }
  xhr.send(data)
}
