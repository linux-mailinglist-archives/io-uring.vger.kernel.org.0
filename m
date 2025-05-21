Return-Path: <io-uring+bounces-8059-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0CDACABF709
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 16:04:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8EC819E5767
	for <lists+io-uring@lfdr.de>; Wed, 21 May 2025 14:02:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EDB9D40C03;
	Wed, 21 May 2025 14:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NJ94khdb"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE65118D643
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747836175; cv=none; b=GNjwwWU6r+hUiKkqbNXQDKs4yh8SZXStB55bh2foVqr3hSjqs+0ik2/oCuZSDkMh6t2ySvwokKYawv9PphNKb0C9yn6h9PSDPAAcqReri6Ec6HBqHaVC1T0zRC6wQL6HT9faRSg9xueJWp6rTxsGMvizijeV07z68nH4/IQcvWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747836175; c=relaxed/simple;
	bh=LYC7a/UMeC78mBSQ+ILv5qLpcWe9qF2lN4jPeP2EXdY=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=k1azcPiWvqoHIJI1XFR8m+UGzTTk6IKdowL1/VjGehIDiVsuEbz14E+NXcPFSeKIOABpWnuPuLsF0y16XwdsRxNCy85npSy2Y+3jbyEHsOCQWVXnyvHJ/OkwkC19f0mpFum45eO156Na4PzxrULw7txdYgI9l8Qe+hXxGCNA/iU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NJ94khdb; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20250521140250epoutp0370e22faaf2c5ca6846a8fb513dbe89d2~Bj7yfkbJO2976129761epoutp03Q
	for <io-uring@vger.kernel.org>; Wed, 21 May 2025 14:02:50 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20250521140250epoutp0370e22faaf2c5ca6846a8fb513dbe89d2~Bj7yfkbJO2976129761epoutp03Q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1747836170;
	bh=48XQbNieUEs6ykNYa1g341kH5YwhQSnEPongzk9u+/E=;
	h=From:To:Cc:Subject:Date:References:From;
	b=NJ94khdbIHwB6xC0JAbWjutA47T1r/EM/nnTPr6GEcfxZzE02cKQT/6oenlFP4p2c
	 Typldl6tCavvA8oLR0OnzAq1vL0+TRJM5q9IQCuEX5QkLUGTEf82mqt+aclcAdhrzo
	 K1/sR6mIsBtfYZjM+4JgVoTbgZy+0u4bsYD6VyzM=
Received: from epsnrtp02.localdomain (unknown [182.195.42.154]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20250521140250epcas5p3306e6f4ecb3dec323247a84978ebc648~Bj7x7vpDU2640926409epcas5p3d;
	Wed, 21 May 2025 14:02:50 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.182]) by
	epsnrtp02.localdomain (Postfix) with ESMTP id 4b2Y6056ngz2SSKX; Wed, 21 May
	2025 14:02:48 +0000 (GMT)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20250521134959epcas5p412e2aac9e57ccda2e81b416d5171a53b~Bjwkofg323184331843epcas5p4C;
	Wed, 21 May 2025 13:49:59 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20250521134959epsmtrp1c0d635e7f734e439edaeb460ef4f3399~Bjwkn2gOg2963129631epsmtrp1C;
	Wed, 21 May 2025 13:49:59 +0000 (GMT)
X-AuditID: b6c32a28-46cef70000001e8a-a0-682dda07aaf8
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	78.54.07818.70ADD286; Wed, 21 May 2025 22:49:59 +0900 (KST)
Received: from localhost.localdomain (unknown [107.99.41.245]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20250521134958epsmtip15115b4388e0589442849a7c8ff5a4ee0~BjwjlHhr20131601316epsmtip11;
	Wed, 21 May 2025 13:49:58 +0000 (GMT)
From: Anuj Gupta <anuj20.g@samsung.com>
To: io-uring@vger.kernel.org, anuj1072538@gmail.com, axboe@kernel.dk,
	asml.silence@gmail.com
Cc: joshi.k@samsung.com, Anuj Gupta <anuj20.g@samsung.com>
Subject: [PATCH liburing] test/io_uring_passthrough: remove
 io_uring_prep_read/write*() helpers
Date: Wed, 21 May 2025 19:03:03 +0530
Message-Id: <20250521133303.8272-1-anuj20.g@samsung.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrELMWRmVeSWpSXmKPExsWy7bCSnC77Ld0MgzOHDSw+fv3NYtE04S+z
	xZxV2xgtVt/tZ7N413qOxeLo/7dsDmweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL
	9O0SuDJuvdrGWtAjXrF8z2TWBsY9gl2MnBwSAiYS93+uY+xi5OIQEtjNKPF9+WpmiISExKmX
	yxghbGGJlf+es4PYQgIfGSVmf6oCsdkE1CWOPG8FqxERSJL4t2EZaxcjBwezgI3EhcvRIGFh
	gXiJXesPsYDYLAKqEpN6foDZvAIWEk+PbIJaJS8x89J3doi4oMTJmU/AapiB4s1bZzNPYOSb
	hSQ1C0lqASPTKkbJ1ILi3PTcZMMCw7zUcr3ixNzi0rx0veT83E2M4GDU0tjB+O5bk/4hRiYO
	xkOMEhzMSiK8sSt0MoR4UxIrq1KL8uOLSnNSiw8xSnOwKInzrjSMSBcSSE8sSc1OTS1ILYLJ
	MnFwSjUwtajad/8/u8dWxtXmQGEE096n8taCDfufP5kmcEr9x2KGTR/lz8joMO1SZLtTeuy1
	sul59iX7O836OZ4HqZo19W2K2hi07En2K15XX7uNUR5zj817FyGtJfT78mZLqawNVeKcy5nP
	r7yT9KT71OxyVllbz0rb5q5qdy3VqEVRsquFYvd8XvDlV+Crp6ZT/+dPvqvgW2YjvShq6heT
	HldOzi/9v02qr2U/qxZpkD9ZUBgmJV/rx2zMmuvLqeqZ8PLaBO5nmc8DFC0fV9a07Gm+l1EY
	wpng96P0o0zqZQ/VpQe0Y/yvfS4Qc5rxcs0Zy3kiMqd9XSe5P+MK2LV1auH0idOC7x+v8XBQ
	epTzxlGJpTgj0VCLuag4EQAjE/detQIAAA==
X-CMS-MailID: 20250521134959epcas5p412e2aac9e57ccda2e81b416d5171a53b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250521134959epcas5p412e2aac9e57ccda2e81b416d5171a53b
References: <CGME20250521134959epcas5p412e2aac9e57ccda2e81b416d5171a53b@epcas5p4.samsung.com>

io_uring passthrough doesn't require setting the rw fields of the SQE.
So get rid of them, and just set the required fields.

Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
---
 test/io_uring_passthrough.c | 71 ++++++++-----------------------------
 1 file changed, 15 insertions(+), 56 deletions(-)

diff --git a/test/io_uring_passthrough.c b/test/io_uring_passthrough.c
index 4a0ad73..74bbfe0 100644
--- a/test/io_uring_passthrough.c
+++ b/test/io_uring_passthrough.c
@@ -75,7 +75,7 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
 	struct nvme_uring_cmd *cmd;
 	int open_flags;
 	int do_fixed;
-	int i, ret, fd = -1;
+	int i, ret, fd = -1, use_fd = -1;
 	off_t offset;
 	__u64 slba;
 	__u32 nlb;
@@ -121,61 +121,20 @@ static int __test_io(const char *file, struct io_uring *ring, int tc, int read,
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
-			if (do_fixed && nonvec) {
-				io_uring_prep_read_fixed(sqe, use_fd, vecs[i].iov_base,
-								vecs[i].iov_len,
-								offset, i);
-				sqe->cmd_op = NVME_URING_CMD_IO;
-			} else if (do_fixed) {
-				io_uring_prep_readv_fixed(sqe, use_fd, &vecs[i],
-								1, offset, 0, i);
-				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
-			} else if (nonvec) {
-				io_uring_prep_read(sqe, use_fd, vecs[i].iov_base,
-							vecs[i].iov_len, offset);
-				sqe->cmd_op = NVME_URING_CMD_IO;
-			} else {
-				io_uring_prep_readv(sqe, use_fd, &vecs[i], 1,
-								offset);
-				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
-			}
-		} else {
-			int use_fd = fd;
-
-			do_fixed = fixed;
-
-			if (sqthread)
-				use_fd = 0;
-			if (fixed && (i & 1))
-				do_fixed = 0;
-			if (do_fixed && nonvec) {
-				io_uring_prep_write_fixed(sqe, use_fd, vecs[i].iov_base,
-								vecs[i].iov_len,
-								offset, i);
-				sqe->cmd_op = NVME_URING_CMD_IO;
-			} else if (do_fixed) {
-				io_uring_prep_writev_fixed(sqe, use_fd, &vecs[i],
-								1, offset, 0, i);
-				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
-			} else if (nonvec) {
-				io_uring_prep_write(sqe, use_fd, vecs[i].iov_base,
-							vecs[i].iov_len, offset);
-				sqe->cmd_op = NVME_URING_CMD_IO;
-			} else {
-				io_uring_prep_writev(sqe, use_fd, &vecs[i], 1,
-								offset);
-				sqe->cmd_op = NVME_URING_CMD_IO_VEC;
-			}
-		}
+		use_fd = fd;
+		do_fixed = fixed;
+
+		if (sqthread)
+			use_fd = 0;
+		if (fixed && (i & 1))
+			do_fixed = 0;
+		if (do_fixed)
+			sqe->buf_index = i;
+		if (nonvec)
+			sqe->cmd_op = NVME_URING_CMD_IO;
+		else
+			sqe->cmd_op = NVME_URING_CMD_IO_VEC;
+		sqe->fd = use_fd;
 		sqe->opcode = IORING_OP_URING_CMD;
 		if (do_fixed)
 			sqe->uring_cmd_flags |= IORING_URING_CMD_FIXED;
-- 
2.25.1


