// _bridge_isProp
// _bridge_getProp

// _bridge_isMethod
// _bridge_getMethod

// _bridge_set
// _requireNativeClass
try {
    function requireNativeClass(className) {
        log('require native class' + className);
        return createProxy(_requireNativeClass(className));
    }
    
    function createProxy(value) {
        if (null === value) return null;
        switch (typeof value) {
            case 'number':
            case 'string':
            case 'function':
                return value;
            case 'object':
                return new Proxy(value, {
                                 get(target, prop) {
                                 return getNativeProp(target, prop);
                                 }
                                 });
        }
    }
    
    // 用 _ 进行分割
    function getNativeProp(target, prop) {
        try {
            if (_bridge_isProp(target, prop)) {
                log('is prop');
                return createProxy(_bridge_getProp(target, prop));
            } else if (_bridge_isMethod(target, prop)) {
                log('is method ' + prop);
                return function() {
                    return createProxy(_bridge_getMethod(target, prop).apply(null, arguments));
                };
            } else return null;
        } catch (e) {}
    }
    
    function setNativeProp(target, prop, value) {
        try {
            return _bridge_set(target, prop, value);
        } catch (e) {}
    }
    
    log('Log works');
    log(requireNativeClass('Test').staticMethodWithArg_(600));
    
//    log(
//        requireNativeClass('Test')
//        .alloc()
//        .init().instanceProp
//        );
} catch (e) {
    log(e.toString());
}

