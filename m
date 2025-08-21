Return-Path: <io-uring+bounces-9203-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC88DB304A5
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:19:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B025E1CE5B0F
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:18:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D766E369332;
	Thu, 21 Aug 2025 20:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A8Y/z55w"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C7A6368081
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806886; cv=none; b=XWoGrJQh4T2VAZrcK3Pdeu/6O4uhgBrGq3putkZy8FG5Gw/Koz5Gp4ZWAUkD4kAw7OLkszZwdNODwbvQweu7/rhZEByxNnb7sTWzu1Vj+r/JrP1k1l2Ngx8oR/psfv28zOwGcDgVcQpnAkyexLolST+jMAORq3MR9Z3VSNYp3hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806886; c=relaxed/simple;
	bh=E88hXeAEs+yXdxHqIfTWo/GvQIeDr+kkFObDidynu1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNjJsdr1oGu80s3L1w8zIHxwO6XwIM2x7xf6B4TOhk4kSwRwgeOkb/UGg/FPi+SEWvIGHiZtBmhabdxDaCyb2IXU98UhdAr8i9rM3Em7sHH38FKcrEeTzLxrcGRIv3j3pBJ16RkM6/U8HEiuOVZ9SN2Wzv3LD50IhEmKA5mtZMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A8Y/z55w; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
	b=A8Y/z55whALu5jqaXnjs712aVYLHqF67dWfcHgxKHZmTKO15vFqYgm6IipQfXBlddnyuA1
	RZYJ63hZY0NJMOIqNrnpdJhIP3tv/7T+fyT56ysyvrcSKeis+Pi5fzo5tiq8r7hX68Se3U
	q18q7jTiHvKbMFln/PhXwPJpbZhgang=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-253-CN_mqvq9MluNJm1NT_4zwg-1; Thu, 21 Aug 2025 16:08:01 -0400
X-MC-Unique: CN_mqvq9MluNJm1NT_4zwg-1
X-Mimecast-MFC-AGG-ID: CN_mqvq9MluNJm1NT_4zwg_1755806880
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a15fd6b45so10808095e9.1
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:08:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806880; x=1756411680;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w6VkvDa+3msZeC5nA9B9+aDln+Mg2ABReefULBX94/4=;
        b=LnGEUY9+VPLJ2J5EsY/M1n28ctnf5uFJyBxvC9O/0ObwPLS6YmvboiwTtB1+tveXp0
         Ezlmsx1ITeEbpTwzSeVvlsLtNVjJ6SDIB9750BuvV3kJt5wuuS96DwgNvg3zForAU0dy
         wdZY3muAY/FPeKitWlfRA0HwEDaHV9Tvik75kppNZxXmc8HWlu7RB+bz7M4xIFlIWrVw
         NVtv05Ya3eIrwsKKX/boYBFYEnPkyvaXXEI61cmBDQNIQ5eRor2X9SkSGEC6OEh90SDb
         9/mMZWc2qWVPqQiXM0Aq2ArXS0hcMySXhKWH8Wj/zBQjaZTOVqcKSIswS9xhFkcmwA57
         Px3w==
X-Forwarded-Encrypted: i=1; AJvYcCVDaihPmeuXy6r2jAuFEk3iEYUmGm0oETkkPeE+IjVToPURlkQUlc1t7l2xSKYWItcLz8zmjku9/Q==@vger.kernel.org
X-Gm-Message-State: AOJu0YyLCbekMUlru4CAeMHZZ9m+AX6mVlCFa+YIwDqG9kpLxZFPwIiL
	do73v/OMNB5WLZX7FR7iZHMtycfNV2FqlSXy3XfYDWmH5eG4O5pjUUV9ISHPmSaxB1V8r88e/ue
	oWME1vrkZn0KfJ2o6CaZPBHn5FzT8qKhWyyEqGl/7zrZKbmV0MaB5cj1YCrZM
X-Gm-Gg: ASbGncuswMsD3ljLC1VCCoRyU26R5RoiZn8RrkbFEHmoX5jkwsK6+SL6b9wEffhCigv
	Xs7cECe547Nvvidn0gGGw/UNKhA/daaOcEkCKZKWNfGtuV041ncMvOrm/+Gv0dbrzfTRvO6cg2n
	MNGtz1c8DaE9wHAuhC47nDH1BM/zFEpOJaMcIEJ+SngWA424cYl1m28uwas1eo2jLvKQCi7IOQg
	uE+zW3Uw++KUNaCK0S33g3YaSsq045ET2IR8sHa2u0y2SKyahluFz7Y+TQS+pflOrFgxQ5DJJg7
	bVfxraSQppasAghceGiYzJDdC1qaLA7SJ9iDJ8v7gXmag0joiw2JAUlcfTo+LaSY/9iyQf7O4HT
	1Szlb6D8dItvlGtIS3L5lRw==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr3328495e9.11.1755806880024;
        Thu, 21 Aug 2025 13:08:00 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IG9ciI0WdoI3CxhUtu7m/cESVsdReJmvmXFWCMaWsO+hhXySreox2GeOL2sJ8kVyLPwCYhbEA==
X-Received: by 2002:a05:600c:1c87:b0:456:942:b162 with SMTP id 5b1f17b1804b1-45b51792539mr3328365e9.11.1755806879543;
        Thu, 21 Aug 2025 13:07:59 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07778939bsm12219075f8f.46.2025.08.21.13.07.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:59 -0700 (PDT)
From: David Hildenbrand <david@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: David Hildenbrand <david@redhat.com>,
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
Subject: [PATCH RFC 19/35] io_uring/zcrx: remove nth_page() usage within folio
Date: Thu, 21 Aug 2025 22:06:45 +0200
Message-ID: <20250821200701.1329277-20-david@redhat.com>
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

Within a folio/compound page, nth_page() is no longer required.
Given that we call folio_test_partial_kmap()+kmap_local_page(), the code
would already be problematic if the src_pages would span multiple folios.

So let's just assume that all src pages belong to a single
folio/compound page and can be iterated ordinarily.

Cc: Jens Axboe <axboe@kernel.dk>
Signed-off-by: David Hildenbrand <david@redhat.com>
---
 io_uring/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/zcrx.c b/io_uring/zcrx.c
index f29b2a4867516..107b2a1b31c1c 100644
--- a/io_uring/zcrx.c
+++ b/io_uring/zcrx.c
@@ -966,7 +966,7 @@ static ssize_t io_copy_page(struct page *dst_page, struct page *src_page,
 		size_t n = len;
 
 		if (folio_test_partial_kmap(page_folio(src_page))) {
-			src_page = nth_page(src_page, src_offset / PAGE_SIZE);
+			src_page += src_offset / PAGE_SIZE;
 			src_offset = offset_in_page(src_offset);
 			n = min(PAGE_SIZE - src_offset, PAGE_SIZE - dst_offset);
 			n = min(n, len);
-- 
2.50.1


