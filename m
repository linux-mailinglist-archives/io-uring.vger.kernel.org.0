Return-Path: <io-uring+bounces-9384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 79F85B39724
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 10:38:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B8AFB1B23A13
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 08:38:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 655472DF6F4;
	Thu, 28 Aug 2025 08:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="u4Kv9tb0"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1495932C8B;
	Thu, 28 Aug 2025 08:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756370276; cv=none; b=aZBoSA26ZnvVFWuLeaaaFt6oUnDVLu4DiMF16DnvF8UWPndOZY7MJgGAPTqBIiutd03TSNGkNOBRr3E6Ol1r/wzgvBV3avuMER+C6R5cE6NKtJ9/m4hadrhrVrcpP2/D9XDPPjGVGp1GDmpQy0mvQJtxpRSZzAL1z2gUack4Izo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756370276; c=relaxed/simple;
	bh=IVLnXXvrcuUFj2BZziSgUB2XoLuFxUupzbzqW/5G2yk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XGfnvOEEqst6YcHT1pHB5CyjAny1uHUH1J9nxlujBRLWi/FreBaTl9JgkSlm8yvr81cgrsxxQ32h/XxvuLBMtBZpC6futVIIFCnkV8m33UAzfzKSQvzxbGUVjJfo9U9Y+kEowcB90/JAQIPYDxTIcqXWexDwzh9zgm8R9mbLj4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=u4Kv9tb0; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 836CFC4CEEB;
	Thu, 28 Aug 2025 08:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756370275;
	bh=IVLnXXvrcuUFj2BZziSgUB2XoLuFxUupzbzqW/5G2yk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=u4Kv9tb0W5HJY1z7Kha4RAxr/UDU+cy25InJtGEnO3JiyN+nbkHyw+9MpLitEOa5G
	 0pSV+hVfSXm9giRO4saHh0FNbPWIN8sA2oA/bVZ8ebErMJIoJf5LF4hfU+XC82WOgd
	 o5Dgh+w2lF46YEB0ubeKLXGmDFSIt276UaYMpIYsyodQH72bNpUaPHECThHiReLcwu
	 lbXv5EztKdkS391yu76bPtHOGB6uXK2NxrE3bcXs03h3uWTI0l2Znk0+rahaBHO1Pt
	 hHaVxoPeO8aKdT7uTaRf2Ck2cSXP3LlsqOYOEOuwJLFl7J5jwbm5nIR+gc/gZJcMeT
	 tq+aaMu2hoX5A==
Date: Thu, 28 Aug 2025 11:37:37 +0300
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
Subject: Re: [PATCH v1 13/36] mm/hugetlb: cleanup
 hugetlb_folio_init_tail_vmemmap()
Message-ID: <aLAVUePBQuz9D89T@kernel.org>
References: <20250827220141.262669-1-david@redhat.com>
 <20250827220141.262669-14-david@redhat.com>
 <aLADXP89cp6hAq0q@kernel.org>
 <377449bd-3c06-4a09-8647-e41354e64b30@redhat.com>
 <aLAN7xS4WQsN6Hpm@kernel.org>
 <6880f125-803d-4eea-88ac-b67fdcc5995d@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6880f125-803d-4eea-88ac-b67fdcc5995d@redhat.com>

On Thu, Aug 28, 2025 at 10:18:23AM +0200, David Hildenbrand wrote:
> On 28.08.25 10:06, Mike Rapoport wrote:
> > On Thu, Aug 28, 2025 at 09:44:27AM +0200, David Hildenbrand wrote:
> > > On 28.08.25 09:21, Mike Rapoport wrote:
> > > > On Thu, Aug 28, 2025 at 12:01:17AM +0200, David Hildenbrand wrote:
> > > > > +	/*
> > > > > +	 * We mark all tail pages with memblock_reserved_mark_noinit(),
> > > > > +	 * so these pages are completely uninitialized.
> > > > 
> > > >                                ^ not? ;-)
> > > 
> > > Can you elaborate?
> > 
> > Oh, sorry, I misread "uninitialized".
> > Still, I'd phrase it as
> > 
> > 	/*
> > 	 * We marked all tail pages with memblock_reserved_mark_noinit(),
> > 	 * so we must initialize them here.
> > 	 */
> 
> I prefer what I currently have, but thanks for the review.

No strong feelings, feel free to add

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.

