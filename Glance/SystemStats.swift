import Foundation
import Combine
import Darwin

class SystemStats: ObservableObject {
    @Published var cpuUsage: Double = 0
    @Published var ramUsed: Double = 0
    @Published var ramTotal: Double = 0
    @Published var diskFree: Double = 0
    @Published var diskTotal: Double = 0
    @Published var netUpload: Double = 0
    @Published var netDownload: Double = 0

    @Published var refreshInterval: Double = 1.0 {
        didSet { restartTimer() }
    }
    @Published var warnThreshold: Double = 60.0
    @Published var critThreshold: Double = 80.0

    private var timer: Timer?
    private var prevNetOut: UInt64 = 0
    private var prevNetIn: UInt64 = 0

    init() {
        startMonitoring()
    }

    func startMonitoring() {
        timer = Timer.scheduledTimer(withTimeInterval: refreshInterval, repeats: true) { _ in
            DispatchQueue.main.async {
                self.updateCPU()
                self.updateRAM()
                self.updateDisk()
                self.updateNetwork()
            }
        }
    }

    func restartTimer() {
        timer?.invalidate()
        startMonitoring()
    }

    func updateCPU() {
        var cpuInfo = processor_info_array_t(bitPattern: 0)
        var numCpuInfo: mach_msg_type_number_t = 0
        var numCpus: natural_t = 0

        let result = host_processor_info(mach_host_self(), PROCESSOR_CPU_LOAD_INFO,
                                         &numCpus, &cpuInfo, &numCpuInfo)
        guard result == KERN_SUCCESS, let cpuInfo else { return }

        var totalUsed: Double = 0
        var totalTicks: Double = 0

        for i in 0..<Int(numCpus) {
            let base = Int(CPU_STATE_MAX) * i
            let user   = Double(cpuInfo[base + Int(CPU_STATE_USER)])
            let system = Double(cpuInfo[base + Int(CPU_STATE_SYSTEM)])
            let nice   = Double(cpuInfo[base + Int(CPU_STATE_NICE)])
            let idle   = Double(cpuInfo[base + Int(CPU_STATE_IDLE)])
            totalUsed  += user + system + nice
            totalTicks += user + system + nice + idle
        }

        cpuUsage = totalTicks > 0 ? (totalUsed / totalTicks) * 100 : 0
        vm_deallocate(mach_task_self_, vm_address_t(bitPattern: cpuInfo), vm_size_t(numCpuInfo))
    }

    func updateRAM() {
        var stats = vm_statistics64()
        var count = mach_msg_type_number_t(MemoryLayout<vm_statistics64>.size / MemoryLayout<integer_t>.size)
        let pageSize = Double(vm_page_size)

        withUnsafeMutablePointer(to: &stats) {
            $0.withMemoryRebound(to: integer_t.self, capacity: Int(count)) {
                _ = host_statistics64(mach_host_self(), HOST_VM_INFO64, $0, &count)
            }
        }

        let used = Double(stats.active_count + stats.wire_count) * pageSize
        let total = Double(ProcessInfo.processInfo.physicalMemory)
        ramUsed  = used  / 1_073_741_824
        ramTotal = total / 1_073_741_824
    }

    func updateDisk() {
        let url = URL(fileURLWithPath: "/")
        let values = try? url.resourceValues(forKeys: [.volumeTotalCapacityKey, .volumeAvailableCapacityKey])
        let total = Double(values?.volumeTotalCapacity ?? 0)
        let avail = Double(values?.volumeAvailableCapacity ?? 0)
        diskTotal = total / 1_073_741_824
        diskFree  = avail / 1_073_741_824
    }

    func updateNetwork() {
        var ifaddr: UnsafeMutablePointer<ifaddrs>?
        guard getifaddrs(&ifaddr) == 0 else { return }

        var totalIn: UInt64 = 0
        var totalOut: UInt64 = 0
        var ptr = ifaddr

        while let interface = ptr {
            let addr = interface.pointee.ifa_addr
            if addr?.pointee.sa_family == UInt8(AF_LINK) {
                let data = unsafeBitCast(interface.pointee.ifa_data,
                                         to: UnsafeMutablePointer<if_data>.self)
                totalIn  += UInt64(data.pointee.ifi_ibytes)
                totalOut += UInt64(data.pointee.ifi_obytes)
            }
            ptr = interface.pointee.ifa_next
        }
        freeifaddrs(ifaddr)

        if prevNetIn > 0 {
            netDownload = Double(totalIn  - prevNetIn)  / 1024
            netUpload   = Double(totalOut - prevNetOut) / 1024
        }
        prevNetIn  = totalIn
        prevNetOut = totalOut
    }
}
