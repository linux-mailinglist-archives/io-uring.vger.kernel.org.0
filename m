Return-Path: <io-uring+bounces-9290-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D09DB35A4B
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 12:46:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 571FC165CA5
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 10:46:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C7282BE7D7;
	Tue, 26 Aug 2025 10:46:12 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EB77932C8B;
	Tue, 26 Aug 2025 10:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756205172; cv=none; b=lVpRpw3XdbcxyhAIssUAeGT68p2NO2QaBX1pOtCDlQqRWe94K/sn0cobj7Aje7Gu2S6e/wv1qd/6kAC+50vYMSY6pnkHqoKDhlxeLbtOxlGQuY6RkegK9T8HM+ky9I0zXvkfjc3jQsdmlQ4tm9BLq03D3zy7D7t17GKHMlo+360=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756205172; c=relaxed/simple;
	bh=RlYaQIsXPj/hYp0IY2hzpcUql9s2CJOIs/Vq55SuaEg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dpxrCLdKufhXareDb3Vurb23Q14RmhzSBQHMZlnn3rWYiIGT7ffwO2HGosclr3zfH+S72E4e4IAKI1ATPilOCkeo1PJR+rDFtKuLm9PKqJqqhj9fzs6ugOYq++ktRobp+eFY/CJ9MVDDrB41/sf/a1pf4Q1Pgo+hJaErhPS/Otw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0AD2A1A00;
	Tue, 26 Aug 2025 03:46:01 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 93FC13F694;
	Tue, 26 Aug 2025 03:46:01 -0700 (PDT)
Date: Tue, 26 Aug 2025 11:45:58 +0100
From: Alexandru Elisei <alexandru.elisei@arm.com>
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
	Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>, netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>, Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>, Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev, Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com, x86@kernel.org, Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 21/35] mm/cma: refuse handing out non-contiguous page
 ranges
Message-ID: <aK2QZnzS1ErHK5tP@raptor>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-22-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-22-david@redhat.com>

Hi David,

On Thu, Aug 21, 2025 at 10:06:47PM +0200, David Hildenbrand wrote:
> Let's disallow handing out PFN ranges with non-contiguous pages, so we
> can remove the nth-page usage in __cma_alloc(), and so any callers don't
> have to worry about that either when wanting to blindly iterate pages.
> 
> This is really only a problem in configs with SPARSEMEM but without
> SPARSEMEM_VMEMMAP, and only when we would cross memory sections in some
> cases.
> 
> Will this cause harm? Probably not, because it's mostly 32bit that does
> not support SPARSEMEM_VMEMMAP. If this ever becomes a problem we could
> look into allocating the memmap for the memory sections spanned by a
> single CMA region in one go from memblock.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  include/linux/mm.h |  6 ++++++
>  mm/cma.c           | 36 +++++++++++++++++++++++-------------
>  mm/util.c          | 33 +++++++++++++++++++++++++++++++++
>  3 files changed, 62 insertions(+), 13 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index ef360b72cb05c..f59ad1f9fc792 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -209,9 +209,15 @@ extern unsigned long sysctl_user_reserve_kbytes;
>  extern unsigned long sysctl_admin_reserve_kbytes;
>  
>  #if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +bool page_range_contiguous(const struct page *page, unsigned long nr_pages);
>  #define nth_page(page,n) pfn_to_page(page_to_pfn((page)) + (n))
>  #else
>  #define nth_page(page,n) ((page) + (n))
> +static inline bool page_range_contiguous(const struct page *page,
> +		unsigned long nr_pages)
> +{
> +	return true;
> +}
>  #endif
>  
>  /* to align the pointer to the (next) page boundary */
> diff --git a/mm/cma.c b/mm/cma.c
> index 2ffa4befb99ab..1119fa2830008 100644
> --- a/mm/cma.c
> +++ b/mm/cma.c
> @@ -780,10 +780,8 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>  				unsigned long count, unsigned int align,
>  				struct page **pagep, gfp_t gfp)
>  {
> -	unsigned long mask, offset;
> -	unsigned long pfn = -1;
> -	unsigned long start = 0;
>  	unsigned long bitmap_maxno, bitmap_no, bitmap_count;
> +	unsigned long start, pfn, mask, offset;
>  	int ret = -EBUSY;
>  	struct page *page = NULL;
>  
> @@ -795,7 +793,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>  	if (bitmap_count > bitmap_maxno)
>  		goto out;
>  
> -	for (;;) {
> +	for (start = 0; ; start = bitmap_no + mask + 1) {
>  		spin_lock_irq(&cma->lock);
>  		/*
>  		 * If the request is larger than the available number
> @@ -812,6 +810,22 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>  			spin_unlock_irq(&cma->lock);
>  			break;
>  		}
> +
> +		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
> +		page = pfn_to_page(pfn);
> +
> +		/*
> +		 * Do not hand out page ranges that are not contiguous, so
> +		 * callers can just iterate the pages without having to worry
> +		 * about these corner cases.
> +		 */
> +		if (!page_range_contiguous(page, count)) {
> +			spin_unlock_irq(&cma->lock);
> +			pr_warn_ratelimited("%s: %s: skipping incompatible area [0x%lx-0x%lx]",
> +					    __func__, cma->name, pfn, pfn + count - 1);
> +			continue;
> +		}
> +
>  		bitmap_set(cmr->bitmap, bitmap_no, bitmap_count);
>  		cma->available_count -= count;
>  		/*
> @@ -821,29 +835,25 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
>  		 */
>  		spin_unlock_irq(&cma->lock);
>  
> -		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
>  		mutex_lock(&cma->alloc_mutex);
>  		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
>  		mutex_unlock(&cma->alloc_mutex);
> -		if (ret == 0) {
> -			page = pfn_to_page(pfn);
> +		if (!ret)
>  			break;
> -		}
>  
>  		cma_clear_bitmap(cma, cmr, pfn, count);
>  		if (ret != -EBUSY)
>  			break;
>  
>  		pr_debug("%s(): memory range at pfn 0x%lx %p is busy, retrying\n",
> -			 __func__, pfn, pfn_to_page(pfn));
> +			 __func__, pfn, page);
>  
>  		trace_cma_alloc_busy_retry(cma->name, pfn, pfn_to_page(pfn),

Nitpick: I think you already have the page here.

>  					   count, align);
> -		/* try again with a bit different memory target */
> -		start = bitmap_no + mask + 1;
>  	}
>  out:
> -	*pagep = page;
> +	if (!ret)
> +		*pagep = page;
>  	return ret;
>  }
>  
> @@ -882,7 +892,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
>  	 */
>  	if (page) {
>  		for (i = 0; i < count; i++)
> -			page_kasan_tag_reset(nth_page(page, i));
> +			page_kasan_tag_reset(page + i);

Had a look at it, not very familiar with CMA, but the changes look equivalent to
what was before. Not sure that's worth a Reviewed-by tag, but here it in case
you want to add it:

Reviewed-by: Alexandru Elisei <alexandru.elisei@arm.com>

Just so I can better understand the problem being fixed, I guess you can have
two consecutive pfns with non-consecutive associated struct page if you have two
adjacent memory sections spanning the same physical memory region, is that
correct?

Thanks,
Alex

>  	}
>  
>  	if (ret && !(gfp & __GFP_NOWARN)) {
> diff --git a/mm/util.c b/mm/util.c
> index d235b74f7aff7..0bf349b19b652 100644
> --- a/mm/util.c
> +++ b/mm/util.c
> @@ -1280,4 +1280,37 @@ unsigned int folio_pte_batch(struct folio *folio, pte_t *ptep, pte_t pte,
>  {
>  	return folio_pte_batch_flags(folio, NULL, ptep, &pte, max_nr, 0);
>  }
> +
> +#if defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +/**
> + * page_range_contiguous - test whether the page range is contiguous
> + * @page: the start of the page range.
> + * @nr_pages: the number of pages in the range.
> + *
> + * Test whether the page range is contiguous, such that they can be iterated
> + * naively, corresponding to iterating a contiguous PFN range.
> + *
> + * This function should primarily only be used for debug checks, or when
> + * working with page ranges that are not naturally contiguous (e.g., pages
> + * within a folio are).
> + *
> + * Returns true if contiguous, otherwise false.
> + */
> +bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
> +{
> +	const unsigned long start_pfn = page_to_pfn(page);
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +	unsigned long pfn;
> +
> +	/*
> +	 * The memmap is allocated per memory section. We need to check
> +	 * each involved memory section once.
> +	 */
> +	for (pfn = ALIGN(start_pfn, PAGES_PER_SECTION);
> +	     pfn < end_pfn; pfn += PAGES_PER_SECTION)
> +		if (unlikely(page + (pfn - start_pfn) != pfn_to_page(pfn)))
> +			return false;
> +	return true;
> +}
> +#endif
>  #endif /* CONFIG_MMU */
> -- 
> 2.50.1
> 
> 

