Return-Path: <io-uring+bounces-347-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 8D75B81BF36
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 20:44:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BFD571C23FC2
	for <lists+io-uring@lfdr.de>; Thu, 21 Dec 2023 19:44:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11EF1651BB;
	Thu, 21 Dec 2023 19:44:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PgFiJ2lm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625C3651B3;
	Thu, 21 Dec 2023 19:44:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a268836254aso142673166b.1;
        Thu, 21 Dec 2023 11:44:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703187845; x=1703792645; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pbdJM7jcrT7OuR7e65CGFmz1ctkL4cu4WD9zPciMeig=;
        b=PgFiJ2lmymCG6ahweFrUKY7xpQ3otwfO4JeLMTSHwBi1Gqa5gHifCqOX62WoKLswij
         Q2LJT+J8Yc8amTB/Ps0p16q7/ErAyRWkscfHLfDkTut01JD1LfrIAIgY4/prx0WhlPo/
         ILvOTn+IUitI27iGqloIOo124ZOeH+HdDz1Idg3hYpDnjSR7n38f6Nz3FKVRg88rxy1a
         vJyF+117bUv8ZbjZb8nYd5tjN3B36i1cNIVZpr+znGkwB8Q5LJXSBsP8QKbld2pqwiIE
         09/YbqWW/f6lcuNwFnEaQMYd4hA8+1X94z00zQnMUcF6AQ04qi9LwH7E8VnL0yEJ1x82
         ZvRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703187845; x=1703792645;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pbdJM7jcrT7OuR7e65CGFmz1ctkL4cu4WD9zPciMeig=;
        b=X02kUXKlX1A4gHEPct48bBgNOuGIJXrDx4mP27i5M4R5LesiVlRPGAPr+/24F/gHih
         t0Lv8aUNO0CkPWRIqTfx5H12/qF16s8JP/lFln+6KS5+TiS1OlwHl++HoC7yNue4ZcUJ
         QSUwLUCTI3vc0kZ0UaHB1vOL4bdY4ewBgO1ZxKDvwBG6ugCyeUfrsrND0WZo3ZUbJKXf
         iUmcPu2ef+MAmaesRaVPYVIsfVZPfZucvAmwOWVR4a3vO4q/mx0XnJ5dKQYRYo8Ybd/r
         0T2olo+nhEyAtPDD5xVrMBOq7ReIr317lXxYn+wwK+I36VgzilMYHgWtxNT+TPmTxI4y
         RJIA==
X-Gm-Message-State: AOJu0YzTCdJwM7auN/aNfxgZecwqyOImllXjgwmIO1S9qXtJyfS/21TU
	Vyx0tP+Avyw0Rk9sGrSDBeY=
X-Google-Smtp-Source: AGHT+IFtRsBBU/iMf3HpwSw1YOa7QY160mG45mUhzQkYn/EGkHHNai5PQFJqYl622MpVHW5Cu6iQiA==
X-Received: by 2002:a17:906:74de:b0:a1e:437c:6a6d with SMTP id z30-20020a17090674de00b00a1e437c6a6dmr123779ejl.95.1703187845387;
        Thu, 21 Dec 2023 11:44:05 -0800 (PST)
Received: from [192.168.8.100] ([185.69.145.35])
        by smtp.gmail.com with ESMTPSA id cl2-20020a170906c4c200b00a19afc16d23sm1264296ejb.104.2023.12.21.11.44.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Dec 2023 11:44:05 -0800 (PST)
Message-ID: <3986f106-051d-46c8-8ec3-82558f670253@gmail.com>
Date: Thu, 21 Dec 2023 19:36:27 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 13/20] io_uring: implement pp memory provider for
 zc rx
Content-Language: en-US
To: David Wei <dw@davidwei.uk>, io-uring@vger.kernel.org,
 netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, Jakub Kicinski <kuba@kernel.org>,
 Paolo Abeni <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>,
 Eric Dumazet <edumazet@google.com>, Jesper Dangaard Brouer
 <hawk@kernel.org>, David Ahern <dsahern@kernel.org>,
 Mina Almasry <almasrymina@google.com>
References: <20231219210357.4029713-1-dw@davidwei.uk>
 <20231219210357.4029713-14-dw@davidwei.uk>
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20231219210357.4029713-14-dw@davidwei.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/19/23 21:03, David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> We're adding a new pp memory provider to implement io_uring zerocopy
> receive. It'll be "registered" in pp and used in later paches.
> 
> The typical life cycle of a buffer goes as follows: first it's allocated
> to a driver with the initial refcount set to 1. The drivers fills it
> with data, puts it into an skb and passes down the stack, where it gets
> queued up to a socket. Later, a zc io_uring request will be receiving
> data from the socket from a task context. At that point io_uring will
> tell the userspace that this buffer has some data by posting an
> appropriate completion. It'll also elevating the refcount by
> IO_ZC_RX_UREF, so the buffer is not recycled while userspace is reading
> the data. When the userspace is done with the buffer it should return it
> back to io_uring by adding an entry to the buffer refill ring. When
> necessary io_uring will poll the refill ring, compare references
> including IO_ZC_RX_UREF and reuse the buffer.
> 
> Initally, all buffers are placed in a spinlock protected ->freelist.
> It's a slow path stash, where buffers are considered to be unallocated
> and not exposed to core page pool. On allocation, pp will first try
> all its caches, and the ->alloc_pages callback if everything else
> failed.
> 
> The hot path for io_pp_zc_alloc_pages() is to grab pages from the refill
> ring. The consumption from the ring is always done in the attached napi
> context, so no additional synchronisation required. If that fails we'll
> be getting buffers from the ->freelist.
> 
> Note: only ->freelist are considered unallocated for page pool, so we
> only add pages_state_hold_cnt when allocating from there. Subsequently,
> as page_pool_return_page() and others bump the ->pages_state_release_cnt
> counter, io_pp_zc_release_page() can only use ->freelist, which is not a
> problem as it's not a slow path.
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>
> ---
...
> +static void io_zc_rx_ring_refill(struct page_pool *pp,
> +				 struct io_zc_rx_ifq *ifq)
> +{
> +	unsigned int entries = io_zc_rx_rqring_entries(ifq);
> +	unsigned int mask = ifq->rq_entries - 1;
> +	struct io_zc_rx_pool *pool = ifq->pool;
> +
> +	if (unlikely(!entries))
> +		return;
> +
> +	while (entries--) {
> +		unsigned int rq_idx = ifq->cached_rq_head++ & mask;
> +		struct io_uring_rbuf_rqe *rqe = &ifq->rqes[rq_idx];
> +		u32 pgid = rqe->off / PAGE_SIZE;
> +		struct io_zc_rx_buf *buf = &pool->bufs[pgid];
> +
> +		if (!io_zc_rx_put_buf_uref(buf))
> +			continue;

It's worth to note that here we have to add a dma sync as per
discussions with page pool folks.

> +		io_zc_add_pp_cache(pp, buf);
> +		if (pp->alloc.count >= PP_ALLOC_CACHE_REFILL)
> +			break;
> +	}
> +	smp_store_release(&ifq->ring->rq.head, ifq->cached_rq_head);
> +}
> +
> +static void io_zc_rx_refill_slow(struct page_pool *pp, struct io_zc_rx_ifq *ifq)
> +{
> +	struct io_zc_rx_pool *pool = ifq->pool;
> +
> +	spin_lock_bh(&pool->freelist_lock);
> +	while (pool->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
> +		struct io_zc_rx_buf *buf;
> +		u32 pgid;
> +
> +		pgid = pool->freelist[--pool->free_count];
> +		buf = &pool->bufs[pgid];
> +
> +		io_zc_add_pp_cache(pp, buf);
> +		pp->pages_state_hold_cnt++;
> +		trace_page_pool_state_hold(pp, io_zc_buf_to_pp_page(buf),
> +					   pp->pages_state_hold_cnt);
> +	}
> +	spin_unlock_bh(&pool->freelist_lock);
> +}
...

-- 
Pavel Begunkov

