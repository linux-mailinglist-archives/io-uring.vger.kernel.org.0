Return-Path: <io-uring+bounces-5379-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A87329EA6A5
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 04:30:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4FEFB1888680
	for <lists+io-uring@lfdr.de>; Tue, 10 Dec 2024 03:30:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 880061D5CFB;
	Tue, 10 Dec 2024 03:30:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="M/MQun+s"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C6101BEF8B;
	Tue, 10 Dec 2024 03:30:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733801401; cv=none; b=l+3F3U/vq4Sry9jPQRq00TJ6KySGl2KKDNpry1ukR0qvxSi/9xgfgpDtoeobo4D6TAHRuy5GHWceYK/nIhqXlx6orgNAGJYeOe//9Kxig6vra5rqJCgWre+joB6w6eDKwsNkxBYqn6KHzVNFCJ/SFNaNp0bmsrcretnMAjh1DQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733801401; c=relaxed/simple;
	bh=HcWoaK439QTaY/DOc4afGwl8pFNb+PCJ7dAnkLL7e4k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MM9TpTSuCcCbmkIWRyve8I0KQcbpOva0RP9NFom5MeipLXQO91Tj9Vq+ctwOVY0uJfwpnv4IFS0vV4i3Qi+dScnUnp/+GOjd9SlWJyB6cKa/bw2te2i3AcA3OPykdQm08OC+pb59aZULckkRsR8gHZ7B3ki2YBnheVKxZUZghOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=M/MQun+s; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6167CC4CED6;
	Tue, 10 Dec 2024 03:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1733801400;
	bh=HcWoaK439QTaY/DOc4afGwl8pFNb+PCJ7dAnkLL7e4k=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=M/MQun+sIrYfdZCh9CNqjL7ftXtStBD9UtTfmzKgfTEoWm6YPFYtptK1seAQQFr5m
	 Wlzt9VJaLP7W1lvI2HQ04K4rT3Fzj+p6+CLkeT7Jo7WXGJqSdImcfDg5T3J7AgRHKo
	 hBn0SiuWi/kPyhBYSiwjE2AYjp1MN0otY5m/xqddsmU3zUkBn/y3+YsIlmlX/ulhV2
	 iuNwkm32uNM86pMwyUqAP8aL+pRl5pAEomKAkAnwm6kMCNbijT6Hc1MHQZLSpexD2y
	 yx39x/6fBzRtGaX5qcsvvGhElCdQmDEJGCZAZe7CGGRqp7BmG8G5r677ZzVuCjsKDk
	 tPoY1vzxjjt+g==
Date: Mon, 9 Dec 2024 19:29:59 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v8 06/17] net: page pool: add helper creating
 area from pages
Message-ID: <20241209192959.42425232@kernel.org>
In-Reply-To: <20241204172204.4180482-7-dw@davidwei.uk>
References: <20241204172204.4180482-1-dw@davidwei.uk>
	<20241204172204.4180482-7-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed,  4 Dec 2024 09:21:45 -0800 David Wei wrote:
> From: Pavel Begunkov <asml.silence@gmail.com>
> 
> Add a helper that takes an array of pages and initialises passed in
> memory provider's area with them, where each net_iov takes one page.
> It's also responsible for setting up dma mappings.
> 
> We keep it in page_pool.c not to leak netmem details to outside
> providers like io_uring, which don't have access to netmem_priv.h
> and other private helpers.

User space will likely give us hugepages. Feels a bit wasteful to map
and manage them 4k at a time. But okay, we can optimize this later.

> diff --git a/include/net/page_pool/memory_provider.h b/include/net/page_pool/memory_provider.h
> new file mode 100644
> index 000000000000..83d7eec0058d
> --- /dev/null
> +++ b/include/net/page_pool/memory_provider.h
> @@ -0,0 +1,10 @@

nit: missing SPDX

> +#ifndef _NET_PAGE_POOL_MEMORY_PROVIDER_H
> +#define _NET_PAGE_POOL_MEMORY_PROVIDER_H
> +
> +int page_pool_mp_init_paged_area(struct page_pool *pool,
> +				struct net_iov_area *area,
> +				struct page **pages);
> +void page_pool_mp_release_area(struct page_pool *pool,
> +				struct net_iov_area *area);
> +
> +#endif

> +static void page_pool_release_page_dma(struct page_pool *pool,
> +				       netmem_ref netmem)
> +{
> +	__page_pool_release_page_dma(pool, netmem);

I'm guessing this is to save text? Because
__page_pool_release_page_dma() is always_inline? 
Maybe add a comment?

> +}
> +
> +int page_pool_mp_init_paged_area(struct page_pool *pool,
> +				 struct net_iov_area *area,
> +				 struct page **pages)
> +{
> +	struct net_iov *niov;
> +	netmem_ref netmem;
> +	int i, ret = 0;
> +
> +	if (!pool->dma_map)
> +		return -EOPNOTSUPP;
> +
> +	for (i = 0; i < area->num_niovs; i++) {
> +		niov = &area->niovs[i];
> +		netmem = net_iov_to_netmem(niov);
> +
> +		page_pool_set_pp_info(pool, netmem);

Maybe move setting pp down, after we successfully mapped. Technically
it's not a bug to leave it set on netmem, but it would be on a page
struct.

> +		if (!page_pool_dma_map_page(pool, netmem, pages[i])) {
> +			ret = -EINVAL;
> +			goto err_unmap_dma;
> +		}
> +	}
> +	return 0;
> +
> +err_unmap_dma:
> +	while (i--) {
> +		netmem = net_iov_to_netmem(&area->niovs[i]);
> +		page_pool_release_page_dma(pool, netmem);
> +	}
> +	return ret;
> +}
> +
> +void page_pool_mp_release_area(struct page_pool *pool,
> +			       struct net_iov_area *area)
> +{
> +	int i;
> +
> +	if (!pool->dma_map)
> +		return;
> +
> +	for (i = 0; i < area->num_niovs; i++) {
> +		struct net_iov *niov = &area->niovs[i];
> +
> +		page_pool_release_page_dma(pool, net_iov_to_netmem(niov));
> +	}
> +}


