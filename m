Return-Path: <io-uring+bounces-5387-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B52119EA6F9
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 05:06:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 749942831CC
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:06:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B77DF22258B;
	Tue, 10 Dec 2024 04:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IvadmxrY"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CD611D79A3;
	Tue, 10 Dec 2024 04:06:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733803598; cv=none; b=YtqDTj2bX1m3XiWf2YDB28/qmu9FjdI9vOlweWH2tFBBCg1rRc/504AwjMljIfD62IQkuRCsblRMqRenx2b27R32NfzLoRp3h/oX/SaeWv/7hoys/GNHluJTHDW74O4L/TrhYgf4Dc6X5T0DjdWZm67+Dr7CtvAZb6cuYjwP5vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733803598; c=relaxed/simple;
	bh=Z9MSlpT6pO+CDpMvGNjA66WOMoimHkeIXJF9L4bBQKk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IN3c6sxj4tVnGlnW4SyFpFQtbThOzkXCWCVc8GTCeLItn6mQJqGMWVtFoAXsYWmfGo0Mlvx9CVny5Az4FWUot4Xqc2QcYt5YWEdhI97/pov485Q1xLXz6Py7mx8DPP6wNmY89sZudqRz9dSiDMuDDflftQbztuaArYabSeNFab0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IvadmxrY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88DC7C4CED6;
	Tue, 10 Dec 2024 04:06:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733803598;
	bh=Z9MSlpT6pO+CDpMvGNjA66WOMoimHkeIXJF9L4bBQKk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=IvadmxrY8MQnoq5+8WvkBggkqLITuZ/V4OOLeMGxslVg6+pWEYpK2UDciEGk3lG+T
	 4jPvAaXE+oxecWrXDQLrxjZmAArVStM7DycT2KH4KnDRDQK/kR3xlmPnlDxzZ8I9a1
	 bhfHUz0NgUqsxVG3/NdJdD3LbOBQsP1pavFU64E1+ZsK++vvZjVF0c6dzWTe7EXgy0
	 nNBxkNAwsK7JEaStyAdQRR4aVX+rdpK4EtCC3v3jkQIhGKfqS0aKR0nSps2yMPc0Er
	 V9HOBTvRuHQyoz+fqmUIxzv4kf4hC4u3Gxr9BEb27qv6rudFuk2YpFtK2MEyCkz0Oi
	 nkhDZIkPefGVQ==
Date: Mon, 9 Dec 2024 20:06:36 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 04/17] net: prepare for non devmem TCP
 memory providers
Message-ID: <20241209200636.56a3dbae@kernel.org>
In-Reply-To: <12cb04de-dfbe-4247-b1d6-8e6feae640d8@gmail.com>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-5-dw@davidwei.uk>
	<20241209191526.063d6797@kernel.org>
	<12cb04de-dfbe-4247-b1d6-8e6feae640d8@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Dec 2024 03:53:36 +0000 Pavel Begunkov wrote:
> >> @@ -353,16 +356,16 @@ void page_pool_unlist(struct page_pool *pool)
> >>   int page_pool_check_memory_provider(struct net_device *dev,
> >>   				    struct netdev_rx_queue *rxq)
> >>   {
> >> -	struct net_devmem_dmabuf_binding *binding = rxq->mp_params.mp_priv;
> >> +	void *mp_priv = rxq->mp_params.mp_priv;
> >>   	struct page_pool *pool;
> >>   	struct hlist_node *n;
> >>   
> >> -	if (!binding)
> >> +	if (!mp_priv)
> >>   		return 0;
> >>   
> >>   	mutex_lock(&page_pools_lock);
> >>   	hlist_for_each_entry_safe(pool, n, &dev->page_pools, user.list) {
> >> -		if (pool->mp_priv != binding)
> >> +		if (pool->mp_priv != mp_priv)
> >>   			continue;
> >>   
> >>   		if (pool->slow.queue_idx == get_netdev_rx_queue_index(rxq)) {  
> > 
> > appears to be unrelated  
> 
> The entire chunk? It removes the type, nobody should be blindly casting
> it to devmem specific binding even if it's not referenced, otherwise it
> gets pretty ugly pretty fast. E.g. people might assume that it's always
> the right type to cast to.

Change is good. It didn't feel very related to the other changes
which specifically address devmem code. While this one only removes 
the type because the code itself isn't devmem specific. Right?

if you make this chunk a separate patch #1 in the series I can apply it
right away. pp->mp_priv is void *, this is a good cleanup regardless.

