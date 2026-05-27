Return-Path: <io-uring+bounces-13524-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QOQ1Cqr8FmrwzwcAu9opvQ
	(envelope-from <io-uring+bounces-13524-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:16:10 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F6EB5E5B94
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 16:16:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0BB813103A0F
	for <lists+io-uring@lfdr.de>; Wed, 27 May 2026 14:07:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44C643242D8;
	Wed, 27 May 2026 14:07:31 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD23F320A37;
	Wed, 27 May 2026 14:07:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779890851; cv=none; b=Zv4V9ENb6nGsmUYdoqOX75hGd9DavN3x+3d8qO1Sovi4qPSUeUBM9agZVE81AHwdOzp+dv8ZVeXoN53YnYhco5oBCJ6mRP3eFFUqQE9UrILsi0k2nJWOch8HTQHKoR77ZHUyTWqa6sDqp+qCe1FHrK+XHWpkz93uZ6IEKN2ggfk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779890851; c=relaxed/simple;
	bh=gf9Zm7uRt63514Y+7TY7/J/2IFULdGzW2yT8efvrUCw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=PuZU7YRF20FAknIo/Uw9bCCmWtZ8x87JBPOj5CrzpapJ9I+4VYs7MYVdOdu0JyX3oVNWB73BlrFFxCuup/JILQF+NEzlA+6qp2AFf4zW9MGNgPaRtJcv7uWq4Ajgya0FzARruR8dPzDZpa33+N83WkBqa0EN4xiXVtWCXvx9oJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 8156068C4E; Wed, 27 May 2026 16:07:24 +0200 (CEST)
Date: Wed, 27 May 2026 16:07:24 +0200
From: Christoph Hellwig <hch@lst.de>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Jesper Dangaard Brouer <hawk@kernel.org>,
	Christoph Hellwig <hch@lst.de>, Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
	freedreno@lists.freedesktop.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, io-uring@vger.kernel.org,
	kasan-dev@googlegroups.com, bpf@vger.kernel.org,
	netdev@vger.kernel.org, Matt Fleming <mfleming@cloudflare.com>,
	kernel-team <kernel-team@cloudflare.com>
Subject: Re: [PATCH] mm/slab: improve kmem_cache_alloc_bulk
Message-ID: <20260527140724.GA13256@lst.de>
References: <20260527070239.2252948-1-hch@lst.de> <20260527070239.2252948-2-hch@lst.de> <e4dcfbc8-2666-452c-90b2-25c4b2c50c9f@kernel.org> <777c7229-4285-4c7c-9340-dfaebd2ab291@intel.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <777c7229-4285-4c7c-9340-dfaebd2ab291@intel.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Spamd-Result: default: False [-1.36 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	DMARC_POLICY_SOFTFAIL(0.10)[lst.de : SPF not aligned (relaxed), No valid DKIM,none];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-0.992];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[hch@lst.de,io-uring@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,lst.de:mid];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13524-lists,io-uring=lfdr.de];
	R_DKIM_NA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[]
X-Rspamd-Queue-Id: 6F6EB5E5B94
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Wed, May 27, 2026 at 03:56:38PM +0200, Alexander Lobakin wrote:
> >> -    n -= kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> >> -                   GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
> >> -                   n - nc->skb_count, &skbs[nc->skb_count]);
> >> +    if (kmem_cache_alloc_bulk(net_hotdata.skbuff_cache,
> >> +                  GFP_ATOMIC | __GFP_ZERO | __GFP_NOWARN,
> >> +                  n - nc->skb_count, &skbs[nc->skb_count]))
> >> +        n = nc->skb_count;
> 
> kmem_cache_alloc_bulk() allocates `n - nc->skb_count`, but here you
> assign `nc->skb_count` to n.
> Ah wait,
> 
> n -= n - nc->skb_count
> n = n - (n - nc->skb_count)
> n = n - n + nc->skb_count
> n = nc->skb_count
> 
> Correct :D

Exactly the steps I went through when writing this patch :)


