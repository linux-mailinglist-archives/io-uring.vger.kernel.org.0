Return-Path: <io-uring+bounces-8414-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6B159ADE4E4
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 09:51:54 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id BC179189A680
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 07:51:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6908A1D61AA;
	Wed, 18 Jun 2025 07:51:29 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgau1.qq.com (smtpbgau1.qq.com [54.206.16.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5812C27EFEF
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 07:51:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.206.16.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750233089; cv=none; b=apH2REz8yUJdTlppCINkZXNIxvriKW7XVqjEpTIfHqcS2tA3I6SJ6kxTOABO4AYnwpT0mgE6OzI5xqvcrc3lUg5zE4XqyxpsfYO62qQwp379/aLOlKXu5gObj77A60PD/DTuUEAGz/s9emWuLjG2wzUsEdovegqQ0R72uXOJQoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750233089; c=relaxed/simple;
	bh=+A9nfo9MXB2/wailjqB24i0nnzV6/JryHZ2jPIqjyME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aFm9B8mKB6vZbDEHiDKe9WkkKuwk1qwO4/E/++/d6HznaSAwU/vPY1U/wY78Ik1+/e7hLCpxGzpCPUiKBcSJI2Re0FEsfvkubAUujzcDUwBFznkznqDzp8LstpdsL01blELlr3IagAqVFzW4qRNqFCGR5OWZw2iFxESLZh3UzBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.206.16.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz1t1750233073t28448ebe
X-QQ-Originating-IP: mGXhao2E0Rrr7I2x2HxMykNFMQ7I5wBl0EawmspFK8s=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 15:51:12 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3458643990699294890
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v1 4/6] examples/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 15:49:19 +0800
Message-ID: <0599278798038A7C+20250618075056.142118-5-haiyue.wang@cloudprime.ai>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250618075056.142118-1-haiyue.wang@cloudprime.ai>
References: <20250618075056.142118-1-haiyue.wang@cloudprime.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:cloudprime.ai:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: NBkE/PP8DpFYcHefFScrwbyWwNGe6pO2gg7zPG9F8HaApJfrbpHeEpO8
	Mr6mzN0fuPloORywwSpQvbue81JRlJjBuyRgvfTapEauDzhlGKK9BZ9H9rH8fRmEvw4rylL
	drwbdTjJVtwwTFKpZEI95BOjeKAKuYxpa8tVDhyTgeqPMvDYnCm+ilGaefw2uOOwr82DjIN
	CeZZOW6ZnPAdF3WRKJvnXU4YOY7GU0ugxVN8UzHWqvRtdLiOGJbiOEM+Q4PpklnKLQtMOvF
	iKKCJ/ia03c7IElv1KKAsWeUqNWv3xDl/92Ya/CYz9+qt8jlV8YhPYoXFWnDqU1j/8CR/43
	viawgUtc3I5pqYxJGfwMujIoVx+b8yh4H+FuSKA7lSVtjaCTlT0AuwnBpYhyC3VCil4NZKy
	B2fpGSHt4sNdCvnyOWZeg22YM7eWNeORjp1/N3yfxIsqq8MYPrgpZFlLuQVZYRDciYBOXBC
	r1kZn4FcJA6VTCkKUPe17Zt1GfwmyWNs05ljZOj7dIKNMKht30ehIkB/QFSuaJJF4RxzfFX
	/oZkXyx5YGnex+xvmlWOT3pVUHNyIAhzSF0TlFHD99f9z8eElBSM6r77qXZO81N9uu642a1
	TEXV0LPjwLQY54PXe+CHtEzNkwMQHqtTqJFpW9ZPIuV5udl1gSLQpnUlJ6QuWYaIRHskxuF
	MJ62hbi86FzG5rSeGBteh6/T2hCxgmOrGVsuy7na3qa/OmUZBX5AN3rzJxb7YjyP1ztxt5o
	EqdubStRCx2pcrDI+ycYHwbfKnj26u8XIztvWxbSU7OMKU1rYrFSNKDIUI+oh9aJF1x7PwJ
	/IXWiPzc7sUukF7pyIrBSw3OsqEJogv3Vhc0THoEKyWJqw2UW9kzJcU5AyGzzjm5tQ8vPra
	Se5gk646r3E3MD8bk07yvVCxlvr4PipGsoUlcL7DwoeAQNtAp8CKAI6c88zf6b02WJbNJOv
	axr0iY9Se9q4MiRLHqMEqS/+bXfO/oHb0UT1Ogh0wtDgo5mmzXzk3Vu1TT2O5REvSzvyyzj
	F2ZhMqhzVFbLwbKZxigOR8sxw1UdQ=
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
X-QQ-RECHKSPAM: 0

Use the helper to handle type convertions, instead of two type
convertions by hand: '(__u64) (unsigned long)'.

Signed-off-by: Haiyue Wang <haiyue.wang@cloudprime.ai>
---
 examples/zcrx.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/examples/zcrx.c b/examples/zcrx.c
index 5fc8814..a269b1a 100644
--- a/examples/zcrx.c
+++ b/examples/zcrx.c
@@ -163,7 +163,7 @@ static void zcrx_populate_area(struct io_uring_zcrx_area_reg *area_reg)
 		t_error(1, 0, "mmap(): area allocation failed");
 
 	memset(area_reg, 0, sizeof(*area_reg));
-	area_reg->addr = (__u64)(unsigned long)area_ptr;
+	area_reg->addr = uring_ptr_to_u64(area_ptr);
 	area_reg->len = AREA_SIZE;
 	area_reg->flags = 0;
 }
@@ -194,7 +194,7 @@ static void setup_zcrx(struct io_uring *ring)
 
 	struct io_uring_region_desc region_reg = {
 		.size = ring_size,
-		.user_addr = (__u64)(unsigned long)ring_ptr,
+		.user_addr = uring_ptr_to_u64(ring_ptr),
 		.flags = rq_flags,
 	};
 
@@ -204,8 +204,8 @@ static void setup_zcrx(struct io_uring *ring)
 		.if_idx = ifindex,
 		.if_rxq = cfg_queue_id,
 		.rq_entries = rq_entries,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
-		.region_ptr = (__u64)(unsigned long)&region_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
+		.region_ptr = uring_ptr_to_u64(&region_reg),
 	};
 
 	ret = io_uring_register_ifq(ring, &reg);
-- 
2.49.0


