Return-Path: <io-uring+bounces-9294-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 20F3AB3625B
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 15:18:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 64A922A1543
	for <lists+io-uring@lfdr.de>; Tue, 26 Aug 2025 13:12:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 577F6298CA7;
	Tue, 26 Aug 2025 13:11:47 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 78069268C40;
	Tue, 26 Aug 2025 13:11:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.140.110.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213907; cv=none; b=CWw58cRYt3KhGuBAmyGe0ej5N0Uobsfe9VJ+JbLq3U2uLHuG1Q3NcYFItyxKKEZvKjBEPCIpMMaTPK6S7X5MmRr1dV4cEEt9emRUHdJHAOPeCULy4mJCGAe2OLQA6OfTsNjMkbyKg9fNaXYsdXSh3VsLrL0Zo3aNmkFi8Brb0RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213907; c=relaxed/simple;
	bh=r4P1fcbNrMFnG8T5p3u4dMJamruaFASdwNbmXce96jM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q6grDa1aR3QZkWBsvSGDnCL7tfbQP8dhNLUDMb19LemWKdTEjBOq72cfFmZR1Mqs8Md/zjPHgK1/8DF15lB16+tyS2LPhRkmihg+XFZYtQMXi0jCGNyPerA9Yr8aPY48Shi9z7nQHj5LNSZj0KmrKe10799+LmQmDWo4+TgI2rU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com; spf=pass smtp.mailfrom=arm.com; arc=none smtp.client-ip=217.140.110.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=arm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7C1B82BF2;
	Tue, 26 Aug 2025 06:11:36 -0700 (PDT)
Received: from raptor (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 0B7A13F63F;
	Tue, 26 Aug 2025 06:11:36 -0700 (PDT)
Date: Tue, 26 Aug 2025 14:11:34 +0100
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
Message-ID: <aK2yhtQ0M_0hqQHh@raptor>
References: <20250821200701.1329277-1-david@redhat.com>
 <20250821200701.1329277-22-david@redhat.com>
 <aK2QZnzS1ErHK5tP@raptor>
 <ad521f4f-47aa-4728-916f-3704bf01f770@redhat.com>
 <aK2wlGYvCaFQXzBm@raptor>
 <ecc599ee-4175-4356-ab66-1d76a75f44f7@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ecc599ee-4175-4356-ab66-1d76a75f44f7@redhat.com>

Hi David,

On Tue, Aug 26, 2025 at 03:08:08PM +0200, David Hildenbrand wrote:
> On 26.08.25 15:03, Alexandru Elisei wrote:
> > Hi David,
> > 
> > On Tue, Aug 26, 2025 at 01:04:33PM +0200, David Hildenbrand wrote:
> > ..
> > > > Just so I can better understand the problem being fixed, I guess you can have
> > > > two consecutive pfns with non-consecutive associated struct page if you have two
> > > > adjacent memory sections spanning the same physical memory region, is that
> > > > correct?
> > > 
> > > Exactly. Essentially on SPARSEMEM without SPARSEMEM_VMEMMAP it is not
> > > guaranteed that
> > > 
> > > 	pfn_to_page(pfn + 1) == pfn_to_page(pfn) + 1
> > > 
> > > when we cross memory section boundaries.
> > > 
> > > It can be the case for early boot memory if we allocated consecutive areas
> > > from memblock when allocating the memmap (struct pages) per memory section,
> > > but it's not guaranteed.
> > 
> > Thank you for the explanation, but I'm a bit confused by the last paragraph. I
> > think what you're saying is that we can also have the reverse problem, where
> > consecutive struct page * represent non-consecutive pfns, because memmap
> > allocations happened to return consecutive virtual addresses, is that right?
> 
> Exactly, that's something we have to deal with elsewhere [1]. For this code,
> it's not a problem because we always allocate a contiguous PFN range.
> 
> > 
> > If that's correct, I don't think that's the case for CMA, which deals out
> > contiguous physical memory. Or were you just trying to explain the other side of
> > the problem, and I'm just overthinking it?
> 
> The latter :)

Ok, sorry for the noise then, and thank you for educating me.

Alex

