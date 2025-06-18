Return-Path: <io-uring+bounces-8423-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id DAD69ADE97F
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:01:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 0FDFD189D95A
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 11:01:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E2A5028505A;
	Wed, 18 Jun 2025 11:01:05 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbguseast1.qq.com (smtpbguseast1.qq.com [54.204.34.129])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2B427F4CA
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 11:01:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.204.34.129
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750244465; cv=none; b=o20B2psgEkMZxfCIevay88BKA0SJJmo6cOTZ3AhQMfiZzTF+agCIFqAeZ7UJ3lOhVUwrzHBZpmoQ9A47KtM2s8NHxEDObdxxn3Y8XhtgzXm4HETeZtHE9PjysUtUv7dmsr+uaeUTC90jKtJe6Zdug126t6jpI5RfSIqZCIXU6FQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750244465; c=relaxed/simple;
	bh=dJtJzFMsQQ6bO7iVcDgMfNWZu/ixqPlMy3hlUlon5/U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TH/Y8pWDxZ+tk/Zeq771GUde9owljqLgfN9iusy1I02vI1CUWBVCVaffGwuT6afTxcdTAKHmyXAKrPgYRgB14zQDJVhJoEgq/EqvuP7KqnOt0Un5+eZsGRFIp0QoCx+dq9QMB60SpzKcIxwCMuAt6ajnAPNaetTyRJeAYiAjV9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.204.34.129
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz8t1750244451t3e6c42d6
X-QQ-Originating-IP: lPylcRO/e8CS3+csAiAR5oMURdsLXPnY5HpoOSfAjnU=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 19:00:50 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 14168097257706404078
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v2 6/6] test/zcrx: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 18:55:43 +0800
Message-ID: <1547EB824275D420+20250618110034.30904-7-haiyue.wang@cloudprime.ai>
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
X-QQ-XMAILINFO: MjQ00mYXMHtuudSAOBLWB3TTijkhLRE4/ajhoiwjNSSq6IOt17LQ1m4p
	T7P4KqeuWEVwWuvVwliwtTdPyKENQ9nOfLqZZpBwpJs4Kc7KMQeuQpFO7duYyJgc1OPDXVb
	QdvR9z+KVgfgB0L83mGVbcfN2FeZvlh9IWVlgfjcNbx1NJ6Jy+HFEKcRlaFYnfiev73MpLN
	KBK5a1lG/p/exUnA/gtWtjBb8Kr4qucI6tE/1aegmo3F2PlrW4h/j+ok7ubE2POMBO2lZEl
	+9JhprVM0qf/HlRhWKsXoOf1mBlO87MMOBi853zDadN7IgyFKuC26fIV0hHfS4y9IgUnrjo
	sV1ps3rPKBDNeZV13DeaIEGqqyO6ZTaGi4csVEMPYUKbnKfGvJuwkCYe8jQoSL/Mv2YL9MO
	qPn7UAA4gdC+bhTcGfIjmkrG8eCEV2WSiceBSH/VIwuFiw+F0Pyk7R28b8Euau5QPqXCBRC
	Fx+J/ul8SMfXEhpDJmIBEaPR3mpjf3y+KBj03KdjVg7tR5vdp4x1iRXkktgeapyzdNMcVfv
	OI5IRSKg9rjhIwAZhWxOc32Q6wwDKqJxegvbw+3FPD+MM8blNimriuMQlPKFe5A6LXoE3fG
	YHdWFEYEgdo7hXoUKKoCovcoEPBiYqCHP/ru6t0nFJpFrccNtkYrVWTSSHb7D/O+5lW5njO
	OUxcpNF9uyTMdtC3XcMIMStIP4qcippdcXnCIVAeN8Xd0tqesgDxd9EB0WkOMHOVKRRYSPW
	4LKiz0Z0l+BvUBt+1RBGnfXO50ZeLBlaSYMeCKB43H9cpKAlCm6QWC4mYMB9kAnb6gHmnte
	3M6A9cJoDcKCh0jmZuLCr0L6usBImZpLME9tao0FUz+sioKhsBYU9ovFMX75zhp28LqU2fv
	zYQ35/mz2u7L5oWpNF8wRH5vMFeHb979VGv2wcpfKOmSLLEwa6DuAnC2SBgdD+la6IKS1ZE
	n9j8gxQ9alK9t+3lIOoEQLhFi4sGX9rGfHQYE7BQi+WYX2e+OBYYzd0LOChcruOT7ruNpjn
	UR6RUgyoDEPADmMTGQkM1K98zP0XszpcsA3IYWJBdvAbaJ+jFs
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
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


