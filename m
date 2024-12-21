Return-Path: <io-uring+bounces-5592-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E916D9F9DE7
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 03:17:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id C24717A28C8
	for <lists+io-uring@lfdr.de>; Sat, 21 Dec 2024 02:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4446433981;
	Sat, 21 Dec 2024 02:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sX+uDWUn"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18AE81799B;
	Sat, 21 Dec 2024 02:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734747432; cv=none; b=G1fjlrH4uFiAzZD3eaq/MUfXPc0EvaEI4lXwQxJbubsenWwL+XC2eOTwyp6WCYKrABtXPP8TNEiUcRFT14xGYdTSIffJu0Dj7X4XjyhLifVo3O2WSJep6DIJCxLpkxT2Cyh/QG2eJUz56nzqYQjCTwEHtC4Y4/ugG0P4XL1Sq/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734747432; c=relaxed/simple;
	bh=clQAnOdrTApie7Ogbhp8w//FdijyQDap8ohFhe+tXd0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dablgadis28gnqJckxJCkWBax8ZElhp17j43TxRbZMjTKTdY3a0UyS6EY6dNi/DQ02Wu8DnYbBfddbDiqud0v7f8WYH1CxA4yo8fiM4IqmXUMo8x654pHJmZ0ZVdWFlGuYTPzhMPODTn4cXDbtFjbH9cCJBhc4QwUyDxtZX+u/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sX+uDWUn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C99C7C4CECD;
	Sat, 21 Dec 2024 02:17:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734747431;
	bh=clQAnOdrTApie7Ogbhp8w//FdijyQDap8ohFhe+tXd0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=sX+uDWUnSYH5qSlVISuVZUd4YmXRa6UCCWoQ5p9nPx9Y3nUndQCinC1wgf6vdLsfT
	 eh3OvDxTKsfsc3yMiWfJwpAu8or07NljRwaU3cW8HmVA3GIEaXNUuk7ZFgaQyuRT7F
	 2RUF2ZTtm8tX6yyaT4zhMhs8k+MO8lCilDTC2xIV8S83dkdrg2PEOYuteZre6Le3Kd
	 FGziSiirP9Xl8i5WsSRbEsHYK85lCEBBGZ+etQDHq3xhUgjoflgYswORwFURV2VYjd
	 WacevurHRM1KItEukPSB24IGO/CaQVoqcJMz2v5JQKSKtoXfXB6yPTwAvbPF2Yo0Ek
	 GXJ0Iyf6sLzYw==
Date: Fri, 20 Dec 2024 18:17:09 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 03/20] net: generalise net_iov chunk owners
Message-ID: <20241220181709.3e48c266@kernel.org>
In-Reply-To: <5d308d1b-4c9d-430e-b116-e669bd778b30@gmail.com>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-4-dw@davidwei.uk>
	<20241220141436.65513ff7@kernel.org>
	<5d308d1b-4c9d-430e-b116-e669bd778b30@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sat, 21 Dec 2024 00:50:37 +0000 Pavel Begunkov wrote:
> > Is there a good reason why dma addr is not part of net_iov_area?
> > net_iov_area is one chunk of continuous address space.
> > Instead of looping over pages in io_zcrx_map_area we could map
> > the whole thing in one go.  
> 
> It's not physically contiguous. The registration API takes
> contig user addresses, but that's not a hard requirement
> either.

Okay, I was thrown off by the base_virtual being in the common struct.
But it appears you don't use that?

AFAIR for devmem each area is physically contiguous if the region is 
not it gets split into areas.

