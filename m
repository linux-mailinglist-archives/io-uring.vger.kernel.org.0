Return-Path: <io-uring+bounces-9508-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 88D64B3E9C1
	for <lists+io-uring@lfdr.de>; Mon,  1 Sep 2025 17:23:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D9BBC480BA9
	for <lists+io-uring@lfdr.de>; Mon,  1 Sep 2025 15:17:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A2AC31AF21;
	Mon,  1 Sep 2025 15:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RsskXaXl"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB4234A326
	for <io-uring@vger.kernel.org>; Mon,  1 Sep 2025 15:09:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756739390; cv=none; b=l3fMessAFnTHCNbijFkcYYwLYD8xMQffo2hrimEb14dQvcg+deB0hAg7pc71TC6vVk9HJhuyoYHp9wNfmuyTUqTBPTh9woxipD2EaXSVCUuzIOdFB5M0PwCY3+rDDjSAyCe9nF1rdezb3iq5AeX7+DB+5+OhAN/ByX2Xj2ZbV08=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756739390; c=relaxed/simple;
	bh=mt9fiareU3+y02nYpe/B8txCT/Ho5QEBC+A/KGfVXMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ki8LXOHu5GB1x21IzqMFJzUgGvw13KyZknBJZXEjhMq30jGTVmaWVS8INLXfFA0DqfjHg8QqLsX7Iat6ITNHHGd1tUSya1NE28hDh8Z5UtkEbyLSTAX+SjQUcdykX73uv10R+VA9ta8qCYYSHuMmHcpNScNTLmVrqDJ3LNjLNXY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RsskXaXl; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739386;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ofhABKsmQsD0ka1l5H0E8RzWEQACOMy7wboU2BWZCLc=;
	b=RsskXaXlEg45dPjZAyhoB8smP+AnkT7TOyRAAr0KcGzJbN+qlufO07otay7bb19K3nO1wA
	S+z0gjY+I3sSeuLIgfToi8g/veMCtiQkrrZkUAWV/ygqiK9jeeCwcpqwT1Sayovh35eVzP
	sIRxUYnadZme8HLlRioT/wWy4DhE8Ak=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-630-rpW4Z1WtP2m8xTNCro4Y-g-1; Mon,
 01 Sep 2025 11:09:41 -0400
X-MC-Unique: rpW4Z1WtP2m8xTNCro4Y-g-1
X-Mimecast-MFC-AGG-ID: rpW4Z1WtP2m8xTNCro4Y-g_1756739367
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B75951800378;
	Mon,  1 Sep 2025 15:09:27 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 79F631800447;
	Mon,  1 Sep 2025 15:09:13 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH v2 19/37] mm/gup: remove record_subpages()
Date: Mon,  1 Sep 2025 17:03:40 +0200
Message-ID: <20250901150359.867252-20-david@redhat.com>
In-Reply-To: <20250901150359.867252-1-david@redhat.com>
References: <20250901150359.867252-1-david@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

We can just cleanup the code by calculating the #refs earlier,
so we can just inline what remains of record_subpages().

Calculate the number of references/pages ahead of times, and record them
only once all our tests passed.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index c10cd969c1a3b..f0f4d1a68e094 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -484,19 +484,6 @@ static inline void mm_set_has_pinned_flag(struct mm_struct *mm)
 #ifdef CONFIG_MMU
 
 #ifdef CONFIG_HAVE_GUP_FAST
-static int record_subpages(struct page *page, unsigned long sz,
-			   unsigned long addr, unsigned long end,
-			   struct page **pages)
-{
-	int nr;
-
-	page += (addr & (sz - 1)) >> PAGE_SHIFT;
-	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = page++;
-
-	return nr;
-}
-
 /**
  * try_grab_folio_fast() - Attempt to get or pin a folio in fast path.
  * @page:  pointer to page to be grabbed
@@ -2967,8 +2954,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	if (pmd_special(orig))
 		return 0;
 
-	page = pmd_page(orig);
-	refs = record_subpages(page, PMD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pmd_page(orig) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, refs, flags);
 	if (!folio)
@@ -2989,6 +2976,8 @@ static int gup_fast_pmd_leaf(pmd_t orig, pmd_t *pmdp, unsigned long addr,
 	}
 
 	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
 	folio_set_referenced(folio);
 	return 1;
 }
@@ -3007,8 +2996,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 	if (pud_special(orig))
 		return 0;
 
-	page = pud_page(orig);
-	refs = record_subpages(page, PUD_SIZE, addr, end, pages + *nr);
+	refs = (end - addr) >> PAGE_SHIFT;
+	page = pud_page(orig) + ((addr & ~PUD_MASK) >> PAGE_SHIFT);
 
 	folio = try_grab_folio_fast(page, refs, flags);
 	if (!folio)
@@ -3030,6 +3019,8 @@ static int gup_fast_pud_leaf(pud_t orig, pud_t *pudp, unsigned long addr,
 	}
 
 	*nr += refs;
+	for (; refs; refs--)
+		*(pages++) = page++;
 	folio_set_referenced(folio);
 	return 1;
 }
-- 
2.50.1


