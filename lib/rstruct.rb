require 'rstruct/registry'
require 'rstruct/type'
require 'rstruct/types'
require 'rstruct/structure'
require 'rstruct/struct_builder'

module Rstruct
  module ClassMethods

    # Take the following C struct for example:
    #
    # Which can be defined with rstruct as follows:
    #
    #   struct tm {
    #     int   tm_sec;      /* seconds after the minute [0-60] */
    #     int   tm_min;      /* minutes after the hour [0-59] */
    #     int   tm_hour;     /* hours since midnight [0-23] */
    #     int   tm_mday;     /* day of the month [1-31] */
    #     int   tm_mon;      /* months since January [0-11] */
    #     int   tm_year;     /* years since 1900 */
    #     int   tm_wday;     /* days since Sunday [0-6] */
    #     int   tm_yday;     /* days since January 1 [0-365] */
    #     int   tm_isdst;    /* Daylight Savings Time flag */
    #     long  tm_gmtoff;   /* offset from CUT in seconds */
    #     char  *tm_zone;    /* timezone abbreviation */
    #   };
    #
    #   Rstruct.struct(:tm) {
    #     int   :tm_sec       # seconds after the minute [0-60] */
    #     int   :tm_min       # minutes after the hour [0-59] */
    #     int   :tm_hour      # hours since midnight [0-23] */
    #     int   :tm_mday      # day of the month [1-31] */
    #     int   :tm_mon       # months since January [0-11] */
    #     int   :tm_year      # years since 1900 */
    #     int   :tm_wday      # days since Sunday [0-6] */
    #     int   :tm_yday      # days since January 1 [0-365] */
    #     int   :tm_isdst     # Daylight Savings Time flag */
    #     long  :tm_gmtoff    # offset from CUT in seconds */
    #     char  *:tm_zone     # timezone abbreviation */
    #   }
    #
    # The DSL interface for this method is implemented by
    # Rstruct::StructBuilder.
    def struct(name, opts={},&block)
      Rstruct::Structure.new(name, opts, &block)
    end

    # Returns the default Rstruct registry
    def default_registry
      Registry::DEFAULT_REGISTRY
    end
  end

  extend(ClassMethods)
end

