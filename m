Return-Path: <io-uring+bounces-9338-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D1E9B38D6A
	for <lists+io-uring@lfdr.de>; Thu, 28 Aug 2025 00:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 7C3721C24E9B
	for <lists+io-uring@lfdr.de>; Wed, 27 Aug 2025 22:13:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 47A1B3314A7;
	Wed, 27 Aug 2025 22:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DWaBNMnv"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20A91314A9F
	for <io-uring@vger.kernel.org>; Wed, 27 Aug 2025 22:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756332486; cv=none; b=W6JGh6zAeT52LESloHpT8IZXTgB4btaSU+zteVmq/XqNtXP3ifCh/8+vok7gWYeAFpoOAvbqp+KY9PxbzWhSPFljiX4NS402mt4mSTrUU2a+56fFxYAZczNCHGw/BMwu+16Z/XOGpzewT+ucEhmVn0zzhKK2p6G+RWIHhlpMiSE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756332486; c=relaxed/simple;
	bh=bLHjOTNpsHVzUO+cO2M/nuJz28LIvshjEUcpE8PfecA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLea+wIgfDEf0K36rP5YmwE20YZZZnHUV5nvcwEGGVU32cfkQK4TdhNXgk+uJBeG4ZUYwcBPMV6TDRw5jfH3H8qtNmtaxio1z0JuGlL9EEcXuKaPARvhkYF5Qlqdm+9Y98/6FRtcs2SJo8A86tI337ULQce1SXZL6ERs81YEcqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=DWaBNMnv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756332483;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3ZA4z8X3DBAGYUxj/2WGnSPhW3B2O9Q5Mn2y+SAGx1Y=;
	b=DWaBNMnveU1tSZpjByUJKlZ1okenrWfEBZEVhDP4eB2lqhUaDKG3MATYWNax2tnWNaJwZY
	7Myx3FDadHyKe7P1i1g2Y5KFK/knSwOAyrhJ7B/swxwP775N/Fhw13oAKch1I7BVQXzbHt
	F6PWG89+V3nUhF+Iz9Iw8jQyESwvhlg=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-9CODWK8aMK6h5vL0lOzKFQ-1; Wed,
 27 Aug 2025 18:07:57 -0400
X-MC-Unique: 9CODWK8aMK6h5vL0lOzKFQ-1
X-Mimecast-MFC-AGG-ID: 9CODWK8aMK6h5vL0lOzKFQ_1756332470
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AD5F5195608A;
	Wed, 27 Aug 2025 22:07:50 +0000 (UTC)
Received: from t14s.redhat.com (unknown [10.22.80.195])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 7867C30001A1;
	Wed, 27 Aug 2025 22:07:34 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
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
Subject: [PATCH v1 20/36] mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()
Date: Thu, 28 Aug 2025 00:01:24 +0200
Message-ID: <20250827220141.262669-21-david@redhat.com>
In-Reply-To: <20250827220141.262669-1-david@redhat.com>
References: <20250827220141.262669-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Let's make it clearer that we are operating within a single folio by
providing both the folio and the page.

This implies that for flush_dcache_folio() we'll now avoid one more
page->folio lookup, and that we can safely drop the "nth_page" usage.

Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 arch/mips/include/asm/cacheflush.h | 11 +++++++----
 arch/mips/mm/cache.c               |  8 ++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/mips/include/asm/cacheflush.h b/arch/mips/include/asm/cacheflush.h
index 5d283ef89d90d..8d79bfc687d21 100644
--- a/arch/mips/include/asm/cacheflush.h
+++ b/arch/mips/include/asm/cacheflush.h
@@ -50,13 +50,14 @@ extern void (*flush_cache_mm)(struct mm_struct *mm);
 extern void (*flush_cache_range)(struct vm_area_struct *vma,
 	unsigned long start, unsigned long end);
 extern void (*flush_cache_page)(struct vm_area_struct *vma, unsigned long page, unsigned long pfn);
-extern void __flush_dcache_pages(struct page *page, unsigned int nr);
+extern void __flush_dcache_folio_pages(struct folio *folio, struct page *page, unsigned int nr);
 
 #define ARCH_IMPLEMENTS_FLUSH_DCACHE_PAGE 1
 static inline void flush_dcache_folio(struct folio *folio)
 {
 	if (cpu_has_dc_aliases)
-		__flush_dcache_pages(&folio->page, folio_nr_pages(folio));
+		__flush_dcache_folio_pages(folio, folio_page(folio, 0),
+					   folio_nr_pages(folio));
 	else if (!cpu_has_ic_fills_f_dc)
 		folio_set_dcache_dirty(folio);
 }
@@ -64,10 +65,12 @@ static inline void flush_dcache_folio(struct folio *folio)
 
 static inline void flush_dcache_page(struct page *page)
 {
+	struct folio *folio = page_folio(page);
+
 	if (cpu_has_dc_aliases)
-		__flush_dcache_pages(page, 1);
+		__flush_dcache_folio_pages(folio, page, folio_nr_pages(folio));
 	else if (!cpu_has_ic_fills_f_dc)
-		folio_set_dcache_dirty(page_folio(page));
+		folio_set_dcache_dirty(folio);
 }
 
 #define flush_dcache_mmap_lock(mapping)		do { } while (0)
diff --git a/arch/mips/mm/cache.c b/arch/mips/mm/cache.c
index bf9a37c60e9f0..e3b4224c9a406 100644
--- a/arch/mips/mm/cache.c
+++ b/arch/mips/mm/cache.c
@@ -99,9 +99,9 @@ SYSCALL_DEFINE3(cacheflush, unsigned long, addr, unsigned long, bytes,
 	return 0;
 }
 
-void __flush_dcache_pages(struct page *page, unsigned int nr)
+void __flush_dcache_folio_pages(struct folio *folio, struct page *page,
+		unsigned int nr)
 {
-	struct folio *folio = page_folio(page);
 	struct address_space *mapping = folio_flush_mapping(folio);
 	unsigned long addr;
 	unsigned int i;
@@ -117,12 +117,12 @@ void __flush_dcache_pages(struct page *page, unsigned int nr)
 	 * get faulted into the tlb (and thus flushed) anyways.
 	 */
 	for (i = 0; i < nr; i++) {
-		addr = (unsigned long)kmap_local_page(nth_page(page, i));
+		addr = (unsigned long)kmap_local_page(page + i);
 		flush_data_cache_page(addr);
 		kunmap_local((void *)addr);
 	}
 }
-EXPORT_SYMBOL(__flush_dcache_pages);
+EXPORT_SYMBOL(__flush_dcache_folio_pages);
 
 void __flush_anon_page(struct page *page, unsigned long vmaddr)
 {
-- 
2.50.1


