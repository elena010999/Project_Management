#!/bin/bash
#
# Config utilities
#
# Functions to implement:
#
# pm_config_init(CONFIG_PATH)
#   - Load defaults
#   - Merge with values from CONFIG_PATH (if exists)
#   - Allow overrides from environment variables
#
# pm_config_get(KEY, DEFAULT)
#   - Return value for KEY if set, otherwise DEFAULT
#
# pm_config_require(KEY)
#   - Exit if KEY not set
#
# pm_config_dump()
#   - Print all effective config values (for debugging)

