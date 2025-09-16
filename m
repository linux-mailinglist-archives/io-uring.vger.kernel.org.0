Return-Path: <io-uring+bounces-9799-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id EA471B58B35
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 03:31:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2AF85520ADA
	for <lists+io-uring@lfdr.de>; Tue, 16 Sep 2025 01:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B911B20CCE4;
	Tue, 16 Sep 2025 01:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pxqG5lE7"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B943824A3;
	Tue, 16 Sep 2025 01:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757986239; cv=none; b=BkEu7EH3zGvfgTYCgySqUoM4yiJ3aBveVUYVKH9VhBTdO+vuwpH/MEqpudu5M8uhH97jy1rdANkp9v+MLH5vWq35eMKUEK0gvF4uoHYegNNCsuanTi5dRP7AuUNRzRSdi8/r8TGG86Ck0GjpNH/cYI6G/BhesNd7h2ZQbgXB+no=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757986239; c=relaxed/simple;
	bh=v9tC8NiGK9d1Q1Se1trYoJ8mZvSBVLWX2i6c4mciDCQ=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=HDuCXe3cq0PPGQO8dpGpI6ANIDf/DssqQRTuNK2WU+gikonIaHOh3DJolgnfRIncNNEwfvGPCTIZWw3CY2MkIBsByZZ3H9oVGSkkIrqkjHj8steAZSPWp08u4eFmnE7CK7n+XW5mqzckPygPCfIIHZr4Gl7U+NY9L6icnRsdYVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pxqG5lE7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AC33C4CEF1;
	Tue, 16 Sep 2025 01:30:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757986239;
	bh=v9tC8NiGK9d1Q1Se1trYoJ8mZvSBVLWX2i6c4mciDCQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=pxqG5lE7BEaXo8yXYR1n7DpO+ePghIH9ud4/ipVp59Jd4BWL8CYcrRifqXoxmAGmb
	 79/dRdQnQTvxIRE3P+c4gd6KD7kOAIZ3rn1/Bk3joxgx6D36tAWIOIaZE6dRVui9VP
	 RKmJ4PEGSYNZBaDslYGmwQyJ8SYSF63TPWoje/2N+6ezafnKAIYhNu4XYyJwbqZebK
	 K3V+8qg30D8QgjT25vVKyAcKS8/gxPfuhKmgwGK4FgFc6Ty4E/N/c/HllW+2GCtHxt
	 u0Ip0PJkbnzUhHwqsYretAiZFyJoujj9a3NzFFIp1f/xT9V+T9sEkP4GOrhcsmBuRl
	 UhnhXollRKB7A==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id ADF2039D0C17;
	Tue, 16 Sep 2025 01:30:41 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] io_uring/zcrx: fix ifq->if_rxq is -1,
 get dma_dev is NULL
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175798624024.559370.11569066407695924130.git-patchwork-notify@kernel.org>
Date: Tue, 16 Sep 2025 01:30:40 +0000
References: <20250912140133.97741-1-zhoufeng.zf@bytedance.com>
In-Reply-To: <20250912140133.97741-1-zhoufeng.zf@bytedance.com>
To: Feng zhou <zhoufeng.zf@bytedance.com>
Cc: axboe@kernel.dk, asml.silence@gmail.com, almasrymina@google.com,
 kuba@kernel.org, edumazet@google.com, pabeni@redhat.com, horms@kernel.org,
 saeedm@nvidia.com, tariqt@nvidia.co, mbloch@nvidia.com, leon@kernel.org,
 andrew+netdev@lunn.ch, dtatulea@nvidia.com, netdev@vger.kernel.org,
 io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 yangzhenze@bytedance.com, wangdongdong.6@bytedance.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 12 Sep 2025 22:01:33 +0800 you wrote:
> From: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> ifq->if_rxq has not been assigned, is -1, the correct value is
> in reg.if_rxq.
> 
> Fixes: 59b8b32ac8d469958936fcea781c7f58e3d64742 ("io_uring/zcrx: add support for custom DMA devices")
> Signed-off-by: Feng Zhou <zhoufeng.zf@bytedance.com>
> 
> [...]

Here is the summary with links:
  - [net-next] io_uring/zcrx: fix ifq->if_rxq is -1, get dma_dev is NULL
    https://git.kernel.org/netdev/net-next/c/3a0ac202534b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



