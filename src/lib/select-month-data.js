/*
License:

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

import createCachedSelector from 're-reselect'

import getMonthData from './workdata'
import getHolidayData from './holiday-data'

/**
 * CachedSelector that stores the month data.
 */
export default createCachedSelector(
  year => year,
  (year, month) => month,
  (year, month, is64Model) => is64Model,

  (year, month, is64Model) => {
    const data = getMonthData(year, month, is64Model)

    data.holidays = getHolidayData(year, month)

    return data
  }
)( // Key selector. Data will be saved with this key.
  (year, month, is64Model) => `${year}-${month}-${is64Model}`
)