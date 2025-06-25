Return-Path: <io-uring+bounces-8488-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1D5ECAE8F17
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 22:03:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8C21B3B5E2E
	for <lists+io-uring@lfdr.de>; Wed, 25 Jun 2025 20:02:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF854206F27;
	Wed, 25 Jun 2025 20:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BCaXJ2Qx"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 064E21F3B8A
	for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 20:03:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750881800; cv=none; b=kz7t3fVGQILQYFZFKTPkHD9uJTKxmF/K3zVvMGP8hbCFZwr5UnQMM4wSbxtcS8xuhxP64av8SOMU5ix5yxt8DENFMCzH4wEHw2V5l7HMuQnXV2xxj6FfDI+VKF159tJ2fne+0metFzBUdzv4nPVlOCaoPlFIxgdGFgSuOKJcNAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750881800; c=relaxed/simple;
	bh=diZUvsuygdgUuJpbdkBRN2X7Ia6hWcWPIGA1aInMWZE=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=pF7Kxo/VGspUbzmKGqpYM8GWQldOkXjgbKmer34X2XGPP5Jnbg9VF/TroA+G8QaVwkbGTBlqw+U2FsEYbY4uJ3fBRIFUBiq/PEoakvuVvFCkHE3KXanQZswc4cnbm007c0DkKe3vfy0rDlc6ytVZACjPFHE8Z+w+K3RAFZBpzEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BCaXJ2Qx; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1750881798;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=JSs8so6zmO6ZUprflkSDZAkkmaHGPnqT6njVMAY4rO0=;
	b=BCaXJ2Qx4h0ThIOBqxJP52bqHfc0Ou+6JNIZgKp2TFngxgD77GXpcldO8wTzLuUkydr5Fc
	yHk7ecWrYQmjOkvfroMUb+98zNwWtAQqlI4QIZXMV0+W8/dYYFfXmxX37gS5TjA57eA4Ml
	qIO7ethErLB7W8noM/KXwF5j+tyR0mU=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-79-hvkB3JDsP3u9RXBfkz80Mg-1; Wed, 25 Jun 2025 16:03:16 -0400
X-MC-Unique: hvkB3JDsP3u9RXBfkz80Mg-1
X-Mimecast-MFC-AGG-ID: hvkB3JDsP3u9RXBfkz80Mg_1750881796
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-313fb0ec33bso150160a91.2
        for <io-uring@vger.kernel.org>; Wed, 25 Jun 2025 13:03:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750881795; x=1751486595;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JSs8so6zmO6ZUprflkSDZAkkmaHGPnqT6njVMAY4rO0=;
        b=xM8WXCtV8/VQmOdB3CjZdzDOTyLonYbz+1TvUp2TT81pAKbhWw8qZQyLI5HdNnbBeA
         8sAKKuIhC831wy/4YbDOKWZlUROBrSnldT8567JYodl2uVao8JM85D7KSh2znoKf7OAL
         qBLRHNhl5UV+yxRnRyPI0pkLwZLgUdBSiy+Of+24789pC99sA+oFs7SIu4WicdYpzbOE
         6SlpZzUl0DUFuzyQQdvunPb32TLKw2IG61FkYkRmpAhdTvqsjuMjSTFLSzwlE/mNEXMJ
         xiORTrq6+gAxRwgRuWo0ivX+c9+OBbDltbqaeFweEsUD2lHKJLDefagyzrPd0D+vNUg3
         VIYg==
X-Forwarded-Encrypted: i=1; AJvYcCVZGbr7hNwVj3w7cI/jPWeheqKmAgzRNDJzY1LggFQ467MrpDhDJlnPdCvyasC1HQKS9jOzgVRCFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YyZiloy4L4ym5O0QrecJWQAo2ey043dzeRxNJQ35EUX3JP9IukH
	IsMZSZM7BRUGbnk8S0geHiLiXSKhx30RSiPGAAMUF2LXd+ZoGO53RpXaer3NsuW8U0gyhhm0iBY
	tUXZ1lQ1vVzOzQ6SC0NUfT2cdU3jZ4VFSdbbvitqtYCaWIXbRX3z6r+fDeNpX
X-Gm-Gg: ASbGncsqW2lKrpeS2pByuzj83iR0GO8QRLsZwFJQtpVYrO0Nn0sNKEj5dEE/+pLI+i9
	YQF1N5K4liJX2p9zumMOezRDtQsv2zMbsxrBXj65wKGVdt8v2+JZ8y70Tsl/WzCYcBejrS6i94G
	i9bpQwRXbw6HoJ+4EVAlOi7p4RXT76yitgbkJodIr2l9aAec4HoOh+kQ+mPm1zleFaf0lbemAbx
	pPuB4d1KiFc3FeCJQVafww8DPZCd0GXyOIcIDzi2cazaIZ+gbPefkh3bSaqmE3oucUWh1TtrwdD
	8CL2dpBSEng=
X-Received: by 2002:a17:90b:2c84:b0:312:26d9:d5a7 with SMTP id 98e67ed59e1d1-315f269a810mr6390272a91.20.1750881795448;
        Wed, 25 Jun 2025 13:03:15 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEWluOphzoBkdIqDO9x/Cn/KdojkpjiUCw5fsKUu7aYBwan55TLSI3+J3vCjY7+OxhBm/MMMQ==
X-Received: by 2002:a17:90b:2c84:b0:312:26d9:d5a7 with SMTP id 98e67ed59e1d1-315f269a810mr6390240a91.20.1750881794982;
        Wed, 25 Jun 2025 13:03:14 -0700 (PDT)
Received: from x1.com ([85.131.185.92])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-315f53a1bcbsm2509238a91.19.2025.06.25.13.03.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Jun 2025 13:03:14 -0700 (PDT)
From: Peter Xu <peterx@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: peterx@redhat.com,
	Helge Deller <deller@gmx.de>,
	Jens Axboe <axboe@kernel.dk>,
	Jason Gunthorpe <jgg@nvidia.com>,
	io-uring@vger.kernel.org
Subject: [PATCH RFC] io_uring: Fix addr usage on get_unmapped_area()
Date: Wed, 25 Jun 2025 16:03:10 -0400
Message-ID: <20250625200310.1968696-1-peterx@redhat.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

mm_get_unmapped_area() is an internal mm API to calculate virtual addresses
for mmap().  Here, addr parameter should normally be passed over from an
userspace as hint address.  When with MAP_FIXED, it's required to use the
address or fail the mmap().

When reviewing existing mm_get_unmapped_area() users, I stumbled upon this
use case, where addr will be adjusted to io_uring_validate_mmap_request().
That internally uses io_region_get_ptr() to fetch the kernel address that
io_uring used, by either page_address() or vmap() from io_region_init_ptr()
calls.

Here, the io_mapped_region.ptr isn't a valid user address, hence passing it
over to mm_get_unmapped_area() is misleading if not wrong.

The problem should be about parisc having issues with cache aliasing when
both io_uring kernel and the userspace may map the same pages.  Here what
matters should be pgoff rather than the address hint.  Simplify the code to
keep addr=0, while setup pgoff only to make sure the VA to be calculated
will satisfy VIPT's cache aliasing demand.

Cc: Helge Deller <deller@gmx.de>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Jason Gunthorpe <jgg@nvidia.com>
Cc: io-uring@vger.kernel.org
Signed-off-by: Peter Xu <peterx@redhat.com>
---
Marking this as RFC because I don't have parisc hence no test done, but
raise this issue.
---
 io_uring/memmap.c | 14 +++++---------
 1 file changed, 5 insertions(+), 9 deletions(-)

diff --git a/io_uring/memmap.c b/io_uring/memmap.c
index 725dc0bec24c..8b74894489bc 100644
--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -371,21 +371,17 @@ unsigned long io_uring_get_unmapped_area(struct file *filp, unsigned long addr,
 	 * kernel memory *and* userspace memory. To achieve that:
 	 * - use a NULL file pointer to reference physical memory, and
 	 * - use the kernel virtual address of the shared io_uring context
-	 *   (instead of the userspace-provided address, which has to be 0UL
-	 *   anyway).
-	 * - use the same pgoff which the get_unmapped_area() uses to
-	 *   calculate the page colouring.
+	 *   to calculate pgoff, which will be used later in parisc va
+	 *   allocator to calculate VIPT-safe aliasing va.
 	 * For architectures without such aliasing requirements, the
-	 * architecture will return any suitable mapping because addr is 0.
+	 * architecture will return any suitable mapping because pgoff is 0.
 	 */
 	filp = NULL;
 	flags |= MAP_SHARED;
-	pgoff = 0;	/* has been translated to ptr above */
 #ifdef SHM_COLOUR
-	addr = (uintptr_t) ptr;
-	pgoff = addr >> PAGE_SHIFT;
+	pgoff = (uintptr_t)ptr >> PAGE_SHIFT;
 #else
-	addr = 0UL;
+	pgoff = 0;
 #endif
 	return mm_get_unmapped_area(current->mm, filp, addr, len, pgoff, flags);
 }
-- 
2.49.0


