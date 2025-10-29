Return-Path: <io-uring+bounces-10289-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 130B6C1DD59
	for <lists+io-uring@lfdr.de>; Thu, 30 Oct 2025 00:56:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3E8223AD3F5
	for <lists+io-uring@lfdr.de>; Wed, 29 Oct 2025 23:55:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF68A32143C;
	Wed, 29 Oct 2025 23:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NcMA9IIN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5C333203B2;
	Wed, 29 Oct 2025 23:54:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761782098; cv=none; b=DK6j1wkOixImxr/F4xVj5Jh3WRRbl+azFPVPav2IPEm22p0jpS5IhBmRwl3IAc152NAQn8MTnt4P4MTpu5VNpbjWobOSdRhX3Z9Cx581U0ei32iNUeCRkG7+iqg4g473IDj1ysC2gaVJ5inyR93p8sqBQzbXhCKUztj6Xv+GpmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761782098; c=relaxed/simple;
	bh=742GIbTdsDbx0L0rpTnF8hXu0JvNPDPjbBgRoioZqnE=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PXez6z1TNSIBsiGBBQh6CLcHOKAPPkeiHwiNckC4gni+LjTc3/Xd0Fj9WsxyFDIcqcdFJ+IMpdgZFhDF2QUYsMIPzTyq+/YxuMw5sQ2XggNeZBCe4Cwyv2NwNz8TJv5F3c9wg3Dw1ugY4ZL6uLLrRk5eutu7szjJLrDSxt8H/aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NcMA9IIN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E57DFC4CEF7;
	Wed, 29 Oct 2025 23:54:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761782098;
	bh=742GIbTdsDbx0L0rpTnF8hXu0JvNPDPjbBgRoioZqnE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=NcMA9IINoPWQvikkKTw2tu6laETU394Zad5MzQwvQpzKBC3ol5fkAnd7qM+I9akkm
	 nuz1VnZYi3DPn/D/EPgO8cfxgv8RgY8wo97nVwfQlwG9ygj8/vg8CtyGf8sdiP8YvD
	 xan28uH+axbBf+GZZX++Moq8RmLxHQHsC7ZtF60Alep396W76SVrylhX/EBra5/fMB
	 Vo6YKR0Fr0SY/AYh9OzPWmccseDB3HOY58u1lej6z7wavyhp47rKzRU+i4NyrtMnUr
	 VFTJ9W4EqbSfck/JDmRLVKS7akzhvyFtsOfeBA7w6enOHrq07W+3JHDQfhDbfSG+Wq
	 SPQkyOjJONd1A==
Date: Wed, 29 Oct 2025 16:54:57 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH v2 2/2] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
Message-ID: <20251029165457.557f8f7d@kernel.org>
In-Reply-To: <20251029231654.1156874-3-dw@davidwei.uk>
References: <20251029231654.1156874-1-dw@davidwei.uk>
	<20251029231654.1156874-3-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Oct 2025 16:16:54 -0700 David Wei wrote:
> +	ifq->netdev = netdev_get_by_index_lock(current->nsproxy->net_ns, reg.if_idx);
>  	if (!ifq->netdev) {
>  		ret = -ENODEV;
> -		goto err;
> +		goto netdev_unlock;
>  	}
>  
>  	ifq->dev = netdev_queue_get_dma_dev(ifq->netdev, reg.if_rxq);
>  	if (!ifq->dev) {
>  		ret = -EOPNOTSUPP;
> -		goto err;
> +		goto netdev_unlock;
>  	}
> +	netdev_hold(ifq->netdev, &ifq->netdev_tracker, GFP_KERNEL);
>  	get_device(ifq->dev);
>  
>  	ret = io_zcrx_create_area(ifq, &area);
>  	if (ret)
> -		goto err;
> +		goto netdev_unlock;

Without looking at larger context this looks sus.
You're jumping to the same label before and after you took the ref on
the netdev..

