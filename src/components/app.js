/*
License:

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

import { html, useReducer, useState, useEffect } from '../preact.js'
import { Router } from '../web_modules/preact-router.js'
import Hammer from '../web_modules/hammerjs.js'
import qs from '../web_modules/querystringify.js'

import FirstRunDialog from './first-run.js'
import Header from './header.js'
import Impressum from './impressum.js'
import InstallPrompt from './install-prompt.js'
import Main from './main.js'

import { scrollToADay } from '../lib/utils.js'
import {
  shiftModelNames,
  shift66Name,
  shiftModelNumberOfGroups
} from '../lib/constants.js'

const initialState = {
  url: window.location.pathname,
  didSelectModel: true, // did the user select a shift-model once?
  fullYear: false, // should the full year be displayed
  shiftModel: shift66Name, // Which shift-model is it, the 6-4 model or the 6-6 model?
  search: null,
  year: 2020, // Selected year
  month: 1, // Selected month
  group: 0 // group to display; 0 = all, 1 - 6 is group number
}

/**
 * The App main component
 * @returns {JSX.Element}
 */
export default function App() {
  const [state, dispatch] = useReducer(reducer, initialState, initReducer)

  const today = useToday()
  useHammer(dispatch, state.fullYear)

  useEffect(() => {
    if (state.search) {
      scrollToADay(...state.search)
    }
  }, [state.search])

  useEffect(() => {
    // on first render, and every time the shift model changes.
    if (state.didSelectModel) {
      const now = new Date()
      scrollToADay(now.getFullYear(), now.getMonth(), now.getDate())
    }
  }, [state.shiftModel, state.didSelectModel])

  return html`
    <div id="app">
      <${Header}
        year=${state.year}
        month=${state.month}
        isFullYear=${state.fullYear}
        shiftModel=${state.shiftModel}
        search=${state.search}
        group=${state.group}
        url=${state.url}
        dispatch=${dispatch}
      />
      <${Router}
        onChange=${event => {
          dispatch({ type: 'url_change', url: event.url })
        }}
      >
        <${Main}
          path="/"
          isFullYear=${state.fullYear}
          year=${state.year}
          month=${state.month}
          shiftModel=${state.shiftModel}
          today=${today}
          search=${state.search}
          group=${state.group}
        />
        <${Impressum} path="/impressum/" />
      </${Router}>

      <${InstallPrompt} />

      ${state.didSelectModel
        ? null
        : html`<${FirstRunDialog}
          onClick=${model => {
            dispatch({
              type: 'model_change',
              payload: model
            })
          }}
        />`
      }
    </div>
  `
}

function initReducer (initialState) {
  const now = new Date()
  const year = now.getFullYear()
  const month = now.getMonth()

  return {
    ...initialState,
    year,
    month
  }
}

function reducer (state, action) {
  switch (action.type) {
    case 'url_change':
      return {
        ...state,
        url: action.url
      }

    case 'goto':
      return {
        ...state,
        fullYear: action.fullYear != null
          ? action.fullYear
          : state.fullYear,
        year: action.year || state.year,
        month: action.month || state.month
      }

    case 'move':
    {
      let month = state.month + action.payload
      let year = state.year
      if (month < 0) {
        year -= 1
        month += 12
      } else if (month >= 12) {
        year += 1
        month -= 12
      }
      return {
        ...state,
        fullYear: false,
        year,
        month
      }
    }

    case 'toggle_full_year':
      return {
        ...state,
        fullYear: !state.fullYear
      }

    case 'group_change':
      return {
        ...state,
        group: action.payload
      }

    case 'model_change':
      if (shiftModelNames.every(model => model !== action.payload)) {
        throw new TypeError(`Unknown shift-model! "${action.payload}" is unknown!`)
      }
      return {
        ...state,
        shiftModel: action.payload,
        didSelectModel: true,
        group: state.group > shiftModelNumberOfGroups[action.payload]
          ? 0
          : state.group
      }

    case 'search':
      return {
        ...state,
        year: action.year,
        month: action.month,
        search: [action.year, action.month, action.day]
      }

    case 'clear_search':
      return {
        ...state,
        search: null
      }

    default:
      return state
  }
}

/**
 * Get today as a array of [year, month, day, hours].
 * @returns {[number, number, number, number]} Today-array
 */
function useToday () {
  const [today, setToday] = useState(() => {
    const now = new Date()
    return [now.getFullYear(), now.getMonth(), now.getDate(), now.getHours()]
  })

  useEffect(() => {
    const onFocus = () => {
      const now = new Date()
      const nextToday = [now.getFullYear(), now.getMonth(), now.getDate(), now.getHours()]
      if (nextToday.some((n, index) => n !== today[index])) {
        setToday(nextToday)
      }
    }

    const nextHour = new Date()
    nextHour.setHours(nextHour.getHours() + 1)
    nextHour.setMinutes(0)
    nextHour.setSeconds(0)

    const resetTimeout = setTimeout(() => {
      onFocus()
    }, Date.now() - nextHour.getTime())

    window.addEventListener('focus', onFocus)
    return () => {
      window.removeEventListener('focus', onFocus)
      clearTimeout(resetTimeout)
    }
  }, [today])

  return today
}

/**
 * Setup Hammer and handle swipes.
 * @param {function} dispatch   Dispatch function of the reducer.
 * @param {boolean}  isFullYear Is the full year displayed?
 */
function useHammer (dispatch, isFullYear) {
  useEffect(() => {
    if (isFullYear) return

    const handler = event => {
      switch (event.direction) {
        case 2: // right to left
          dispatch({
            type: 'move',
            payload: 1
          })
          break

        case 4: // left to right
          dispatch({
            type: 'move',
            payload: -1
          })
          break
      }
    }

    const hammertime = new Hammer(document.getElementById('app'))
    hammertime.on('swipe', handler)
    return () => {
      hammertime.off('swipe', handler)
    }
  }, [isFullYear])
}
