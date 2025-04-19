Return-Path: <io-uring+bounces-7555-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 3045BA942B5
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 11:58:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id E9A1D19E3DA0
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 09:58:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 780F91C3BF1;
	Sat, 19 Apr 2025 09:58:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="Hs9iGXhe"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C4C43FBB3
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 09:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745056694; cv=none; b=o2RXoK2p4f6cCwR+QIR7BisqrDwY7fqTT+5Y1tGmHeDYe806fJOQ2e3DKa9DtSHa3JA6Bj5my6RYZe3tfcxbOMFYi1LwZgaWPYG2Ft4DwlIoc3ToaXYaXhembYbl03ettvS8UkSWIYVCWAxWUkREuUKMwyUZcKU6Fvgt5IAxbSI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745056694; c=relaxed/simple;
	bh=gEjNgDoLeU9RJCbef/Tsj2w+vEhvsByXB+jd6kEwM+s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cKsict9mzi/SWoU8efJv4YwQe9NFKOKZa9AYLeekQq4dkbumtmqmHDCcjsm8StCQ693sWCVErOfkTXkWdoidzajb/Cl0i4HbO/XoZIkj3puDQf/nEGLTjmjumHithyMJkdD8iCEmRb5c0penMYMGHBz+ndbLpLZPo1J4KB2Xlq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=Hs9iGXhe; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=Hk5ud
	QedhG1FWdeQ9WrZYTqrF4H6O7vJwIPF5dc3wfc=; b=Hs9iGXhe0q1adf1B1uGpC
	52CKHkTLA1LrrZJZn2trxY9cIe+jrInVsijIfazdml73feqhquiwHysdIpIpWv8B
	dl48XGwOHeXWPFJ8whNAsmI8fVGP2wklZaK/TD7VDP/MVTbITieGiIOl3o08EayR
	hKF4ePmBTJqyHXsnc/v6X0=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-1 (Coremail) with SMTP id _____wD3m++lcwNo7+zKAw--.32953S2;
	Sat, 19 Apr 2025 17:57:58 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH liburing v1 1/2] examples/zcrx: Use PAGE_SIZE for ring refill alignment
Date: Sat, 19 Apr 2025 17:57:20 +0800
Message-ID: <20250419095732.4076-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3m++lcwNo7+zKAw--.32953S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr1fAr48KF13ur1kGrW5trb_yoW3tFc_C3
	Z3tw4Sgr1fJF9Y9r1Utr4xtF9xKa1IyF4fWrWIvrnxA3W8uanY9FWkGr95uFn8Xws3Za45
	ta45ury3Zr13GjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRXdjtUUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiShI0a2gDcBBU3QAAsF

According to the 'Create refill ring' section in [1], use the macro
PAGE_SIZE instead of 4096 hard code number.

[1]: https://www.kernel.org/doc/html/latest/networking/iou-zcrx.html

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 examples/zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 8393cfe..c96bbfe 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -66,7 +66,7 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
 	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
 	/* add space for the header (head/tail/etc.) */
 	ring_size += PAGE_SIZE;
-	return T_ALIGN_UP(ring_size, 4096);
+	return T_ALIGN_UP(ring_size, PAGE_SIZE);
 }
 
 static void setup_zcrx(struct io_uring *ring)
-- 
2.49.0


