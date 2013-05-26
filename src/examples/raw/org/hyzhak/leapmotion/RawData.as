package org.hyzhak.leapmotion {
    import com.hurlant.util.Base64;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.Socket;
    import flash.text.TextField;
    import flash.utils.ByteArray;

    /**
     * Get RAW data from WebSocket on localhost:6437
     */
    public class RawData extends Sprite {
        /**
         * LeapMotion Socket url
         */
        public var host:String = "localhost";
        public var port:int = 6437;

        /**
         * Socket for connect with LeapMotion
         */
        private var _socket:Socket;

        /**
         * text field for logging LeapMotion state
         */
        private var _tf:TextField;

        /**
         * Base64 encoded cryptographic nonce value.
         */
        private var _secWebSocketKey:String;

        public function RawData() {
            _tf = new TextField();
            _tf.width = stage.stageWidth;
            _tf.height = stage.stageHeight;
            _tf.multiline = true;
            addChild(_tf);

            _socket = new Socket(host, port);
            _socket.addEventListener( Event.CONNECT, onSocketConnectHandler);
            _socket.addEventListener( IOErrorEvent.IO_ERROR, onIOError);
            _socket.addEventListener( SecurityErrorEvent.SECURITY_ERROR, onSecurityErrorHandler );
            _socket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketDataHandler );
        }

        private function onIOError(event:IOErrorEvent):void {
            log("onIOError", event.text);
        }

        private function onSecurityErrorHandler(event:SecurityErrorEvent):void {
            log("onSecurityErrorHandler", event.text);
        }

        private function onSocketConnectHandler( event:Event ):void {
            log("onSocketConnectHandler");
            generateSecWebSocketKey();
            sendHandshake();
        }

        /**
         * Generate key for emulate handshake with LeapMotion WebSocket
         */
        private function generateSecWebSocketKey():void {
            // Generate nonce
            var nonce:ByteArray = new ByteArray();
            for ( var i:int = 0; i < 16; i++ )
                nonce.writeByte( Math.round( Math.random() * 0xFF ) );

            nonce.position = 0;

            _secWebSocketKey = Base64.encodeByteArray(nonce);
        }

        /**
         * Sends the HTTP handshake to the Leap
         *
         */
        private function sendHandshake():void {
            var text:String = "";
            text += "GET / HTTP/1.1\r\n";
            text += "Host: " + host + ":6437\r\n";
            text += "Upgrade: websocket\r\n";
            text += "Connection: Upgrade\r\n";
            text += "Sec-WebSocket-Key: " + _secWebSocketKey + "\r\n";
            text += "Origin: *\r\n";
            text += "Sec-WebSocket-Version: 13\r\n";
            text += "\r\n";

            _socket.writeMultiByte( text, "us-ascii" );
        }

        /**
         * Log upcoming date from LeapMotion
         *
         * @param event
         */
        private function onSocketDataHandler( event:ProgressEvent = null ):void {
            clearLog();
            log("onSocketDataHandler");
            log(_socket.readUTFBytes(_socket.bytesAvailable));
        }

        private function clearLog():void {
            _tf.text = "";
        }

        private function log(...args):void {
            trace.apply(null, args);
            _tf.appendText(args.join(" "));
        }
    }
}
