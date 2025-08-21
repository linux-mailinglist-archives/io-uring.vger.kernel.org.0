Return-Path: <io-uring+bounces-9204-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id B0A9FB304AF
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:20:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id C3937188B7D6
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:19:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 351E236C087;
	Thu, 21 Aug 2025 20:08:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bRW0NX5J"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73C7636934E
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:08:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806890; cv=none; b=gXUB7onNjSjc+BX7G1v1cxG2CX2jp7Mkkj6ujL0/y+QeXnMIasj/HfQDQ6fckSFiBlvz/85CS052wEsH6XP0LtfnxznjY9qlKU6zQDQb8F2Za1gx/LDA97NVgNp3J8PZ/TmsiX4Nzna2a+7fzLY4u6ONfkHTZRZx8cYRD1gZZSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806890; c=relaxed/simple;
	bh=3RfOoWzbZTj8EGhrr7OVQfmCtFM6TSZBuGB7jdppkcE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wa9a9y2YekBpSW28ezKNfBxGP/KkubDLs/qG1o7Lz6sUDyQuGW4Q5zpTtKzNb+5z28JeuI3HCscnW06CUZf3C/6Ckw/KLw2c2TGNHsWSSSuArHg0Q4+Ssriy4o/rhqo+T8RU2cn0JLEPpoj2lznY83xBh957F2bKnr1NCnyhjeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bRW0NX5J; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806887;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jaRFM4K4Pg6WYlxhcM2k1BGbQ/DW6XfjnDsCttbmjXY=;
	b=bRW0NX5JRUyYmmsy5RWGUdG59gEQiLUM26nWMH9eAS2FF5LAXdSlvHhloENu9w9Izpz/r8
	b5fI0cGvapphvg0ew8KJbpGOLmQ8ivTZF47L73ckZJsP9vDZ6EUAnVgXRYxGQqMuJR2pob
	DKQ69qkedCwZH3f4l1XsLH5N7/4Fz/s=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-439-yfDpCsK1OvKgWXbJwrZvKA-1; Thu, 21 Aug 2025 16:08:04 -0400
X-MC-Unique: yfDpCsK1OvKgWXbJwrZvKA-1
X-Mimecast-MFC-AGG-ID: yfDpCsK1OvKgWXbJwrZvKA_1755806883
Received: by mail-wm1-f71.google.com with SMTP id 5b1f17b1804b1-45a1b0045a0so8436245e9.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806883; x=1756411683;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jaRFM4K4Pg6WYlxhcM2k1BGbQ/DW6XfjnDsCttbmjXY=;
        b=l7c+LFDTBuRMB7GY/dFMl0MygomOvj0ZJ1SuQ0Dc5f9tuKHCsWCqIVyLvnkRCQcTLx
         a3oOggXjYA1P16k5AseW5O9O99SKEnW3qb5h6uRt9a3/KIj+Cn4c7wGwp12cB0eY9pyb
         yITa+z2ulGrclQ5ZdzLW6EqJKpEvP+nvQYEmP0v6POKBXqCoxjG4IlkLjEpWR4UkGZJw
         t9LxFOhOd51DzLLFZsJtgo5uOmz6U1qzM+mirOH4pwFyz0mrHogaEidzObjX0P3Saxyz
         t/ONZgfxs959zmMdCx1Y76yoISq6/YExiDHM/QZHwTdy/dswUb79fLmyOIg4qnAvnic3
         ALTg==
X-Forwarded-Encrypted: i=1; AJvYcCUPE8Bgj5UWL1cZxE4xMGpxdEGm+TFJnEqBIa3T6pTAA4/v6n4XWyzgmP3f5Jx4Ca3wy5frptdLWw==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy/9X9E9yr5/S4zy8g7xDx1Hy8HdZd8qKfGj5A37IwKC/5jYWZQ
	pu8MzXOLX225nanEF3n+FHkTAhDl+ssE594+fT8B0qsEJpKaWFbycNtAZgzBRigba2mx7QbYeRk
	oMkkGL64i5MO7sHW0kWLhKIO2h9tLCdGb9eM7RALw96FwI0rSkduvUz40g9hV
X-Gm-Gg: ASbGncvggJYpNAsjjAGVbTczfje9QNV9XnvxyomfzhlV61202ESCwohJNqfaMR+zvZ6
	f00OQfwEUxhxIHiH/K4tl8czpqB73jpqNO0FkoGHUDrlIufmPNw2G0UTxZngeECgD5A9GflYJgp
	fEnBkod0eeGxosAwXBpxX/ttuEgsiF5TG1qRC2VFzTyFroNFnJP7IxbxwSE5ZwP6dBQjBS50l/l
	Q+n8VkegMQATIxyswBYcR1DGzL35sfckQvBlmxxqWPjZf+6SvwsmnRUzHG0OwbsBWXksaU3jaUY
	9+aT3FL874IoFhtgInxOoLaunAslVdUqxNwIcURPT+V/HL3+WpwoFC8Qbz92HWvOJsU3CsySimo
	1B7IeW0j2/J+i3/ea5vc/YQ==
X-Received: by 2002:a05:6000:2012:b0:3b7:dd87:d741 with SMTP id ffacd0b85a97d-3c5dcc095c3mr196213f8f.42.1755806882819;
        Thu, 21 Aug 2025 13:08:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFiRO9AsztHDXjXXwtKcCswXKV/HQQvQjujQOlltIgK9F5s1Ca8ikdDYrX2bvCVEtKZoFK6NA==
X-Received: by 2002:a05:6000:2012:b0:3b7:dd87:d741 with SMTP id ffacd0b85a97d-3c5dcc095c3mr196155f8f.42.1755806882316;
        Thu, 21 Aug 2025 13:08:02 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b50e0b299sm8957945e9.22.2025.08.21.13.08.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:08:01 -0700 (PDT)
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
Subject: [PATCH RFC 20/35] mips: mm: convert __flush_dcache_pages() to __flush_dcache_folio_pages()
Date: Thu, 21 Aug 2025 22:06:46 +0200
Message-ID: <20250821200701.1329277-21-david@redhat.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250821200701.1329277-1-david@redhat.com>
References: <20250821200701.1329277-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

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
index 1f14132b3fc98..8a2de28936e07 100644
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


