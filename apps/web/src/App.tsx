import './App.css'

function App() {
  return (
    <div className="min-h-screen bg-gray-50">
      {/* Header */}
      <header className="bg-white shadow-sm">
        <div className="max-w-7xl mx-auto px-4 py-4 flex items-center justify-between">
          <h1 className="text-xl font-bold text-gray-900">Mono With Go</h1>
          <nav className="flex gap-4">
            <a href="#" className="text-gray-600 hover:text-gray-900">Home</a>
            <a href="#" className="text-gray-600 hover:text-gray-900">About</a>
          </nav>
        </div>
      </header>

      {/* Main */}
      <main className="max-w-7xl mx-auto px-4 py-12">
        <div className="text-center">
          <h2 className="text-4xl font-bold text-gray-900 mb-4">
            React + Go Monorepo
          </h2>
          <p className="text-lg text-gray-600 mb-8">
            Frontend with React & Tailwind | Backend with Gin + GORM + JWT
          </p>
          <div className="inline-flex gap-3">
            <span className="px-3 py-1 bg-blue-100 text-blue-800 rounded-full text-sm font-medium">
              React
            </span>
            <span className="px-3 py-1 bg-cyan-100 text-cyan-800 rounded-full text-sm font-medium">
              Tailwind
            </span>
            <span className="px-3 py-1 bg-emerald-100 text-emerald-800 rounded-full text-sm font-medium">
              Go
            </span>
            <span className="px-3 py-1 bg-orange-100 text-orange-800 rounded-full text-sm font-medium">
              Gin
            </span>
          </div>
        </div>

        {/* API Test Section */}
        <div className="mt-16 max-w-md mx-auto">
          <div className="bg-white rounded-lg shadow p-6">
            <h3 className="text-lg font-semibold text-gray-900 mb-4">API Health Check</h3>
            <p className="text-gray-600 text-sm mb-4">
              Click the button to test the Go backend API connection.
            </p>
            <button
              onClick={async () => {
                try {
                  const res = await fetch('/api/health')
                  const data = await res.json()
                  alert(JSON.stringify(data, null, 2))
                } catch {
                  alert('API not available. Make sure the Go server is running.')
                }
              }}
              className="w-full bg-indigo-600 text-white py-2 px-4 rounded-md hover:bg-indigo-700 transition-colors cursor-pointer"
            >
              Test API
            </button>
          </div>
        </div>
      </main>
    </div>
  )
}

export default App
