Return-Path: <io-uring+bounces-6866-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D8E98A4A68E
	for <lists+io-uring@lfdr.de>; Sat,  1 Mar 2025 00:14:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 336487A5BDA
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2025 23:13:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C6D11DF270;
	Fri, 28 Feb 2025 23:14:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ClO6Qt1+"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f99.google.com (mail-oa1-f99.google.com [209.85.160.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCAD923F370
	for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 23:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740784478; cv=none; b=uQRTslLr06rrV+tlwMZWs8z29GrT7dQa4xok4rXyD3Y6tmuenwu8mqXe5bEsS+0gi2JJuYB4D1iUNroj9JkYihz9JU/zDzaE8oWcxi5hqvxTFV7Z4LaxyHUyI1X0zN5zDELRtSDHmxTYMidvVIDqrVcSfs5prTzgo/fPGNonZjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740784478; c=relaxed/simple;
	bh=sXf5/A1zFytM8lFmj2gEeV5EMeYDWOAN3JXS2CuB0z0=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=gsK08v26xG4NJ9p78LSuIKoiMuIE4nvFSx6iyY2/3fqFFewVs+iTvB959pdTGvKFWQ0MYdZFggf2Q8wOYfrYwP8HvOnX0njv5ZQ2VFvzWaAEtpMU31aV9OPvmSecVV4vJSVdzSbKK/FPU6yIPw4Qz4/hcVC+icjjC7sxRCz4OTY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ClO6Qt1+; arc=none smtp.client-ip=209.85.160.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oa1-f99.google.com with SMTP id 586e51a60fabf-2a890f85cb1so113075fac.1
        for <io-uring@vger.kernel.org>; Fri, 28 Feb 2025 15:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1740784475; x=1741389275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=td3QLI6VMDUiQOrb4BUroNuidyjitBQIjpVlt7JOrWo=;
        b=ClO6Qt1+RSnuk4+Sh77B2GRSKqwrpoxIB8lU93xNfEioWZ5F7VpXnqSOA1RnwLK5x8
         JlWypEp/n5tX4nhY74Khnv2DxyBH1DmgIiY6aPDXSvwJBqHk3muIvTy32NgfqNfBk7tQ
         rDnf6RpgI63X3ZHy4m/AGDBXRXq10e+vxtVD5zk8olEHbzw344TyNLQsokqvWgZPTioK
         ISuFymSEMelPwuM5SkAVNBgkJl8NaBjN7eWvXb6etFi+okXdSqQMsYtRxK+NFp1TVvfb
         j1kNMlgh+sFOXOs61oAbhCkxXy+fiuD7ATt1vy9Z0G0ZL1xqz+dYopPJAAl5CzPqaw0o
         MAzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740784475; x=1741389275;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=td3QLI6VMDUiQOrb4BUroNuidyjitBQIjpVlt7JOrWo=;
        b=nYUE5mbJbLTzz+tVfyXAZij/ZfPOJByeJfBGWagsOfF0xKNSfqgRqCl6wiff+Ncx0I
         P9K8fqzBjTnsPRVN25VaWqteSOjwYUUxSdd0EQ7dI9hiil3sB6yAfJBXZc8n/Q5+hOTP
         LW1Iqi0IORwNM1Z7Geme+x+EYV5s9yGoGl5aTxX8TRSqKwAhIUhmt1IGwV2DqEUwe7K0
         v2yNdBmWvZJStWPPuXYkJiLSBn1BxxNYzp9hAL2GE9NMfmNQ68xRzkb+LxvAuLsoqKXU
         IvCtt01pXgNoCrCJS120fuwHShqAuRAKycksk3lPpRKl3P9Y1ZP0tVDEPyOqatJD83i4
         BwHw==
X-Forwarded-Encrypted: i=1; AJvYcCUHvYSeH3N5O08/WhFjIOGuHf2X+vNh3UN7Tx7pDJdAU5nyGL+rmz9RblUw1HnjlzilSV8KRBIZUQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YwD0Iy3NZUVsluFV99TL54TUkc6k/KqdslAaej+wuuA1HnD38VV
	vBoJ0oCKKPd53AmCe9gCf1FmRLrkPDWjGrNQcrgpV5RooLV1w/utZ8OovZuIf3g2lAvkkuuHOfj
	vN7pk51wH4OtyHsURhcbYZr7U3b/VmDFKydYgO9hM91Kt3HQf
X-Gm-Gg: ASbGncuHr2jDd9Z94aVtR/Snj7i4BD1Emmm4DGU4V5aOWvDGVwUTpoh0gLuAguBBuf5
	uZysCnErtnV5e5Av7AxlTCOWxLRbdmykbnjkflrFr9uGKm9B6RmAIH2x+BXtoI9ChIVeSY5c4Q6
	NfaoTMtWSgmrtS8FB4kdxtCjx519lXwOhAAEInsINMICyRYj4KPDfYAhOhqKM2Wh3XmeC499zjU
	u+NvchdteLI5wJvcM9rqLq7+eY9RaAidXgcTEurFfHuZKHZ05SRSCG3UXSsC9ftIDFnzia4mWFY
	8aaDFEnRIg9Czmuh79NqEeGQLKz3TAGV6A==
X-Google-Smtp-Source: AGHT+IE1+WxOcP+PFDf9gVT8bBwaZ8BjfRRqOWZNPk/1wluXto7KDqsniux9pWhX0MxzxMrxHOiWccWukV59
X-Received: by 2002:a05:6871:3804:b0:297:270f:d79d with SMTP id 586e51a60fabf-2c1786717b0mr1131713fac.8.1740784474779;
        Fri, 28 Feb 2025 15:14:34 -0800 (PST)
Received: from c7-smtp-2023.dev.purestorage.com ([2620:125:9017:12:36:3:5:0])
        by smtp-relay.gmail.com with ESMTPS id 586e51a60fabf-2c15c4d775fsm235764fac.34.2025.02.28.15.14.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 Feb 2025 15:14:34 -0800 (PST)
X-Relaying-Domain: purestorage.com
Received: from dev-csander.dev.purestorage.com (dev-csander.dev.purestorage.com [10.7.70.37])
	by c7-smtp-2023.dev.purestorage.com (Postfix) with ESMTP id A9BF934028F;
	Fri, 28 Feb 2025 16:14:33 -0700 (MST)
Received: by dev-csander.dev.purestorage.com (Postfix, from userid 1557716354)
	id 9E713E419D4; Fri, 28 Feb 2025 16:14:33 -0700 (MST)
From: Caleb Sander Mateos <csander@purestorage.com>
To: Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH] io_uring/ublk: report error when unregister operation fails
Date: Fri, 28 Feb 2025 16:14:31 -0700
Message-ID: <20250228231432.642417-1-csander@purestorage.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Indicate to userspace applications if a UBLK_IO_UNREGISTER_IO_BUF
command specifies an invalid buffer index by returning an error code.
Return -EINVAL if no buffer is registered with the given index, and
-EBUSY if the registered buffer is not a kernel bvec.

Signed-off-by: Caleb Sander Mateos <csander@purestorage.com>
---
 drivers/block/ublk_drv.c     |  3 +--
 include/linux/io_uring/cmd.h |  4 ++--
 io_uring/rsrc.c              | 18 ++++++++++++++----
 3 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index b5cf92baaf0f..512cbd456817 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1785,12 +1785,11 @@ static int ublk_register_io_buf(struct io_uring_cmd *cmd,
 
 static int ublk_unregister_io_buf(struct io_uring_cmd *cmd,
 				  const struct ublksrv_io_cmd *ub_cmd,
 				  unsigned int issue_flags)
 {
-	io_buffer_unregister_bvec(cmd, ub_cmd->addr, issue_flags);
-	return 0;
+	return io_buffer_unregister_bvec(cmd, ub_cmd->addr, issue_flags);
 }
 
 static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 			       unsigned int issue_flags,
 			       const struct ublksrv_io_cmd *ub_cmd)
diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index cf8d80d84734..05d7b6145731 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -127,9 +127,9 @@ static inline struct io_uring_cmd_data *io_uring_cmd_get_async_data(struct io_ur
 }
 
 int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 			    void (*release)(void *), unsigned int index,
 			    unsigned int issue_flags);
-void io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
-			       unsigned int issue_flags);
+int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
+			      unsigned int issue_flags);
 
 #endif /* _LINUX_IO_URING_CMD_H */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 45bfb37bca1e..29c0c31092eb 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -975,30 +975,40 @@ int io_buffer_register_bvec(struct io_uring_cmd *cmd, struct request *rq,
 	io_ring_submit_unlock(ctx, issue_flags);
 	return ret;
 }
 EXPORT_SYMBOL_GPL(io_buffer_register_bvec);
 
-void io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
-			       unsigned int issue_flags)
+int io_buffer_unregister_bvec(struct io_uring_cmd *cmd, unsigned int index,
+			      unsigned int issue_flags)
 {
 	struct io_ring_ctx *ctx = cmd_to_io_kiocb(cmd)->ctx;
 	struct io_rsrc_data *data = &ctx->buf_table;
 	struct io_rsrc_node *node;
+	int ret = 0;
 
 	io_ring_submit_lock(ctx, issue_flags);
-	if (index >= data->nr)
+	if (index >= data->nr) {
+		ret = -EINVAL;
 		goto unlock;
+	}
 	index = array_index_nospec(index, data->nr);
 
 	node = data->nodes[index];
-	if (!node || !node->buf->is_kbuf)
+	if (!node) {
+		ret = -EINVAL;
 		goto unlock;
+	}
+	if (!node->buf->is_kbuf) {
+		ret = -EBUSY;
+		goto unlock;
+	}
 
 	io_put_rsrc_node(ctx, node);
 	data->nodes[index] = NULL;
 unlock:
 	io_ring_submit_unlock(ctx, issue_flags);
+	return ret;
 }
 EXPORT_SYMBOL_GPL(io_buffer_unregister_bvec);
 
 static int io_import_fixed(int ddir, struct iov_iter *iter,
 			   struct io_mapped_ubuf *imu,
-- 
2.45.2


