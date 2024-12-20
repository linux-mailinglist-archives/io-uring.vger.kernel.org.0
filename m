Return-Path: <io-uring+bounces-5588-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E4259F9CC7
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 23:39:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A1B17189104E
	for <lists+io-uring@lfdr.de>; Fri, 20 Dec 2024 22:39:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FD8F1C0DD3;
	Fri, 20 Dec 2024 22:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="niN+4Oco"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 763671A9B27;
	Fri, 20 Dec 2024 22:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734734336; cv=none; b=KhUMgfvQ7kREp6xVf7Q/X2i/GJ+bH6dyTFM3F9PldBdZN6d2ULPSjwP6zbjzX07Y9qB2SeukUmy5MxQeQpJqwDXjtMcE+2OTeHSrPLhST6sg+G1k5D8L13jsiSm5Cpr5GfyR17KkP4A1HCtmMkC44iZswNxn5/b6uf42Uj3ulto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734734336; c=relaxed/simple;
	bh=CE9hXLB6pKnSm4AEHPKeMze9wcAEg2Yx8BXS7R9ckIg=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NCyViS5GhSn6BvBMr0javQ/tDgl4/SpTkB1OcD1J6PIic0Wf7S1X+eFGdYAKKZziB5S8i/dtx2zXnmondfQnfPok+2HRbxDeVV2lDZx+Ifu4jQs7rEhgZBbG+ABp4G51F+apwxDT6JuxX+a2KX+Rr/qT2EzlCLV6zOxEPBorJc4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=niN+4Oco; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 705B2C4CECD;
	Fri, 20 Dec 2024 22:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1734734335;
	bh=CE9hXLB6pKnSm4AEHPKeMze9wcAEg2Yx8BXS7R9ckIg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=niN+4OcoO6X0/JMYa2hI/lLvbQT8Ookpg48cDmmsc4wAMGcevRg+t5iqig34r5qq5
	 gbr401g28B9WuMgbeCbPF1cpvIfbc1MivxgKBnn5OllPbJYsoI0q//ru26vs3ygGyy
	 fASQSTxfU6njjrhd31v3PnYNwGzLdCEouvN4W83SemyLCl1UiL/+YMT8aZZSBHEVdK
	 bgwm7g+FXwIIRmitzCCPErO+f8rMCKsudgQ6Fk0OZ7cI95TdiQ5ZE6OYWqp3DTjIUl
	 mhzAUCpNhwTEtuci/Rbnq94E7om0D87jKJqQlQ6bsMUEYsOYLXdUJ6WsTAsxEQoPhr
	 /cF68TUlHekkg==
Date: Fri, 20 Dec 2024 14:38:54 -0800
From: Jakub Kicinski <kuba@kernel.org>
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, Jens Axboe
 <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, Paolo Abeni
 <pabeni@redhat.com>, "David S. Miller" <davem@davemloft.net>, Eric Dumazet
 <edumazet@google.com>, Jesper Dangaard Brouer <hawk@kernel.org>, David
 Ahern <dsahern@kernel.org>, Mina Almasry <almasrymina@google.com>,
 Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>,
 Pedro Tammela <pctammela@mojatatu.com>
Subject: Re: [PATCH net-next v9 14/20] io_uring/zcrx: dma-map area for the
 device
Message-ID: <20241220143854.7dce75e4@kernel.org>
In-Reply-To: <20241218003748.796939-15-dw@davidwei.uk>
References: <20241218003748.796939-1-dw@davidwei.uk>
	<20241218003748.796939-15-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 17 Dec 2024 16:37:40 -0800 David Wei wrote:
> diff --git a/include/uapi/linux/netdev.h b/include/uapi/linux/netdev.h
> index e4be227d3ad6..13d810a28ed6 100644
> --- a/include/uapi/linux/netdev.h
> +++ b/include/uapi/linux/netdev.h

The top of this file says:

/* Do not edit directly, auto-generated from: */
/*	Documentation/netlink/specs/netdev.yaml */

> +static void io_zcrx_refill_slow(struct page_pool *pp, struct io_zcrx_ifq *ifq)
> +{
> +	struct io_zcrx_area *area = ifq->area;
> +
> +	spin_lock_bh(&area->freelist_lock);
> +	while (area->free_count && pp->alloc.count < PP_ALLOC_CACHE_REFILL) {
> +		struct net_iov *niov = __io_zcrx_get_free_niov(area);
> +		netmem_ref netmem = net_iov_to_netmem(niov);
> +
> +		page_pool_set_pp_info(pp, netmem);
> +		page_pool_mp_return_in_cache(pp, netmem);
> 
> +		pp->pages_state_hold_cnt++;

But the kdoc on page_pool_mp_return_in_cache() says:

+ * Return already allocated and accounted netmem to the page pool's allocation
           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

> +		trace_page_pool_state_hold(pp, netmem, pp->pages_state_hold_cnt);
> +	}
> +	spin_unlock_bh(&area->freelist_lock);
> +}

> +	if (page_pool_unref_netmem(netmem, 1) == 0)

page_pool_unref_and_test()

> +		io_zcrx_return_niov_freelist(netmem_to_net_iov(netmem));
> +	return false;
>  }

