Return-Path: <io-uring+bounces-7226-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7590FA6E3EF
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 21:06:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 32DEE1890DE2
	for <lists+io-uring@lfdr.de>; Mon, 24 Mar 2025 20:06:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0F3681C860F;
	Mon, 24 Mar 2025 20:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="gMxxYlSS"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f100.google.com (mail-io1-f100.google.com [209.85.166.100])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31D8C1C07D9
	for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 20:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.100
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742846787; cv=none; b=c7ikgMGQk2MNzb1j0ohojijt4UiDks1VpN3iuwO2FKX+Lq4OowHYSF/M6jyfGxmlWU6Ow46aa1zeNcypy/505qhcwh8TZAfU//nM+I0hoFL3T+MgAFJ6mfMjAQNkNsKaiptEBLsH6RPGDOFNhm4HGK5rvpKwV24d7ykFR6YV5jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742846787; c=relaxed/simple;
	bh=a/OqDesckC4x9orY8rbOzrIOx5U2C6nDLJe9hDC2J94=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ay1lPD+GnYXO4em/PezLSEq9s7UbwERzZwaTFRyf/APbnEAQlE53r+CAxHIQNYrsDK1bkn5TxD/P3aZP9tk3GTJjB6QgfZhO0dHNIdrb6pbgUtluweWuYZc94AabvtEvxA+/KPL6wJRMXuOcOrbVZTnWPiZqiNAUmW4BfS/2o6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=gMxxYlSS; arc=none smtp.client-ip=209.85.166.100
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f100.google.com with SMTP id ca18e2360f4ac-85b418faf5cso15545639f.3
        for <io-uring@vger.kernel.org>; Mon, 24 Mar 2025 13:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1742846784; x=1743451584; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2AeP3tUa1PaSAs4qnZHRPSHqiV7KLICBeUZhC4wZNt0=;
        b=gMxxYlSSSZKUnoHpp5k9MJ+HOoWOaY+QgeIQSiySVnnHh55opDlSu63Dm1pEglWdFu
         LDIyE7k/nqnibjCYWtSlQ2Dn+P9YQnTaDJrehcoPFpcGrT2nfm50lV1r8kDcr1BnK4cy
         CtW8yE64+VNYDq6mOQQoSZ1mQ9UHPmPl4v9EJq9sJQ7fXxz59iweZ6wD+u0ZqAjYDbj6
         ashJdT+Jr4pZS/mFQKApnzCcJZNce8VFbAQ6eUQeEP+BwAdltsfnUejCmpgepRn8lXOL
         V0lu+2fAasJ3lcCcm20JfSVaLzPENjN60tK5dUbxX3gS0T/TIu3Rfc0gpQzu2hAhhj0o
         t3Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742846784; x=1743451584;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2AeP3tUa1PaSAs4qnZHRPSHqiV7KLICBeUZhC4wZNt0=;
        b=FeYbghB1iMxSqeho6F/5DL1r7isv/QTURyJ4B80DM5GOZik+LQY0kieTzgqObNM0qC
         ePYgxKJF3iNXwI9z5BvE3+5IBer4kY/CPQ12PpHjOYqb1Ssk8qtzhnxj2m1hv3u7Wrlx
         aRS+tZ66/BoePQu8KtA+dzIlfnQPbRutdFJh2YpyPYWre8FFm/KEULdoiQe4xrFBw/++
         C89jrbZlkVwlxWgXfGUP82grWZ/Aszcxqrb1gB8+830DSBuf312SujNukymKz/R0hAhe
         k/QeoSmDv/Dd5fSe3dgkdjwSPEOFgZXo6fGVkwNJw6O5+Y/q7Qd2T/O3BC91KIcLJ3Gv
         h+AA==
X-Forwarded-Encrypted: i=1; AJvYcCXm4EbRHca5XVvmp77PjbgBvK1Dm/tsEu/f1KNfs0bHmSVfYQo+PyRagPWi/OyWy7aqHkl6+lSoHg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw9Py4ZqecSPyxnuaXHv7wG07W6i5jRy5Ow9HIvqFjXcABpJcjw
	FnZQLyUaPJuwVAr+8xS625ebRAMPVO97rW25u+ZgZw8O/wp8sHfRjNeXBnJGgJ5jKrD4W/4zFNc
	+NRWi++Du0HkWKQVMcxuLdxcYHZe3kQT9YO1/inK8mc/0LbUq
X-Gm-Gg: ASbGncvBiKl4/9Jhrr/J2BBCo9w5BkfcBBIFYP8DUkZ7w9iECUXbuj1xQ7X+qhG4+tW
	tQMKWyrOZd9lh6S2eSkScaeod/oLQxKRNQ89X1E4XjwC2VIfAbkHyapg4N9dnUl1HUVks4BGyov
	L473WhMwugdOPh0hRSSUDWi1o5ocYZndzzPAZyCNVCQVwRpvET9LAChOJgywI4o8bZmIguYqSbx
	uzwPEZNu0vRn96eBAgNyUaKgFvYcZyuoR1RhFB2WjttQnDyPKT5Pn9AX7Ww1OATA6W6tkmmSazb
	HcuSR2ZHGrsU+6q5h50e/0PPWonEZK+2Mw==
X-Google-Smtp-Source: AGHT+IHNqvmP9ln5GrZ4X4+8LO1tZJJn7NGCANLbaSu7JIy8WsCk3TVzlhQISS+g7lZW4375/xs/ty7i0mo7
X-Received: by 2002:a05:6e02:1946:b0:3d4:3aba:9547 with SMTP id e9e14a558f8ab-3d59616811cmr38294575ab.4.1742846783927;
        Mon, 24 Mar 2025 13:06:23 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id e9e14a558f8ab-3d5960fdf9bsm3732575ab.52.2025.03.24.13.06.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Mar 2025 13:06:23 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 0B9543404B9;
	Mon, 24 Mar 2025 14:06:23 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 00019E40AE6; Mon, 24 Mar 2025 14:05:52 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Xinyu Zhang <xizhang@purestorage.com>,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v3 3/3] nvme/ioctl: move fixed buffer lookup to nvme_uring_cmd_io()
Date: Mon, 24 Mar 2025 14:05:40 -0600
Message-ID: <20250324200540.910962-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250324200540.910962-1-csander@purestorage.com>
References: <20250324200540.910962-1-csander@purestorage.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nvme_map_user_request() is called from both nvme_submit_user_cmd() and
nvme_uring_cmd_io(). But the ioucmd branch is only applicable to
nvme_uring_cmd_io(). Move it to nvme_uring_cmd_io() and just pass the
resulting iov_iter to nvme_map_user_request().

For NVMe passthru operations with fixed buffers, the fixed buffer lookup
happens in io_uring_cmd_import_fixed(). But nvme_uring_cmd_io() can
return -EAGAIN first from nvme_alloc_user_request() if all tags in the
tag set are in use. This ordering difference is observable when using
UBLK_U_IO_{,UN}REGISTER_IO_BUF SQEs to modify the fixed buffer table. If
the NVMe passthru operation is followed by UBLK_U_IO_UNREGISTER_IO_BUF
to unregister the fixed buffer and the NVMe passthru goes async, the
fixed buffer lookup will fail because it happens after the unregister.

Userspace should not depend on the order in which io_uring issues SQEs
submitted in parallel, but it may try submitting the SQEs together and
fall back on a slow path if the fixed buffer lookup fails. To make the
fast path more likely, do the import before nvme_alloc_user_request().

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 drivers/nvme/host/ioctl.c | 45 +++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index f6576e7201c5..da0eee21ecd0 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -112,12 +112,11 @@ static struct request *nvme_alloc_user_request(struct request_queue *q,
 	return req;
 }
 
 static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		unsigned bufflen, void __user *meta_buffer, unsigned meta_len,
-		struct io_uring_cmd *ioucmd, unsigned int flags,
-		unsigned int iou_issue_flags)
+		struct iov_iter *iter, unsigned int flags)
 {
 	struct request_queue *q = req->q;
 	struct nvme_ns *ns = q->queuedata;
 	struct block_device *bdev = ns ? ns->disk->part0 : NULL;
 	bool supports_metadata = bdev && blk_get_integrity(bdev->bd_disk);
@@ -135,28 +134,16 @@ static int nvme_map_user_request(struct request *req, u64 ubuffer,
 		if (!nvme_ctrl_meta_sgl_supported(ctrl))
 			dev_warn_once(ctrl->device,
 				      "using unchecked metadata buffer\n");
 	}
 
-	if (ioucmd && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
-		struct iov_iter iter;
-
-		/* fixedbufs is only for non-vectored io */
-		if (flags & NVME_IOCTL_VEC)
-			return -EINVAL;
-
-		ret = io_uring_cmd_import_fixed(ubuffer, bufflen,
-				rq_data_dir(req), &iter, ioucmd,
-				iou_issue_flags);
-		if (ret < 0)
-			return ret;
-		ret = blk_rq_map_user_iov(q, req, NULL, &iter, GFP_KERNEL);
-	} else {
+	if (iter)
+		ret = blk_rq_map_user_iov(q, req, NULL, iter, GFP_KERNEL);
+	else
 		ret = blk_rq_map_user_io(req, NULL, nvme_to_user_ptr(ubuffer),
 				bufflen, GFP_KERNEL, flags & NVME_IOCTL_VEC, 0,
 				0, rq_data_dir(req));
-	}
 
 	if (ret)
 		return ret;
 
 	bio = req->bio;
@@ -194,11 +181,11 @@ static int nvme_submit_user_cmd(struct request_queue *q,
 		return PTR_ERR(req);
 
 	req->timeout = timeout;
 	if (ubuffer && bufflen) {
 		ret = nvme_map_user_request(req, ubuffer, bufflen, meta_buffer,
-				meta_len, NULL, flags, 0);
+				meta_len, NULL, flags);
 		if (ret)
 			goto out_free_req;
 	}
 
 	bio = req->bio;
@@ -465,10 +452,12 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	struct nvme_uring_cmd_pdu *pdu = nvme_uring_cmd_pdu(ioucmd);
 	const struct nvme_uring_cmd *cmd = io_uring_sqe_cmd(ioucmd->sqe);
 	struct request_queue *q = ns ? ns->queue : ctrl->admin_q;
 	struct nvme_uring_data d;
 	struct nvme_command c;
+	struct iov_iter iter;
+	struct iov_iter *map_iter = NULL;
 	struct request *req;
 	blk_opf_t rq_flags = REQ_ALLOC_CACHE;
 	blk_mq_req_flags_t blk_flags = 0;
 	int ret;
 
@@ -500,10 +489,24 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	d.addr = READ_ONCE(cmd->addr);
 	d.data_len = READ_ONCE(cmd->data_len);
 	d.metadata_len = READ_ONCE(cmd->metadata_len);
 	d.timeout_ms = READ_ONCE(cmd->timeout_ms);
 
+	if (d.data_len && (ioucmd->flags & IORING_URING_CMD_FIXED)) {
+		/* fixedbufs is only for non-vectored io */
+		if (vec)
+			return -EINVAL;
+
+		ret = io_uring_cmd_import_fixed(d.addr, d.data_len,
+			nvme_is_write(&c) ? WRITE : READ, &iter, ioucmd,
+			issue_flags);
+		if (ret < 0)
+			return ret;
+
+		map_iter = &iter;
+	}
+
 	if (issue_flags & IO_URING_F_NONBLOCK) {
 		rq_flags |= REQ_NOWAIT;
 		blk_flags = BLK_MQ_REQ_NOWAIT;
 	}
 	if (issue_flags & IO_URING_F_IOPOLL)
@@ -513,13 +516,13 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	if (IS_ERR(req))
 		return PTR_ERR(req);
 	req->timeout = d.timeout_ms ? msecs_to_jiffies(d.timeout_ms) : 0;
 
 	if (d.data_len) {
-		ret = nvme_map_user_request(req, d.addr,
-			d.data_len, nvme_to_user_ptr(d.metadata),
-			d.metadata_len, ioucmd, vec, issue_flags);
+		ret = nvme_map_user_request(req, d.addr, d.data_len,
+			nvme_to_user_ptr(d.metadata), d.metadata_len,
+			map_iter, vec);
 		if (ret)
 			goto out_free_req;
 	}
 
 	/* to free bio on completion, as req->bio will be null at that time */
-- 
2.45.2


