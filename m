Return-Path: <io-uring+bounces-8673-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97A80B04D37
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 03:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E53B6165940
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 01:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2487A145346;
	Tue, 15 Jul 2025 01:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TS+hm9F8"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96F928F4;
	Tue, 15 Jul 2025 01:11:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752541898; cv=none; b=P+O+E7gRrNZoSevZGg1zrGgnvRu+zzA/j+hZzN9YEPMAw2B2jiYpam0mj1QdN+gFT2qSBKzrwXVBL31g1kYmOblusmuy+1SEvCUZfj1bzMfYM3QoqIcrJOOxatHdG1wykTOA5EHmcaIYWVQFSzZUPMoILH4i59n8WhWTGlADBEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752541898; c=relaxed/simple;
	bh=tILcL9lOOKgHOdK6m9Dq8RGStCv1M3g+AM12QcV3CQE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i0nKTnbiep/reFMgbJRRBhwxKQzBm6MpRLttt12aGS3aD9JTG6M0poQDwymb3AK37dtXr+tlY06VPawaj+FBgHOEmP4kvVZLQf5ktXoNnJNtdS2FJdhFpmQbikirVEUoYFcad0AwsgNNpsBHuKT74PLoIRjXVTBpAfCmMh6VhX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TS+hm9F8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BC39C4CEED;
	Tue, 15 Jul 2025 01:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752541897;
	bh=tILcL9lOOKgHOdK6m9Dq8RGStCv1M3g+AM12QcV3CQE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TS+hm9F8p0PwL4KIr8ShmWzZSW6WZkA+d5Lgjp4xYMy3UCXWuFWBFlbfY0rK0ztUk
	 XzcuELpJ3Gv2GAag9SnnOp0g0DRTbXsVgz6S6tyOvVQ/aNoQd6RSme+QoAutfQsOOv
	 y+6rFEkNSv3t5b587rhhuC2VY6smLS3xJeR15KkE9mR1RZVGjFk8UK/pr9bzJzEnW9
	 Aptv4s2WgdhBNQFKEidsyyFTR3tsHOP4w/nRWws74fvZabDktpmK1RmfAZa57hM6II
	 uvp3Q5RKZZd4b5dJaCGn6qO3Y5JEELrwaYm9p7J9njWXRPRUsviyMYlkrWdDwbeLPm
	 s/aC29uuZ0Stg==
Date: Mon, 14 Jul 2025 18:11:36 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Dragos Tatulea <dtatulea@nvidia.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Andrew Lunn <andrew+netdev@lunn.ch>, Jens Axboe
 <axboe@kernel.dk>, <parav@nvidia.com>, Cosmin Ratio <cratiu@nvidia.com>,
 Tariq Toukan <tariqt@nvidia.com>, Pavel Begunkov <asml.silence@gmail.com>,
 Mina Almasry <almasrymina@google.com>, <netdev@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>, <io-uring@vger.kernel.org>
Subject: Re: [PATCH v2 net-next] net: Allow SF devices to be used for ZC DMA
Message-ID: <20250714181136.7fd53312@kernel.org>
In-Reply-To: <20250711092634.2733340-2-dtatulea@nvidia.com>
References: <20250711092634.2733340-2-dtatulea@nvidia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 11 Jul 2025 09:26:34 +0000 Dragos Tatulea wrote:
> diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> index 5847c20994d3..53aa63d6e5a3 100644
> --- a/include/linux/netdevice.h
> +++ b/include/linux/netdevice.h
> @@ -5560,4 +5560,25 @@ extern struct net_device *blackhole_netdev;
>  		atomic_long_add((VAL), &(DEV)->stats.__##FIELD)
>  #define DEV_STATS_READ(DEV, FIELD) atomic_long_read(&(DEV)->stats.__##FIELD)
>  
> +static inline struct device *netdev_get_dma_dev(const struct net_device *dev)
> +{
> +	struct device *dma_dev = dev->dev.parent;
> +
> +	if (!dma_dev)
> +		return NULL;
> +
> +	/* Common case: dma device is parent device of netdev. */
> +	if (dma_dev->dma_mask)
> +		return dma_dev;
> +
> +	/* SF netdevs have an auxdev device as parent, the dma device being the
> +	 * grandparent.
> +	 */
> +	dma_dev = dma_dev->parent;
> +	if (dma_dev && dma_dev->dma_mask)
> +		return dma_dev;
> +
> +	return NULL;
> +}

LGTM, but we need a better place for this function. netdevice.h is
included directly by 1.5k files, and indirectly by probably another 5k.
It's not a great place to put random helpers with 2 callers. 
Maybe net/netdev_rx_queue.h and net/core/netdev_rx_queue.c?
I don't think it needs to be a static inline either.
-- 
pw-bot: cr

