Return-Path: <io-uring+bounces-8410-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BA57ADE4DB
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 09:51:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6C7E13BCB33
	for <lists+io-uring@lfdr.de>; Wed, 18 Jun 2025 07:50:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A946A1D5CEA;
	Wed, 18 Jun 2025 07:51:18 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from smtpbgjp3.qq.com (smtpbgjp3.qq.com [54.92.39.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 529B125A33A
	for <io-uring@vger.kernel.org>; Wed, 18 Jun 2025 07:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.92.39.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750233078; cv=none; b=ktIg/XTet527vcBYZFOGso1zcygHZTHL+WeEkg3VpJECW3gCIucWjVE3qRCBtdJZUqB4wscPz4DNl3B8mhOBtEgqtG0IvYPNBtscNTfZEaKsdYZs2QVsCeg5ROoYLlxp1XRLY58sm1Pfm6hUqZeYFc95YtISTsDvEGjCQeD1uwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750233078; c=relaxed/simple;
	bh=jEGcUrUzW4bBd4XLG92+QqiiXo/KXyBHaL1GxUKmxeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lhQ4uVlOpM37IXkwb0Od/xWtjX3a06cQWvNxe4/reRs1tObqBCrsYkVB4WbPZT1bhKFCFi46XhrhVGXoSsdOs3aZ8IT/oGKQHPsPIV5eudt3Idytnp4DnIGtKH2w0/A8aGq/CckCwGbe0QvpOE6JCt3x4ZSQnsB1Tyr3NV5kKyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai; spf=none smtp.mailfrom=cloudprime.ai; arc=none smtp.client-ip=54.92.39.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=cloudprime.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=cloudprime.ai
X-QQ-mid: zesmtpgz1t1750233069t230d9931
X-QQ-Originating-IP: fSynssGf0uTaYUHV1mZRBypWe+DYBpAPFoNVmbkEzyQ=
Received: from haiyue-pc.localdomain ( [222.64.207.179])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Wed, 18 Jun 2025 15:51:08 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 9162071731163168030
EX-QQ-RecipientCnt: 2
From: Haiyue Wang <haiyue.wang@cloudprime.ai>
To: io-uring@vger.kernel.org
Cc: Haiyue Wang <haiyue.wang@cloudprime.ai>
Subject: [PATCH liburing v1 2/6] liburing: use uring_ptr_to_u64() helper to convert ptr to u64
Date: Wed, 18 Jun 2025 15:49:17 +0800
Message-ID: <D389371A903202C0+20250618075056.142118-3-haiyue.wang@cloudprime.ai>
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
X-QQ-XMAILINFO: NY3HYYTs4gYS6+JgFWz3tulITIAZWRmatxfh+0+7KtV7YyHs5cH/IHvG
	oGGwHZJafPoMBigTcOabIHyFQLc1tMn+QoNL4/fWRt+9Of9+CPPoiTH+HXQzsEy9oKWiofY
	e8Vsx6ISrTC/FPk+99cP9RjIrwTAa3NRQM2eLXA+HHB7Fyb0aG8vGoekqqJFCkVjM9X6Rw8
	AkDYjjHGh9m272NPgntNAOqnJKCaoVIvnzNOYexRcOzxxjExktRReTyof3WobMNJwOS8uMT
	S4pXl3Z+vZbuxlaAlGudhOnlPP1MxnnC2WJpnHqA9YLrv/kBs6Gb35NNVinbVfFASyXb+TZ
	Tl4/gnG8pTwDWfQozUIaY98/8q9iBVPll66fbifxSSDB4qdfyZSm7TCu1cdgbIUwvTI97LJ
	Hifdc6vrKdECWmTtezBbbicnkm7k3WiQ8/40QNmRQ+aK6u0Hxdv63Ni0twNM2IB5dYmZfjC
	9MIc5AWjgaceSJi12Sr3GJe4PA4ppE+GDXPsN+qS7iw4C9bcveOPnM2VDZ9j1diGxrxiHJX
	DufAxzn/u0xzBvloGkn7iIsKV7QOR99xn7aZrr/CvREOAeWKMg8QlqOcJqW8Ha2WL1mBIhs
	Rcvq1VcxtSTdnvJY0VdFkQrmPYb2WK3yy3AwdcozxjN4a/bSRwRaGWJyF47xev8Mnh7Hb5k
	szsOdVNySkTGX68iw+0v7pbq0wyjt8O+/i7N76k5JT6OKHor+RZaE3ddeQUiQVQASSxv2h3
	YeMFrOjysHifQAkbEnXdQppU43ceDRgLykA1o3bNsi8tVAvIRXkLMHJBRj9vCesQUHYEtkt
	gyiaZ/JmxIracjJiKpe54g5MRN8RPCYjTVfth9BkEQ+crNhXiTQPKI73yIeBXrzAefzqpSi
	/MQlzFYc+JARXWBADUXVi9Q6y1+oNO9k43oCJqsZnE0Y9+vH0XZ0qP5yTS+Kxqs9I5Ve/AT
	/9DFgjAu6HcY0lbAFfhQvHbtTlkWs2dAdKc3zWL0l2zGZSBV23GPM8Hxp7ca4wqddG4ZFK4
	V5e2939iTMCZ8EH/BI
X-QQ-XMRINFO: NS+P29fieYNw95Bth2bWPxk=
X-QQ-RECHKSPAM: 0

Use the helper to handle type convertions, instead of two type
convertions by hand: '(__u64) (unsigned long)'

Signed-off-by: Haiyue Wang <haiyue.wang@cloudprime.ai>
---
 src/include/liburing.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/include/liburing.h b/src/include/liburing.h
index 6d87248..9f13e78 100644
--- a/src/include/liburing.h
+++ b/src/include/liburing.h
@@ -721,7 +721,7 @@ IOURINGINLINE void io_uring_prep_accept(struct io_uring_sqe *sqe, int fd,
 					socklen_t *addrlen, int flags)
 {
 	io_uring_prep_rw(IORING_OP_ACCEPT, sqe, fd, addr, 0,
-				(__u64) (unsigned long) addrlen);
+				uring_ptr_to_u64(addrlen));
 	sqe->accept_flags = (__u32) flags;
 }
 
@@ -907,7 +907,7 @@ IOURINGINLINE void io_uring_prep_statx(struct io_uring_sqe *sqe, int dfd,
 				       unsigned mask, struct statx *statxbuf)
 {
 	io_uring_prep_rw(IORING_OP_STATX, sqe, dfd, path, mask,
-				(__u64) (unsigned long) statxbuf);
+				uring_ptr_to_u64(statxbuf));
 	sqe->statx_flags = (__u32) flags;
 }
 
-- 
2.49.0


