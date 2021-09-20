const express = require('express')    
const app = express()    
const port = 5000    
app.get('/', (req, res) => {    
  res.send('Hello Jumbo world!')    
})    
app.listen(port);