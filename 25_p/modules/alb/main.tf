
resource "helm_release" "alb_controller" {
  provider   = helm
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  namespace  = "kube-system"
  version    = "1.6.2"

  values = [
    yamlencode({
      clusterName = var.cluster_name
      region      = "ap-northeast-2"
      vpcId       = var.vpc_id

      serviceAccount = {
        create = false
        name   = "aws-load-balancer-controller"
      }

      image = {
        repository = "602401143452.dkr.ecr.ap-northeast-2.amazonaws.com/amazon/aws-load-balancer-controller"
      }

      ingressClass = "alb"
      enableServiceMutatorWebhook = true
    })
  ]
}
