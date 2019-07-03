 (
  function (){
      var messsageQueue = [];
      var messagePending = false;
  
      function processQueue (){
          if(!messsageQueue.length || messagePending) return;
          messagePending = true;
          document.location = 'webjs-navigation-objc://WSMessageHandler?'+ encodeURIComponent(messsageQueue.shift());
      }
  
      window.WSMessageHandler = {
          postMessage: function (data){
              console.log('window.WSMessageHandler.postMessage:',data);
              messsageQueue.push(String(data));
              processQueue();
          },
          messageReceived: function (){
              messagePending = false;
              processQueue();
          }
      }
  }

 )();
