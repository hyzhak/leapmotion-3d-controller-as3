package org.hyzhak.leapmotion {
    import com.leapmotion.leap.util.Base64Encoder;

    import flash.display.Sprite;
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.net.Socket;
    import flash.utils.ByteArray;

    /**
     * Get RAW information from WebSocket on localhost:6437
     */
    public class RawData extends Sprite {
        private var _socket:Socket;
        private var _host:String = "localhost";

        /**
         * Base64 encoded cryptographic nonce value.
         */
        private var _secWebSocketKey:String;

        public function RawData() {
            generateSecWebSocketKey();

            _socket = new Socket(_host, 6437);
            _socket.addEventListener( Event.CONNECT, onSocketConnectHandler);
            _socket.addEventListener( ProgressEvent.SOCKET_DATA, onSocketDataHandler );
        }

        private function generateSecWebSocketKey():void {
            // Generate nonce
            var nonce:ByteArray = new ByteArray();
            for ( var i:int = 0; i < 16; i++ )
                nonce.writeByte( Math.round( Math.random() * 0xFF ) );

            nonce.position = 0;

            var encoder:Base64Encoder = new Base64Encoder();
            encoder.encodeBytes( nonce );
            _secWebSocketKey = encoder.flush();
        }

        private function onSocketConnectHandler( event:Event ):void
        {
            sendHandshake();
        }

        /**
         * Sends the HTTP handshake to the Leap
         *
         */
        private function sendHandshake():void
        {
            var text:String = "";
            text += "GET / HTTP/1.1\r\n";
            text += "Host: " + _host + ":6437\r\n";
            text += "Upgrade: websocket\r\n";
            text += "Connection: Upgrade\r\n";
            text += "Sec-WebSocket-Key: " + _secWebSocketKey + "\r\n";
            text += "Origin: *\r\n";
            text += "Sec-WebSocket-Version: 13\r\n";
            text += "\r\n";

            _socket.writeMultiByte( text, "us-ascii" );
        }

        private function onSocketDataHandler( event:ProgressEvent = null ):void
        {
            trace("onSocketDataHandler");
            trace(_socket.readUTFBytes(_socket.bytesAvailable));
        }
    }
}
