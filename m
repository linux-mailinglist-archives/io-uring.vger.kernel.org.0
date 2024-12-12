Return-Path: <io-uring+bounces-5454-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 670109EDD29
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 02:39:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A925C2833D9
	for <lists+io-uring@lfdr.de>; Thu, 12 Dec 2024 01:39:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3243152F71;
	Thu, 12 Dec 2024 01:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OjoNxqna"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0993D2AF16;
	Thu, 12 Dec 2024 01:38:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733967538; cv=none; b=V3AeoHWimYKDwUyTB8jybIWtIGusfVNiPQUhHiLGgBA/eheoaveWDx0MWc7nfGSxfXLNiDNz9BE9YV2Qz3pPvtITW9yUdNUZGsR9+eBModTPVizt4GPlvZcnyxK0CEs8+ocA1edUNblnWsIlMo+nmG3N1ewlVWK9PR1tE6g2Cn0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733967538; c=relaxed/simple;
	bh=py6g8lSby1TUB+WCJ5gZK/n+doNDbmI2BOROrpNymmA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RIzUwysRXOo414D2LVbZGRaMIeBBtXzmNUKljLNTnJaI901KoMmRtidE0ySLmiIPGYJWGtJZHix89ZZy3P1vzOwLCjmzCha9fwiwjzM5Z2HYFwa/jf9i+EduTlmToQg1Zi4lp3D3ey4PUIrMNCnqrccB0AVhVz7K7vQ8i+0aJio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OjoNxqna; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01EE4C4CED2;
	Thu, 12 Dec 2024 01:38:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733967537;
	bh=py6g8lSby1TUB+WCJ5gZK/n+doNDbmI2BOROrpNymmA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OjoNxqnasTquIDjA5k+Yav47JIQUnMdqiKSE3HKyEfARHSQkB8Ws24cF7JMate71+
	 0m21SEYOUByf3wTjo4yWbPqVAhMawppiR+A73CoRqoifAqxz+mld9zMIIiECc/YzvN
	 VIZ8rk/7Mv5E8lf6tYsbb1AqvTslJokrNhGtCDfd/jtUJtR3KTHNu0htTQ8az7E5pS
	 YF2kcrGyZTNDSinjEZTLcQsDx4h3RGtlkqnGgExcDm2ZW5TcuWLXoPzAPHW/NKQ5EL
	 Ghi0ayp6+PzBc4noPh4wUjkgfj5p72Dal4EF0uwU5utJn4iOTn530P9aui8ShXdqqd
	 ONiJPtIpD17NQ==
Date: Wed, 11 Dec 2024 17:38:55 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 11/17] io_uring/zcrx: implement zerocopy
 receive pp memory provider
Message-ID: <20241211173855.461cb6ec@kernel.org>
In-Reply-To: <95e02ca4-4f0d-4f74-a882-6c975b345daa@gmail.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-12-dw@davidwei.uk>
	<20241209200156.3aaa5e24@kernel.org>
	<aa20a0fd-75fb-4859-bd0e-74d0098daae8@gmail.com>
	<20241210162412.6f04a505@kernel.org>
	<95e02ca4-4f0d-4f74-a882-6c975b345daa@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 11 Dec 2024 14:42:43 +0000 Pavel Begunkov wrote:
> > I was thinking along the lines of transferring the ownership of
> > the frags. But let's work on that as a follow up. Atomic add on  
> 
> That's fine to leave it out for now and deal later, but what's
> important for me when going through preliminary shittification of
> the project is to have a way to optimise it after and a clear
> understanding that it can't be left w/o it, and that there are
> no strong opinions that would block it.
> 
> The current cache situation is too unfortunate, understandably so
> with it being aliased to struct page. pp_ref_count is in the
> same line with ->pp and others. Here an iov usually gets modified
> by napi, then refcounted from syscall, after deferred skb put will
> put it down back at napi context, and in some time after it gets
> washed out from the cache, the user will finally return it back
> to page pool.

Let's not get distracted. It's very unusual to have arguments about
microoptimizations before the initial version of the code is merged :|

> > an exclusively owned cacheline is 2 cycles on AMD if I'm looking
> > correctly.  
> 
> Sounds too good to be true considering x86 implies a full barrier
> for atomics.

Right but two barriers back to back are hopefully similar impact as one.

> I wonder where the data comes from?

Agner's instruction tables. What source do you use?

