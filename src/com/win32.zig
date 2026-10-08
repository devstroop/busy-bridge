//! Raw COM/OLE FFI for 32-bit Windows: extern declarations, GUIDs, VARIANT,
//! DISPPARAMS, and the IErrorInfo/IDispatch/ITypeInfo vtable layouts.
//! TYPEATTR/FUNCDESC byte offsets used by callers are x86 layouts (oaidl.h).

pub const GUID = extern struct {
    Data1: u32,
    Data2: u16,
    Data3: u16,
    Data4: [8]u8,
};

pub const IID_NULL = GUID{ .Data1 = 0, .Data2 = 0, .Data3 = 0, .Data4 = @splat(0) };

pub extern "ole32" fn CoInitializeEx(?*anyopaque, u32) callconv(.winapi) i32;
pub extern "ole32" fn CoUninitialize() callconv(.winapi) void;
pub extern "ole32" fn CoCreateInstance(
    *const GUID,
    ?*anyopaque,
    u32,
    *const GUID,
    *?*anyopaque,
) callconv(.winapi) i32;
pub extern "ole32" fn CLSIDFromProgID([*:0]const u16, *GUID) callconv(.winapi) i32;
pub extern "ole32" fn CLSIDFromString([*:0]const u16, *GUID) callconv(.winapi) i32;

pub extern "oleaut32" fn VariantClear(*VARIANT) callconv(.winapi) i32;
pub extern "oleaut32" fn SysAllocString([*:0]const u16) callconv(.winapi) ?[*:0]u16;
pub extern "oleaut32" fn SysFreeString(?[*:0]const u16) callconv(.winapi) void;
pub extern "oleaut32" fn SysStringLen(?[*:0]const u16) callconv(.winapi) u32;
pub extern "oleaut32" fn GetErrorInfo(u32, *?*IErrorInfo) callconv(.winapi) i32;

pub const COINIT_APARTMENTTHREADED: u32 = 0x2;
pub const CLSCTX_INPROC_SERVER: u32 = 0x1;
pub const S_OK: i32 = 0;
pub const DISP_E_PARAMNOTFOUND: i32 = @bitCast(@as(u32, 0x80020003));
pub const DISP_E_EXCEPTION: i32 = @bitCast(@as(u32, 0x80020009));

pub const VT_EMPTY: u16 = 0;
pub const VT_NULL: u16 = 1;
pub const VT_I2: u16 = 2;
pub const VT_I4: u16 = 3;
pub const VT_R4: u16 = 4;
pub const VT_R8: u16 = 5;
pub const VT_BSTR: u16 = 8;
pub const VT_DISPATCH: u16 = 9;
pub const VT_ERROR: u16 = 10;
pub const VT_BOOL: u16 = 11;
pub const VT_VARIANT: u16 = 12;
pub const VT_UNKNOWN: u16 = 13;
pub const VT_UI4: u16 = 19;
pub const VT_I8: u16 = 20;
pub const VT_INT: u16 = 22;
pub const VT_UINT: u16 = 23;
pub const VT_HRESULT: u16 = 25;
pub const VT_BYREF: u16 = 0x4000;

pub const VARIANT = extern struct {
    vt: u16,
    r1: u16 = 0,
    r2: u16 = 0,
    r3: u16 = 0,
    data: extern union {
        llVal: i64,
        lVal: i32,
        intVal: i32,
        uintVal: u32,
        bstrVal: ?[*:0]u16,
        boolVal: i16,
        fltVal: f32,
        dblVal: f64,
        scode: i32,
        byref: ?*anyopaque,
        pdispVal: ?*anyopaque,
        punkVal: ?*anyopaque,
    } align(8),

    pub fn init() VARIANT {
        return .{ .vt = VT_EMPTY, .data = undefined };
    }
};

pub const DISPPARAMS = extern struct {
    rgvarg: ?*VARIANT,
    rgdispidNamedArgs: ?*i32,
    cArgs: u32,
    cNamedArgs: u32,
};

pub const IErrorInfo = struct {
    vtbl: *const Vtbl,
    const Vtbl = extern struct {
        QueryInterface: *const fn (*IErrorInfo, *const GUID, *?*anyopaque) callconv(.winapi) i32,
        AddRef: *const fn (*IErrorInfo) callconv(.winapi) u32,
        Release: *const fn (*IErrorInfo) callconv(.winapi) u32,
        GetGUID: *const fn (*IErrorInfo, *GUID) callconv(.winapi) i32,
        GetSource: *const fn (*IErrorInfo, *?[*:0]u16) callconv(.winapi) i32,
        GetDescription: *const fn (*IErrorInfo, *?[*:0]u16) callconv(.winapi) i32,
        GetHelpFile: *const fn (*IErrorInfo, *?[*:0]u16) callconv(.winapi) i32,
        GetHelpContext: *const fn (*IErrorInfo, *u32) callconv(.winapi) i32,
    };
};

pub const IDispatch = struct {
    // align(1): BUSY hands out interface pointers from packed heap arrays
    // (observed 2-aligned Field objects). x86 executes unaligned loads fine;
    // declared alignment 1 keeps Zig's safety checks from panicking on them.
    vtbl: *const Vtbl align(1),
    const Vtbl = extern struct {
        QueryInterface: *const fn (*IDispatch, *const GUID, *?*anyopaque) callconv(.winapi) i32,
        AddRef: *const fn (*IDispatch) callconv(.winapi) u32,
        Release: *const fn (*IDispatch) callconv(.winapi) u32,
        GetTypeInfoCount: *const fn (*IDispatch, *u32) callconv(.winapi) i32,
        GetTypeInfo: *const fn (*IDispatch, u32, u32, *?*ITypeInfo) callconv(.winapi) i32,
        GetIDsOfNames: *const fn (*IDispatch, *const GUID, [*][*:0]const u16, u32, u32, *i32) callconv(.winapi) i32,
        Invoke: *const fn (
            *IDispatch,
            i32,
            *const GUID,
            u32,
            u16,
            *DISPPARAMS,
            *VARIANT,
            ?*anyopaque,
            ?*u32,
        ) callconv(.winapi) i32,
    };
};

pub const ITypeInfo = struct {
    vtbl: *const Vtbl,
    const Vtbl = extern struct {
        QueryInterface: *const fn (*ITypeInfo, *const GUID, *?*anyopaque) callconv(.winapi) i32,
        AddRef: *const fn (*ITypeInfo) callconv(.winapi) u32,
        Release: *const fn (*ITypeInfo) callconv(.winapi) u32,
        GetTypeAttr: *const fn (*ITypeInfo, *?*u8) callconv(.winapi) i32,
        GetTypeComp: *const fn (*ITypeInfo, *?*anyopaque) callconv(.winapi) i32,
        GetFuncDesc: *const fn (*ITypeInfo, u16, *?*u8) callconv(.winapi) i32,
        GetVarDesc: *const fn (*ITypeInfo, u16, *?*u8) callconv(.winapi) i32,
        GetNames: *const fn (*ITypeInfo, i32, [*]?[*:0]u16, u32, *u32) callconv(.winapi) i32,
        GetRefTypeOfImplType: *const fn (*ITypeInfo, u16, *u16) callconv(.winapi) i32,
        GetImplTypeFlags: *const fn (*ITypeInfo, u16, *i32) callconv(.winapi) i32,
        GetIDsOfNamesI: *const fn (*ITypeInfo, [*][*:0]const u16, u32, [*]i32) callconv(.winapi) i32,
        InvokeFunc: *const fn (*ITypeInfo, ?*anyopaque, i32, u16, *DISPPARAMS, *VARIANT, *i32) callconv(.winapi) i32,
        GetDocumentation: *const fn (*ITypeInfo, i32, *?[*:0]u16, *?[*:0]u16, *u32, *?[*:0]u16) callconv(.winapi) i32,
        GetDllEntry: *const fn (*ITypeInfo, i32, u16, u32, *?[*:0]u16, *?[*:0]u16, *u16) callconv(.winapi) i32,
        GetRefTypeInfo: *const fn (*ITypeInfo, u16, *?*ITypeInfo) callconv(.winapi) i32,
        AddressOfMember: *const fn (*ITypeInfo, i32, u16, *?*anyopaque) callconv(.winapi) i32,
        CreateInstance: *const fn (*ITypeInfo, *const GUID, *?*anyopaque) callconv(.winapi) i32,
        GetMops: *const fn (*ITypeInfo, i32, *?[*:0]u16) callconv(.winapi) i32,
        GetContainingTypeLib: *const fn (*ITypeInfo, *?*anyopaque, *u32) callconv(.winapi) i32,
        ReleaseTypeAttr: *const fn (*ITypeInfo, *u8) callconv(.winapi) void,
        ReleaseFuncDesc: *const fn (*ITypeInfo, *u8) callconv(.winapi) void,
        ReleaseVarDesc: *const fn (*ITypeInfo, *u8) callconv(.winapi) void,
    };
};
