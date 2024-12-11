Return-Path: <io-uring+bounces-5425-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 605789EBFC8
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 01:06:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1BC28283E6C
	for <lists+io-uring@lfdr.de>; Wed, 11 Dec 2024 00:06:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 43B7F195;
	Wed, 11 Dec 2024 00:06:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LV3pbIfJ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E9BEC4;
	Wed, 11 Dec 2024 00:06:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733875614; cv=none; b=N/WP4uWeLZd6pn19BJM4Mq1PeSFliUc6awfObvcXRHCoRc/HSyN9KHeAV0+EIK05FW5FuEu33BKgEqCI7/vr8ylhKzlgXizn8OsAotw1WNpV8rRwdtSc9YB8mDBg2HdQW7AL5yma0YrtlR8rJ4IGAPLbCsvUcySdGZVhpp7GhqU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733875614; c=relaxed/simple;
	bh=Q0xDJhoumS6SK4KZTkewFgu5ZjY6X4lL0E/F4WlCvP0=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mFHDCi1MlfDMeJjDZ3uHh6uW8va8/jBfy5XtIiMRYcJFRXEvqrZFWiPYmfyCOrik9hTuAUdAYkVXfWKW1MGEF7LvqGyGGFZ1KF8Je6tnpAPY2NDe8fHedOIUNhFoFlU/QNqniV9nUs/JTQb86p8dny89tHDgrbm7YrZVXkzPYy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LV3pbIfJ; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB5ACC4CED6;
	Wed, 11 Dec 2024 00:06:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733875613;
	bh=Q0xDJhoumS6SK4KZTkewFgu5ZjY6X4lL0E/F4WlCvP0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=LV3pbIfJ9XYGTBYZA4wWCfSnbR8UKWkGdey3/DgCAZjVV511CY2CRFoeARwjN/D9V
	 EWHX9W+TUpzzGh5ml8qo0dnX3ufKGNppjjaIDsgKr5ntUTEuDzp20KIHuNw3owC9x5
	 Sg+IiUNJZTWFmSMZFllDKyVIw1BnpYRh8aS59oIjqhU2XIxxQEISXbH+eoN0vxNtOY
	 X5FQMcYpOp1n2JBdSxE8cLf16IuGzdZ04ET5BB3jKzYEwfPJl53bv70S415Ovv26bA
	 9ArpS6cNj/mjt+sDHkp+SjEp+TB1JdJ6cZfrdJvf5OSGm+Wg9IuwasBt7gFfV2LpHr
	 tNqohNEQmqEhg==
Date: Tue, 10 Dec 2024 16:06:51 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 07/17] net: page_pool: introduce
 page_pool_mp_return_in_cache
Message-ID: <20241210160651.32b5e8f8@kernel.org>
In-Reply-To: <fc1715f6-c123-43c6-9562-f84c7aab4ed2@gmail.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-8-dw@davidwei.uk>
	<20241209194057.161e9183@kernel.org>
	<fc1715f6-c123-43c6-9562-f84c7aab4ed2@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 04:31:53 +0000 Pavel Begunkov wrote:
> >> +	page_pool_dma_sync_for_device(pool, netmem, -1);
> >> +	page_pool_fragment_netmem(netmem, 1);
> >> +	pool->alloc.cache[pool->alloc.count++] = netmem;  
> > 
> > and here:
> > 
> > 	return true;
> > 
> > this say mps can use return value as a stop condition in a do {} while()
> > loop, without having to duplicate the check.
> > 
> > 	do {
> > 		netmem = alloc...
> > 		... logic;
> > 	} while (page_pool_mp_alloc_refill(pp, netmem));
> > 
> > 	/* last netmem didn't fit in the cache */
> > 	return netmem;  
> 
> That last netmem is a problem. Returning it is not a bad option,
> but it doesn't feel right. Providers should rather converge to
> one way of returning buffers and batching here is needed.
> 
> I'd rather prefer this one then
> 
> while (pp_has_space()) {
> 	netmem = alloc();
> 	pp_push(netmem);
> }
> 
> Any thoughts on that?

No strong preference. If I was the one who placed the ->alloc() call
the way it is placed it's probably because it saves us a conditional,
it saves us checking if the cache is empty. 

If we want to have the page pool pick the last object out of the cache
I'd lean towards avoiding all the helpers. Make the callback:

 void alloc_netmem(struct page_pool *pool, gfp_t gfp,
                   size_t cnt, netmem_ref *arr);

you get an @arr(ay) to fill up with up to @cnt elements. Mirroring
alloc_pages_bulk_array_node() (down to its, to me at least, unusual
ordering of arguments).

