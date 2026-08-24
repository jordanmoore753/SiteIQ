import { useState } from 'react'
import MeasurementsList from './components/MeasurementsList'

function App() {
  const [url, setUrl] = useState('https://www.jordanmoore.dev/')
  const [measurements, setMeasurements] = useState([])

  const handleMeasure = async () => {
    const response = await fetch('http://localhost:3000/captures', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ capture: { url } }),
    })
    const capture = await response.json()

    setMeasurements([
      { name: 'TTFB', value: capture.ttfb, unit: 'ms' },
      { name: 'LCP', value: capture.lcp, unit: 'ms' },
      { name: '404s', value: capture.count_404 },
      { name: '500s', value: capture.count_500 },
    ])
  }

  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 bg-gray-50 px-4">
      <h1 className="text-4xl font-semibold tracking-tight text-gray-900">
        SiteIQ
      </h1>
      <div className="flex w-full max-w-md gap-2">
        <input
          type="text"
          value={url}
          onChange={(e) => setUrl(e.target.value)}
          className="w-full rounded-md border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        />
        <button
          type="button"
          onClick={handleMeasure}
          className="rounded-md bg-indigo-600 px-4 py-2 font-medium text-white shadow-sm hover:bg-indigo-500"
        >
          Measure
        </button>
      </div>
      {measurements.length > 0 && (
        <MeasurementsList measurements={measurements} />
      )}
    </main>
  )
}

export default App
