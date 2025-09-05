Return-Path: <io-uring+bounces-9612-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 84FF6B466E7
	for <lists+io-uring@lfdr.de>; Sat,  6 Sep 2025 01:01:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 3F1111C83961
	for <lists+io-uring@lfdr.de>; Fri,  5 Sep 2025 23:01:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 382CA27CB04;
	Fri,  5 Sep 2025 23:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="FKhh4N0Y"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D534072639;
	Fri,  5 Sep 2025 23:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757113283; cv=none; b=STHTwbkIUVyVc7/Lt3KdXJswKeeXO6ub4oO/A4fn/hio24PmAXQ4j33bZlZeIH4/EKkF1ydvJyWKcoiZL/hsxI2S6XTK5sfeeH6rQSy+d/V0WUS52Dr+w4Ga30z3Ey9QMdboVM8/bPPo7tSb/lionQYM2sHQjvtVNXMwc+y1ZZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757113283; c=relaxed/simple;
	bh=+lhopyxIHPkimkHLqjBagKsowbxPduHdhl1alB5XIHw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=N75cZXP1uVrHhIJ9EPjB03JXuyOgr/DVmBetbhnxkc2jy5WGQHWzf3CfpoeeT+fOsJzUEx47wPpgyN43SxU3d62W5Po1LCgxkA2EyKIY3vTV+zpKEov7n98vGiJUbFohpyvKvli9clGo6PdRHczPUuzF/vel7BmS57mz0Q44AUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=FKhh4N0Y; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2CEDC4CEF1;
	Fri,  5 Sep 2025 23:01:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757113280;
	bh=+lhopyxIHPkimkHLqjBagKsowbxPduHdhl1alB5XIHw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKhh4N0YC7rktiPdXEfXclWanEDKYne9TN6cdcuCjqPCtcq4Rn0r96yLuECJbiw+4
	 LjwCnjQtLBAm0edveUnCZZYiNonj/7aqKLJr2wGtnUHH+scBK/7r7JUigttXLAScDm
	 pXeFnpIPvL1/rZKX9LdznwwDYBYkDL4/X0Q74Dlpx/NmySnEYO46ImCPWzvWXVlUfn
	 7nKQ1fERSefzbF0N9pUOtT2Ew99OpHStRZ+01KHKpecJw2kFIukduhp+K3hQulq8o0
	 47VhyxuU+d72ralUlgkhIgcgxiZyD9aQX9YFUuu3Ep7hq8BTDKfbNp6DFssdME8qWg
	 uTEId8/MJZDQg==
Date: Fri, 5 Sep 2025 16:00:06 -0700
From: Eric Biggers <ebiggers@kernel.org>
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
Subject: Re: [PATCH v2 19/37] mm/gup: remove record_subpages()
Message-ID: <20250905230006.GA1776@sol>
References: <20250901150359.867252-1-david@redhat.com>
 <20250901150359.867252-20-david@redhat.com>
 <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5090355d-546a-4d06-99e1-064354d156b5@redhat.com>

On Fri, Sep 05, 2025 at 08:41:23AM +0200, David Hildenbrand wrote:
> On 01.09.25 17:03, David Hildenbrand wrote:
> > We can just cleanup the code by calculating the #refs earlier,
> > so we can just inline what remains of record_subpages().
> > 
> > Calculate the number of references/pages ahead of times, and record them
> > only once all our tests passed.
> > 
> > Signed-off-by: David Hildenbrand <david@redhat.com>
> > ---
> >   mm/gup.c | 25 ++++++++-----------------
> >   1 file changed, 8 insertions(+), 17 deletions(-)
> > 
> > diff --git a/mm/gup.c b/mm/gup.c
> > index c10cd969c1a3b..f0f4d1a68e094 100644
> > --- a/mm/gup.c
> > +++ b/mm/gup.c
> > @@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
> >   #ifdef CONFIG_MMU
> >   #ifdef CONFIG_HAVE_GUP_FAST
> > -static int record_subpages(struct page *page, unsigned long sz,
> > -			   unsigned long addr, unsigned long end,
> > -			   struct page **pages)
> > -{
> > -	int nr;
> > -
> > -	page += (addr & (sz - 1)) >> PAGE_SHIFT;
> > -	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
> > -		pages[nr] = page++;
> > -
> > -	return nr;
> > -}
> > -
> >   /**
> >    * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
> >    * @page:  pointer to page to be grabbed
> > @@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> >   	if (pmd_special(orig))
> >   		return 0;
> > -	page = pmd_page(orig);
> > -	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
> > +	refs = (end - addr) >> PAGE_SHIFT;
> > +	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
> >   	folio = try_grab_folio_fast(page, refs, flags);
> >   	if (!folio)
> > @@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
> >   	}
> >   	*nr += refs;
> > +	for (; refs; refs--)
> > +		*(pages++) = page++;
> >   	folio_set_referenced(folio);
> >   	return 1;
> >   }
> > @@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >   	if (pud_special(orig))
> >   		return 0;
> > -	page = pud_page(orig);
> > -	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
> > +	refs = (end - addr) >> PAGE_SHIFT;
> > +	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
> >   	folio = try_grab_folio_fast(page, refs, flags);
> >   	if (!folio)
> > @@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
> >   	}
> >   	*nr += refs;
> > +	for (; refs; refs--)
> > +		*(pages++) = page++;
> >   	folio_set_referenced(folio);
> >   	return 1;
> >   }
> 
> Okay, this code is nasty. We should rework this code to just return the nr and receive a the proper
> pages pointer, getting rid of the "*nr" parameter.
> 
> For the time being, the following should do the trick:
> 
> commit bfd07c995814354f6b66c5b6a72e96a7aa9fb73b (HEAD -> nth_page)
> Author: David Hildenbrand <david@redhat.com>
> Date:   Fri Sep 5 08:38:43 2025 +0200
> 
>     fixup: mm/gup: remove record_subpages()
>     pages is not adjusted by the caller, but idnexed by existing *nr.
>     Signed-off-by: David Hildenbrand <david@redhat.com>
> 
> diff --git a/mm/gup.c b/mm/gup.c
> index 010fe56f6e132..22420f2069ee1 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -2981,6 +2981,7 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
>                 return 0;
>         }
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;
> @@ -3024,6 +3025,7 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
>                 return 0;
>         }
> +       pages += *nr;
>         *nr += refs;
>         for (; refs; refs--)
>                 *(pages++) = page++;

Can this get folded in soon?  This bug is causing crashes in AF_ALG too.

Thanks,

- Eric

