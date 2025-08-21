Return-Path: <io-uring+bounces-9195-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id C8FB5B3044D
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:15:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 50CF21C22576
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:13:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ADA3534A332;
	Thu, 21 Aug 2025 20:07:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CH8r6nmP"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C39313555
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:07:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806864; cv=none; b=sew7hpEzV285uhFq63g3/Uq74srhpLrwQPTZzsHsZsEKfDFS+YQK9RPrcm9Cgj/AzmopdrYYYWnKdk8+LoYx6cupJha2JrSR2M5lYkruC0w1biRlFvKC5bRmMs+mZ97cXbNjupNxa1w881gKSND8as8EjuRwzEnEsv1l8djmYY0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806864; c=relaxed/simple;
	bh=XmsSbVhT3dGsaRmtyroJ024d7WMqPWbEWQJfIPHhOJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ctA9+jp9yH+gcSu1Cnmkf4bnRXjWJUoSUyXjzf0Iwss+tkDBRAI5Fm4dqcbGcDDG+Hm0oEiTIbIJuOrYvZiOCLyPPYx+hdDEWULEQ1+fgNDumpRChefGt5SJ2nD4E/hNOb1fF9s8zn9bCj9Xyjn9K6zJ47TX/mAF4cyZhII7DI4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CH8r6nmP; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806861;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QQ4Uu4zoWyKmYQrq0i4l3HgKr6VpAHaNUVdQgPTsBAE=;
	b=CH8r6nmP3KCdXZMFkoQvPAZ1pJZRBcIAUYhHBGbN4jDLDZcaoAULhvaDkuTvcoWYCPQKxc
	Xz+1EDYt4987pD0fioEn7fmuSQW6gtcCiM6aZBUExDmETNIBvNF7qlU3/6+eDOdvpQFO6u
	k+VZJ2bivRWRY8bIqct/CM0tFvC6TSY=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-275-P_DWPSfJP8ua5m3ZH-qDXA-1; Thu, 21 Aug 2025 16:07:39 -0400
X-MC-Unique: P_DWPSfJP8ua5m3ZH-qDXA-1
X-Mimecast-MFC-AGG-ID: P_DWPSfJP8ua5m3ZH-qDXA_1755806858
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-45b51411839so821385e9.0
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:07:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806858; x=1756411658;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QQ4Uu4zoWyKmYQrq0i4l3HgKr6VpAHaNUVdQgPTsBAE=;
        b=MIKA3Ri9p48lw6bAtsn3/BtN56Ef2VGDR/YU5UcItbVKYoeEL8aSMLxPy80hKEIHDe
         L/DsVCEvNk4Kyonl8bJCqlr5x1ARVGQaQsA+fBAxLIxHSkEfFM/Xit5lN1SkheeUYvmo
         yLPmO9mCDo8vaPgismVZPsd/Iem1/5qy7AKuFpjh8jmd2hIEyJrm6Dsi34KisLknfVL3
         79oTDhpqimbErY4EZPIEbNBu5hxQmXhjOGh2H8O86zEFlmIhHIylj/ptWEyelUPqRWg8
         RsJ6SdpqiDjsCu++GM1xZN+Fxs7GUEGHiZdWGLLS+SY99hFYVyvfb6s20SG0OZrdN5a4
         DSSA==
X-Forwarded-Encrypted: i=1; AJvYcCVf2Ae4GwmXtdIg1M0riWLZFC1x6EqKKw+jER74PsL97LCb2q9TKgCyBTYRATGZ+RiQrqOgPaPcyQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yz6fhDWCR+EGpqcTzm1C2wV6G+ZmaYNgdmbbGpnt/kLwIW6BX1c
	eTYfXLGX2Ozde4aibSKNGEndiQbZmt4IDRufb4o2Da0I8LSsEIU5nWEWmPrpbsBqesoKm8WQXwE
	zZBagwDIhCfjC8O31eetru2riDQpF20ekRq4FP+IZSzEdINieFwgyLj2wt2QT
X-Gm-Gg: ASbGncuJd1PxABDnidIHbNjk1p3nxF6gym3bPVPMCuJGS0WNPSXYeRkHBClykG8J47C
	depbb2sGCMo8y//1oeQtgQP/0io5+Bw77E8YhIcGE9Is1t2QE29jXP5HA71d2g+4uCybwzc9Bis
	CtJ7VR1a64kZBHQYbzt9vQo96+Tr71awsj/i0jV5GuIiLw/sAK2pWGY2oyYrx3lKVK7KyywhAhk
	/4Q32Xy1+wgfw0/C9lc0swo+oCUnw/5pv+wkc/hFdAyaPoCHy7ehdXENxntzQDNmBvFyOsoPyYS
	4c4UwxUZvsJ1bwLpR0pQgu8G4MKgHyMaSFWIcizITVBaJcaiKcu7eMG/yCFFz1NWI1B4IdV5YDZ
	7wCV476uAUVuIRuLaunbpcw==
X-Received: by 2002:a05:600c:5251:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b517ca54cmr2646535e9.18.1755806857889;
        Thu, 21 Aug 2025 13:07:37 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHlSU80KqPPviGOLp6CI40u/NjPujjG4FLCG6NoakJIlvY80lRDOTTm20w50mEKFuk0YjVSLQ==
X-Received: by 2002:a05:600c:5251:b0:455:f380:32e2 with SMTP id 5b1f17b1804b1-45b517ca54cmr2646245e9.18.1755806857378;
        Thu, 21 Aug 2025 13:07:37 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-45b4e87858asm18672185e9.3.2025.08.21.13.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:36 -0700 (PDT)
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
Subject: [PATCH RFC 11/35] mm: sanity-check maximum folio size in folio_set_order()
Date: Thu, 21 Aug 2025 22:06:37 +0200
Message-ID: <20250821200701.1329277-12-david@redhat.com>
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

Let's sanity-check in folio_set_order() whether we would be trying to
create a folio with an order that would make it exceed MAX_FOLIO_ORDER.

This will enable the check whenever a folio/compound page is initialized
through prepare_compound_head() / prepare_compound_page().

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/internal.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/internal.h b/mm/internal.h
index 45b725c3dc030..946ce97036d67 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -755,6 +755,7 @@ static inline void folio_set_order(struct folio *folio, unsigned int order)
 {
 	if (WARN_ON_ONCE(!order || !folio_test_large(folio)))
 		return;
+	VM_WARN_ON_ONCE(order > MAX_FOLIO_ORDER);
 
 	folio->_flags_1 = (folio->_flags_1 & ~0xffUL) | order;
 #ifdef NR_PAGES_IN_LARGE_FOLIO
-- 
2.50.1


