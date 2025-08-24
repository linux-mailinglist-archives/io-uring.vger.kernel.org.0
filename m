Return-Path: <io-uring+bounces-9274-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 36DA2B33011
	for <lists+io-uring@lfdr.de>; Sun, 24 Aug 2025 15:24:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2BD921B22976
	for <lists+io-uring@lfdr.de>; Sun, 24 Aug 2025 13:25:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEA2E2D7387;
	Sun, 24 Aug 2025 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SquWihWK"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C3D2393DE3;
	Sun, 24 Aug 2025 13:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756041880; cv=none; b=VP4If5ozBuciAvANxGkykqsy5cYI2s6CmQASw/YAAqldG3NPH1K2d8y3nT03z1xK/Wn/MdvkrTaq9qUZlXEUCoD/40poqJi68er6jh1Yub3tFG09ifLIjjzfKO3xKSDjiNqtrp20Ba01qgIiuANRSB3rkS3y4AFOqGTT5lYPJG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756041880; c=relaxed/simple;
	bh=ULWSWvx5qOQocuXhhEVwmUdZJ/jQrpo8zzXV1kr+XYk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ull+/HlBVmEZZhKNv/0sF3Fn0DS7SlawRmd45WFjUcqhk6vXZn+ZJRH0gdfvL+szbq3qH/vrNmxBQiRIDrUmnj5odiEMPyrVd8IVLdTS1jYwx3VQgA/2P1BdSidVqMXbvEYDwQ5VAJulrtq5kSIboWrVEqZwW0XH9JdD3c5I0ZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SquWihWK; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4638C4CEEB;
	Sun, 24 Aug 2025 13:24:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756041880;
	bh=ULWSWvx5qOQocuXhhEVwmUdZJ/jQrpo8zzXV1kr+XYk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=SquWihWK3f+VpRPVHREvb/KU1Ip2U18TP7N1MuJITOAx4rQrPZH3cvqtkOP5SvK7q
	 i6NO1TPVUbZk8RWkAk3LTCsFqBTBZ14HIKev8nasvhFuIsLkIUiO3cKzio2Q51II/F
	 wyed5FtAlddWEWPif7U0YGP0VU7Jz0WnTx8oiBRZXCVwF7SJXztCvl7h61L8oudm/m
	 ZzJcPQiQ6a3vkdslZGaL+map5bzuxrOH69hNlp4a8gDkADVHKqlXnjP6H9fUKUPAle
	 G5RP+5YSDJFPCZAOfsIK30ngRx5fl+uNMhMZuFtvohYRU68gjsyw/nUrRlnisE/5CR
	 1GDLoGVBUCvXA==
Date: Sun, 24 Aug 2025 16:24:23 +0300
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
Subject: Re: [PATCH RFC 12/35] mm: limit folio/compound page sizes in
 problematic kernel configs
Message-ID: <aKsSh0OEjf4GLmIG@kernel.org>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-13-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250821200701.1329277-13-david@redhat.com>

On Thu, Aug 21, 2025 at 10:06:38PM +0200, David Hildenbrand wrote:
> Let's limit the maximum folio size in problematic kernel config where
> the memmap is allocated per memory section (SPARSEMEM without
> SPARSEMEM_VMEMMAP) to a single memory section.
> 
> Currently, only a single architectures supports ARCH_HAS_GIGANTIC_PAGE
> but not SPARSEMEM_VMEMMAP: sh.
> 
> Fortunately, the biggest hugetlb size sh supports is 64 MiB
> (HUGETLB_PAGE_SIZE_64MB) and the section size is at least 64 MiB
> (SECTION_SIZE_BITS == 26), so their use case is not degraded.
> 
> As folios and memory sections are naturally aligned to their order-2 size
> in memory, consequently a single folio can no longer span multiple memory
> sections on these problematic kernel configs.
> 
> nth_page() is no longer required when operating within a single compound
> page / folio.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mm.h | 22 ++++++++++++++++++----
>  1 file changed, 18 insertions(+), 4 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 77737cbf2216a..48a985e17ef4e 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -2053,11 +2053,25 @@ static inline long folio_nr_pages(const struct folio *folio)
>  	return folio_large_nr_pages(folio);
>  }
>  
> -/* Only hugetlbfs can allocate folios larger than MAX_ORDER */
> -#ifdef CONFIG_ARCH_HAS_GIGANTIC_PAGE
> -#define MAX_FOLIO_ORDER		PUD_ORDER
> -#else
> +#if !defined(CONFIG_ARCH_HAS_GIGANTIC_PAGE)
> +/*
> + * We don't expect any folios that exceed buddy sizes (and consequently
> + * memory sections).
> + */
>  #define MAX_FOLIO_ORDER		MAX_PAGE_ORDER
> +#elif defined(CONFIG_SPARSEMEM) && !defined(CONFIG_SPARSEMEM_VMEMMAP)
> +/*
> + * Only pages within a single memory section are guaranteed to be
> + * contiguous. By limiting folios to a single memory section, all folio
> + * pages are guaranteed to be contiguous.
> + */
> +#define MAX_FOLIO_ORDER		PFN_SECTION_SHIFT
> +#else
> +/*
> + * There is no real limit on the folio size. We limit them to the maximum we
> + * currently expect.
> + */
> +#define MAX_FOLIO_ORDER		PUD_ORDER
>  #endif
>  
>  #define MAX_FOLIO_NR_PAGES	(1UL << MAX_FOLIO_ORDER)
> -- 
> 2.50.1
> 

-- 
Sincerely yours,
Mike.

