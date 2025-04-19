Return-Path: <io-uring+bounces-7557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F23CAA942B7
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 11:58:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2770417A986
	for <lists+io-uring@lfdr.de>; Sat, 19 Apr 2025 09:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F263A19B5B8;
	Sat, 19 Apr 2025 09:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="nsTf+Hh6"
X-Original-To: io-uring@vger.kernel.org
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.4])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55BDE3FBB3
	for <io-uring@vger.kernel.org>; Sat, 19 Apr 2025 09:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745056713; cv=none; b=fBPtS3E5ciOxRD6M4+RWVE7IQIu4rBYnbsMJW6X5sxZ6or1ONOdA2+j2D2/DbofUyL3N9HdBoSkZOon0IqjkdyVwokBiD5l3gck3UAZSvhww8pwxALG2g333Dv/NEaGgdoHur1Us20b7U7I5qUZqBP0p7936x4a30L3urUZJVOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745056713; c=relaxed/simple;
	bh=Bh9HBTzBxdagLsVXnJf5cp6SRQZ3UlX7aIMyQi0yagc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=cRKIsETrryPDGdhA/GSj1A8/HGktScuwmxLEQqCfcpVTpY46C5QkRfNCGloSc8AmRYR0ZruvHZU2tf/DFuw4rAetJHt0JVFiXtw8cJDM487gVFbje9OpLQMS6KtIDrIBM8SM1jTZLy0unYpA3M7G1F8TNn+B2fGpKVx0E+d+RAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=nsTf+Hh6; arc=none smtp.client-ip=220.197.31.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=163.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:Subject:Date:Message-ID:MIME-Version; bh=tKDrG
	Ta2t3TXPh3fU5Xp5sX6HzqXI7kb174QzFmUzYo=; b=nsTf+Hh6wl7Tc2xiMHuWg
	6NJAuj4BuVFU7hxcetujgCSOk2ZfMlNL8Ea9skq2Y2RLnSzB+QFaRJ4dMexyBBjY
	au1vqu2aj7Irmue6nOZt4xya8VtGU6lTHyF9eXWKyeQceJZ9pa40gdE/1kSRKUdo
	INO5qDV6bwV7K3XTMHmKFA=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wDnN_HCcwNopKSqBA--.44364S2;
	Sat, 19 Apr 2025 17:58:27 +0800 (CST)
From: Haiyue Wang <haiyuewa@163.com>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyuewa@163.com>
Subject: [PATCH v1] selftests: io_uring/zcrx: Use PAGE_SIZE for ring refill alignment
Date: Sat, 19 Apr 2025 17:57:56 +0800
Message-ID: <20250419095801.4162-1-haiyuewa@163.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wDnN_HCcwNopKSqBA--.44364S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrtr1fAr48KF13ur1kGr17ZFb_yoWDZrXE9r
	srtw13Grn7AF1v9r4UGFsIvr9Ika129F4rZrW2qFZxWa4Uu3Z8ZFWkuFykZ3Z5W393A3sF
	vFyDGrW3Ary5KjkaLaAFLSUrUUUUjb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
	9fnUUvcSsGvfC2KfnxnUUI43ZEXa7sRRMKZPUUUUU==
X-CM-SenderInfo: 5kdl53xhzdqiywtou0bp/1tbiShU0a2gDcBBXWgAAsG

According to the 'Create refill ring' section in [1], use the macro
PAGE_SIZE instead of 4096 hard code number.

[1]: https://www.kernel.org/doc/html/latest/networking/iou-zcrx.html

Signed-off-by: Haiyue Wang <haiyuewa@163.com>
---
 tools/testing/selftests/drivers/net/hw/iou-zcrx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
index c26b4180eddd..b9f6eb43400a 100644
--- a/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
+++ b/tools/testing/selftests/drivers/net/hw/iou-zcrx.c
@@ -115,7 +115,7 @@ static inline size_t get_refill_ring_size(unsigned int rq_entries)
 	ring_size = rq_entries * sizeof(struct io_uring_zcrx_rqe);
 	/* add space for the header (head/tail/etc.) */
 	ring_size += PAGE_SIZE;
-	return ALIGN_UP(ring_size, 4096);
+	return ALIGN_UP(ring_size, PAGE_SIZE);
 }
 
 static void setup_zcrx(struct io_uring *ring)
-- 
2.49.0


