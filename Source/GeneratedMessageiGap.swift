//
//  GeneratedMessageiGap.swift
//  ProtocolBuffers
//
//  Created by Kayvan on 11/5/16.
//  Copyright © 2016 alexeyxo. All rights reserved.
//

//MARK: - GeneratedMessage
open class GeneratedRequestMessage : GeneratedMessage {
    
}

open class GeneratedResponseMessage : GeneratedMessage {
    open var igpResponse:IGPResponse!
    open var hasIgpResponse:Bool = false
}


//MARK: - GeneratedMessageBuilder
protocol IGPRequestProtocol {
    func setIgpRequest(_ value:IGPRequest!) -> GeneratedMessageBuilder
}

open class GeneratedRequestMessageBuilder: GeneratedMessageBuilder, IGPRequestProtocol {
    open func setIgpRequest(_ value:IGPRequest!) -> GeneratedMessageBuilder {
        return self
    }
}


open class GeneratedResponseMessageBuilder: GeneratedMessageBuilder {
    
}

