
def json_to_csv_impl(ctx: "context") -> ["provider"]:
    output = ctx.actions.declare_output(ctx.attrs.out)
    ctx.actions.run(
        ["python3", ctx.attrs.script, ctx.attrs.src, output.as_output()],
        category='json_to_csv'
    )
    return [
        DefaultInfo(default_output=output)
    ]

json_to_csv = rule(
    impl=json_to_csv_impl,
    attrs={
        "script": attrs.source(),
        "src": attrs.source(),
        "out": attrs.string()
    }
)
