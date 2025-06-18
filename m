Return-Path: <io-uring+bounces-8412-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CEF51ADE4E2
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 09:51:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B33F53B486B
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 07:51:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EFD7527EFE5;
	Wed, 18 Jun 2025 07:51:25 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgsg1.qq.com (smtpbgsg1.qq.com [54.254.200.92])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF91727EFE7
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 07:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.92
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750233085; cv=none; b=Ym3BQw84WVB+YsKKo5LKlXJRud/rm1k//zt5+4PvfXSar/x9+6s1ElahpTOb1eQLvq+TjTLfvnDmnVf2VEjr5wDXybbbncXkvY/wAE+UaEWrmeozcLcp8Nb7y7tqATi2EhEJlu9y7impOx1ALbU3YD4uX9Gu60wFd3BcfRVING4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750233085; c=relaxed/simple;
	bh=1nlKgAOpMdMo24T2nqevD4E+oGiRn+YhvOGUhqXCtY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfPi2E9SDYHl9sRHE16sg/5giCYgt+P7tvS2nRGZOS/gdHCAoOy5MtYJQVhEvSRIM6Irt5uxq3OxGBX7oECYbl/pdS6mvjbaCEMrBLxIvXR61iGapmqlZqb/7FdDSQTkLzfarLQWafkxyJ2OLbU0DrdDHOtPWoU8Zoz7WPfqubk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.254.200.92
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz1t1750233071t1a346685
X-QQ-Originating-IP: 7Yku9JOxyHD9yklBXtO2VR2MDqLU81D1BUqT4SGDGSA=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 15:51:10 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9659161133647207417
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v1 3/6] examples/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 15:49:18 +0800
Message-ID: <EEA6B2B9763599F1+20250618075056.142118-4-haiyue.wang@cloudprime.ai>
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
X-QQ-XMAILINFO: OffpsKYrFLbUWfI+hbgrvdDaiBDixxNld/TatA1R+eoQARWCF7tvZoeX
	wiGCTtBDqWTdNFc6tDrS2thFnld1mGJ/1PxY50ni7K78yR75yOerBXH1jD54LjuC0T4Nkub
	e0SCnS1z27fJRtlgH+9O4mnOFg3iENyyIGjo3ltje8EYcAC6js/279ezOZOwiNr+Ps8trdg
	b7K1DT5FazDJDN13XNNUxyw9yRq1M0Bn0Oe2BYdY0HXCgl+NVPAIDRo6kMBwJkOhSN/dA88
	jxHk+juKKpxWxaTHNKbKVA1k7OmD7+5nrcBm3mEN2Hf5MefSbDoknuSZ+3yjh+AP0/Mtx/6
	zoWtffHFe7bvmC0R6tl6T4mtVjVA34/bhTIlMuAY3gay87Bfhk9z2Es2I1tGgNB6Ddr4KLQ
	LdTTlJnyk/qKKI4A9s0i8DAU7yXzviGNZ7BRUJz3Ik+UulPAxCQ+4dXjF/wvTLXSsNuVfx9
	+2O5oVwKjaVs6aS8Z8NjANfZeC5tm+D+7JSfCLsHjDTp+boKpR5+nkzxwWXTB8g/Y3JhIli
	P64nVhXccpHq1dIpAijrXE3AHnvBax+jpDBGlUu7Zmmr/kmmIfPMxdkbWP7qrypr8aH7GfK
	UeJOpfaK7pIVzbaXZS8yS7FoHKWB65KZHPb4ooWceOCyudLYfPAezMk6NlT+Q9fstXwBZ0N
	0cRs5xMUo2SW6a0VnOQuTJrESYwUd2uS1iJr1jV3rj0BGqgWIXOA1J2ASEQZiELEH+dSie7
	PoFWlzGuXluT8sKSeZEj5/ubxsEPQbZkGzOJH3bTWW+D6d4a3shOj8AXvpoLm7NNynZTwkX
	UK0N5szapS9o+/PO/9xUwwfkVbjB63dRUw7VS/tZIYwlARZrrluDRdd+uWeqULlFnqcuMLV
	0h+PHpulIg8tP0rPl9wF+/2QPZCt9fLmzzcjy/M0t4NNrTGyE7wANR7L4MGXZNDE3d+iI0x
	m70BA2CGUsgwxBnVE+H4FT+k9ZdwRiMnYcaOPCKSN+QbLTHIwpz/4Mm7rNKKlGh0OfSrPoX
	WdusI1Vg==
X-QQ-XMRINFO: MSVp+SPm3vtS1Vd6Y4Mggwc=
X-QQ-RECHKSPAM: 0

Use the helper to handle type convertions, instead of two type
convertions by hand: '(__u64) (unsigned long)'.

Signed-off-by: Haiyue Wang <haiyue.wang@cloudprime.ai>
---
 examples/reg-wait.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/examples/reg-wait.c b/examples/reg-wait.c
index e868f3f..4f04293 100644
--- a/examples/reg-wait.c
+++ b/examples/reg-wait.c
@@ -45,10 +45,10 @@ static int register_memory(struct io_uring *ring, void *ptr, size_t size)
 	struct io_uring_region_desc rd = {};
 	struct io_uring_mem_region_reg mr = {};
 
-	rd.user_addr = (__u64)(unsigned long)ptr;
+	rd.user_addr = uring_ptr_to_u64(ptr);
 	rd.size = size;
 	rd.flags = IORING_MEM_REGION_TYPE_USER;
-	mr.region_uptr = (__u64)(unsigned long)&rd;
+	mr.region_uptr = uring_ptr_to_u64(&rd);
 	mr.flags = IORING_MEM_REGION_REG_WAIT_ARG;
 
 	return io_uring_register_region(ring, &mr);
-- 
2.49.0


