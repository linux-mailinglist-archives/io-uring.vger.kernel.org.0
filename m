Return-Path: <io-uring+bounces-9292-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 83521B3612E
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 15:07:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DAEAE3BEF00
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 13:03:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80C5A211491;
	Tue, 26 Aug 2025 13:03:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 338221FBE9B;
	Tue, 26 Aug 2025 13:03:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213409; cv=none; b=YYKLJLgtX0P9ZjVxnyH1jr/DA9TrgfmLqLlgKF5LQ2rN/gLduE9IYFP4OradlZQpgn5kXXpxUp1aqDTnoYlvMXes78XIapXm7WU4ej4p9fh4ybcIlTYvtAGlLtzZwwqRLSIf39rfmTd+d6n21knZcBq3ZAT3un2F2JFGOlvuE8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213409; c=relaxed/simple;
	bh=T9Gkxrj+Jbh4BEF2Xoy+VopdtFjdz7eGQjhjbYkar1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qtWmARSB3t93ksPeigFaw03FdIV/swq5lerGJxmziRLiCNXa0zyBPkEaQWZ3t1w1Mocd65b8S6Sc2Nd2zoqZbMjQ5Ob/pZ/nqcbk9y/jNbYv53T+nMo1uBRbzckOyruxf53xPKi457Iy+G41tDbMn+Rrp2YFKqoKUBSqPUqQ6i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 025E02C23;
	Tue, 26 Aug 2025 06:03:18 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A5B423F63F;
	Tue, 26 Aug 2025 06:03:19 -0700 (PDT)
Date: Tue, 26 Aug 2025 14:03:16 +0100
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
Message-ID: <aK2wlGYvCaFQXzBm@raptor>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-22-david@redhat.com>
 <aK2QZnzS1ErHK5tP@raptor>
 <ad521f4f-47aa-4728-916f-3704bf01f770@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ad521f4f-47aa-4728-916f-3704bf01f770@redhat.com>

Hi David,

On Tue, Aug 26, 2025 at 01:04:33PM +0200, David Hildenbrand wrote:
..
> > Just so I can better understand the problem being fixed, I guess you can have
> > two consecutive pfns with non-consecutive associated struct page if you have two
> > adjacent memory sections spanning the same physical memory region, is that
> > correct?
> 
> Exactly. Essentially on SPARSEMEM without SPARSEMEM_VMEMMAP it is not
> guaranteed that
> 
> 	pfn_to_page(pfn + 1) == pfn_to_page(pfn) + 1
> 
> when we cross memory section boundaries.
> 
> It can be the case for early boot memory if we allocated consecutive areas
> from memblock when allocating the memmap (struct pages) per memory section,
> but it's not guaranteed.

Thank you for the explanation, but I'm a bit confused by the last paragraph. I
think what you're saying is that we can also have the reverse problem, where
consecutive struct page * represent non-consecutive pfns, because memmap
allocations happened to return consecutive virtual addresses, is that right?

If that's correct, I don't think that's the case for CMA, which deals out
contiguous physical memory. Or were you just trying to explain the other side of
the problem, and I'm just overthinking it?

Thanks,
Alex

