Return-Path: <io-uring+bounces-8416-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 21E59ADE4E9
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 09:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 95AC71898879
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 07:53:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E40A25B687;
	Wed, 18 Jun 2025 07:53:13 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D2517E105
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 07:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750233193; cv=none; b=VR8Qa6+ZN8fRWhWAJeilid8WFBt5njiSr8epjIUWwhgWXF3eC+cgRg7H8rDwNeW0BRYjfc1esvT03fWALaHfA5pdHR+2LRrKDuX0rHb1TW1Vo+mqfEZPEYEE672GYqzLI8jDrxctdkTH6Vh5fOP+4w9nNgQQxTtfVIbgy1ch1TI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750233193; c=relaxed/simple;
	bh=/PvCz3pw5Og8hHlo//GR0WyWlUaVz+i70vG9ya2gWt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pEs140QTCeaXFNtagXUzdiUGyn+7SSgRU30AQowtwwA1/mgM4FUT0Z0SFncQSYl6k6T6xNMUWHSHx7jvhNO9LsErK/+FhT2+H+0kqGfYdbchjGrLTb/u2WgPtpQPPnWB8srMQ0mQ2apUlbRpp8bAWuCEuptymLUEEZx0O+NweDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz1t1750233074t9fe2aa1f
X-QQ-Originating-IP: SujidDy8NnZrAIhuQmU0HYKHZuAf8B9qrtdCxZ0b3PM=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 15:51:13 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 2705348779738801561
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v1 5/6] test/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 15:49:20 +0800
Message-ID: <CC0C2F62427F0CA0+20250618075056.142118-6-haiyue.wang@cloudprime.ai>
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
X-QQ-XMAILINFO: MeGVnsUF9M9xZ7hAUSnYtEdyvDWjZKUC7KC5kpqJg8jDBF3srl0BVuqG
	3OaG1U9QsN7QuoYzdcFuDZ3fFnTxVyn3jG1Bxorh0ROkE7QfJhx0jQe3MnVWQ4xY2+N+zf+
	8f/ugxo/XorC6wwbPr9qGI35adk7l9hu/5R4CbZJ16cMAf7AH9EG1aFU0T3lShM/zj1+uW1
	XS+MPrmujiB8VRStWNwu7QFkysqNO9chLq0LY4MVjdNoEZTPjDVV9cNywM6E3/YF/ZzG7nx
	ORqXMFz3f6qOaJ7Kn9xHvHsFXO32z1Ns7LYKsVxFci5Ubcz2HknQQqOTfgDmu7huXf7N0TD
	gT4YTxFCr3jgeMiLYVA+HZEUUIHadNpnEygCXcduz1v/17bMjDiOJkkHauUtlsFIC5WdNTP
	715/79kOfaxOiEGM7BGkbapz0tk87Y5/cW0W27IiEF0Qmezx6eekXSicDpKF/5bogwPMvXZ
	oy8wgIKdCDtqWkkGnaMV0MVqwTeQShEdFIz2aX5zV3YI+1UnTsUSAW+wblDYT41xlcjV4nl
	DtjYzF215A/gVKs9qs5Mh+lXV8bG20kfPrRl2cKgSa2p3ff/7wxWrSey/H68eRIIeIVd1MI
	cd2RQwls1dv3Lc1B/HOtp+Zd0eT/UzwqJg8UF5F9FwKz8BlTZeLRXnF0qRQS058jy2FRJMB
	l9rV9JGDRzPjog7YtER42X0C/2jrDMmBfSXi44FjJr310pybSWOruq4KOvR+74VKEfQt1TB
	oAFM29GYA9qH4JApQJ4i+O1QulZtGWzDsFgKWXQRZ8tkSDG2iRMZ/JNc4sZbuBlL7yeIIA/
	fchcw+uqyDCyhXjPNpTjI9LpOxCGyxjtf5QJEJoI/LD88dGQTM6ZWVgvbfemEXqxfhGfJs/
	essvK18+woHD0gFi4CRlz+o7mdZnuSW6ab3PMzNvgO68dq0x8IP/OvaKTE4nQ6Wj9KCEWJ6
	NbIBT6F2wHAhcUerqN2P3Nbmol6kkH2xbBMUcoZ1K0IubsDWzFQuXYsOuCvbva1Mbsp03TC
	x4enTrwSACqzQyB2yjCkU8R68KpeE=
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

Use the helper to handle type convertions, instead of two type
convertions by hand: '(__u64) (unsigned long)'.

Signed-off-by: Haiyue Wang <haiyue.wang@cloudprime.ai>
---
 test/reg-wait.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/test/reg-wait.c b/test/reg-wait.c
index 01d5e8f..af517a1 100644
--- a/test/reg-wait.c
+++ b/test/reg-wait.c
@@ -219,10 +219,10 @@ static int test_wait_arg(void)
 		return T_EXIT_FAIL;
 	}
 
-	rd.user_addr = (__u64)(unsigned long)buffer;
+	rd.user_addr = uring_ptr_to_u64(buffer);
 	rd.size = page_size;
 	rd.flags = IORING_MEM_REGION_TYPE_USER;
-	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.region_uptr = uring_ptr_to_u64(&rd);
 	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
 
 	ret = io_uring_register_region(&ring, &mr);
@@ -287,11 +287,11 @@ static int test_regions(void)
 		return T_EXIT_FAIL;
 	}
 
-	rd.user_addr = (__u64)(unsigned long)buffer;
+	rd.user_addr = uring_ptr_to_u64(buffer);
 	rd.size = page_size;
 	rd.flags = IORING_MEM_REGION_TYPE_USER;
 
-	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.region_uptr = uring_ptr_to_u64(&rd);
 	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
 
 	ret = test_try_register_region(&mr, true);
@@ -324,7 +324,7 @@ static int test_regions(void)
 		fprintf(stderr, "test_try_register_region() null uptr fail %i\n", ret);
 		return T_EXIT_FAIL;
 	}
-	rd.user_addr = (__u64)(unsigned long)buffer;
+	rd.user_addr = uring_ptr_to_u64(buffer);
 
 	rd.flags = 0;
 	ret = test_try_register_region(&mr, true);
@@ -348,7 +348,7 @@ static int test_regions(void)
 		fprintf(stderr, "test_try_register_region() NULL region %i\n", ret);
 		return T_EXIT_FAIL;
 	}
-	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.region_uptr = uring_ptr_to_u64(&rd);
 
 	rd.user_addr += 16;
 	ret = test_try_register_region(&mr, true);
@@ -363,7 +363,7 @@ static int test_regions(void)
 		fprintf(stderr, "test_try_register_region() bogus uptr %i\n", ret);
 		return T_EXIT_FAIL;
 	}
-	rd.user_addr = (__u64)(unsigned long)buffer;
+	rd.user_addr = uring_ptr_to_u64(buffer);
 	free(buffer);
 
 	buffer = mmap(NULL, page_size, PROT_READ, MAP_PRIVATE | MAP_ANONYMOUS, -1, 0);
@@ -372,7 +372,7 @@ static int test_regions(void)
 		return 1;
 	}
 
-	rd.user_addr = (__u64)(unsigned long)buffer;
+	rd.user_addr = uring_ptr_to_u64(buffer);
 	ret = test_try_register_region(&mr, true);
 	if (ret != -EFAULT) {
 		fprintf(stderr, "test_try_register_region() RO uptr %i\n", ret);
@@ -393,7 +393,7 @@ static int test_regions(void)
 
 	has_kernel_regions = true;
 	rd.flags = 0;
-	rd.user_addr = (__u64)(unsigned long)buffer;
+	rd.user_addr = uring_ptr_to_u64(buffer);
 	ret = test_try_register_region(&mr, true);
 	if (!ret) {
 		fprintf(stderr, "test_try_register_region() failed uptr w kernel alloc %i\n", ret);
@@ -421,7 +421,7 @@ static int t_region_create_kernel(struct t_region *r,
 {
 	struct io_uring_region_desc rd = { .size = r->size, };
 	struct io_uring_mem_region_reg mr = {
-		.region_uptr = (__u64)(unsigned long)&rd,
+		.region_uptr = uring_ptr_to_u64(&rd),
 		.flags = IORING_MEM_REGION_REG_WAIT_ARG,
 	};
 	void *p;
@@ -458,9 +458,9 @@ static int t_region_create_user(struct t_region *r,
 	if (p == MAP_FAILED)
 		return -ENOMEM;
 
-	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.region_uptr = uring_ptr_to_u64(&rd);
 	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
-	rd.user_addr = (__u64)(unsigned long)p;
+	rd.user_addr = uring_ptr_to_u64(p);
 	rd.flags = IORING_MEM_REGION_TYPE_USER;
 	rd.size = r->size;
 
-- 
2.49.0


