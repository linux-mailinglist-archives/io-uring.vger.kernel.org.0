Return-Path: <io-uring+bounces-10357-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 12DC3C2E7B5
	for <lists+io-uring@lfdr.de>; Tue, 04 Nov 2025 00:50:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 8FE9D34C306
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 23:50:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F9B62FF667;
	Mon,  3 Nov 2025 23:50:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxrUiOrn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB81F29B20A;
	Mon,  3 Nov 2025 23:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762213822; cv=none; b=Jf/yyjpMYrELUA4Pg4za5emnPjjh8m1Y4y7jbOMfZ9gC98eR8zoYNvn9JT44AQYg/Aw5P0hHlfW6PVafs5auedg18fPJD1JET0Cmk5QzR0xNtG5JOCLiTbit2crZ3/gBC5gRlpuJM6AvLVTr+RMw3UQdvguHVR1XzqoFS/fNDDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762213822; c=relaxed/simple;
	bh=WMY/eAXt80l03jJnHXmzPf4/X5caqk1MeutwEflAyCQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kHvPFQfDIs/qVH1ex1dV5TRgfqniqMQKtBhGYTeL43nHx+Sf3TowT5w61qVwUlgkHjvo8V5Nxyb2EsYLt779DavPmYPNEpkxIoKYAC2eeQJN7PNI/nDvZ6K/uYkA4PCHb0GHqpb9Fwn0Ws7OYzcNfZw7sFM1XRNAu4QFVmPdeg0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxrUiOrn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD330C4CEE7;
	Mon,  3 Nov 2025 23:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762213821;
	bh=WMY/eAXt80l03jJnHXmzPf4/X5caqk1MeutwEflAyCQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JxrUiOrnJNmW3xwmMi66ybUxOW03D7BTn53adG4jiaXB6PqtVjj72lKqhHtd2tnBl
	 mdkkurecPB5d48QmVDqwNn10TNzpTU9mGQ7YYuEdOfelml56z2Fk66BolBJjh3TOxb
	 4nk07m+7HN2KXA49+YNqSbXROX7+8z7zaxo+i4ErFpbDLpsmlO2LMAhgr3nfaE7soI
	 rwfLr8mOpYKT4xYuo78zmdn/eseDZhScOurQOWkPcLqHTQJ6+blqS4+OOiI6W3CqdQ
	 kzX+sihkuyR0VW6dSW6RoeIdlCdi/rxyrnR3ecmmr7Q/t8LyJEecj90IgFjEK53tUI
	 /6uPbosizD/ig==
Date: Mon, 3 Nov 2025 15:50:19 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>
Subject: Re: [PATCH v3 2/2] net: io_uring/zcrx: call
 netdev_queue_get_dma_dev() under instance lock
Message-ID: <20251103155019.08789f78@kernel.org>
In-Reply-To: <20251101022449.1112313-3-dw@davidwei.uk>
References: <20251101022449.1112313-1-dw@davidwei.uk>
	<20251101022449.1112313-3-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri, 31 Oct 2025 19:24:49 -0700 David Wei wrote:
> netdev ops must be called under instance lock or rtnl_lock, but
> io_register_zcrx_ifq() isn't doing this for netdev_queue_get_dma_dev().
> Fix this by taking the instance lock using netdev_get_by_index_lock().
> 
> Extended the instance lock section to include attaching a memory
> provider. Could not move io_zcrx_create_area() outside, since the dmabuf
> codepath IORING_ZCRX_AREA_DMABUF requires ifq->dev.
> 
> Fixes: 59b8b32ac8d4 ("io_uring/zcrx: add support for custom DMA devices")
> Signed-off-by: David Wei <dw@davidwei.uk>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

