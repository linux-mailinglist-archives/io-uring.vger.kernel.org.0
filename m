Return-Path: <io-uring+bounces-5904-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3B1A1A1302E
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 01:49:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B55163A3DE1
	for <lists+io-uring@lfdr.de>; Thu, 16 Jan 2025 00:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45D96C139;
	Thu, 16 Jan 2025 00:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gowDLU7D"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 192F328691;
	Thu, 16 Jan 2025 00:49:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736988576; cv=none; b=lKLQ/FjAhQvj0zvsIuIH9Htc4U24Av+3V5qh1o/YuQh4O3JNazyq4v8LbJdy6YRshUHqNg60Hd7U81QIEbH6sQ726Qi1jxiYiJoVWf5qSY5a7ikbb6Gdc9h0engF3mbbBxEBoq7N83mSyUrxf3gUen+UgwvC9kOhaxV4unL1ffE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736988576; c=relaxed/simple;
	bh=L7tBeIh9o6JZ5K22NgKyOy72Vq/eCt7bcfYNS6B8kNQ=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lE8ywDmPsAyy5b78hJMBetrHP1lZ1aSK0mdnmc3Vb0RuiKVdl9NAvm8UfTzQ2Ci3IXa+SBERmsaGZBNdVKSJuycyhh/V8BLe6uo2smyO+TAGIstOoYpTCr9nrkplRS2TCUwrzLnN1JFfGt3L0E+JfXuTrE02ri/MraW8TjvINio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gowDLU7D; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CCE0C4CED1;
	Thu, 16 Jan 2025 00:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736988575;
	bh=L7tBeIh9o6JZ5K22NgKyOy72Vq/eCt7bcfYNS6B8kNQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=gowDLU7D1l7R/wsKVO0YhRV8SAdQDbMyRdkp1uK/71Ek9a7TyhtiT4iVhc3UijgE2
	 +VCjwEeXCOG+xCPXw6hr7+BS9y8PznmLpEGswo4BaLoejRG2qxi+A1to70pq+4Vegd
	 HhIK4A4lonRrHY/xVxD04Jq7Z7RwrjJkNPI/ynACtdh2TPn8JIFIK/z8Z0Ljb08nYr
	 eQolgz5lRYP0xdDbpiZznu+DzzDkWQ7ecNTdK5Ik59+n2szuIAgzyNwSD7z8QF+o+F
	 QsxNYmhhZUbrx/jdVYrBqrRAYWrTUvWOYD5bZKPGNqsOHvRLey6QoLCfp9nLvtPrcB
	 71cFj25hr4URg==
Date: Wed, 15 Jan 2025 16:49:34 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v10 11/22] net: page_pool: add memory provider
 helpers
Message-ID: <20250115164934.27b8ea19@kernel.org>
In-Reply-To: <20250108220644.3528845-12-dw@davidwei.uk>
References: <20250108220644.3528845-1-dw@davidwei.uk>
	<20250108220644.3528845-12-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  8 Jan 2025 14:06:32 -0800 David Wei wrote:
> +void net_mp_niov_set_page_pool(struct page_pool *pool, struct net_iov *niov);
> +void net_mp_niov_clear_page_pool(struct net_iov *niov);
> +
> +/*

nit: if you meant this to be a kdoc you're missing a * here.

> + * net_mp_netmem_place_in_cache() - give a netmem to a page pool
> + * @pool:      the page pool to place the netmem into
> + * @netmem:    netmem to give
> + *
> + * Push an accounted netmem into the page pool's allocation cache. The caller
> + * must ensure that there is space in the cache. It should only be called off
> + * the mp_ops->alloc_netmems() path.
> + */
> +static inline void net_mp_netmem_place_in_cache(struct page_pool *pool,
> +						netmem_ref netmem)
> +{
> +	pool->alloc.cache[pool->alloc.count++] = netmem;
> +}

