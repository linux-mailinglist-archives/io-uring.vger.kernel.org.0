Return-Path: <io-uring+bounces-9266-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E275B31EA7
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 17:32:41 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5BA903A5623
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:27:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D14EC23D7D2;
	Fri, 22 Aug 2025 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CMSA8/iN"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782B821ABA8;
	Fri, 22 Aug 2025 15:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755876461; cv=none; b=C1lFzeSJNW9RrPeAkXeN6bC1MnD+IKxhNI2mKAcEYDmpwA/AtRS2X/srO46DylZFSnJdRylNr+pUFW9ZUYjz11K5IlBDchNwsuhJeUTY8KVX3z2KXFZoXtElg3QNALZHsizNdZ/gtaJSB2QtB/DMMNUM9RXJISJ+pAzUEkoQAr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755876461; c=relaxed/simple;
	bh=0qR8BCWLBcRlRrpkcs+atUvi5PdtJ50YHK9esf5ZAKk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=U+71PgDkq+jvmV9v8sNxv3h/PBa1RJTfEuDTKtsZHyiL4nPiCgd3TXo8C3HPX66K7TAiPYXucKiSnPI3VAiO85U1iKKsFglqZFiyxdow9sSLJ3p/MfwSrEVugsfP502LneEn2L6GnsL8F2AhM7D0zE5U0b5YCA/ATvc15RcjbCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CMSA8/iN; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95AB4C4CEF4;
	Fri, 22 Aug 2025 15:27:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755876460;
	bh=0qR8BCWLBcRlRrpkcs+atUvi5PdtJ50YHK9esf5ZAKk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CMSA8/iNRQzGZkbIDx5A4cJNOwmFhybJqReMu4HdwOVn3PNotQlsB8AgT+yFZA8Y8
	 tXDvC072J+TRehmdgF6MQY8T9LhOc8Vm8r28olhGEPc9En2no+wNDu0dVCg2CmWd50
	 VDF4ewu4MW0eWpp/VV3ju+VCox+NXDJKc5r3/Tt5bBkHB/AdI2MAkYGs2yDcmuxBr5
	 hcRW5ZzeP6W5XkLDFTOtzNceF2yrK9Br6VLgJmKNP6QZnYnlUbDho/SCHAoD5sdcAx
	 wQt2gTTeyRZX4my8A32bD2sZ4a3Ym/R4GffRVx6rLGX5yIxOwM3XEG7ZllyzhSW098
	 +DeEOtb4E7cHQ==
Date: Fri, 22 Aug 2025 18:27:22 +0300
From: Mike Rapoport <rppt@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>, Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>, dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org, iommu@lists.linux.dev,
	io-uring@vger.kernel.org, Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>, Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>, kasan-dev@googlegroups.com,
	kvm@vger.kernel.org, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com, linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org, linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org, linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org, linux-mm@kvack.org,
	linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>, Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org, Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>, Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 09/35] mm/mm_init: make memmap_init_compound() look
 more like prep_compound_page()
Message-ID: <aKiMWoZMyXYTAPJj@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-10-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-10-david@redhat.com>

On Thu, Aug 21, 2025 at 10:06:35PM +0200, David Hildenbrand wrote:
> Grepping for "prep_compound_page" leaves on clueless how devdax gets its
> compound pages initialized.
> 
> Let's add a comment that might help finding this open-coded
> prep_compound_page() initialization more easily.
> 
> Further, let's be less smart about the ordering of initialization and just
> perform the prep_compound_head() call after all tail pages were
> initialized: just like prep_compound_page() does.
> 
> No need for a lengthy comment then: again, just like prep_compound_page().
> 
> Note that prep_compound_head() already does initialize stuff in page[2]
> through prep_compound_head() that successive tail page initialization
> will overwrite: _deferred_list, and on 32bit _entire_mapcount and
> _pincount. Very likely 32bit does not apply, and likely nobody ever ends
> up testing whether the _deferred_list is empty.
> 
> So it shouldn't be a fix at this point, but certainly something to clean
> up.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/mm_init.c | 13 +++++--------
>  1 file changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 5c21b3af216b2..708466c5b2cc9 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1091,6 +1091,10 @@ static void __ref memmap_init_compound(struct page *head,
>  	unsigned long pfn, end_pfn = head_pfn + nr_pages;
>  	unsigned int order = pgmap->vmemmap_shift;
>  
> +	/*
> +	 * This is an open-coded prep_compound_page() whereby we avoid
> +	 * walking pages twice by initializing them in the same go.
> +	 */

While on it, can you also mention that prep_compound_page() is not used to
properly set page zone link?

With this

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

>  	__SetPageHead(head);
>  	for (pfn = head_pfn + 1; pfn < end_pfn; pfn++) {
>  		struct page *page = pfn_to_page(pfn);
> @@ -1098,15 +1102,8 @@ static void __ref memmap_init_compound(struct page *head,
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  		prep_compound_tail(head, pfn - head_pfn);
>  		set_page_count(page, 0);
> -
> -		/*
> -		 * The first tail page stores important compound page info.
> -		 * Call prep_compound_head() after the first tail page has
> -		 * been initialized, to not have the data overwritten.
> -		 */
> -		if (pfn == head_pfn + 1)
> -			prep_compound_head(head, order);
>  	}
> +	prep_compound_head(head, order);
>  }
>  
>  void __ref memmap_init_zone_device(struct zone *zone,
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

