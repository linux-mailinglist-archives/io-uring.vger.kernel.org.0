Return-Path: <io-uring+bounces-8054-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B33CABF58A
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 15:08:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 6CEBB1BC2B20
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 13:08:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B907C2472A0;
	Wed, 21 May 2025 13:07:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="vNNwT5sg"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 987A8270547
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 13:07:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747832874; cv=none; b=DT+0aqMf7xRBR5Yi+F6LphUhSE9cmHpPbJuDr4Qip37upQFhOTz486rWgNJmF5heCtWaivn5DoyN0JQKFDzCL3vPYSBoI8d+UUJuynzzFcyApwNHGemS/uJgJDXrep8kaU7P9JiuwHN1xmRjJ8DBXc9vX4xNlHnbkfNU5HkyIw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747832874; c=relaxed/simple;
	bh=hEb7/xLQ3UvFAso72P7Tm6TvfoxavTjcoFOZyU8kEJI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=SQhRpss4LMy9byMooYcSiDyUAOuzT3020yH6QQYdsA2LIabQyGYdmnqKCfOZMgKiNU2ZIdqTG6F9r1VKUJsb4RhGQAiMkSMWnddpyLQyA3H8iSnOpIzJoGaxmtih+9XSZ5ghjEMLi6SkSZvgq6IpJNI0W7SaphHc27m26X+LilM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=vNNwT5sg; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20250521130749epoutp0435b5d8d1533f7f4310276f8847756aa8~BjLv9M7gy0370903709epoutp04v
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 13:07:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20250521130749epoutp0435b5d8d1533f7f4310276f8847756aa8~BjLv9M7gy0370903709epoutp04v
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1747832869;
	bh=FpbzYexdQXr6xqh2JhEkec9qakdSnlFgbhoCq3cixrM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=vNNwT5sgnfgcpsqynrPghTP+MtUHWjbd80x2biX6bVVOUBrJLoetF/hvm52ruHNJf
	 /Mq2QKU4iHBvWgDXqCKcXsw2cmpPrAPfTFeO/2w604NMRfx9qPY89p4msI2CG/95TS
	 f1YlKDqrXPyqRqUbFGPlcBgNjIFyYllzKUcLrkvE=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250521130749epcas5p31474f16bbf6d68b4021636718ea5f782~BjLvkUTRo0781307813epcas5p3C;
	Wed, 21 May 2025 13:07:48 +0000 (GMT)
Received: from epcas5p2.samsung.com (unknown [182.195.38.182]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4b2WtW4SYFz3hhT3; Wed, 21 May
	2025 13:07:47 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250521125340epcas5p44d0f9a187e59ded5975323dc3017a8e3~Bi-ZZ5CXt1065910659epcas5p4g;
	Wed, 21 May 2025 12:53:40 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250521125340epsmtrp199532c4f44fc52175fcb61de342bc0a9~Bi-ZZQHn62940529405epsmtrp1I;
	Wed, 21 May 2025 12:53:40 +0000 (GMT)
X-AuditID: b6c32a52-41dfa70000004c16-25-682dccd4e8da
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	79.50.19478.4DCCD286; Wed, 21 May 2025 21:53:40 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20250521125339epsmtip2d7268da94e894801a88b99f231616716~Bi-YY3M_y1905819058epsmtip2G;
	Wed, 21 May 2025 12:53:39 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: io-uring@vger.kernel.org, anuj1072538@gmail.com, axboe@kernel.dk,
	asml.silence@gmail.com
Cc: joshi.k@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH liburing] test/io_uring_passthrough: remove
 io_uring_prep_read/write*() helpers
Date: Wed, 21 May 2025 18:06:43 +0530
Message-Id: <20250521123643.4793-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprHLMWRmVeSWpSXmKPExsWy7bCSvO6VM7oZBnenyFh8/PqbxaJpwl9m
	izmrtjFarL7bz2bxrvUci8XR/2/ZHNg8ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW
	6dslcGXMnXadqeC1SMXPrvvsDYyP+LsYOTkkBEwkzm17wNjFyMUhJLCdUaK3+wsTREJC4tTL
	ZYwQtrDEyn/P2SGKPjJKfHr3GKyITUBd4sjzVrAiEYEkiX8blrF2MXJwMAvYSFy4HA0SFhaI
	l9i1/hALiM0ioCqx/NlJFpASXgELiVPHgiHGy0vMvPSdHcTmFRCUODnzCVg5M1C8eets5gmM
	fLOQpGYhSS1gZFrFKJpaUJybnptcYKhXnJhbXJqXrpecn7uJERyEWkE7GJet/6t3iJGJg/EQ
	owQHs5IIb+wKnQwh3pTEyqrUovz4otKc1OJDjNIcLErivMo5nSlCAumJJanZqakFqUUwWSYO
	TqkGpqjDj1/P0F7ot3ieTPyque2LpbMNDLmvm2T39vpwdtl5uom6bn//pOePZ4j6Zoupb7bM
	bj23VmqH8o7ag1INkToSIp41qinHdnzasSfaRvedmv43w8iiBLeJcq9XvnT/tvltzIxCofxr
	i7ytnqf2/Cl+NCUq7L+93uKS5ilb+r06NlX+3LVf6E6awjujp+tj79848mhjbYjOfJ7tkvXZ
	zjvk8j91SaaVGopLbJnxnkG9fM3Uek7fz+EODk+ncG7JXreyfD2XtOPSvr0yLdfmz2hmufLk
	eMjluSqvLj4y9zrT+t2Cc4VqSpdr6gHvz0lr69hdb764lfv0jLeG57EihfA1z+6Zt/7uUE7V
	u2c/Q4mlOCPRUIu5qDgRANk6KKGxAgAA
X-CMS-MailID: 20250521125340epcas5p44d0f9a187e59ded5975323dc3017a8e3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250521125340epcas5p44d0f9a187e59ded5975323dc3017a8e3
References: <CGME20250521125340epcas5p44d0f9a187e59ded5975323dc3017a8e3@epcas5p4.samsung.com>

io_uring passthrough doesn't require setting the rw fields of the SQE.
So get rid of them, and just set the required fields.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 test/io_uring_passthrough.c | 61 +++++++++----------------------------
 1 file changed, 15 insertions(+), 46 deletions(-)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index 66c97da..b62eccf 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -74,7 +74,7 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 	struct nvme_uring_cmd *cmd;
 	int open_flags;
 	int do_fixed;
-	int i, ret, fd = -1;
+	int i, ret, fd = -1, use_fd = -1;
 	off_t offset;
 	__u64 slba;
 	__u32 nlb;
@@ -120,53 +120,22 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 			fprintf(stderr, "sqe get failed\n");
 			goto err;
 		}
-		if (read) {
-			int use_fd = fd;
-
-			do_fixed = fixed;
-
-			if (sqthread)
-				use_fd = 0;
-			if (fixed && (i & 1))
-				do_fixed = 0;
-			if (do_fixed) {
-				io_uring_prep_read_fixed(sqe, use_fd, vecs[i].iov_base,
-								vecs[i].iov_len,
-								offset, i);
-				sqe->cmd_op = NVME_URING_CMD_IO;
-			} else if (nonvec) {
-				io_uring_prep_read(sqe, use_fd, vecs[i].iov_base,
-							vecs[i].iov_len, offset);
-				sqe->cmd_op = NVME_URING_CMD_IO;
-			} else {
-				io_uring_prep_readv(sqe, use_fd, &vecs[i], 1,
-								offset);
-				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
-			}
+		use_fd = fd;
+		do_fixed = fixed;
+
+		if (sqthread)
+			use_fd = 0;
+		if (fixed && (i & 1))
+			do_fixed = 0;
+		if (do_fixed) {
+			sqe->buf_index = i;
+			sqe->cmd_op = NVME_URING_CMD_IO;
+		} else if (nonvec) {
+			sqe->cmd_op = NVME_URING_CMD_IO;
 		} else {
-			int use_fd = fd;
-
-			do_fixed = fixed;
-
-			if (sqthread)
-				use_fd = 0;
-			if (fixed && (i & 1))
-				do_fixed = 0;
-			if (do_fixed) {
-				io_uring_prep_write_fixed(sqe, use_fd, vecs[i].iov_base,
-								vecs[i].iov_len,
-								offset, i);
-				sqe->cmd_op = NVME_URING_CMD_IO;
-			} else if (nonvec) {
-				io_uring_prep_write(sqe, use_fd, vecs[i].iov_base,
-							vecs[i].iov_len, offset);
-				sqe->cmd_op = NVME_URING_CMD_IO;
-			} else {
-				io_uring_prep_writev(sqe, use_fd, &vecs[i], 1,
-								offset);
-				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
-			}
+			sqe->cmd_op = NVME_URING_CMD_IO_VEC;
 		}
+		sqe->fd = use_fd;
 		sqe->opcode = IORING_OP_URING_CMD;
 		if (do_fixed)
 			sqe->uring_cmd_flags |= IORING_URING_CMD_FIXED;
-- 
2.25.1


