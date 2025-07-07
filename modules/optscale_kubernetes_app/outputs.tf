output "frontend_ip_address" {
  description = "The external IP address of the OptScale frontend service."
  value       = kubernetes_service.optscale_frontend.status[0].load_balancer[0].ingress[0].ip
}
