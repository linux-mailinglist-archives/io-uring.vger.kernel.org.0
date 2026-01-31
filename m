Return-Path: <io-uring+bounces-12004-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id X7ybFjQgfmnZVwIAu9opvQ
	(envelope-from <io-uring+bounces-12004-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 16:31:00 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 6ED58C2B19
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 16:30:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 0A6A33001F96
	for <lists+io-uring@lfdr.de>; Sat, 31 Jan 2026 15:30:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C2C1B78C9C;
	Sat, 31 Jan 2026 15:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="Ll2TEnev"
X-Original-To: io-uring@vger.kernel.org
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB6235958
	for <io-uring@vger.kernel.org>; Sat, 31 Jan 2026 15:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.183
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769873455; cv=none; b=ULIL719R+Kt6ok4Av/RRupooQgwIaCCAgd913kYeU7xGj1dBkMj2UuYmRv2AL1qmKBLNYvgr3WLCEvSLypZY1PT6HEOIKDnD797OhLIManpkFnloOTPvCJZjRG+zcUhuqDxCazXl5xOaXpxCFj41Jfrb2GQlMi1m/opq3YfvpCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769873455; c=relaxed/simple;
	bh=k65BQmwpkOPaM58vAcJ6yes9nqO/7udHCrPIEcZYrUA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sa3aLcdlgV6oYdJzPzrkQs7fTdR6okLSa4obvnv0/64Q0ee0+2zT7parFLeiohdlFwbbcpHx9XTqTAL8HC+FCGl0qVXVOBVW4iO1dBeVYotC3MO/NIAvCCDj+ZtTgs+T96PFgBTNxyNg9VOmYcx11ihWDPTtPzOOTl6Wii9tVLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=Ll2TEnev; arc=none smtp.client-ip=91.218.175.183
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Message-ID: <b37f990b-cb70-489b-849e-202eae190c37@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769873450;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Vsqwz7F9b/j0YuC0Xj04np2r/jOowSHbOYUcStWbWks=;
	b=Ll2TEnev9UOge0Djma0Yblote92o8CtIkC88ZTaonMMbe7xVUGE2vMfWZ8sP5y3MI23H6C
	TXRPG23ZFUuyHUKn/olRG/11XBte+tVDXB8aPPaN3LLEwrO3BQcGChPh2TAOnqlkHN9QHH
	Csj0oC5e4Oc8WfxG70WFfxzfNRG12a4=
Date: Sat, 31 Jan 2026 23:30:35 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: [RFC PATCH 1/5] io_uring: allocate folio in
 io_mem_alloc_compound() and function rename
Content-Language: en-US
To: Zi Yan <ziy@nvidia.com>
Cc: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Suren Baghdasaryan
 <surenb@google.com>, Jason Gunthorpe <jgg@nvidia.com>,
 Michal Hocko <mhocko@suse.com>, Jens Axboe <axboe@kernel.dk>,
 David Hildenbrand <david@kernel.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260130034818.472804-1-ziy@nvidia.com>
 <20260130034818.472804-2-ziy@nvidia.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260130034818.472804-2-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.dev,none];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[linux.dev:s=key1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12004-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[26];
	DKIM_TRACE(0.00)[linux.dev:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[lance.yang@linux.dev,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 6ED58C2B19
X-Rspamd-Action: no action



On 2026/1/30 11:48, Zi Yan wrote:
> The page allocated in io_mem_alloc_compound() is actually used as a folio
> later in io_region_mmap(). So allocate a folio instead of a compound page
> and rename io_mem_alloc_compound() to io_mem_alloc_folio().
> 
> This prepares for code separation of compound page and folio in a follow-up
> commit.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   io_uring/memmap.c | 12 ++++++------
>   1 file changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/io_uring/memmap.c b/io_uring/memmap.c
> index 7d3c5eb58480..8ed8a78d71cc 100644
> --- a/io_uring/memmap.c
> +++ b/io_uring/memmap.c
> @@ -15,10 +15,10 @@
>   #include "rsrc.h"
>   #include "zcrx.h"
>   
> -static bool io_mem_alloc_compound(struct page **pages, int nr_pages,
> +static bool io_mem_alloc_folio(struct page **pages, int nr_pages,
>   				  size_t size, gfp_t gfp)
>   {
> -	struct page *page;
> +	struct folio *folio;
>   	int i, order;
>   
>   	order = get_order(size);
> @@ -27,12 +27,12 @@ static bool io_mem_alloc_compound(struct page **pages, int nr_pages,

Nit:

>   	else if (order)
>   		gfp |= __GFP_COMP;

Since we're switching to folio_alloc(), which already adds __GFP_COMP
internally, the "else if (order)" part above can be dropped while at it.

IIUC, for order == 0, __GFP_COMP gets ignored anyway:

  - prep_new_page() won't call prep_compound_page() (since order is zero)
  - page_rmappable_folio() sees a non-compound page and does nothing

So no behavior change there :)

>   
> -	page = alloc_pages(gfp, order);
> -	if (!page)
> +	folio = folio_alloc(gfp, order);
> +	if (!folio)
>   		return false;
>   
>   	for (i = 0; i < nr_pages; i++)
> -		pages[i] = page + i;
> +		pages[i] = folio_page(folio, i);
>   
>   	return true;
>   }
> @@ -162,7 +162,7 @@ static int io_region_allocate_pages(struct io_mapped_region *mr,
>   	if (!pages)
>   		return -ENOMEM;
>   
> -	if (io_mem_alloc_compound(pages, mr->nr_pages, size, gfp)) {
> +	if (io_mem_alloc_folio(pages, mr->nr_pages, size, gfp)) {
>   		mr->flags |= IO_REGION_F_SINGLE_REF;
>   		goto done;
>   	}


