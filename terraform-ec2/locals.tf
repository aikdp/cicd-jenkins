locals {
    common_tags = merge(
        
        var.common_tags,
    
        {
            CreatedAt = formatdate("YYYY-MM-DD", timestamp())
        }
    
    )
}