import torch

def anneal_dsm_score_estimation(scorenet, samples, sigmas, labels=None, anneal_power=2., hook=None):
    if labels is None:
        labels = torch.randint(0, len(sigmas), (samples.shape[0],), device=samples.device)
    used_sigmas = sigmas[labels].view(samples.shape[0], *([1] * len(samples.shape[1:])))
    # noise = torch.randn_like(samples) * used_sigmas
    # 使用伽马分布 Gamma(a^2, a) 其中 a=10000，并减去均值 a
    a = 10000
    gamma_dist = torch.distributions.gamma.Gamma(a ** 2, a)
    # 生成伽马分布随机数并减去均值 a
    noise = (gamma_dist.sample(samples.shape).to(samples.device) - a) * used_sigmas

    perturbed_samples = samples + noise
    # target = - 1 / (used_sigmas ** 2) * noise
    # 新的target计算公式：-\frac{used_sigmas+a\cdot noise}{used_sigmas\cdot noise+a\cdot used_sigmas^{2}}
    target = -(used_sigmas + a * noise) / (used_sigmas * noise + a * used_sigmas ** 2)

    scores = scorenet(perturbed_samples, labels)
    target = target.view(target.shape[0], -1)
    scores = scores.view(scores.shape[0], -1)
    loss = 1 / 2. * ((scores - target) ** 2).sum(dim=-1) * used_sigmas.squeeze() ** anneal_power

    if hook is not None:
        hook(loss, labels)

    return loss.mean(dim=0)
