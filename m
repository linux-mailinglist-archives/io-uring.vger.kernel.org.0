Return-Path: <io-uring+bounces-8420-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A731DADE97C
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:01:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CFD87A63CD
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 10:59:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5B7E628505A;
	Wed, 18 Jun 2025 11:00:59 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgsg2.qq.com (smtpbgsg2.qq.com [54.254.200.128])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81BEE1A83ED
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 11:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.254.200.128
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750244459; cv=none; b=pyToFA+sa9GewNj3/M9waD+n8u18KM3bT2rRl06Va8A+VLOFeiBykN2cBMcVJma53r3/r4SjTWVh/f4KV0xU78YEQ2LxAn3EWIvHq27WMeZ/Lw7y8hEdcmJzWXb5gUawSG0FyQ9aBwqFNz1uprEqtq22mTNDojSzYSwhXrahpB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750244459; c=relaxed/simple;
	bh=1nlKgAOpMdMo24T2nqevD4E+oGiRn+YhvOGUhqXCtY4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNRTqv46htJPcRnvYdDUjtTjc2AtaGOdMbt5icIaoukYDDyjP+1LWDUvn6Q+nFfT4+Z5+ETzemhXBkRRvz5RD8+7TujmBkuk8H1xEC5ssJOPG4IxVkLMVSGh8xbnoOILHQ0R5e0Twi41Dfp3ZlsyRXUxSKqNsppCn8PuE6vATWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.254.200.128
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz8t1750244445t1c128329
X-QQ-Originating-IP: tg+M6i2k1ABf1wsECOQ8dG95pwwBj5W78Y27CCDfjlU=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 19:00:45 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 3565204347870000548
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v2 3/6] examples/reg-wait: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 18:55:40 +0800
Message-ID: <62F8E74FDBF1737B+20250618110034.30904-4-haiyue.wang@cloudprime.ai>
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
X-QQ-XMAILINFO: MhHYuF7Otq+oDYtIzfCn5RNpXQTSIHdqWMv61gR48pNa0BLjb+B8B5fu
	LdVFFhLOgWXDxLph+Ic2n+qEFfcdCzUwcOW40+38Th0ku5YYUbBQNZfJ8prmCGAoNguW/xM
	SYtuD00CM8pJZL+miEEPDujIQiahUQAYGqu9oIPeRgFRiz6UD4qk2CLPlhE7D69tm311lhy
	w78eDdfRdlJxBw/+a3GKYGnakyoTE4h36tkE68pEA5k/INYd9O9jXalk1HFQ1AG/5gbxy+a
	Ej7OmtF9r8JdWeqisJjebGZbLRQbulAyIB09asK0OQDeZBcsR4yGKyWVxIZl7HFvpRG9a0j
	yA7YUTlcyjkCtRTQi0WS2yHDps/ppv9mNmtaLL7rK9MYB9EKatTq9Ng18B8Kj0HnuQGpxjt
	THTpWDsU3QIy+BzA+Cf1JF0nurFQP/u3ESE+zaAizTj1Wcy5DltmcIaq9gNrGkEY/7WMquN
	1O2IiHL95wKRVWD2ozOdBIs5hn2RRDds85PrYohowcpyU/wCmeMukh1RmAJT9TaohK8m8gS
	ic/t/nQjUu5rkOV+ts+OjgmWVpFcOWo8odfapOg2dOoVT1u4cLpiRMTcn7mj0988+uKk+qb
	7iY4FHkSpRCvdiDTNHdmdU3SwGtZZBRlgeWXrb7VLBGunPQrHbm5+epZ00GvKMc612SO+nW
	MduwtXbqe9JGeUi9oiQl5wplOhy8z/N1uKANwnHO9euzO7CwRbc27WbJgSIGbc+kzYSM+4A
	DGDhq0NPPcBBcKYQVh1O1bfeo0EOmRVzNP+w6/qlATHraIAhdNTan6B2lj1ZOOCWXr2eCzB
	XnxK37Aj7I/wwytffVVhL+BlpjoV1hX5MmjfX/QdD3/lwIccOoqnzslJ8Ox+8Y/7yuFcQQ/
	FmpUnNS2f2GbFf0A2K6JFXxEhQLkMmybrGjXhGeyxGYIWBheWnthU0FF0NtGPFqRCoIu7V9
	lokFZNR4xm+AO89VqiukzoBSBCgbqlKH5oChx8E8w2YO3EA529MISUgn74FcYh7PqbXn72c
	iEfbS1rx95DDvJ1QDm
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
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


