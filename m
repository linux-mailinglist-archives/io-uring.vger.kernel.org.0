Return-Path: <io-uring+bounces-12012-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id rNc7GD4hgGnw3AIAu9opvQ
	(envelope-from <io-uring+bounces-12012-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 04:59:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DDBE3C818D
	for <lists+io-uring@lfdr.de>; Mon, 02 Feb 2026 04:59:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 087923001306
	for <lists+io-uring@lfdr.de>; Mon,  2 Feb 2026 03:59:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB804273D77;
	Mon,  2 Feb 2026 03:59:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="qfNItAW0"
X-Original-To: io-uring@vger.kernel.org
Received: from out30-110.freemail.mail.aliyun.com (out30-110.freemail.mail.aliyun.com [115.124.30.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2882248868;
	Mon,  2 Feb 2026 03:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770004793; cv=none; b=hUPHBjX3SZ2d5fQfdsQydJRQNgZyusmsOF52k5RrKmFHAD66QAG5w8NhyWxQ/fG7ZAQ/CDuzm1Dvr2i6WDfwnLayCPrJz7gPjuS+AJRNjvAavFPPvgmu18dx1se//7xIk/5mKUfHai6/sO6x/Uj4LVdKysfNUkKvCV86gB0zYSo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770004793; c=relaxed/simple;
	bh=mqmjkFGQMMX1X00bH6Sd/emDC8f4LPtH4YU5eY3FjQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nSo7Co2EYydCIBSTMI7Yv67DL3lTD6PF/MKQDz3yNuJQrWkatF03pupGQgK3wd8PTvPRXmY0vYWyKLw7wo/YMdHZUhAsjqp4a6Y+cuvuo+rat0klGyL6Zv7ir0NdBqYSktHK959h2zHDzigdNNCaBGhKiHt6fGhJ7bDwr7OluHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=qfNItAW0; arc=none smtp.client-ip=115.124.30.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770004782; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=YLNM8XwLs6ZfkN2Ffdw20cH4cfsACOxpWucxMWKeiyY=;
	b=qfNItAW07rHVoTvY11QvkHsTdURIsJf+ZPFKD5do8PpZhS5YMUovESvPHglnZTy/w8eqe9VKYtFt2ZmiokjP5YZO45lw3vGlgpmgQpatmEw2JzmO+BXgtnvbdjoNEV1uLEktRLnRAkkpfnoOg+C5najBP0yisS2TCXLKuFLicx8=
Received: from 30.74.144.134(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WyJ0bcv_1770004779 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 02 Feb 2026 11:59:40 +0800
Message-ID: <5aefd2ea-8eba-49ed-bc21-f84dbab8cf3b@linux.alibaba.com>
Date: Mon, 2 Feb 2026 11:59:39 +0800
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and
 avoid deferred_list handling
To: Zi Yan <ziy@nvidia.com>, Jason Gunthorpe <jgg@nvidia.com>,
 David Hildenbrand <david@kernel.org>, Matthew Wilcox <willy@infradead.org>
Cc: Alistair Popple <apopple@nvidia.com>, Balbir Singh <balbirs@nvidia.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jens Axboe <axboe@kernel.dk>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
References: <20260130034818.472804-1-ziy@nvidia.com>
 <20260130034818.472804-4-ziy@nvidia.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260130034818.472804-4-ziy@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-9.16 / 15.00];
	WHITELIST_DMARC(-7.00)[alibaba.com:D:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[linux.alibaba.com,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[linux.alibaba.com:s=default];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-12012-lists,io-uring=lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[26];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[baolin.wang@linux.alibaba.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[linux.alibaba.com:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[nvidia.com:email,linux.alibaba.com:mid,linux.alibaba.com:dkim]
X-Rspamd-Queue-Id: DDBE3C818D
X-Rspamd-Action: no action



On 1/30/26 11:48 AM, Zi Yan wrote:
> Commit f708f6970cc9 ("mm/hugetlb: fix kernel NULL pointer dereference when
> migrating hugetlb folio") fixed a NULL pointer dereference when
> folio_undo_large_rmappable(), now folio_unqueue_deferred_list(), is used on
> hugetlb to clear deferred_list. It cleared large_rmappable flag on hugetlb.
> hugetlb is rmappable, thus clearing large_rmappable flag looks misleading.
> Instead, reject hugetlb in folio_unqueue_deferred_list() to avoid the
> issue.
> 
> This prepares for code separation of compound page and folio in a follow-up
> commit.
> 
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> ---
>   mm/hugetlb.c     | 6 +++---
>   mm/hugetlb_cma.c | 2 +-
>   mm/internal.h    | 3 ++-
>   3 files changed, 6 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 6e855a32de3d..7466c7bf41a1 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -1422,8 +1422,8 @@ static struct folio *alloc_gigantic_frozen_folio(int order, gfp_t gfp_mask,
>   	if (hugetlb_cma_exclusive_alloc())
>   		return NULL;
>   
> -	folio = (struct folio *)alloc_contig_frozen_pages(1 << order, gfp_mask,
> -							  nid, nodemask);
> +	folio = page_rmappable_folio(alloc_contig_frozen_pages(1 << order, gfp_mask,
> +							  nid, nodemask));
>   	return folio;
>   }
>   #else /* !CONFIG_ARCH_HAS_GIGANTIC_PAGE || !CONFIG_CONTIG_ALLOC */
> @@ -1859,7 +1859,7 @@ static struct folio *alloc_buddy_frozen_folio(int order, gfp_t gfp_mask,
>   	if (alloc_try_hard)
>   		gfp_mask |= __GFP_RETRY_MAYFAIL;
>   
> -	folio = (struct folio *)__alloc_frozen_pages(gfp_mask, order, nid, nmask);
> +	folio = page_rmappable_folio(__alloc_frozen_pages(gfp_mask, order, nid, nmask));
>   
>   	/*
>   	 * If we did not specify __GFP_RETRY_MAYFAIL, but still got a
> diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> index f83ae4998990..4245b5dda4dc 100644
> --- a/mm/hugetlb_cma.c
> +++ b/mm/hugetlb_cma.c
> @@ -51,7 +51,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
>   	if (!page)
>   		return NULL;
>   
> -	folio = page_folio(page);
> +	folio = page_rmappable_folio(page);
>   	folio_set_hugetlb_cma(folio);
>   	return folio;
>   }

IIUC, this will break the semantics of the is_transparent_hugepage() and 
might trigger a split of a hugetlb folio, right?

static inline bool is_transparent_hugepage(const struct folio *folio)
{
	if (!folio_test_large(folio))
		return false;

	return is_huge_zero_folio(folio) ||
		folio_test_large_rmappable(folio);
}

