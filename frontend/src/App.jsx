import { useState } from 'react'
import MeasureForm from './components/MeasureForm'
import MeasurementsList from './components/MeasurementsList'

function App() {
  const [url, setUrl] = useState('https://www.jordanmoore.dev/')
  const [measurements, setMeasurements] = useState([])

  const handleMeasure = async (e) => {
    e.preventDefault()

    const response = await fetch('http://localhost:3000/captures', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ capture: { url } }),
    })
    const capture = await response.json()

    setMeasurements([
      { name: 'TTFB', ...capture.ttfb, unit: 'ms' },
      { name: 'LCP', ...capture.lcp, unit: 'ms' },
      { name: '404s', ...capture.count_404 },
      { name: '500s', ...capture.count_500 },
      { name: 'Page Size', ...capture.total_size_mb, unit: 'MB' },
    ])
  }

  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 bg-gray-50 px-4">
      <h1 className="text-4xl font-semibold tracking-tight text-gray-900">
        SiteIQ
      </h1>
      <MeasureForm url={url} onUrlChange={setUrl} onSubmit={handleMeasure} />
      {measurements.length > 0 && (
        <MeasurementsList measurements={measurements} />
      )}
    </main>
  )
}

export default App
