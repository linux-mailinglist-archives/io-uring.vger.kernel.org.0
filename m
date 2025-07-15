Return-Path: <io-uring+bounces-8681-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2334FB05ACA
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 15:07:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C47733B19A1
	for <lists+io-uring@lfdr.de>; Tue, 15 Jul 2025 13:06:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 930992E266C;
	Tue, 15 Jul 2025 13:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IVyyJsxv"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6945E1C860A;
	Tue, 15 Jul 2025 13:06:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752584811; cv=none; b=WmW9wdSSqVZVofkhKssKftLQEPhC1kG9XUYgrgIiWjtYbf4trdGq+edBgP8U3lULHapRBn0qsIKBWA1lwd5gPHLpt1EX25ZtMMRIl8ZoSFD/Z14SlTr+ctlzNPFtTZyTUxQPHZ06re45RfMv6DtY2JAGhFp8avDEBn+8HrpCmbI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752584811; c=relaxed/simple;
	bh=bafqguJWmXLYYlTq9y7yrUcgb2q8KMWK6ngMv9tRjeM=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uykW3Ts8KrQb9v17ps8pyJ3qohaZnmWg2Q7/W1vz5itnvdLykwDPD6aNyi9CRCqw7Rp3I/rEkgPpHxUd+4iTly81PIfcMIhFpilUJtOE91BSHoPPVJcUyyO918FfzUiGfJpHHdWEIoIdyw/zLn4wBYicOv2ZKPwK+WsfH1CWwVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IVyyJsxv; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85D19C4CEE3;
	Tue, 15 Jul 2025 13:06:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752584811;
	bh=bafqguJWmXLYYlTq9y7yrUcgb2q8KMWK6ngMv9tRjeM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IVyyJsxvGSqsedu0Re6yN9Jid9yCV65jOVf83KiowRDGNaC42SKzb7IER0MvKl8SV
	 LhYWQlcpkG3l+8tNydtpmfV5yC4UdT+K9hsi0kcEP0n6K3Rc0Evm8ZVhmiJoSh3Vwp
	 SSDocwPHhKJIUu8H/c/NoapbDxShDyVsjM+NPZWJaLDR4pl+0wwVaoc7kHSrLfEeja
	 0YbsWQzHQ6ZZS5riO+V0RfGFTbypRm5JCbnf+nnyRhwBHamWDUshw0z16CGj2BX087
	 bBDIbeultNeoQHQioCUoqVFmywdfgoaWUb8wcRweKPD8aSLfNmcnPcQekrjQeSA/68
	 lmih8z6hhzYuQ==
Date: Tue, 15 Jul 2025 06:06:49 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dragos Tatulea <dtatulea@nvidia.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Andrew Lunn
 <andrew+netdev@lunn.ch>, Jens Axboe <axboe@kernel.dk>, parav@nvidia.com,
 Cosmin Ratio <cratiu@nvidia.com>, Tariq Toukan <tariqt@nvidia.com>, Pavel
 Begunkov <asml.silence@gmail.com>, Mina Almasry <almasrymina@google.com>,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
 io-uring@vger.kernel.org
Subject: Re: [PATCH v2 net-next] net: Allow SF devices to be used for ZC DMA
Message-ID: <20250715060649.03b3798c@kernel.org>
In-Reply-To: <aHXbgr67d1l5atW8@infradead.org>
References: <20250711092634.2733340-2-dtatulea@nvidia.com>
	<20250714181136.7fd53312@kernel.org>
	<aHXbgr67d1l5atW8@infradead.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 14 Jul 2025 21:39:30 -0700 Christoph Hellwig wrote:
> > LGTM, but we need a better place for this function. netdevice.h is
> > included directly by 1.5k files, and indirectly by probably another 5k.
> > It's not a great place to put random helpers with 2 callers. 
> > Maybe net/netdev_rx_queue.h and net/core/netdev_rx_queue.c?
> > I don't think it needs to be a static inline either.  
> 
> The whole concept is also buggy.  Trying to get a dma-able device by
> walking down from an upper level construct like the netdevice can't work
> reliably.  You'll need to explicitly provide the dma_device using either
> a method or a pointer to it instead of this guesswork.

Yeah, I'm pretty sure we'll end up with a method in queue ops.
But it's not that deep, an easy thing to change.

