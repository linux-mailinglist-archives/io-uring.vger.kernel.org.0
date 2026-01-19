Return-Path: <io-uring+bounces-11808-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 04238D39F72
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 08:13:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 67EFA305FC4B
	for <lists+io-uring@lfdr.de>; Mon, 19 Jan 2026 07:10:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C66A2DCC1F;
	Mon, 19 Jan 2026 07:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M7sgr0tg"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qv1-f66.google.com (mail-qv1-f66.google.com [209.85.219.66])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7103B2DA75B
	for <io-uring@vger.kernel.org>; Mon, 19 Jan 2026 07:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.66
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768806650; cv=none; b=Hwpek9Fz7EcXbMsdz7VuPfwaXF0h18Y9X7n81f0fMMV86zVKTOWRg7xKN4oQc/5Td90FirFhfP3Sx5tr0PmgAuPWG393Jy3fL+Y6ifAhisZ24/VLAFuw3+huxLaDh6P9z+EMNt+tSm0tjPZBW9UM81eqWoHbbqvb1m77+gejig0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768806650; c=relaxed/simple;
	bh=S3Y98FFWgoY8a3pcnPVFBrL19HFaL0F70zFtuxAOCe0=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version; b=isx+LA34EqBs+w4eC4CreMv5teaWEy5UVYEyL1RlNGaqmweLetlF5gVLtkjVo8dPVYQhIxLfQx/S8fkSCLdl3Ck2ugzGDvn3FQh0m6BqwlhVce/T6szH0chuZ9pRjCYC1C0ATNlUj5ZVmrtGFuTrLvDM9uBePic4cXy6BA4v364=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M7sgr0tg; arc=none smtp.client-ip=209.85.219.66
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qv1-f66.google.com with SMTP id 6a1803df08f44-88a37cb5afdso70773586d6.0
        for <io-uring@vger.kernel.org>; Sun, 18 Jan 2026 23:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768806647; x=1769411447; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=gKM15vI5ObaHuQbAnvaLHXhQIMY9SS6X3bJEvEg+p4E=;
        b=M7sgr0tgEqxU85NZwJXA0fJ7ksaOXe6UK4eRTS1rsoNH5NYiD/ICYEV2fV4Z2JLz6l
         Zk4FHXMO3n7O612o9SENbGsWzYCqdU6ol8hUShUZB1aNN3m3oviyUIPufkPTTwJ13121
         RNHk7ACCZ2/tZrhcbqAH0QRRqpwYZCjjRMkWLwymPK3K2jfIw5uyGLj09Gq869sDSR8/
         8M81UMFqjq0CaeHK6jvN0h8hMq1wIq9LTga5offRTuTcCWgFwmjM/+vsGKHOO/Z23EnB
         +3N+TZO/YzgbAgsiQ+gTZDggeHAy4xD3kRgVlUK6/mIyLbQHJfivjL+BosbRvxibvVfs
         Y6Pg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768806647; x=1769411447;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gKM15vI5ObaHuQbAnvaLHXhQIMY9SS6X3bJEvEg+p4E=;
        b=vrda7BjX3wYqoxJsIKiPru+4uAe81FIPQce0B/meYCX+N2tkhEL1/fqubCBUpZRjec
         t/Fnmve52IHZn6wPrFBMLT2F7jd05lDSu9GctBI8q3Ckqrmk1Kz3wEUCdnvAVslqEYyw
         aVp1vL179wsnCdpaUi2nidgtNMvd+U7i9M2KXU7cHd7U+sc0bH+webrCPLyj7oM272qp
         M/qZIs2zDdRGguQ8g51JnaZatXIsBFUaeSR9XS+3omCY1BnfyId9VxHEvu+iF9zobyeF
         eQsi1+TJmHozDkViOyG0NJAUYEOGcQkEXp81rCCO8mLjcJDkjM1+7vWlVQYosu1l26Rs
         nhYA==
X-Gm-Message-State: AOJu0YyzV/QJsbSqlL8RIj9SBPhv9/bglT1FB1vo1oVHroYfSlRyL7Ci
	FgFBtLi7QuyjfEQ7YyUg3xBY5xQx/xv+Yyd3UZFAqYUp+RUkNl+jQcKA
X-Gm-Gg: AY/fxX5Ej8cGTh1wp409itsV8kDm06/Huldq7927AY0429sTJ1EK3sLoP+at0Qs+Sgd
	QlFv+qHLA6V5VwxgcyELagxYzJ+GwSiv1s47bLOBwAunpQkY3VVu/iG2I2Lb+ywHwE2rIjwSHM2
	PKYOTH/d51Tv0+Oth1X1Ywp54J5VYetfzUxazVrjl0EiIcEveEkJXSkuZ9DnMzMOcwGspyIfyxP
	McvjxnWHcP/nXprC/dfzkQrsCqlM+e0S7lnXKjLJl0Q7RKu0fvJzvqZwq8bSR69OJWn5AUqMUH+
	rP6GJZUYToI9HCT5k+8hMI7wVD1l3eQGhkCq2gLXd5BBkUxqqC3vvboQc13UbhkddwR7LlzroXv
	HWwICQ6g3+b6beFU/CpCLBbfKnAxim0cvXdJEc/D05I0nFryGi/3kuolhQUzVS595MLKXqLKgPh
	Wjc6Aptt1e2IkmZ8z4SGt7BOrqzOxTcRx6Oo2RQWIOVtf1n/lNwVQv6g01M6C6mml0CpXrCP85U
	/uUZ3vJ3HA1VgdDHNX/9dS9PA==
X-Received: by 2002:a05:6214:21ef:b0:87c:19af:4b76 with SMTP id 6a1803df08f44-89398144853mr211893076d6.17.1768806647373;
        Sun, 18 Jan 2026 23:10:47 -0800 (PST)
Received: from abc-virtual-machine.localdomain (c-76-150-86-52.hsd1.il.comcast.net. [76.150.86.52])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8942e6043a6sm79024586d6.18.2026.01.18.23.10.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 18 Jan 2026 23:10:46 -0800 (PST)
From: Yuhao Jiang <danisjiang@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Yuhao Jiang <danisjiang@gmail.com>
Subject: [PATCH v2] io_uring/rsrc: fix RLIMIT_MEMLOCK bypass by removing cross-buffer accounting
Date: Mon, 19 Jan 2026 01:10:39 -0600
Message-Id: <20260119071039.2113739-1-danisjiang@gmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When multiple registered buffers share the same compound page, only the
first buffer accounts for the memory via io_buffer_account_pin(). The
subsequent buffers skip accounting since headpage_already_acct() returns
true.

When the first buffer is unregistered, the accounting is decremented,
but the compound page remains pinned by the remaining buffers. This
creates a state where pinned memory is not properly accounted against
RLIMIT_MEMLOCK.

On systems with HugeTLB pages pre-allocated, an unprivileged user can
exploit this to pin memory beyond RLIMIT_MEMLOCK by cycling buffer
registrations. The bypass amount is proportional to the number of
available huge pages, potentially allowing gigabytes of memory to be
pinned while the kernel accounting shows near-zero.

Fix this by removing the cross-buffer accounting optimization entirely.
Each buffer now independently accounts for its pinned pages, even if
the same compound pages are referenced by other buffers. This prevents
accounting underflow when buffers are unregistered in arbitrary order.

The trade-off is that memory accounting may be overestimated when
multiple buffers share compound pages, but this is safe and prevents
the security issue.

Reported-by: Yuhao Jiang <danisjiang@gmail.com>
Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: de2939388be5 ("io_uring: improve registered buffer accounting for huge pages")
Cc: stable@vger.kernel.org
Signed-off-by: Yuhao Jiang <danisjiang@gmail.com>
---
Changes in v2:
  - Remove cross-buffer accounting logic entirely
  - Link to v1: https://lore.kernel.org/all/20251218025947.36115-1-danisjiang@gmail.com/

 io_uring/rsrc.c | 43 -------------------------------------------
 1 file changed, 43 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 41c89f5c616d..f35652f36c57 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -619,47 +619,6 @@ int io_sqe_buffers_unregister(struct io_ring_ctx *ctx)
 	return 0;
 }
 
-/*
- * Not super efficient, but this is just a registration time. And we do cache
- * the last compound head, so generally we'll only do a full search if we don't
- * match that one.
- *
- * We check if the given compound head page has already been accounted, to
- * avoid double accounting it. This allows us to account the full size of the
- * page, not just the constituent pages of a huge page.
- */
-static bool headpage_already_acct(struct io_ring_ctx *ctx, struct page **pages,
-				  int nr_pages, struct page *hpage)
-{
-	int i, j;
-
-	/* check current page array */
-	for (i = 0; i < nr_pages; i++) {
-		if (!PageCompound(pages[i]))
-			continue;
-		if (compound_head(pages[i]) == hpage)
-			return true;
-	}
-
-	/* check previously registered pages */
-	for (i = 0; i < ctx->buf_table.nr; i++) {
-		struct io_rsrc_node *node = ctx->buf_table.nodes[i];
-		struct io_mapped_ubuf *imu;
-
-		if (!node)
-			continue;
-		imu = node->buf;
-		for (j = 0; j < imu->nr_bvecs; j++) {
-			if (!PageCompound(imu->bvec[j].bv_page))
-				continue;
-			if (compound_head(imu->bvec[j].bv_page) == hpage)
-				return true;
-		}
-	}
-
-	return false;
-}
-
 static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 				 int nr_pages, struct io_mapped_ubuf *imu,
 				 struct page **last_hpage)
@@ -677,8 +636,6 @@ static int io_buffer_account_pin(struct io_ring_ctx *ctx, struct page **pages,
 			if (hpage == *last_hpage)
 				continue;
 			*last_hpage = hpage;
-			if (headpage_already_acct(ctx, pages, i, hpage))
-				continue;
 			imu->acct_pages += page_size(hpage) >> PAGE_SHIFT;
 		}
 	}
-- 
2.34.1


