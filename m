Return-Path: <io-uring+bounces-9268-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6FFADB32109
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 19:07:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5264A1D60824
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 17:08:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A49933128D2;
	Fri, 22 Aug 2025 17:07:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fSplAPAb"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444CC312802;
	Fri, 22 Aug 2025 17:07:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755882469; cv=none; b=oK1zHiIzrhSOspR+0B4eMECAi/HhhMR7O0QGF8c4crZur6t6uo93t0VpvKOQSQ6tqp3vD+ecBoJ9rK2eWYjMNF6kPGqd1zGepZ4cQWICVMGefR7FCpNkYiZYXXR7Tlb1NTRGExsMxyjsABqc1/97N6V0MBA82ivCWaG10qsf2z0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755882469; c=relaxed/simple;
	bh=vZLAjgh0rHfPoMdjN4T/8EdoC5/y95Yj/31fEqm5lgA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Z3fHJU6pTKNk6CdzkHGzCZr1c6A28Lx5XDeC1JTKxJQEybE92VdunBr/b6c0ZgJ28l7d3QVDhI7Ltb0bIEyj4YYNhKFHFhwLrEbz0mOQ2eB0VoAjA9JyMg+lNjzaWww1FlYU31Xpz+7qSRxznNhFRJd/w+MjzUJnC3n2ki2hzTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fSplAPAb; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD1D1C4CEF4;
	Fri, 22 Aug 2025 17:07:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755882468;
	bh=vZLAjgh0rHfPoMdjN4T/8EdoC5/y95Yj/31fEqm5lgA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fSplAPAbcqCwXrc73KaBOQNzaayHHHryXHEfz/QvCIP5+OLUcuUqhayGQU30an1Hx
	 YGDC2ch0190J8ZS7lR1jUdP6OQwlEiLMILXs/CkC/SlPI/9/wAF5EXwIZ0nb0Uecnj
	 UA9Ha7hLdu3BvCtDoUnTti40P6RP3bVkvwZuA5UDhaj8Dob3g32dp2vkLL6LUz2Uga
	 JrNca6OOm6CtiYGSnyjbJHFyuYTMa9sirnIIEndUMU2kE26IZfHRAqBcN1+HEuWJKI
	 iH1nd0618aV38WN9VJmQt9ibmxV/jw/X7xirOs3F2GwN8kBuIL5KMKravrNObUYubi
	 MyQ+vWsMpUjxQ==
From: SeongJae Park <sj@kernel.org>
To: David Hildenbrand <david@redhat.com>
Cc: SeongJae Park <sj@kernel.org>,
	linux-kernel@vger.kernel.org,
	Alexander Potapenko <glider@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Jackman <jackmanb@google.com>,
	Christoph Lameter <cl@gentwo.org>,
	Dennis Zhou <dennis@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	dri-devel@lists.freedesktop.org,
	intel-gfx@lists.freedesktop.org,
	iommu@lists.linux.dev,
	io-uring@vger.kernel.org,
	Jason Gunthorpe <jgg@nvidia.com>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	John Hubbard <jhubbard@nvidia.com>,
	kasan-dev@googlegroups.com,
	kvm@vger.kernel.org,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-arm-kernel@axis.com,
	linux-arm-kernel@lists.infradead.org,
	linux-crypto@vger.kernel.org,
	linux-ide@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mips@vger.kernel.org,
	linux-mmc@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux-s390@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	netdev@vger.kernel.org,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Robin Murphy <robin.murphy@arm.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Tejun Heo <tj@kernel.org>,
	virtualization@lists.linux.dev,
	Vlastimil Babka <vbabka@suse.cz>,
	wireguard@lists.zx2c4.com,
	x86@kernel.org,
	Zi Yan <ziy@nvidia.com>
Subject: Re: [PATCH RFC 06/35] mm/page_alloc: reject unreasonable folio/compound page sizes in alloc_contig_range_noprof()
Date: Fri, 22 Aug 2025 10:07:46 -0700
Message-Id: <20250822170746.53309-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250821200701.1329277-7-david@redhat.com>
References: 
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 21 Aug 2025 22:06:32 +0200 David Hildenbrand <david@redhat.com> wrote:

> Let's reject them early,

I like early failures. :)

> which in turn makes folio_alloc_gigantic() reject
> them properly.
> 
> To avoid converting from order to nr_pages, let's just add MAX_FOLIO_ORDER
> and calculate MAX_FOLIO_NR_PAGES based on that.
> 
> Signed-off-by: David Hildenbrand <david@redhat.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

