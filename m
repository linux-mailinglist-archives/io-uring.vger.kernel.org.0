Return-Path: <io-uring+bounces-9432-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id EA431B3AE92
	for <lists+io-uring@lfdr.de>; Fri, 29 Aug 2025 01:50:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A59FC98222D
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 23:50:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E5721276059;
	Thu, 28 Aug 2025 23:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="bSThdl5s"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2B59262FC0;
	Thu, 28 Aug 2025 23:50:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756425009; cv=none; b=Sa24vp+pjCMZcGYkZ4WYT9tDx3/nJCnA6aFGzE6RX1KZubqfC8boWmQo/N5M7w4pBlNILzIKebyTtwTGU9XaOeHRLOK9hUsGmDiK6/2BLnoJLLQB5GQqlBGhwb9K1rh1OxZA0j8ER1FvRMVe2Qcr746o1nOHqYcgCa97HGqfvIc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756425009; c=relaxed/simple;
	bh=e17ImB2Y/pO+JEDTa5g4HLe3a+vtXCoIi5gWJqdD4HY=;
	h=Content-Type:MIME-Version:Subject:From:Message-Id:Date:References:
	 In-Reply-To:To:Cc; b=o1muHGv2ZHSIs/QSQg5NqOC/D18LUUv6osN1ETThjqYkHOKPoDjTUrsHRaj/0UB9uZT8XIR9DNW1iIx3bAS4lXk1t/bkoBu+y3/B6P04r0DzZE98zkHJCumg1b34SAZyran8H56FkhIcflqxzzlf1edOACyPyenotLa6aJ21wa4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=bSThdl5s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 497CFC4CEEB;
	Thu, 28 Aug 2025 23:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756425009;
	bh=e17ImB2Y/pO+JEDTa5g4HLe3a+vtXCoIi5gWJqdD4HY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bSThdl5sMj8UJckeXo86O7E1G4tsHn1RRrQnDQfvnQ9CnFaTxC6W4RtHwV5ToKMrO
	 w/Bf/FH1k3I9vXmNuM/l2bCgqbyl7ZPupkptUWjAL7yb+v3PcL/EUmVBSLWCZE9y+h
	 pwHVAG+HUOQeHZgVFdokM7wXw34Toy/d/FWurC9QJywnCqCLpKRBmiBxL7BNI9tn5x
	 kJMrbnQynmjPOZ77vt5XkhNt1DkUi3yJtjjwlgxalhQ7vNTrq6wCSX0yYpRT5K8mGY
	 bdfOc9Ry8z802zpG3UKMwaHNZ79gILGAjNgNY0NulzOZLyqBwGL/usmgx3kZQymLfT
	 Pq6H2o3jywtEg==
Received: from [10.30.226.235] (localhost [IPv6:::1])
	by aws-us-west-2-korg-oddjob-rhel9-1.codeaurora.org (Postfix) with ESMTP id 70D67383BF75;
	Thu, 28 Aug 2025 23:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v6 0/7] devmem/io_uring: allow more flexibility
 for
 ZC DMA devices
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <175642501625.1650971.15574075096463666063.git-patchwork-notify@kernel.org>
Date: Thu, 28 Aug 2025 23:50:16 +0000
References: <20250827144017.1529208-2-dtatulea@nvidia.com>
In-Reply-To: <20250827144017.1529208-2-dtatulea@nvidia.com>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: almasrymina@google.com, asml.silence@gmail.com, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, horms@kernel.org,
 axboe@kernel.dk, saeedm@nvidia.com, tariqt@nvidia.com, mbloch@nvidia.com,
 leon@kernel.org, andrew+netdev@lunn.ch, cratiu@nvidia.com, parav@nvidia.com,
 netdev@vger.kernel.org, sdf@meta.com, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org, linux-rdma@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 27 Aug 2025 17:39:54 +0300 you wrote:
> For TCP zerocopy rx (io_uring, devmem), there is an assumption that the
> parent device can do DMA. However that is not always the case:
> - Scalable Function netdevs [1] have the DMA device in the grandparent.
> - For Multi-PF netdevs [2] queues can be associated to different DMA
>   devices.
> 
> The series adds an API for getting the DMA device for a netdev queue.
> Drivers that have special requirements can implement the newly added
> queue management op. Otherwise the parent will still be used as before.
> 
> [...]

Here is the summary with links:
  - [net-next,v6,1/7] queue_api: add support for fetching per queue DMA dev
    https://git.kernel.org/netdev/net-next/c/13d8e05adf9d
  - [net-next,v6,2/7] io_uring/zcrx: add support for custom DMA devices
    https://git.kernel.org/netdev/net-next/c/59b8b32ac8d4
  - [net-next,v6,3/7] net: devmem: get netdev DMA device via new API
    https://git.kernel.org/netdev/net-next/c/7c7e94603a76
  - [net-next,v6,4/7] net/mlx5e: add op for getting netdev DMA device
    https://git.kernel.org/netdev/net-next/c/f1debf1a2ef4
  - [net-next,v6,5/7] net: devmem: pull out dma_dev out of net_devmem_bind_dmabuf
    https://git.kernel.org/netdev/net-next/c/512c88fb0e88
  - [net-next,v6,6/7] net: devmem: pre-read requested rx queues during bind
    https://git.kernel.org/netdev/net-next/c/1b416902cd25
  - [net-next,v6,7/7] net: devmem: allow binding on rx queues with same DMA devices
    https://git.kernel.org/netdev/net-next/c/b8aab4bb9585

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



