Return-Path: <io-uring+bounces-5380-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 74AC19EA6C2
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:41:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 73F8B1679AA
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16FA6168BE;
	Tue, 10 Dec 2024 03:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JRUwD7Hs"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE783AD5A;
	Tue, 10 Dec 2024 03:40:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733802059; cv=none; b=NsPau34oykCXXwSEkKt7NH+zb3flzrkFd0MNhyHXkXaBSSrHTWp5akJ8Es6vG6+o0ab6JUV+0S8IWw26xNDlqruO24mtrPa7oMTlvAM6fKiwjcVN/Ef0H4Nsup6uXuWkA06slpARtCy7gGLP+WhTUf+8tCSp8JQnE5N9CsBMTeE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733802059; c=relaxed/simple;
	bh=gYok4tQZmyOvYQ2Dl+Gn48EII0mGjsbBoIhzt4ebACU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FhPICaGhlgiu5IxaYK3ZRlxZAL6ymyp9FrDAJddgERDAPWVCmy5aYNi05+sTS/rnlbHMKeQTQtrHGR4M49HSezdkbTdAgp4XkM6ejc6Euxh74SaR3VkZq4U0+DoG0RkyQ+r/armKzIHd4WKgzm+40Xu8b4rdXQKK2oHrYoDNY6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JRUwD7Hs; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6013C4CED6;
	Tue, 10 Dec 2024 03:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733802058;
	bh=gYok4tQZmyOvYQ2Dl+Gn48EII0mGjsbBoIhzt4ebACU=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=JRUwD7HsTt7/sZ3+nVEw6pmn4cmHV9TZqe+dEQSxYwFUSrBPl+PnTELtbyZ1p7TkJ
	 khOYk9U7IAY3kCLaAhekhogGsLsL0SlQGVZS+kaCm4psV2TMOBPqpn7p+Ut9MEExrE
	 O4ZzKnp/iQr3n5CA1+rYTYERGFDqDwkxd4mLbEEb9CarCMiOojRkURV40AIBTi4Zw2
	 hRteubKciIlAz0gcF+LEF1jS67gqydg2Vdo2UywFl/o5JRP4wXQsZtF/L20BdPCWUb
	 629Ap8qaeS81CeDmatTU5s/dD6kHRCFJWp86RjUvxl4VnNtIRpAP43NkqSDOBRpMTX
	 7m9HYo2vppMVg==
Date: Mon, 9 Dec 2024 19:40:57 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 07/17] net: page_pool: introduce
 page_pool_mp_return_in_cache
Message-ID: <20241209194057.161e9183@kernel.org>
In-Reply-To: <20241204172204.4180482-8-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-8-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Dec 2024 09:21:46 -0800 David Wei wrote:
> +/*
> + * page_pool_mp_return_in_cache() - return a netmem to the allocation cache.
> + * @pool:	pool from which pages were allocated
> + * @netmem:	netmem to return
> + *
> + * Return already allocated and accounted netmem to the page pool's allocation
> + * cache. The function doesn't provide synchronisation and must only be called
> + * from the napi context.

NAPI is irrelevant, this helper, IIUC, has to be called down the call
chain from mp_ops->alloc().

> + */
> +void page_pool_mp_return_in_cache(struct page_pool *pool, netmem_ref netmem)
> +{
> +	if (WARN_ON_ONCE(pool->alloc.count >= PP_ALLOC_CACHE_REFILL))
> +		return;

I'd

	return false;

without a warning.

> +	page_pool_dma_sync_for_device(pool, netmem, -1);
> +	page_pool_fragment_netmem(netmem, 1);
> +	pool->alloc.cache[pool->alloc.count++] = netmem;

and here:

	return true;

this say mps can use return value as a stop condition in a do {} while()
loop, without having to duplicate the check.

	do {
		netmem = alloc...
		... logic;
	} while (page_pool_mp_alloc_refill(pp, netmem));

	/* last netmem didn't fit in the cache */
	return netmem;

