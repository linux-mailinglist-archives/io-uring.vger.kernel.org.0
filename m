Return-Path: <io-uring+bounces-8643-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B1889B00FDB
	for <lists+io-uring@lfdr.de>; Fri, 11 Jul 2025 01:48:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EC0FA643AF8
	for <lists+io-uring@lfdr.de>; Thu, 10 Jul 2025 23:47:09 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B4424728A;
	Thu, 10 Jul 2025 23:47:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TqD4ht0h"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02B84241666;
	Thu, 10 Jul 2025 23:47:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752191252; cv=none; b=Vglj7E2XKbCG25K40RclpOzeOkNDI9zan3ucfFbF0f4dzwH/N4J0R2wj7fPGTNDCZffvbUqALnYOeFfzFkB7xrnIpWJbFt+f0uLqnyxk0H3HYh6PONWkmq+QES/1UTGcuLo1oLrJEm4jrRziylfRQ/VyduyeWwFIGdpGx4oMj04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752191252; c=relaxed/simple;
	bh=7lf+SzstrNJX5Ua/EchjuQ1gKKFkmcXlel1SeweLDtQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOaQi6ZJjCeBSsXueB5UoTfQV9OV4LppOLD5hF5xUUc/WiF9ukSobLmhDSQav7GlMzbmJGPR36MzOYoGInCZeIXhm/2S9D2BekTAxvHECruzR1ZDCAnnhgHKgVI+ElwJJWLZoI3S+ZmR2D9QgGCJdzB7BwWXVoS6ITYk7Jv0oI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TqD4ht0h; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B30D7C4CEE3;
	Thu, 10 Jul 2025 23:47:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752191251;
	bh=7lf+SzstrNJX5Ua/EchjuQ1gKKFkmcXlel1SeweLDtQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=TqD4ht0hDGu0Gf9F3/3Couj2TWls7DeFBkJXPERhZCDK5ihANxMFm9yV4DKCLhQsU
	 sJ+SvunVscPvR8e2H+jtgFz48R6nEG0C+xup0MbPCHHAEhFfwaHub4JRkZU0mGJG2X
	 M/XLp7rmkcGj+CyI7wDis8EF7E47O+jFfsNw+S/INDceW5yGrHH+jdaxbolWDkWAIR
	 ExTs9k4VF1DCt7gsuuUDC8XEAveg9R8uqhbUCKT/Ra7Cc8VFYjOBQOUU9pEi58VkNa
	 wut+3CEm+5CrfXxP9IG1EjROTsY0cdAtN0aErtoz39E/Lma+22bspd9V0xHltHli2z
	 nTRFAQ57PVYOg==
Date: Thu, 10 Jul 2025 16:47:29 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Mina Almasry <almasrymina@google.com>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, asml.silence@gmail.com, Andrew
 Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Simon
 Horman <horms@kernel.org>, Jens Axboe <axboe@kernel.dk>, Simona Vetter
 <simona.vetter@ffwll.ch>, Willem de Bruijn <willemb@google.com>, Kaiyuan
 Zhang <kaiyuanz@google.com>, cratiu@nvidia.com, parav@nvidia.com, Tariq
 Toukan <tariqt@nvidia.com>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH net] net: Allow non parent devices to be used for ZC DMA
Message-ID: <20250710164729.275f62fd@kernel.org>
In-Reply-To: <CAHS8izP18q7s8=fGCjknrEu3uJE5xnQCKceB8u1VvTV5GxTTTg@mail.gmail.com>
References: <20250709124059.516095-2-dtatulea@nvidia.com>
	<CAHS8izNHXvtXF+Xftocvi+1E2hZ0v9FiTWBxaY7NWhemhPy-hQ@mail.gmail.com>
	<bm4uszrqfszm5sgigrtmo2piowoaxzsprwxuezfze4lgbt22ki@rn2w2sncivv3>
	<CAHS8izP18q7s8=fGCjknrEu3uJE5xnQCKceB8u1VvTV5GxTTTg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 9 Jul 2025 15:56:16 -0700 Mina Almasry wrote:
> > > nit: This doesn't seem like a fix? The current code supports all
> > > devices that are not SF well enough, right? And in the case of SF
> > > devices, I expect net_devmem_bind_dmabuf() to fail gracefully as the
> > > dma mapping of a device that doesn't support it, I think, would fail
> > > gracefully. So to me this seems like an improvement rather than a bug
> > > fix.
> > >  
> > dma_buf_map_attachment_unlocked() will return a sg_table with 0 nents.
> > That is graceful. However this will result in page_pools that will
> > always be returning errors further down the line which is very confusing
> > regarding the motives that caused it.
> >
> > I am also fine to not make it a fix btw. Especially since the mlx5
> > devmem code was just accepted.
> 
> If you submit another version I'd rather it be a non-fix, especially
> since applying the io_uring hunk will be challenging when backporting
> this patch, but I assume hunk can be dropped while backporting, so I'm
> fine either way.

+1 for non-fix. The core is working as expected, if we want a Fixes tag
I'd aim it at mlx5 and make the patch reject queue binding to SFs
_within mlx5_ until the core bits are figured out.

