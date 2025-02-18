Return-Path: <io-uring+bounces-6512-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43623A3A7FA
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 20:47:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1C443172760
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2025 19:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37A733C1F;
	Tue, 18 Feb 2025 19:47:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key) header.d=ijzerbout.nl header.i=@ijzerbout.nl header.b="nsRDHHiF"
X-Original-To: io-uring@vger.kernel.org
Received: from bout3.ijzerbout.nl (bout3.ijzerbout.nl [136.144.140.114])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A747D21B9EA;
	Tue, 18 Feb 2025 19:47:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.144.140.114
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739908042; cv=none; b=Gd4NnW72gDcR50m4O/Om4cenX8zkj9amIKQ1dSjVIiOHmHJH1PA16+RZwOj+5jVeIwT3HQrdPRtWoeN5I36Zp0Dec6PN/3TDQR1mmJ3OpbFYkca2GDCdoMOXYT4aJx/+iiQWpf4kP9DIXxzdVprevU16xMdSTH2SOArNgPEX1K4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739908042; c=relaxed/simple;
	bh=KEeAPqwdWAl+/oPSkdxO2/o1p3K53MqPyinGxQV+SCc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ppnf3HU8oz445ebp/ZMN9aSV9hiTWJG39WDSE/UwljAfNiu6q7CZsRk7MV0sNt2LFprRHAJLy8hSBp3pZU9mBQBqe938R/t7spOpibQ5jj8L4aAxUQs/plTx3rbsPFcMAN19GSWDsfxEQloJvEBX9NwDwDXJ2TnJuo87G4M4310=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ijzerbout.nl; spf=pass smtp.mailfrom=ijzerbout.nl; dkim=pass (4096-bit key) header.d=ijzerbout.nl header.i=@ijzerbout.nl header.b=nsRDHHiF; arc=none smtp.client-ip=136.144.140.114
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=ijzerbout.nl
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ijzerbout.nl
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ijzerbout.nl; s=key;
	t=1739907661; bh=KEeAPqwdWAl+/oPSkdxO2/o1p3K53MqPyinGxQV+SCc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nsRDHHiFwywQtXgRDqOg7hjVJsQ0/sF2W7aCUa+/Ad7ruWuhbmpjm4C2LoIVDIiOi
	 TJT/tnwg1gpZUXUpR+Dgp0vpCap9Xz5JitoJ1ALe3v2y6qt1Ilxs+D6VDeURMB9MGB
	 85nrbbgQUDZYPxZsG/gJgcCv4UEG30ZUqoonLv6dJXwQdC8BpxfkAc7uXVoprpNsAL
	 pOQ6Pi1E1OhDqM9SyjgiPiX79y67eEa/ix8uB4XvrbYjgNM9uYbnsLVgS4kIJ6rplr
	 I0qAPRcTNNXV4T0mV6FtK9ez1tLV6HmJOVdJR9tyQVda0qceQeLkZBMiho5qjri30n
	 I2GFY+YMwru43a6I8qSPtU5X9Km4zBexDfNW2sDf1cUbON2c1U5U05HhFuy9osCaJJ
	 qSdr/vqIqZ1+NXPkHByrACB6TdAm4rcsl9BWrubDbOoU4mL61Xl2D6VirfWBndqgaW
	 gFklSNwK25MDnoO6KrnrHEq+q064+mefWJvQ4nXeUe2lopbn3Ha0IVwZP2m7uVRkrf
	 otkeUCFbUTNVE1gqawN9cVCywsxSIlrkzJz3K1l5Ihhm2o0qch05nqYz8MFf2lrK7y
	 cOwdfa2MkuAoW/JwYHn2AdyQ0JRfS9MafLgpMu0TlAYnB7bw2C6uED3x8N1AO6m1cs
	 XmPfzleEbPJgqicX6UMn9Gwk=
Received: from [IPV6:2a10:3781:99:1:1ac0:4dff:fea7:ec3a] (racer.ijzerbout.nl [IPv6:2a10:3781:99:1:1ac0:4dff:fea7:ec3a])
	by bout3.ijzerbout.nl (Postfix) with ESMTPSA id 540CF160133;
	Tue, 18 Feb 2025 20:41:00 +0100 (CET)
Message-ID: <cc1b81b3-f02c-46d0-b4be-34bba23d20c7@ijzerbout.nl>
Date: Tue, 18 Feb 2025 20:40:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 07/11] io_uring/zcrx: set pp memory provider for an rx
 queue
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>, lizetao <lizetao1@huawei.com>
References: <20250215000947.789731-1-dw@davidwei.uk>
 <20250215000947.789731-8-dw@davidwei.uk>
Content-Language: en-US
From: Kees Bakker <kees@ijzerbout.nl>
In-Reply-To: <20250215000947.789731-8-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Op 15-02-2025 om 01:09 schreef David Wei:
> Set the page pool memory provider for the rx queue configured for zero
> copy to io_uring. Then the rx queue is reset using
> netdev_rx_queue_restart() and netdev core + page pool will take care of
> filling the rx queue from the io_uring zero copy memory provider.
>
> For now, there is only one ifq so its destruction happens implicitly
> during io_uring cleanup.
>
> Reviewed-by: Jens Axboe <axboe@kernel.dk>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
>   io_uring/zcrx.c | 49 +++++++++++++++++++++++++++++++++++++++++--------
>   1 file changed, 41 insertions(+), 8 deletions(-)
>
> diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
> index 8833879d94ba..7d24fc98b306 100644
> --- a/io_uring/zcrx.c
> +++ b/io_uring/zcrx.c
> [...]
> @@ -444,6 +475,8 @@ void io_shutdown_zcrx_ifqs(struct io_ring_ctx *ctx)
>   
>   	if (ctx->ifq)
>   		io_zcrx_scrub(ctx->ifq);
> +
> +	io_close_queue(ctx->ifq);
If ctx->ifq is NULL (which seems to be not unlikely given the if 
statement above)
then you'll get a NULL pointer dereference in io_close_queue().
>   }
>   
>   static inline u32 io_zcrx_rqring_entries(struct io_zcrx_ifq *ifq)


