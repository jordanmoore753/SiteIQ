function MeasurementsList({ measurements }) {
  return (
    <ul className="w-full max-w-md divide-y divide-gray-200 rounded-md border border-gray-200 bg-white shadow-sm">
      {measurements.map((measurement) => (
        <li
          key={measurement.name}
          className="flex items-center justify-between px-4 py-3"
        >
          <span className="text-gray-900">{measurement.name}</span>
          <span
            className={measurement.ok ? 'text-green-600' : 'text-red-600'}
          >
            {measurement.unit === 'ms'
              ? `${Math.round(measurement.value / 10) * 10} ms`
              : measurement.unit
                ? `${measurement.value} ${measurement.unit}`
                : measurement.value}
          </span>
        </li>
      ))}
    </ul>
  )
}

export default MeasurementsList
