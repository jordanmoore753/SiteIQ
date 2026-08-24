function SaveButton({ onClick }) {
  return (
    <button
      type="button"
      onClick={onClick}
      className="rounded-md bg-gray-900 px-4 py-2 font-medium text-white shadow-sm hover:bg-gray-700"
    >
      Save
    </button>
  )
}

export default SaveButton
