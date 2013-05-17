//////////////////////////////////////////////////////
// hooks for <%= hook_class %>
@interface <%= hook_class %>_HOOK_BY_XHAN : NSObject
@end
@implementation <%= hook_class %>_HOOK_BY_XHAN
static IMP <%= selectors.map{|sel| imp_from_sel sel}.join(',') %>;
+ (void)_hookMethod:(Class)origin method:(SEL)sel target:(Class)target imp:(IMP*)imp
{
    Method methodOrigin = class_getInstanceMethod(origin, sel);
    Method methodTarget = class_getInstanceMethod(target, sel);  
	*imp = method_getImplementation(methodOrigin);
    method_exchangeImplementations(methodOrigin, methodTarget);
}
+ (void)load{
	Class klassOrigin = NSClassFromString(@"<%= hook_class %>");
	<%- for selector in selectors -%>
	[self _hookMethod:klassOrigin method:@selector(<%=selector%>) target:self imp:&<%=imp_from_sel selector%>];
	<%- end -%>
}
<%= body %>
@end
