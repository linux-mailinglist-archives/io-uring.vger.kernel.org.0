Return-Path: <io-uring+bounces-8413-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 62E5FADE4E3
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 09:51:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CF59E3BD27C
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 07:51:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 74198274FC1;
	Wed, 18 Jun 2025 07:51:26 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbguseast2.qq.com (smtpbguseast2.qq.com [54.204.34.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A2E1D61AA
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 07:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750233086; cv=none; b=E56G4wcK8HHWfTAXQxTviU6NsZyHHM/zAcoUJ2GV36FxcZJlMA9221HjUjjPnSWCXPcojecUSIhQYRI0aDhnGsSyryz3MPYhK2DSLaxL4DiPgbOaKJ0XadQtBb8Tjs1b/OIMRUGTRmON1ABiZmYuLQ6rK8yxZLAutvub+TBN+uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750233086; c=relaxed/simple;
	bh=dJtJzFMsQQ6bO7iVcDgMfNWZu/ixqPlMy3hlUlon5/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZLcxa08F5pY96X4++65biUh9LN4sBLNJZoMDt3NzofbTRloZcwPn0LxksQypCjwWyB5krwxvPcYS40ZKBm0MA4fTcj01WjMKRld3DCpXxBSIKpUEOSkWbXT5BIcvspmj8eTNmB7RZ1aLdIXybMOg0eMlwJHW2FxMuLWZR9E8LhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.204.34.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz1t1750233076t1a38d176
X-QQ-Originating-IP: 9l2rb1gHaozN2hPF4Di2J57qVwsnxsQCvReLvMnLHek=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 15:51:15 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 4958974494793665604
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v1 6/6] test/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 15:49:21 +0800
Message-ID: <6678AFF9D9CC2DEE+20250618075056.142118-7-haiyue.wang@cloudprime.ai>
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
X-QQ-XMAILINFO: ND3CPZxVFFQcluyGOEzoKc7TJfIWH86yhSCzYEcGerYvUwCjvDUM9Kwf
	8+T+N4Swi8bG6LVLJeGW6Xbz8503rLBpzjTS3hNCmlX2qwb6F4AHAjgaxqOQnaIeEWO6VxK
	NPuOukCsFOqCeSWelvn6XFTMZTU2FtWeB2LUKJzh+TZd9tXxhENefHv0sBRVUiEZUUUS86n
	A1S598JM5kxNMTDvPkgcliueYR7tjU4oX+1M6FxCcN2FmF7cLwGEPEZ8vr4oJE9zTDU2apA
	Tw/g8Oivl1Rhezgwk2p1sM5B+a1adEURA0VYW9TMtpFgkrwuee7aS5dO1h5dIBY6kQQ6xCJ
	/sFp9vu2O9OZ83pNZZfv/4HCafBB2mrgM3mtTAkLUNCOt0MMolWqbIiiGAR2QScERWniorU
	5j1JtA2YshlQxOun+cIGboXkKOcNXOWYzGk+lLyMjL/4PaOm/FxNzwQ1eriBxsMzPcqPvkk
	IEjjTKlMhzpNPT2VAFCHOXLmK6nZvxjCPuBOsu/YHGRIJJVLOuqVASN4SAnAva503v312Br
	9BfKHahI+bKVJTrvRmRMu+CrGHznMRxzq1eDIYVRvGW2+GsKO/97PFu1diMNPLYK/keHnOA
	YJiz1UlUyKu2t5zhTW4DIJcd8WI1tq3MkMz0MXBsVf8QR1mJKrxe73UjStWL/eWq7GQTNzj
	6VnmEYfHokfTEPpMpQHk3kfio3TJKaXyCGkIteUbgWM1ML4lyDEAQ4CvBuQOpijA/bnUG0E
	g/mQ2Rf4yoEJAbvrrJWRMy7Ai9Tw+KoLR78uxWnCGUplq0hm2yRhSnesRIrBEgzDU4YswdD
	xwca/f/bupcaXVMPt1YMH2BZgt6zvl0bcOi7Lo700UmjSyZKbqq4Tu5blftrMZSoCXUDkiY
	z1JG6g2Afcwzm3jX5+9rrAWabbSnJSBx6vut2x9gbvm+7dNTBXi9y8copeRRQHLo/0lpgPc
	hqzyBcckuF2GuZiDF6zzJBAynN7QcHt3Q7PIBtwWyDqoSEfdkBNu/u6YNsiOyolLMVxgjaD
	Ss81BuuMYWF8Yx9lRTqD0tZ7+lpu8=
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

Use the helper to handle type convertions, instead of two type
convertions by hand: '(__u64) (unsigned long)'.

Signed-off-by: Haiyue Wang <haiyue.wang@cloudprime.ai>
---
 test/zcrx.c | 44 ++++++++++++++++++++++----------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/test/zcrx.c b/test/zcrx.c
index 61c984d..572e118 100644
--- a/test/zcrx.c
+++ b/test/zcrx.c
@@ -43,7 +43,7 @@ static char str[] = "iv5t4dl500w7wsrf14fsuq8thptto0z7i2q62z1p8dwrv5u4kaxpqhm2rb7
 static int probe_zcrx(void *area)
 {
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)area,
+		.addr = uring_ptr_to_u64(area),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
@@ -51,7 +51,7 @@ static int probe_zcrx(void *area)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 	struct io_uring ring;
 	int ret;
@@ -99,7 +99,7 @@ static int test_invalid_if(void *area)
 {
 	int ret;
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)area,
+		.addr = uring_ptr_to_u64(area),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
@@ -107,7 +107,7 @@ static int test_invalid_if(void *area)
 		.if_idx = -1,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 
 	ret = try_register_ifq(&reg);
@@ -131,7 +131,7 @@ static int test_invalid_ifq_collision(void *area)
 {
 	struct io_uring ring, ring2;
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)area,
+		.addr = uring_ptr_to_u64(area),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
@@ -139,7 +139,7 @@ static int test_invalid_ifq_collision(void *area)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 	int ret;
 
@@ -182,7 +182,7 @@ static int test_rq_setup(void *area)
 {
 	int ret;
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)area,
+		.addr = uring_ptr_to_u64(area),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
@@ -191,7 +191,7 @@ static int test_rq_setup(void *area)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = 0,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 
 	ret = try_register_ifq(&reg);
@@ -232,7 +232,7 @@ static int test_null_area_reg_struct(void)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)0,
+		.area_ptr = uring_ptr_to_u64(0),
 	};
 
 	ret = try_register_ifq(&reg);
@@ -244,7 +244,7 @@ static int test_null_area(void)
 	int ret;
 
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)0,
+		.addr = uring_ptr_to_u64(0),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
@@ -253,7 +253,7 @@ static int test_null_area(void)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 
 	ret = try_register_ifq(&reg);
@@ -264,7 +264,7 @@ static int test_misaligned_area(void *area)
 {
 	int ret;
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)(area + 1),
+		.addr = uring_ptr_to_u64(area + 1),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
@@ -273,13 +273,13 @@ static int test_misaligned_area(void *area)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 
 	if (!try_register_ifq(&reg))
 		return T_EXIT_FAIL;
 
-	area_reg.addr = (__u64)(unsigned long)area;
+	area_reg.addr = uring_ptr_to_u64(area);
 	area_reg.len = AREA_SZ - 1;
 	ret = try_register_ifq(&reg);
 	return ret ? T_EXIT_PASS : T_EXIT_FAIL;
@@ -289,7 +289,7 @@ static int test_larger_than_alloc_area(void *area)
 {
 	int ret;
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)area,
+		.addr = uring_ptr_to_u64(area),
 		.len = AREA_SZ + 4096,
 		.flags = 0,
 	};
@@ -298,7 +298,7 @@ static int test_larger_than_alloc_area(void *area)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 
 	ret = try_register_ifq(&reg);
@@ -315,7 +315,7 @@ static int test_area_access(void)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 	int i, ret;
 	void *area;
@@ -331,7 +331,7 @@ static int test_area_access(void)
 			return T_EXIT_FAIL;
 		}
 
-		area_reg.addr = (__u64)(unsigned long)area;
+		area_reg.addr = uring_ptr_to_u64(area);
 
 		ret = try_register_ifq(&reg);
 		if (ret != -EFAULT) {
@@ -348,7 +348,7 @@ static int test_area_access(void)
 static int create_ring_with_ifq(struct io_uring *ring, void *area, __u32 *id)
 {
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)area,
+		.addr = uring_ptr_to_u64(area),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
@@ -356,7 +356,7 @@ static int create_ring_with_ifq(struct io_uring *ring, void *area, __u32 *id)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 	int ret;
 
@@ -653,7 +653,7 @@ static void *recv_fn(void *data)
 	struct io_uring ring;
 	int ret, sock;
 	struct io_uring_zcrx_area_reg area_reg = {
-		.addr = (__u64)(unsigned long)rd->area,
+		.addr = uring_ptr_to_u64(rd->area),
 		.len = AREA_SZ,
 		.flags = 0,
 	};
@@ -661,7 +661,7 @@ static void *recv_fn(void *data)
 		.if_idx = ifidx,
 		.if_rxq = rxq,
 		.rq_entries = RQ_ENTRIES,
-		.area_ptr = (__u64)(unsigned long)&area_reg,
+		.area_ptr = uring_ptr_to_u64(&area_reg),
 	};
 
 	p.flags = RING_FLAGS;
-- 
2.49.0


