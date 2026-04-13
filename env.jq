.items[] |
.metadata.name as $pod |
.spec.containers[] |
.name as $container |
.env[]? |
"\($pod) | \($container) | \(.name)=\(.value // .valueFrom)"