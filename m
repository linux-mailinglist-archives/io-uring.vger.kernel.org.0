Return-Path: <io-uring+bounces-5593-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 1CE219F9DEB
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 03:23:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 325D81891DA5
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 02:23:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 451A433CFC;
	Sat, 21 Dec 2024 02:23:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Nf5iLDX/"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F67282EE;
	Sat, 21 Dec 2024 02:23:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734747786; cv=none; b=Ad8u9d5l0vY4PeacP7zGwxoNNBTcSuo3eEJqpglMyxtHjtsaKoSk4SUDdLwmnG9r2EmauQaTf9mHLf5C3rJOJVUOyHwkNjNGGEWmL0ZBOyspWbN1nY+cZBvMqym2TYU/Uke5ggXtxAivyOGbNs5bhWFyz1WuhfmMGYdsec5yOgo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734747786; c=relaxed/simple;
	bh=SC/50/T4rdgx6qcF/47GR8JEKPWS5maSOU2isW0MCoY=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qNf4DTbzgTKSMOsCg76iahc46w9Q155879zpWRYdleyvVbaQstVWQdAS9NV26hKM5mWvV/z6izPxxyxzgelWUqbsZ5m97dkxofqOGvRaJL8jRdpZo2TRWrx53cMOVleLd70chA7vOIHhutTmN7Bj3+5yXs7UXy+eBZuwKpWieKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Nf5iLDX/; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1476CC4CECD;
	Sat, 21 Dec 2024 02:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734747785;
	bh=SC/50/T4rdgx6qcF/47GR8JEKPWS5maSOU2isW0MCoY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Nf5iLDX/WqI2LSMn+xFIam5gmaBV0xnqTjOOSTeIY/UuKphNBdHdtGDKhT6l+gsua
	 xMu0lMpyEbvvZ+eAMT+9ZVdPSsKxUaiB/QF8TQBhwrfy6PbOp4hD0uoKC7diDBJsV+
	 qfDumqRRZZZ68p9dfIE+pEJ7GyhSAGFQ2H2sN+unzc0Vl1v3o7tCVJg7/VfxCAI0ZJ
	 LeZJ2qPh29nDLYYB2lseYiDJVNOnHdQRfrmutZbQVJOnvIu9it8DoHYYjHNi2GdrGA
	 mWZ4hnq2YkGM8dUybyDgxBRdfCj097D//lruIo8i27AsEHpqwyoMFI4EeDSY+VS931
	 PU/8LjRLpH1vA==
Date: Fri, 20 Dec 2024 18:23:04 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 08/20] net: expose
 page_pool_{set,clear}_pp_info
Message-ID: <20241220182304.59753594@kernel.org>
In-Reply-To: <99969285-e3f9-4ec8-8caf-f29ae75eb814@gmail.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-9-dw@davidwei.uk>
	<20241220143158.11585b2d@kernel.org>
	<99969285-e3f9-4ec8-8caf-f29ae75eb814@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 21 Dec 2024 01:07:44 +0000 Pavel Begunkov wrote:
> >> Memory providers need to set page pool to its net_iovs on allocation, so
> >> expose page_pool_{set,clear}_pp_info to providers outside net/.  
> > 
> > I'd really rather not expose such low level functions in a header
> > included by every single user of the page pool API.  
> 
> Are you fine if it's exposed in a new header file?

I guess.

I'm uncomfortable with the "outside net/" phrasing of the commit
message. Nothing outside net should used this stuff. Next we'll have
a four letter subsystem abusing it and claiming that it's in a header
so it's a public.

Maybe we should have a conversation about whether io_uring/zcrx.c 
is considered part of networking, whether all patches will get cross
posted and need to get acks from both sides etc. Save ourselves
unpleasant misunderstandings.

