Return-Path: <io-uring+bounces-9509-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9DD1FB3E9D9
	for <lists+io-uring@lfdr.de>; Mon,  1 Sep 2025 17:24:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 028A11A86E24
	for <lists+io-uring@lfdr.de>; Mon,  1 Sep 2025 15:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7313E35A2AE;
	Mon,  1 Sep 2025 15:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ilDqPpzZ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B38135A2B5
	for <io-uring@vger.kernel.org>; Mon,  1 Sep 2025 15:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756739394; cv=none; b=SPcqz2SCdUrA7Th5Vt7W9Nu/lHoMz6LdMBnz7naqoWoPoePN6+EZCplJ52AaONthJDbyfI0wjAz4cqSTjNBt5Emee/J4npzxqdupEQygiV9XKgogScvEX6AN0zuq3oCAmJgP90nULY0BYzd/l2dodDll+wLzD7NkrHYRH7m8PEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756739394; c=relaxed/simple;
	bh=4jc/nUN0hPIGzav4jLjK+Go2JPayw+aXIlYs963cm2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mnY+B/rcXfCKNkD0TikBSf824c8K/6o8F0uqc4Ls3U/BeijxcTcKlpGFeiwZ75eoUDV+6G23eNtpIObGn2Vdzga8X67/1gjKNmrAqLjz30PAUhphIrG0ro+GsOVxrDO7It2G0vg7dptNs3Uc+u0K6unPwRc9l62SpclUxqDJBUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=ilDqPpzZ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1756739390;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0kDSZHtV88oad9zCDDBj5yf1ZyH7AU8+3y2ZSBVzpUw=;
	b=ilDqPpzZIHyvUHHIPaYyBw+aWwDy0dxf0awkdq72J4cqffR8+O224VtPeyn48LO4iUV/Vq
	6mtNh24vEATYo9pfCHwaYiajqVj6fl+W0FrfP6pbgDZaW6T8csLLnx2oVVE1AMS3Yo+UP8
	4hz1R9Ybaiw0HBxLFFE31waEEXsZyOE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-35-RS9bIdDPOQKXbvnr4BPRbg-1; Mon,
 01 Sep 2025 11:09:48 -0400
X-MC-Unique: RS9bIdDPOQKXbvnr4BPRbg-1
X-Mimecast-MFC-AGG-ID: RS9bIdDPOQKXbvnr4BPRbg_1756739383
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3EB7719560B2;
	Mon,  1 Sep 2025 15:09:43 +0000 (UTC)
Received: from t14s.fritz.box (unknown [10.22.88.45])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 54B441800447;
	Mon,  1 Sep 2025 15:09:28 +0000 (UTC)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Jens Axboe <axboe@kernel.dk>,
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
Subject: [PATCH v2 20/37] io_uring/zcrx: remove nth_page() usage within folio
Date: Mon,  1 Sep 2025 17:03:41 +0200
Message-ID: <20250901150359.867252-21-david@redhat.com>
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

Within a folio/compound page, nth_page() is no longer required.
Given that we call folio_test_partial_kmap()+kmap_local_page(), the code
would already be problematic if the pages would span multiple folios.

So let's just assume that all src pages belong to a single
folio/compound page and can be iterated ordinarily. The dst page is
currently always a single page, so we're not actually iterating
anything.

Reviewed-by: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 io_uring/zcrx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index e5ff49f3425e0..18c12f4b56b6c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -975,9 +975,9 @@ static ssize_t io_copy_page(struct io_copy_cache *cc, struct page *src_page,
 
 		if (folio_test_partial_kmap(page_folio(dst_page)) ||
 		    folio_test_partial_kmap(page_folio(src_page))) {
-			dst_page = nth_page(dst_page, dst_offset / PAGE_SIZE);
+			dst_page += dst_offset / PAGE_SIZE;
 			dst_offset = offset_in_page(dst_offset);
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
 			n = min(n, len);
-- 
2.50.1


