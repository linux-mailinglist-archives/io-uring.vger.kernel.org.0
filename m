Return-Path: <io-uring+bounces-5385-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B80B9EA6DE
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:02:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E96CE282AAF
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:02:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC08821505D;
	Tue, 10 Dec 2024 04:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="AZRTCm5y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A41751F63FF;
	Tue, 10 Dec 2024 04:01:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803318; cv=none; b=YhCo99bxhHnNQeDcbeo7fsi+z/L8PobKDVH898AgkYWvg0ATKwycpASxBkqWe4nO+KxNKOVXGgMWLi+t1cBt99q7ADrNvdukQp2pQiSq8eDNvbD8cIWsl7gQOqO31RTYCedQ3sxh6El7zYI57t+kI3HHmZyYNi5e8Pod54IHzZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803318; c=relaxed/simple;
	bh=kzBmwTgvVQyhtEF8y0LkaGKsLhJjXvWIvowcfid8J2k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GWX7+XtUmE0yHl1b3Ez8o83jnM4tbuNLjkzaIb1kB/V5qEnJMb1ALiu1LiG/Trt8UJYTeEdnOkPmBNWwtR4EBarsz1DaBvSLNkAquOoyoV1pU8ACDBPbNhEQ0kwlJ9TsvHzqiRAY+VmJZl6oo+ZD3zWTqzILC4/feILZC1I9v7g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=AZRTCm5y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CCC7C4CED6;
	Tue, 10 Dec 2024 04:01:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733803318;
	bh=kzBmwTgvVQyhtEF8y0LkaGKsLhJjXvWIvowcfid8J2k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=AZRTCm5yJK5m1D3W+JMNCTUH8s/FgB8V4iAekFZTV/zDcDlPpzXdWv5v9FmLF10lO
	 0HnpaCUw/9uSIV5I6H8t1+V9jDEDeHXj5iqZLeYDYbK9+1BE6V8bZwalODOPC17Ir4
	 3hUYlv4u3VWPDJdTG8KNjfGXHeJRmwEsvkML9HaxtdB2oCa1oE6Qzwj2e5GTmIRg6X
	 eqyl2r9Tu+xqLvuycF9KiIamODY0zz2eUDRvH1nkhgrMepyR4L66iSiutBSqx+w7sT
	 fIaT4+xlt+QIZWsC34oWaPj4bEP92NVQLgp+JpoFCxL353+KytZZyXznH1oNxYB7qo
	 b1Ic/4dexj25Q==
Date: Mon, 9 Dec 2024 20:01:56 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 11/17] io_uring/zcrx: implement zerocopy
 receive pp memory provider
Message-ID: <20241209200156.3aaa5e24@kernel.org>
In-Reply-To: <20241204172204.4180482-12-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-12-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Dec 2024 09:21:50 -0800 David Wei wrote:
> Then, either the buffer is dropped and returns back to the page pool
> into the ->freelist via io_pp_zc_release_netmem, in which case the page
> pool will match hold_cnt for us with ->pages_state_release_cnt. Or more
> likely the buffer will go through the network/protocol stacks and end up
> in the corresponding socket's receive queue. From there the user can get
> it via an new io_uring request implemented in following patches. As
> mentioned above, before giving a buffer to the user we bump the refcount
> by IO_ZC_RX_UREF.
> 
> Once the user is done with the buffer processing, it must return it back
> via the refill queue, from where our ->alloc_netmems implementation can
> grab it, check references, put IO_ZC_RX_UREF, and recycle the buffer if
> there are no more users left. As we place such buffers right back into
> the page pools fast cache and they didn't go through the normal pp
> release path, they are still considered "allocated" and no pp hold_cnt
> is required. For the same reason we dma sync buffers for the device
> in io_zc_add_pp_cache().

Can you say more about the IO_ZC_RX_UREF bias? net_iov is not the page
struct, we can add more fields. In fact we have 8B of padding in it
that can be allocated without growing the struct. So why play with
biases? You can add a 32b atomic counter for how many refs have been
handed out to the user.

