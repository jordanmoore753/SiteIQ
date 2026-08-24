import { useState } from 'react'
import MeasureForm from './components/MeasureForm'
import MeasurementsList from './components/MeasurementsList'
import SaveButton from './components/SaveButton'

function App() {
  const [url, setUrl] = useState('https://www.jordanmoore.dev/')
  const [capture, setCapture] = useState(null)
  const [measurements, setMeasurements] = useState([])
  const [isMeasuring, setIsMeasuring] = useState(false)
  const [isMeasured, setIsMeasured] = useState(false)

  const handleMeasure = async (e) => {
    e.preventDefault()
    setIsMeasured(false)
    setCapture(null)
    setMeasurements([])
    setIsMeasuring(true)

    const response = await fetch('http://localhost:3000/captures/measure', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ capture: { url } }),
    })
    const data = await response.json()

    setCapture(data)
    setMeasurements([
      { name: 'TTFB', ...data.ttfb, unit: 'ms' },
      { name: 'LCP', ...data.lcp, unit: 'ms' },
      { name: '404s', ...data.count_404 },
      { name: '500s', ...data.count_500 },
      { name: 'Page Size', ...data.total_size_mb, unit: 'MB' },
    ])
    setIsMeasuring(false)
    setIsMeasured(true)
  }

  const handleSave = async () => {
    await fetch('http://localhost:3000/captures', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        capture: {
          site_id: capture.site_id,
          ttfb: capture.ttfb.value,
          lcp: capture.lcp.value,
          count_404: capture.count_404.value,
          count_500: capture.count_500.value,
          total_size_mb: capture.total_size_mb.value,
        },
      }),
    })
  }

  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 bg-gray-50 px-4">
      <h1 className="text-4xl font-semibold tracking-tight text-gray-900">
        SiteIQ
      </h1>
      <MeasureForm
        url={url}
        onUrlChange={setUrl}
        onSubmit={handleMeasure}
        isMeasuring={isMeasuring}
      />
      {measurements.length > 0 && (
        <MeasurementsList measurements={measurements} />
      )}
      {isMeasured && <SaveButton onClick={handleSave} />}
    </main>
  )
}

export default App
