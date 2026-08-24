function MeasureForm({ url, onUrlChange, onSubmit }) {
  return (
    <form onSubmit={onSubmit} className="flex w-full max-w-md gap-2">
      <input
        type="text"
        value={url}
        onChange={(e) => onUrlChange(e.target.value)}
        className="w-full rounded-md border border-gray-300 px-3 py-2 text-gray-900 shadow-sm focus:border-indigo-500 focus:outline-none focus:ring-1 focus:ring-indigo-500"
      />
      <button
        type="submit"
        className="rounded-md bg-indigo-600 px-4 py-2 font-medium text-white shadow-sm hover:bg-indigo-500"
      >
        Measure
      </button>
    </form>
  )
}

export default MeasureForm
