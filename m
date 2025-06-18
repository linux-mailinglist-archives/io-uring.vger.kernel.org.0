Return-Path: <io-uring+bounces-8417-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9907FADE979
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 13:00:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 18B7C189D68B
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 11:01:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03ED01A83ED;
	Wed, 18 Jun 2025 11:00:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgeu1.qq.com (smtpbgeu1.qq.com [52.59.177.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 755AC219E8
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 11:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=52.59.177.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750244450; cv=none; b=YCi6mzGmbeAD+PxPMaIZCWjjTFDS4Gz6LETd6hneinwHH63kg9Xn9aP/8s1pq0nbEzvX7Z6ZssALvrIUUKdz5TMe0eThcXDtWPdBNuUKgJMYPdumYiEsgmTYF0kRWaVGaUkf+PEjv/h3PR9yuoJyawLEbLUz0txzh0XsmT1BkOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750244450; c=relaxed/simple;
	bh=aB3v5nrL55VC1ypEw6e3OUbNKZST4ehYZwNTE1K+5bc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoKZvlgmNKO7gs7AkAB0RRUhoylgXN1CUy59Vr9RYu8K0YZO0hvw7p1SBowqVmEaOjWawRjN/FoYuCI+2fpP1Bfbjrj9UGKr5qs0ExlbhW7+GzK2VFzA9GcJCHtJ7eO42bC4y+2pvEVImkzwmMTtPmxoEhe4irPk/rci5MgPgCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=52.59.177.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz8t1750244442t6f1f2219
X-QQ-Originating-IP: KTy/6ocDACoLlRnLTV8ruz+cZLkyOwMdtoUs4Ge3DV0=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 19:00:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 14031602900658797052
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v2 1/6] Add uring_ptr_to_u64() helper
Date: Wed, 18 Jun 2025 18:55:38 +0800
Message-ID: <916859AE41FC06CF+20250618110034.30904-2-haiyue.wang@cloudprime.ai>
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
X-QQ-XMAILINFO: Ni68Q0J6fxe25YECQwR24hssrgoJLkECLewf9QEaBDmLW+1SQ7hNaLUy
	CRTuwO1pQO/U7pErwKkSJbMdOyDXLBBZhj5TmL6gpiQSXU8CdN4H1vmnyaNtRO789LcQkgq
	ETRWiEr4EepoL2IuepLyn/f+nP0caIMw9FSAIKfNQf+7oDUwoy+UhWa/UwvT63Q+xWX3Lj0
	oGSldMnIJJkGaqlS7LfhdX1e8lh4Ga7EXSyGGn1ppwqrPBFhOwTsve0mj3PZuQD9sSNcqzR
	iC2B33KedBbAoB6LqKbPn5MjcDHNzvQcYgGrjfrLZtFqfJAl7PQHEWaWoPWoktwtZgWcctS
	G73EkQMuBtFLJvMs7MGmntZ6J8C9K6j4iYQrzdu8lfk93dYIbfHv68CilKSLxPprrOAP5dV
	C9P6yn2FIPNP2uC0TJHYdm1hmBCNrksbNvntzkZnE4HGtdec6rNd17M+VUjWQQqIppqXpvu
	UYiGZMqZPQ8byTwq1EuKkqrQhV96EfxoY5fb81I3gnXRZwTpcrQSbzPJw5U6EodjCeNzk3J
	WtxzF3TZ3+j54Mz+6guNhKJR9F+eC/tbJpkuZW7nZWbJ0y1rXd5BESV/iXglhQOYT3APcCs
	SqpR9almTJKpQnR1z6wrnNKEPw+yAJdlNaqB0A5oC9IovEcm7cx/84ifRGEA8FPZVlQ88Kn
	F1HRsXZoPgS7VgLghbcza5mcpDGyukrzENwGf3ABgrE48VPrBMUSvWZOLXa+vh7ZXGP2EdF
	YqrVEs/olpyl2yyAYEaFDydAMRyl9FLRxzebsnwtoL/7HLsBYJGY3+qxko1npS3Mg/fx6WO
	RZz83u3KnytjCoGqWcBrXu1qZJO+yyRVMIP6+UAdEsNt9nW+Umq674C1OUmqqf7meOQueFh
	YBFDEhTd7CdRc3sYyQnbxJr5FTtKbh1vCqQFIewnnYqCFTYhlLBaKYcDw3f9Ubw8JrHGJdr
	RBcJrlPZeJjtjrnZgsBtpvuWD2nUPIdlE2WXvntQ/isF7xBV0b9JIOqeZlmPFVxMAsOwp4A
	JFXNIFXQ==
X-QQ-XMRINFO: M/715EihBoGSf6IYSX1iLFg=
X-QQ-RECHKSPAM: 0

Add this helper to convert '*ptr' type to '__u64' type directly.

Signed-off-by: Haiyue Wang <haiyue.wang@cloudprime.ai>
---
 src/include/liburing.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 96eeed3..520b07d 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -146,6 +146,11 @@ struct io_uring_zcrx_rq {
  * Library interface
  */
 
+IOURINGINLINE __u64 uring_ptr_to_u64(const void *ptr)
+{
+	return (__u64) (unsigned long) ptr;
+}
+
 /*
  * return an allocated io_uring_probe structure, or NULL if probe fails (for
  * example, if it is not available). The caller is responsible for freeing it
-- 
2.49.0


