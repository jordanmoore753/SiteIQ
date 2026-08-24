function App() {
  return (
    <main className="flex min-h-screen flex-col items-center justify-center gap-6 bg-gray-50 px-4">
      <h1 className="text-4xl font-semibold tracking-tight text-gray-900">
        SiteIQ
      </h1>
      <div className="flex w-full max-w-md gap-2">
        <input
          type="text"
          defaultValue="https://www.jordanmoore.dev/"
          className="w-full rounded-md border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
        />
        <button
          type="button"
          className="rounded-md bg-indigo-600 px-4 py-2 font-medium text-white shadow-sm hover:bg-indigo-500"
        >
          Measure
        </button>
      </div>
    </main>
  )
}

export default App
