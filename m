Return-Path: <io-uring+bounces-9201-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id DB0A7B30499
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 22:19:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 990E316C648
	for <lists+io-uring@lfdr.de>; Thu, 21 Aug 2025 20:16:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2B0535FC1D;
	Thu, 21 Aug 2025 20:07:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aF4HxFg5"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7EA9535E4D5
	for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 20:07:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755806879; cv=none; b=nhkASsc9ORtwISHaWlt5BQheHIe20APH4gufibJLO3zNyR3n10x3cqrF9C+iePPYk7Veh4pUTeHWavAIW5vQeO5ugTKWk/ZB2VGLBMGvHKpYRgzubbRikU69SpGT+fNvyOLikmk+kPVcfXqcK2YEFuemya5KygJfiZZusvkzTSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755806879; c=relaxed/simple;
	bh=jeuBd6AEd//7dLky0U/9/K8CcfgAIF74DmeLEQ7xh6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qScPUmjXt/aV47f8Czz+gtbMMdYeDO1xsSKMge24N7FJ29CzCAK2vF/r7Kigu3Ng0V1aimw24ywbjoAwx7QH4NISvKl7fj8jPFgljbQ7+M9dywa6btfaWM976Owez+oxRh4qcw+L9y4OLfaeBqBYd+Q70tY07beYmXemSIxV4pY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aF4HxFg5; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1755806876;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NPs2EdTZ9fd3MpWdb0ATDCa6nUqfGtFMv2uyZP7L+uU=;
	b=aF4HxFg5JpXNVeLFIw/OyHbb2D9mmnfx5a8LqUFhXI/7ebtYoPoJwpgfA7mJDYQhTXCXmU
	DYgYfvUFxxAKS6LcrbfmGHWzYOb248B7yUp7f5ejrYXDWfNsNabMRylz1fmQOpYvDl8/nE
	13Q5MXPSHqaRtyiK5AfLCwk1fLYn9a0=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-683-cjyNAKnoOMGBGdN6TEOONA-1; Thu, 21 Aug 2025 16:07:55 -0400
X-MC-Unique: cjyNAKnoOMGBGdN6TEOONA-1
X-Mimecast-MFC-AGG-ID: cjyNAKnoOMGBGdN6TEOONA_1755806874
Received: by mail-wm1-f69.google.com with SMTP id 5b1f17b1804b1-45a1b0caae1so7449295e9.3
        for <io-uring@vger.kernel.org>; Thu, 21 Aug 2025 13:07:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755806874; x=1756411674;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NPs2EdTZ9fd3MpWdb0ATDCa6nUqfGtFMv2uyZP7L+uU=;
        b=IPt7dkqMPUuqzlh4+3gzvhUU1+esbcwvvF+66lflZtyTPYQW2lRXaSPyKsUi3d9zYO
         HWrgzEQdwk6TY0XWsNYYAcRPTk8qIi7wLCKgVmh0/f4oHoP6eJzXvxLMIF7BL2Rz20V9
         jEYYTd1oW0IqvMmRJl4Yep4FDX+GSHlCRXMeLCVjmg5xVzZprLwippiuY+V9p4kjxMt7
         GsLAHnGJ6r2OBWX2mDB9ND+3GMtkynjeQ1M/E0hzY3gZc8DwLLO3qrJzWDZdc3hC96cS
         GAK9ij39O1AFc3vUsty6JB1QlambptN3CJbQeeaqbXWUJ0m2/KopWE0ORGxdBQM6Bo80
         PgLg==
X-Forwarded-Encrypted: i=1; AJvYcCU/z3SV2tv9Oj83wLkYpL5+xhHtmG2d6TdApw+5YgH1PzpryWuOBz62rmI2sf/SPcaBctQVpixz1A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyt0FxSkeQT+g3hOh26VRUJzxnskoXgwfZ6gt3uFFOQ+6SwlyR5
	WkeJ9jHCTdSPZIFb2vkga3RUFyw3XDWim3Rw4LkZyaxg96BtrjueLpTOzvbst0R0FI3eJ9tliQI
	jCnHBm/pd3OmLM7/bRXUVkFWWhhehpXmoaBFTCvoFQM7aidpt2TVRKOOh0a2D
X-Gm-Gg: ASbGnctM/izz1e+1w84XRRinstiPn4s8H9XFCJxPyWP/nxHWDT8Y3QIzJKmYgh9pD4N
	CoGINGQ7tV+WSWbkdJUyi31Tpjif1FJGvekBVbfm5zDamEN5jDFKKPu1iS4DZYI2aUz91yzoeQD
	nFn58alZwgvtRwd384LjpIOhyjsXv79iTjFdUec1Z6zmggo3/j7efImwfCX/Y3Wf0IXo6c91C2G
	fsrp3tnsEeTcsnqpS+d/L/dygOgYpZbjB8+x3BwUaUar5hDUbMgV5Ztsy/+IYaRaZbXvM8V5Xp9
	Z3kzbVWTvWWqs62UGGwEYPUi7RtryczT5Fg8AIFc6nklRlLC3ug4IVQHrt7oLb9HY1JzJKQ9yfz
	LiOXXfz/wAIPpgZK6tgZ5Jg==
X-Received: by 2002:a05:600c:1388:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-45b517d40f2mr2554405e9.24.1755806874322;
        Thu, 21 Aug 2025 13:07:54 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFo8ikhW4DoWVw60oDeAXqMRvn4UERlcVawLCjGel2pacwRc1R1ONhYVQm5EzuW0YIJQT4FDg==
X-Received: by 2002:a05:600c:1388:b0:459:d451:3364 with SMTP id 5b1f17b1804b1-45b517d40f2mr2553905e9.24.1755806873856;
        Thu, 21 Aug 2025 13:07:53 -0700 (PDT)
Received: from localhost (p200300d82f26ba0008036ec5991806fd.dip0.t-ipconnect.de. [2003:d8:2f26:ba00:803:6ec5:9918:6fd])
        by smtp.gmail.com with UTF8SMTPSA id ffacd0b85a97d-3c07487a009sm12690403f8f.11.2025.08.21.13.07.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 Aug 2025 13:07:53 -0700 (PDT)
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
Subject: [PATCH RFC 17/35] mm/gup: drop nth_page() usage within folio when recording subpages
Date: Thu, 21 Aug 2025 22:06:43 +0200
Message-ID: <20250821200701.1329277-18-david@redhat.com>
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

nth_page() is no longer required when iterating over pages within a
single folio, so let's just drop it when recording subpages.

Signed-off-by: David Hildenbrand <david@redhat.com>
---
 mm/gup.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index b2a78f0291273..f017ff6d7d61a 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -491,9 +491,9 @@ static int record_subpages(struct page *page, unsigned long sz,
 	struct page *start_page;
 	int nr;
 
-	start_page = nth_page(page, (addr & (sz - 1)) >> PAGE_SHIFT);
+	start_page = page + ((addr & (sz - 1)) >> PAGE_SHIFT);
 	for (nr = 0; addr != end; nr++, addr += PAGE_SIZE)
-		pages[nr] = nth_page(start_page, nr);
+		pages[nr] = start_page + nr;
 
 	return nr;
 }
@@ -1512,7 +1512,7 @@ static long __get_user_pages(struct mm_struct *mm,
 			}
 
 			for (j = 0; j < page_increm; j++) {
-				subpage = nth_page(page, j);
+				subpage = page + j;
 				pages[i + j] = subpage;
 				flush_anon_page(vma, subpage, start + j * PAGE_SIZE);
 				flush_dcache_page(subpage);
-- 
2.50.1


