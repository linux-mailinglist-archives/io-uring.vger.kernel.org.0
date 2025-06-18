Return-Path: <io-uring+bounces-8421-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AE739ADE97D
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:01:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 81E51189D882
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 11:01:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1F7A1A83ED;
	Wed, 18 Jun 2025 11:01:00 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75535219E8
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 11:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750244460; cv=none; b=XB58Pr4GCzHfNkWv+XFMwTuRU1XR7/hSGdZW205cDQ6AE1V3ZucG4qbV8yJkxxoX3ylAdWFnOIQhr4pEzbgBBxJhUYnjdYlXN8r7jqbi5WNUeTLxuOwCHIrF7Eqyl2byhBgXvfo+gh/k2W6Vk2HfzqTTSsGkNejhdd3rk6/2j0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750244460; c=relaxed/simple;
	bh=+A9nfo9MXB2/wailjqB24i0nnzV6/JryHZ2jPIqjyME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0zW0lYY4B3pkqgZKAj2Km3uKUDrLB9EaDG9KtzYVKQ2vRM7EyqS1NrTfV3I6V94TpM5f9iUlEzD3TQkBzPzc9Tr8LU5/KBI64BDLQFZLxVkTfsXitlIkkR/zbS+rPx1jyRTLX0Yu9etP1iH8Xsi2PfldMFlZnOmvFWJN2iSzRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz8t1750244447ta8a12041
X-QQ-Originating-IP: sdA3X+DW7lkWd0VuwMwjQ3hw07nzynh+BxwT7XeuEjw=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 19:00:46 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 17283637316949940150
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v2 4/6] examples/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 18:55:41 +0800
Message-ID: <202C948B9FF7C1C1+20250618110034.30904-5-haiyue.wang@cloudprime.ai>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250618110034.30904-1-haiyue.wang@cloudprime.ai>
References: <20250618110034.30904-1-haiyue.wang@cloudprime.ai>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:cloudprime.ai:qybglogicsvrgz:qybglogicsvrgz7a-0
X-QQ-XMAILINFO: N2dNga98lfCaoGS3IH7CwkLp0SmSZyoK5j2FSSicqBYbByQoWIuvFpLa
	/+NOeM8FjwDODEcUAW6GRTibyd4o4zVZjABg23TRYjZFcMh7RaDlVV/gHGx/1FSuFrsXCXo
	B3T6ogAYOScSpJqTQblGn6pbRNgamznLCzZExVEN9k6W9NyBf5taT+Kkd+P3H2Flm+6wIrE
	cw7xvWx8VmzAh8l69dsGXCAVgCozOQu8ZngR87FN1C0k9Xxx4kSpocuwbBMjGTwWRPd/rdr
	HrLXo3I2EWKpymX6Mbn7bpZekxPbQFcqxHpZ4PJoiMWj0Jco8wapM0F1oeP3r/4NctFRYAu
	TGVd/rws+VnQbqdtU+o/NdHiSSTqhmtHP1zY4XDcfB6VqjVUbl9S5HY95y2rMlCAceABnJn
	c3O/AkRY8KqDgfs2+H8szBBuzXyaUkV2QPsrW+49H6iM8KquXw3Rqwgg7/W/by/eEtRHPI8
	33E4gueNT7a5tvQWrK8rgThmDB/qbX/cklK4hjcBBJTxyXkmVAI6r1SrQXQ8EDEXoee8lsl
	vaMI8hj7NKfJ4gtAvKEKb0b2fueRjFCCYgL7Zb69euWw1c8YIe/3sDkehG81dTPlSnwCxOy
	RZpXBIBlSc1s9rFrThAwzeSZ+ozndjgry6W8oCzOFmk3GnaVQHVe8r8HYj94M9+aLpIBjPV
	1c7PS12gtYtR3jcv92uczE2JJ4GIcItEgmpubRByjiijcovjPICBdzjObIVUHiPNwNH4F8J
	wxypJTjG5l08NlF02+hEawkTTlW+B9owzt2SD2aVixo+wA84ehB7SjiKkt8AV6cErdlgvF5
	zrvxjNnr0x6V2TKWBzz6wlvIDTCAa3o6SGn4WLL4oDPyF7lV2plecbd2Vm1ru1uTassZwIO
	WfJxJIbhgHgfDnrD9WXoZdWKY5/SyMURm1Df8G964/qDgsRcD0iYXPJXassEXPJOOi/xJkD
	6UfLxuOfU10eYaivHrNYjziiLMKOEhL/xxTBc3pmChVuPeJ5yO96zDciFvpNaE168cJCPDE
	ULcl6UhUGUE93DDAyQmJ0cz1k6vr2ZwTE1bongFA==
X-QQ-XMRINFO: OWPUhxQsoeAVDbp3OJHYyFg=
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


