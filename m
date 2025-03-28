Return-Path: <io-uring+bounces-7276-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 45807A74E09
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 16:47:56 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 241E11893E5B
	for <lists+io-uring@lfdr.de>; Fri, 28 Mar 2025 15:48:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8B5A91D54F4;
	Fri, 28 Mar 2025 15:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="YbDvoBPv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f97.google.com (mail-io1-f97.google.com [209.85.166.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A85A31C4A2D
	for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 15:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743176871; cv=none; b=mqZkPymMbyZLtxjtb9EBjn87Fzy3pozZlW9drYa8VaeXco3+gQ9YuaY3yxnQ/pp16xxFwIEcpg4vYzbmeUm4SY9Vgy//ZUzXe3yjngq9HaYqxQzRNMfXsE4ElmEqggm1yAMwx8w9e6z+O7FEoBpx+LvWFGn1hlx2NerXvQ2iU7U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743176871; c=relaxed/simple;
	bh=yYtWoyv8WbfgloYoO/rNNRvz+4dqKS+a7SoTZFAZSuE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AI+M7UgFN7EfnBpb36K9TdANp9rngLO5teAVd0vNbFedDXxa2OyUk2Ky3H1fensGKWpOSx+yQjnJWNNS1HiCbs97g2oeabncLhiDWmbAV8GDoPwUAbGbYB9PpCHZvobg4wBJGJVJfOTTicDx2VGKdL7zE+CFbNVhi0xAlBgQQFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=YbDvoBPv; arc=none smtp.client-ip=209.85.166.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-io1-f97.google.com with SMTP id ca18e2360f4ac-85da20b2640so9458939f.1
        for <io-uring@vger.kernel.org>; Fri, 28 Mar 2025 08:47:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1743176869; x=1743781669; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rvZNgJEOLv7vlUnMHFowwsJc7mv9fgxFUo+rGJDtCw4=;
        b=YbDvoBPvwxVGErSHBFK5ec+eZhMjiXZ78OEA0dZxg8V0BG2b0aO33aQtZKPoFtdd0X
         BDDzwLHFwNTXf81d8YoWWc3ket/6YjAtBbcdENnszTXsgkxXyIUUN3Q6zoikOERZa1q8
         OD2ljfPZVYKQbMk62u4qR+D7HC4BGEAzkLE0X0o/Tzdf/61/2FoQCoAsihByF7hfzGxb
         l9nd8QyRMs93rySULY2c75GXJ/Da15HrFuRqev84Cq14Dn018fXQCDlWLyDbuyVFiZnf
         cpDm3S8reN8qXAl0f1HLoFp0KcprJ5OcsjPqdpJvPKLcrN8qv4P4wuuXe5DO4eG5ry9L
         fzuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743176869; x=1743781669;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rvZNgJEOLv7vlUnMHFowwsJc7mv9fgxFUo+rGJDtCw4=;
        b=ElSrL6uxpscJFp+nJ/aQp6Hhewcu0urR8PCakmsNfffx3W1o/h0Pyj/6jwul/pbOaL
         1GXnOOWMugkJN9gEu8BlJeGL/wOlh+TXixs+d1mGxxFrZf4r4Eg735ToCxTTThdhlkv+
         zAeBGXd/MKCrEf9zz37CGmoAWnStZ/UGW7AQnuaxyi+VBnMk6boPFxB9m1ktVzO/FN/E
         c4zTuwj6teimo4R0ge4m7BGlrBg0UzD0ITW/8OLZqrd46SZP5smeVfn8WBJOdvOPunaz
         VqbbNfUIuGt068JdgssWXUrvwDLYXVOG1oRVXLCv/9l4GqgNO2ePAi8vYl5qnAU/ek7s
         y/DA==
X-Forwarded-Encrypted: i=1; AJvYcCWaaJGs2b9nCNcDah6goO2q0xN3KYKbtwhW8bmn0StGq7Pn7yDzeYjexJrj4GIBeiZvnhF/wS60vg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzNPe/mdFAbNazzwLq8hs/mpAObUzcSjRQjGPbYMuw/PGtzS6Gi
	/pdDteVYE77nMOuZuMf+PGuSvYECMHe/Xfj2p77rYvjvkT5rosWosM52qrl23Z1TetLgCpmyjvj
	gDBKS9r89IaJBzR+7QwaukpZCE128dx7/
X-Gm-Gg: ASbGncvU57jlFvamZMc+Zv9D6EmYhOlTeqFgDJ4XuuLZRcSEjkme288VJWVo67iAc/Q
	6C8ywpbjA8IFzghBU0PljmQcDaUOCe4nSxjurc97uGhjvWb+YIGutDY/j4QqibbZpGDlSZ9jAGd
	K6NOeffTkBa1aKFjdebsR6d2zX4bsVpYI22o0RSxzVBevJeJClVkzo1RE0WL035V1SDoLH5q9/o
	AHDaERZ/x82ZP1P6OHgLp9X8tWD6UesBta6GJg228O3afx+wdLxNfpkRDPh17SLI4CT3s7Le4F8
	RwbYdQH31N6LMM+rjGuRL2vjt40zHz0PhT8vvuZh6OJ3Nb8Y
X-Google-Smtp-Source: AGHT+IHZyp/hTQTgBPdjdI/PAGSVR+TwdInUQ4bs/fMWlLnjp1ni0mf8CfgyGlPr5zMbfOYKigzJ9+sGNsfR
X-Received: by 2002:a05:6602:1691:b0:855:d60d:1104 with SMTP id ca18e2360f4ac-85e83cee041mr242544339f.2.1743176868650;
        Fri, 28 Mar 2025 08:47:48 -0700 (PDT)
Received: from c7-smtp-2023.dev.purestorage.com ([208.88.159.128])
        by smtp-relay.gmail.com with ESMTPS id ca18e2360f4ac-85e900121a8sm23348939f.11.2025.03.28.08.47.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Mar 2025 08:47:48 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id 9515D34018F;
	Fri, 28 Mar 2025 09:47:47 -0600 (MDT)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 912C3E40A9F; Fri, 28 Mar 2025 09:47:17 -0600 (MDT)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Keith Busch <kbusch@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Chaitanya Kulkarni <kch@nvidia.com>,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>
Subject: [PATCH v4 3/3] nvme/ioctl: move fixed buffer lookup to nvme_uring_cmd_io()
Date: Fri, 28 Mar 2025 09:46:47 -0600
Message-ID: <20250328154647.2590171-4-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20250328154647.2590171-1-csander@purestorage.com>
References: <20250328154647.2590171-1-csander@purestorage.com>
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
Reviewed-by: Jens Axboe <axboe@kernel.dk>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
---
 drivers/nvme/host/ioctl.c | 45 +++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 21 deletions(-)

diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index 42dfd29ed39e..400c3df0e58f 100644
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
@@ -467,10 +454,12 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
 
@@ -502,10 +491,24 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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
@@ -515,13 +518,13 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
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


