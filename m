Return-Path: <io-uring+bounces-10946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 52271CA2DF8
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 09:58:14 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 3FAAF30329F3
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 08:57:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B2CB331A46;
	Thu,  4 Dec 2025 08:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="WqHMdm2W"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BC9A3321A3
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 08:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764838678; cv=none; b=WN2uGvF1XaJQ7RxMY5vGGz9HpbIpxOmpKfU2T11ePM+2ZQ2PtteDCeebHk7U1vJwoyqtka6B14B4l7Hmkgml9kUBbzxhQS7G/9pb3eReSfaMiaqCVGzckBEVHYJp3lU+hrFmE7Kx0vj82yjC+6DZ+/DdNNB+M6EqFg4TEOPFf78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764838678; c=relaxed/simple;
	bh=6EJU0s5zQIZkjzWdL3CNTeyUIRwhyZ3aqcIbFKcxh7c=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=A9WUntwxomGIOGN7knYuUsElZ+P7ykOx3HrYP5DjWBi4IAl4CbPjBcSoR0Uw3+BsE88gBIny7e9EVDoRFkUnNT1JZjoJuVUOnDfj5g4WQ1op2q/HWxyEYjeNo8oaULHjjGKF6Iu7U7LieV5vN/ebkq6Bthc1JJ1+c1ueSwZAzLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=WqHMdm2W; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20251204085748epoutp03c1216bfb2461021f544873316030e0c5~992sgLpbI0829208292epoutp03R
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 08:57:48 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20251204085748epoutp03c1216bfb2461021f544873316030e0c5~992sgLpbI0829208292epoutp03R
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1764838668;
	bh=UO47SaecR29UQDqnuN+Ou9tQZZHH3Ag+wsObNVM1ejM=;
	h=From:To:Cc:Subject:Date:References:From;
	b=WqHMdm2WutTk+8yp44uSXIYakWthJgmangwm7c/c94SMcuaBLssdOI/tOpK1x/dNV
	 A9RWm1wE6unazXvRd7qPGaHhOIWTmyX9dg4IvvSKb5ZhpnX34E6D2V7XymzF44K8XS
	 R1D2qeuvkE1K2TAJn2uA3vDspsqJtffP4IUL7tG0=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20251204085747epcas5p3f309e6031bbc1fcef55e543243fb3253~992r84uNu0516705167epcas5p3H;
	Thu,  4 Dec 2025 08:57:47 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.91]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4dMT171JQ4z3hhTB; Thu,  4 Dec
	2025 08:57:47 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20251204083010epcas5p2735e829064ff592b67e88c41fb1e44b3~99ekwVkL92713027130epcas5p2S;
	Thu,  4 Dec 2025 08:30:10 +0000 (GMT)
Received: from node122.. (unknown [109.105.118.122]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20251204083009epsmtip1dd121e43e7021d3bf88c5fdd720036be~99ejAmjkQ2460024600epsmtip1x;
	Thu,  4 Dec 2025 08:30:08 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: miklos@szeredi.hu, axboe@kernel.dk
Cc: io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com, asml.silence@gmail.com, joannelkoong@gmail.com,
	dw@davidwei.uk, josef@toxicpanda.com, kbusch@kernel.org,
	peiwei.li@samsung.com, joshi.k@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH] fuse: add zero-copy to fuse-over-io_uring
Date: Thu,  4 Dec 2025 08:25:36 +0000
Message-Id: <20251204082536.17349-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CMS-MailID: 20251204083010epcas5p2735e829064ff592b67e88c41fb1e44b3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-505,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20251204083010epcas5p2735e829064ff592b67e88c41fb1e44b3
References: <CGME20251204083010epcas5p2735e829064ff592b67e88c41fb1e44b3@epcas5p2.samsung.com>

Joanne has submitted a patch for adding a zero-copy solution.

We have also done some research and testing before, and
the test data shows improved performance. This patch is
submitted for discussion.

libfuse section:
https://github.com/lreeze123/libfuse/tree/zero-copy

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 fs/fuse/dev_uring.c   | 44 +++++++++++++++++++++++++++++++------------
 fs/fuse/dev_uring_i.h |  4 ++++
 2 files changed, 36 insertions(+), 12 deletions(-)

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index f6b12aebb8bb..23790ae78853 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -584,15 +584,20 @@ static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
 	int err;
 	struct fuse_uring_ent_in_out ring_in_out;
 
-	err = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
-			     sizeof(ring_in_out));
-	if (err)
-		return -EFAULT;
+	if (ent->zero_copy) {
+		iter = ent->payload_iter;
+		ring_in_out.payload_sz = ent->cmd->sqe->len;
+	} else {
+		err = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
+					sizeof(ring_in_out));
+		if (err)
+			return -EFAULT;
 
-	err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
-			  &iter);
-	if (err)
-		return err;
+		err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
+				 &iter);
+		if (err)
+			return err;
+	}
 
 	fuse_copy_init(&cs, false, &iter);
 	cs.is_uring = true;
@@ -618,10 +623,14 @@ static int fuse_uring_args_to_ring(struct fuse_ring *ring, struct fuse_req *req,
 		.commit_id = req->in.h.unique,
 	};
 
-	err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
-	if (err) {
-		pr_info_ratelimited("fuse: Import of user buffer failed\n");
-		return err;
+	if (ent->zero_copy) {
+		iter = ent->payload_iter;
+	} else {
+		err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
+		if (err) {
+			pr_info_ratelimited("fuse: Import of user buffer failed\n");
+			return err;
+		}
 	}
 
 	fuse_copy_init(&cs, true, &iter);
@@ -1068,6 +1077,17 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd,
 	ent->headers = iov[0].iov_base;
 	ent->payload = iov[1].iov_base;
 
+	if (READ_ONCE(cmd->sqe->uring_cmd_flags) & IORING_URING_CMD_FIXED) {
+		ent->zero_copy = true;
+		err = io_uring_cmd_import_fixed((u64)ent->payload, payload_size, ITER_DEST,
+						&ent->payload_iter, cmd, 0);
+
+		if (err) {
+			kfree(ent);
+			return ERR_PTR(err);
+		}
+	}
+
 	atomic_inc(&ring->queue_refs);
 	return ent;
 }
diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
index 51a563922ce1..cb5de6e7a262 100644
--- a/fs/fuse/dev_uring_i.h
+++ b/fs/fuse/dev_uring_i.h
@@ -38,6 +38,10 @@ enum fuse_ring_req_state {
 
 /** A fuse ring entry, part of the ring queue */
 struct fuse_ring_ent {
+	bool zero_copy;
+
+	struct iov_iter payload_iter;
+
 	/* userspace buffer */
 	struct fuse_uring_req_header __user *headers;
 	void __user *payload;
-- 
2.34.1


