#
# Load iBoard Modules 
#
include StringExtensions
include LayoutHelper
include Commentables
include Assetables
include IboardFormHelpers
include Blogables

# Register commentables (should be moved to module Commentables on init)
Commentable::register([Posting,Episode])
Commentable::freeze_registered_commentables

