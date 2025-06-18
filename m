Return-Path: <io-uring+bounces-8422-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 61994ADE97E
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id CD744189D85D
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 11:01:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5DD8F219E8;
	Wed, 18 Jun 2025 11:01:04 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbg150.qq.com (smtpbg150.qq.com [18.132.163.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15E72286435
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 11:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=18.132.163.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750244464; cv=none; b=oFTl9C2HvvDYm7Wh39xwpiJwj7RvRaqz3xg34K2mB/ikefI11aUcSM3zheZZwhQOUdAt34TZXaLmC41cyZZmVmH6uF1mI/dSoPmma9NjKY3L938n8XQwry8KjgExOO8NkVblM+Edj7HKK01xv+EBcDulnnAZMuZPcmUo80IoE0E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750244464; c=relaxed/simple;
	bh=/PvCz3pw5Og8hHlo//GR0WyWlUaVz+i70vG9ya2gWt4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fN5n+VDNuPOTlHJ9G958wLzwwL0pniQ5dVhLv+eFWfUkBXbGXxvks+wpGN2JbsarwDWEzM7rNfHHwKT3xqT7kd3FcR681mRNQwK6hX99Lh96d2hU20FtzMTl07S9tIICYQfxic8m7AwqJlL3LA2ByUgrvUb8ECPIk98yZSfN1To=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=18.132.163.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz8t1750244449t972f77e3
X-QQ-Originating-IP: 7hDprpVuZfiIKnXPX7ln8+XNB7JMWjxKjYYAQ+jDFJ8=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 19:00:48 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 4795573298579297758
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v2 5/6] test/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 18:55:42 +0800
Message-ID: <8308685C708DC395+20250618110034.30904-6-haiyue.wang@cloudprime.ai>
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
X-QQ-XMAILINFO: ODO7gCA19e1NlycXFN1weJ0rZePh80VwA+F9etN0rxrjY8PZPlOaiPF0
	blkel+TiRS7aD3Hh9fvKoEK465I2qSjrHQtsFqziwog6Ql4gqCG5Os0hBT5xDeF0FAe+cMs
	QtySHyiKeaVmhJ6nbR8X+BNBxd/rcUdsBBTPj8CGk7XBb96ttILMLxV5n9ekrK2hTHI9p5j
	DW1h+IyxypHYV2SB33nCvHpAMmgq8SUbqZXQRn5h9I8izV0YFagMBMbooch2xsbGg2fSpZg
	jUelKYA/PdJCh1n0K8mtiHxbst9dKpMI1nR3HP6jXEuh5oPxS2RiRQMzERWSx68rmDTFi8J
	JZYsD7zlY1pIob9973fJsvuE8LHNsqxOsS9ysL+O47iGcUF+g+tyFOmdBfa+v71dRJEprUe
	Qj7qR0qEvaJCh5Y8h/75E/cHtTtfWD6NDd2hCXbgNOSRRreGQKiZFdIkxBV9ZAjLNlTrrvP
	cnZwf3KneBOIEc7L67x0OlNZbM1jkRnHXRHx7xD6hXx9JMkDnJGhjLkkzPdWCHa2/sXHBxf
	15srvCUIefybyJ1PlhMaSwHUGYQJ6k4Erpj5TkpMp6N5WeN5gPuIyZCovvcw0uB6ayWzpFa
	h05WSgy+pxSpD4hoDJYDfUtfpRqeGaIe8U3kcrFHCRkmDuXAuph6ybKy3O56+9cajMhqvDI
	rXi2ifoTFiYjzZmRhfcEsHkGlLdJYimDeW4+sY84s+8nUIsEQYVnEedGGrg1l5vFS4GrFot
	dfypJDcflxCLjmsRCBeMdDqKzRDPbVUyBN/j7qHXeB0DTRSJ3lO/CFZwscXyvKqKgWs2LWP
	uO8Qb5x/CN/xj6RkFAaS3ILnwpEMktVaZmL9Pe/uGJgL9FUun1Rvo0Lu+F9txiu6xkvoZR0
	J92TcVYGWcGR992N/TUTrZwULvxO3PNbU+uYBSsR2np/O0mk1CRzSGsPWFPdaDsjHAKMlCX
	JAghUDkQxYSwtttJ43Pr2w+ufatxiRr/1382+JnlnzhOb99EDKaGnqUPqKKUDiVsO/P5LAb
	0WIQ7BVFEJzQls6GGmzFWFvPIaASBHtnTe3wVeWQ==
X-QQ-XMRINFO: Mp0Kj//9VHAxr69bL5MkOOs=
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


