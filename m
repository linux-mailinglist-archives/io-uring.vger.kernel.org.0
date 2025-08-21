Return-Path: <io-uring+bounces-9193-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 60C4FB3044E
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:15:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C29A53B1FB5
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:12:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D72F313520;
	Thu, 21 Aug 2025 20:07:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L1YqEw2r"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 846DD312823
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:07:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806860; cv=none; b=DMuXltZNTZfaCq+5aZvXE533FsmaIzLiiKdJlGcKFCQ09E8lVlvWel6TrPwCZ5H3sPKoQbM7pkIf3gqflW1IwBgLabm/9GOB8rnPszaxTC93ZZpMEWv0qb4V/HBLiUgsJn/8CKLr9JjxbxAsrs+xSoOIftq2F1XVdVsn5J/Ol68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806860; c=relaxed/simple;
	bh=ncGz2ZUizfxPtBenqYCMYHXawyPm3K75je3+1YWzFIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cn71nJzV0HJi7PXkd1pZPCA+kcSuywshmlDWufY+7ghds14VKNvhTr42+JScwkxNCmDpWQDZ8OkyUb8o/QWzlWbqOXqVbmVTuA0n6kLYiDv5m+3GyofIx2x+xh8bRXD9Lf6LkVlgR+7hGoyfzEI2Ru1yri8PvsmE1xZYL8KpTjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=L1YqEw2r; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=G9hzYOZv6YXUN4v1wicJ53nqMhopJDezqYU76J2buLg=;
	b=L1YqEw2rAnHFUE68CfyqqmxiTUYb7LZtUIgBp+BZ7Nga6cvcAHBBD3iauzFq7/AGiKiruq
	uZNMrWdU2a9/deAqAZRa7j0dwZ6dLnJE7TFwYGyyiJ+lgMJOjMQny+FK9YOC4tny1TrmG3
	CHFMltPdih3MATs0VqaEDk4MS+VYyEA=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-410-Yq4RX59NNmS-sCinAt5jjg-1; Thu, 21 Aug 2025 16:07:31 -0400
X-MC-Unique: Yq4RX59NNmS-sCinAt5jjg-1
X-Mimecast-MFC-AGG-ID: Yq4RX59NNmS-sCinAt5jjg_1755806850
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45a1b0cc989so8650515e9.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:07:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806850; x=1756411650;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=G9hzYOZv6YXUN4v1wicJ53nqMhopJDezqYU76J2buLg=;
        b=Ktre/4ZYEO1QpPP9W3nFMIoBv2a2dl+ZPGaXuTAXoFaTlXumevBKh5Y6kb/j/lg1un
         P2VHm9HC29m44M6dKgZB2yI0vcqds6Z+CTKVHgbTW2XtfMdSJjFR0G94BIYC64YgMeev
         Vtwm2eoO8yOt1ptCzI+TyW9W9v1drdnLWlvX6x+CUe7ae4GuTHLR33N1Crfta23nGygn
         nyUIzeC1p4o7iRBRxlFJWnbQvwMbXkXWYGqglcOON1N4BwecoVDc3XCSD8o3i5wsuXKf
         2OdK0eTwz+OZJGQaWw4NhDg1Hsu9S0JMK+JW6rAeJSeOvWM8qgKQC1EbAJOsbMQRVZKc
         QAWA==
X-Forwarded-Encrypted: i=1; AJvYcCVpVtWHRshbmgy8Nt7me3MOtmzch6dOMJZQGbMQ+Y0mSEbxScevhCDXuB13MifleCxwAknQFCUrzg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwBCQK4tVzox7NS29bf6i87nOCwV+3JwfBCjZuDe3kFmNWNWn80
	gQqbT0IpNzS8Wvd1CTpl8i8MXHUzMeH+GEABw/cO1yXRhHE3s4/jEY8Ro1iM0Ci/baq/dDr/rPG
	slGonkXXp+/MiaRa+TXUvRKsr/undWSD4O5YrPoY1+d2ISfmQM0biBS5/CkqB
X-Gm-Gg: ASbGnctHvz18stru2JaoKEv5T8XcsdeIyDIYzHDSAQEiHukvwDLUtdbkAgvT8+jUvvj
	YFHJH2YP87a3tcXpaAsEfrD+EvhANJu7UBgF7AsfdF33cS2p1/XQcskG3VGjlL4M+aitOZfiUnf
	8YRmjcjV/j8jMIi0PlsgPx+LKBXvLpzU5Y76NLCcCGoJrNib46Q1D9+I+wkYSYSdsF+ODu95hBG
	DORKe15ctws1BErTcSgNS9zMqF53UuCXB2+UIovjlDTSoY80phlJIhSgNVqKZy9HodQxatuSIBi
	jKFu3nMpSENNq7NCCMukUz1t8a4pLAEyGuZkcm3OvNTXRqtR8+jIM77sucsxnAfEI7RWlbTc/tq
	zGzSO6PBkfijU9e27/weQiQ==
X-Received: by 2002:a05:600c:1548:b0:459:dfde:3329 with SMTP id 5b1f17b1804b1-45b517ddbe2mr2955945e9.31.1755806850032;
        Thu, 21 Aug 2025 13:07:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHPNoTdvVqQJqQwQf/z0aFpcDb/7HunF1Y6KwbAqmFFF4D3cnAaKEmAnoGbjwE6N5eIepmoyw==
X-Received: by 2002:a05:600c:1548:b0:459:dfde:3329 with SMTP id 5b1f17b1804b1-45b517ddbe2mr2955545e9.31.1755806849496;
        Thu, 21 Aug 2025 13:07:29 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c3a8980ed5sm7242256f8f.16.2025.08.21.13.07.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:29 -0700 (PDT)
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
Subject: [PATCH RFC 08/35] mm/hugetlb: check for unreasonable folio sizes when registering hstate
Date: Thu, 21 Aug 2025 22:06:34 +0200
Message-ID: <20250821200701.1329277-9-david@redhat.com>
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

Let's check that no hstate that corresponds to an unreasonable folio size
is registered by an architecture. If we were to succeed registering, we
could later try allocating an unsupported gigantic folio size.

Further, let's add a BUILD_BUG_ON() for checking that HUGETLB_PAGE_ORDER
is sane at build time. As HUGETLB_PAGE_ORDER is dynamic on powerpc, we have
to use a BUILD_BUG_ON_INVALID() to make it compile.

No existing kernel configuration should be able to trigger this check:
either SPARSEMEM without SPARSEMEM_VMEMMAP cannot be configured or
gigantic folios will not exceed a memory section (the case on sparse).

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/hugetlb.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 514fab5a20ef8..d12a9d5146af4 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4657,6 +4657,7 @@ static int __init hugetlb_init(void)
 
 	BUILD_BUG_ON(sizeof_field(struct page, private) * BITS_PER_BYTE <
 			__NR_HPAGEFLAGS);
+	BUILD_BUG_ON_INVALID(HUGETLB_PAGE_ORDER > MAX_FOLIO_ORDER);
 
 	if (!hugepages_supported()) {
 		if (hugetlb_max_hstate || default_hstate_max_huge_pages)
@@ -4740,6 +4741,7 @@ void __init hugetlb_add_hstate(unsigned int order)
 	}
 	BUG_ON(hugetlb_max_hstate >= HUGE_MAX_HSTATE);
 	BUG_ON(order < order_base_2(__NR_USED_SUBPAGE));
+	WARN_ON(order > MAX_FOLIO_ORDER);
 	h = &hstates[hugetlb_max_hstate++];
 	__mutex_init(&h->resize_lock, "resize mutex", &h->resize_key);
 	h->order = order;
-- 
2.50.1


