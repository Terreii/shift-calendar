/*
License:

This Source Code Form is subject to the terms of the Mozilla Public License, v. 2.0. If a copy of
the MPL was not distributed with this file, You can obtain one at http://mozilla.org/MPL/2.0/.
*/

import { useEffect } from 'react'
import Link from 'next/link'
import { useRouter } from 'next/router'

import Footer from '../components/footer'
import Head from '../components/head'
import { shiftModelNames, shiftModelText } from '../lib/constants'
import { getCalUrl } from '../lib/utils'

export default function Index () {
  const router = useRouter()

  useEffect(() => {
    const isIos = /iphone|ipad|ipod/i.test(window.navigator.platform)
    const isFirstRun = 'pwa' in router.query || // with webmanifest
      // iOS install
      (isIos && window.navigator.standalone && window.sessionStorage.getItem('isFirstRun') == null)

    if (isFirstRun) {
      if (isIos) {
        window.sessionStorage.setItem('isFirstRun', true)
      }

      const settings = JSON.parse(window.localStorage.getItem('settings')) ?? {}
      if (settings.didSelectModel) {
        const now = new Date()

        router.replace(getCalUrl({
          isFullYear: false,
          year: now.getFullYear(),
          month: now.getMonth() + 1,
          day: now.getDate(),
          shiftModel: settings.shiftModel,
          group: settings.group
        }))
      }
    }
  }, [])

  return (
    <main className='w-screen h-screen pt-16 text-center bg-gray-100'>
      <Head />
      <h2>Willkommen zum inoffiziellen Schichtkalender für Bosch Reutlingen!</h2>

      <p>
        Welches Schichtmodell interessiert sie?
        <br />
        Sie können das Modell später jederzeit im Menü
        <img
          className='inline-block ml-1 mr-2'
          src='/assets/icons/hamburger_icon.svg'
          height='20'
          width='20'
          alt='das Menü ist oben rechts'
        />
        umändern.
      </p>

      <ul className='flex flex-col justify-center w-64 p-0 mx-auto mt-2 mb-16 space-y-3 list-none'>
        {shiftModelNames.map(name => (
          <li key={name}>
            <Link href={`/cal/${name}`}>
              <a
                className='inline-block w-full h-12 px-4 py-3 mx-3 text-center text-white bg-indigo-700 border-0 rounded shadow hover:bg-indigo-800 focus:bg-indigo-800 focus:ring focus:outline-none'
              >
                {shiftModelText[name]}
              </a>
            </Link>
          </li>
        ))}
      </ul>

      <Footer />
    </main>
  )
}
