Return-Path: <io-uring+bounces-13516-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNMECFWyFmokogcAu9opvQ
	(envelope-from <io-uring+bounces-13516-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 10:59:01 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E88B5E170E
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 10:59:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E47823049969
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 08:51:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6C3F3E315E;
	Wed, 27 May 2026 08:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="A4bj/hmQ"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F5A3E3144;
	Wed, 27 May 2026 08:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779871910; cv=none; b=OPOx11vl4n20Nqukz0DdLWJEHJaWDde8E9y4Q4KnobfxT/RKt8DnenwkkniH9rtjsz+2JMpVWTwaFKkpv7Nt8YC7ci+ixTf2i8jclDsluSP7UN5rDEY6ms2Sih00QlhJrbGBgU54SM35kltNA8CTvZ0zOzjl9WSCjKj80rEktQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779871910; c=relaxed/simple;
	bh=+hPcOcfHsa8a3ANFA1UCHnJst8TfVpFirCBR15QJVio=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=snCrvFk/6PNMXyqtjawrfSAn2lQ8EUGRHJiehzK6zgvyHGr1QfxOxttUFjhhmf4wr9VHxRZCgYivo7mePBaDrddxR+dhnOnMO2FcuX2izlJoUjHwocdctYssCIIv6zgAnCcYCKAuJicKpE97jE0xkGlV5TVbu9kHRP7CVsAjmEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=A4bj/hmQ; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6AD71F00A3D;
	Wed, 27 May 2026 08:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779871908;
	bh=cw6Hq3fwY9dORsY8hW5a014rXACoZ3Q9ELeTsBjnSJM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=A4bj/hmQa3H0KsSybQA679jZY8C2M2EBxCmGFd4kLjKqsNk3QWKHZjyPK5mXRkcfX
	 VpWCAte43G/7b72JGRYwED2VJuyypr5CTDlz+B/TBjr+N205H33pNj87fbEH7GjTMD
	 f4IzoJPCYeB66bnO4D2+DjO3keQikG9pILexzAijVpqCIMzJOir5m7RmSLWK4oBGUx
	 HpxXjQHd9D1kqOUe/dWA+5FlGHtZur/fBmi1sPvyfdRgQVFYYfU4QdQGQhpaG5w5EU
	 Y1D1Hds9rZPfYSD7ptH/l2KRCdPsgF384y4fFB2IicC6PJSaekfzn3Pg06DbJM/mVv
	 ywTh7ch9dWuXw==
Message-ID: <e4dcfbc8-2666-452c-90b2-25c4b2c50c9f@kernel.org>
Date: Wed, 27 May 2026 10:51:42 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
To: Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@kernel.org>,
 Harry Yoo <harry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
 David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>, linux-arm-msm@vger.kernel.org,
 dri-devel@lists.freedesktop.org, freedreno@lists.freedesktop.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, io-uring@vger.kernel.org,
 kasan-dev@googlegroups.com, bpf@vger.kernel.org, netdev@vger.kernel.org,
 Alexander Lobakin <aleksander.lobakin@intel.com>,
 Matt Fleming <mfleming@cloudflare.com>,
 kernel-team <kernel-team@cloudflare.com>
References: <20260527070239.2252948-1-hch@lst.de>
 <20260527070239.2252948-2-hch@lst.de>
Content-Language: en-US
From: Jesper Dangaard Brouer <hawk@kernel.org>
In-Reply-To: <20260527070239.2252948-2-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13516-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[20];
	DKIM_TRACE(0.00)[kernel.org:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hawk@kernel.org,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lst.de:email]
X-Rspamd-Queue-Id: 8E88B5E170E
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr



On 27/05/2026 09.02, Christoph Hellwig wrote:
> The kmem_cache_alloc_bulk return value is weird.  It returns the number
> of allocated objects, but that must always be 0 or the requested number
> based on the implementations and the handling in the callers, but that
> assumption is not actually documented anywhere, which confuses automated
> review tools.
> 

I remember, this API behavior was requested by AKPM when I developed
kmem_cache_alloc_bulk.  I trusted AKPM's decision, but I cannot explain
why this choice was made.

I kept the netdev code usage below. The current napi_skb_cache_get_bulk
have a retry logic that assumes that a partial bulk number can be
returned (which it cannot as Hellwig explains).  Cc Alex/Olek please
review the changes below as you added this retry logic.


> Fix this by returning a bool if the allocation succeeded and adding a
> kerneldoc comment explaining the API.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>   drivers/gpu/drm/msm/msm_iommu.c       |  6 +--
>   drivers/gpu/drm/panthor/panthor_mmu.c | 12 +++---
>   include/linux/slab.h                  |  6 ++-
>   io_uring/io_uring.c                   | 23 +++++------
>   lib/test_meminit.c                    | 19 +++++----
>   mm/kasan/kasan_test_c.c               |  5 +--
>   mm/kfence/kfence_test.c               |  9 +++--
>   mm/slub.c                             | 58 +++++++++++++++------------
>   net/bpf/test_run.c                    |  7 ++--
>   net/core/skbuff.c                     | 24 ++++++-----
>   tools/include/linux/slab.h            |  2 +-
>   tools/testing/shared/linux.c          | 19 ++++-----
>   12 files changed, 93 insertions(+), 97 deletions(-)
> 

[...]

> diff --git a/net/core/skbuff.c b/net/core/skbuff.c
> index 44ac121cfccb..73045b688385 100644
> --- a/net/core/skbuff.c
> +++ b/net/core/skbuff.c
> @@ -288,11 +288,11 @@ static inline struct sk_buff *napi_skb_cache_get(bool alloc)
>   
>   	local_lock_nested_bh(&napi_alloc_cache.bh_lock);
>   	if (unlikely(!nc->skb_count)) {
> -		if (alloc)
> -			nc->skb_count = kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> -						GFP_ATOMIC | __GFP_NOWARN,
> -						NAPI_SKB_CACHE_BULK,
> -						nc->skb_cache);
> +		if (alloc && kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> +						   GFP_ATOMIC | __GFP_NOWARN,
> +						   NAPI_SKB_CACHE_BULK,
> +						   nc->skb_cache))
> +			nc->skb_count = NAPI_SKB_CACHE_BULK;
>   		if (unlikely(!nc->skb_count)) {
>   			local_unlock_nested_bh(&napi_alloc_cache.bh_lock);
>   			return NULL;
> @@ -353,16 +353,18 @@ u32 napi_skb_cache_get_bulk(void **skbs, u32 n)
>   
>   	/* No enough cached skbs. Try refilling the cache first */
>   	bulk = min(NAPI_SKB_CACHE_SIZE - nc->skb_count, NAPI_SKB_CACHE_BULK);
> -	nc->skb_count += kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> -					       GFP_ATOMIC | __GFP_NOWARN, bulk,
> -					       &nc->skb_cache[nc->skb_count]);
> +	if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> +				  GFP_ATOMIC | __GFP_NOWARN, bulk,
> +				  &nc->skb_cache[nc->skb_count]))
> +		nc->skb_count += bulk;
>   	if (likely(nc->skb_count >= n))
>   		goto get;
>   
>   	/* Still not enough. Bulk-allocate the missing part directly, zeroed */
> -	n -= kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> -				   GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
> -				   n - nc->skb_count, &skbs[nc->skb_count]);
> +	if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> +				  GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
> +				  n - nc->skb_count, &skbs[nc->skb_count]))
> +		n = nc->skb_count;
>   	if (likely(nc->skb_count >= n))
>   		goto get;
>   

