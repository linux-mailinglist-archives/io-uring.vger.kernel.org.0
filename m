Return-Path: <io-uring+bounces-957-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AD10C87D050
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6676828289C
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2F6AF3D576;
	Fri, 15 Mar 2024 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GtdAT4Re"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A6513F9FB;
	Fri, 15 Mar 2024 15:31:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516679; cv=none; b=jEjH+0BenJpw3fOBvgKDnEMzGC4sL4HxwfP4AgM+7MHVsVk78KOknyj27HYTEfxWjooagE3Zd6cg6pI1n5o4QP6xAV/PRZzT4Vs1fgv+Y7Oc9L1S57446d5TnZIr+1eg6W6n8OWQfrAJf2pC3FI3qcsPoGNmY5scIlkGxhZhZdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516679; c=relaxed/simple;
	bh=cgqvBTb7ybCJdaMD4fjwY2yF0dr8IFrOj9E5bPJqda8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PoXj+ur2A1Tpm3jCeHxleOgsTXEwNaLzv4BTg29ZZClQz5HKyUnK943nTYWZHxxsgsz1y4ohKRVwMS/vtOuPWg7adZ0WIEiXYCUYyktWVj3JR+RhEA4Je07729nPGjofv8MzY6IFJ9ed2KYLmeffW4Q8ZervKRgK9gPszoAfsMM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GtdAT4Re; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-33ecbe78c3fso932548f8f.3;
        Fri, 15 Mar 2024 08:31:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516675; x=1711121475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vCYhmaYi+jcvj1JXX6M48ExoNcATA43GN1CGszIjmcE=;
        b=GtdAT4ReFlaILOu2czTwZNWaKMRXmBbb6gAO2sXxCPUlpd966W/fmhHHw+xMRabG3V
         JfGZGRbTrTwdKANf12JZ3V3/eiF3Qx6vRG5vZ26vHJOAnxfsiuBIVmm9NpPZ29pee/lH
         KZq1zeUkypaXM/rwQanvZhh93Nd0pII7AzCIrAXdxsxi3yca7So/WXKLAYMbsTIIrO5p
         VETI5R5VkegAhNrZfJigVH7ODFh5fTNZwl2htIdOhHNGS68o31o401LxXHSdtlKNVu8S
         b4zD5q+Eo+jaolfkCR5gQw8NbI8WyW5GsHeu8ANDFong/KlTUkFxXjuuKoQOHBk6Myh1
         BQnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516675; x=1711121475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vCYhmaYi+jcvj1JXX6M48ExoNcATA43GN1CGszIjmcE=;
        b=odUeoZifTY9vhezWKCpiDCeKSFSY5bafvHL/Z2R8rfUq5Hx1hCMVddXb1Eht0MvEDM
         TDXvMzdoqqFmNtV8BZ2YpaE8qN8A0OMbX7eNwpZMghcP+/IOgHJ9iKJEZBGFEupb1QJw
         iMCdqlQA83Kd9/GIKcuc+XqEfRsY8Q3PhxPMrLB7yjLlmg74rlt+UoLWL1qi9FGcRWG3
         Uqv8497+qMe4kmx+k82iGRXILKSYs8UXnfyf7VOmoZdbBfyDge4q/pxJJfSqLoYldkdn
         QVBpcqzrftntP6Lhm0RxtCJhc6YhLdqvMMUzH4pCIxq7ilTB5x11l+3gR7N7wDSZANtq
         O72w==
X-Gm-Message-State: AOJu0Yzro+WPMWAGi1fLNQpwDOMoDdSNE1BAJXEeWDqw+//FATO3quew
	n1NtfYx49m11gnM0SCLjKmDdS7ybMCjZy9LFDahEm4s8cB2Tjm1fTZiQe2U/
X-Google-Smtp-Source: AGHT+IHIvgy3lJFevAdRRoCyzphrATiOEMWCxY3BUCP4kdlBZy9QkawZBLa/prD5rMkXWJ3V4A7VVA==
X-Received: by 2002:a5d:51c3:0:b0:33e:7f65:bb7b with SMTP id n3-20020a5d51c3000000b0033e7f65bb7bmr3847356wrv.5.1710516675305;
        Fri, 15 Mar 2024 08:31:15 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:14 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 05/11] ublk: don't hard code IO_URING_F_UNLOCKED
Date: Fri, 15 Mar 2024 15:29:55 +0000
Message-ID: <2f7bc9fbc98b11412d10b8fd88e58e35614e3147.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uring_cmd implementations should not try to guess issue_flags, just use
a newly added io_uring_cmd_complete(). We're loosing an optimisation in
the cancellation path in ublk_uring_cmd_cancel_fn(), but the assumption
is that we don't care that much about it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 drivers/block/ublk_drv.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index bea3d5cf8a83..97dceecadab2 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -1417,8 +1417,7 @@ static bool ublk_abort_requests(struct ublk_device *ub, struct ublk_queue *ubq)
 	return true;
 }
 
-static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
-		unsigned int issue_flags)
+static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io)
 {
 	bool done;
 
@@ -1432,15 +1431,14 @@ static void ublk_cancel_cmd(struct ublk_queue *ubq, struct ublk_io *io,
 	spin_unlock(&ubq->cancel_lock);
 
 	if (!done)
-		io_uring_cmd_done(io->cmd, UBLK_IO_RES_ABORT, 0, issue_flags);
+		io_uring_cmd_complete(io->cmd, UBLK_IO_RES_ABORT, 0);
 }
 
 /*
  * The ublk char device won't be closed when calling cancel fn, so both
  * ublk device and queue are guaranteed to be live
  */
-static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
-		unsigned int issue_flags)
+static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd)
 {
 	struct ublk_uring_cmd_pdu *pdu = ublk_get_uring_cmd_pdu(cmd);
 	struct ublk_queue *ubq = pdu->ubq;
@@ -1464,7 +1462,7 @@ static void ublk_uring_cmd_cancel_fn(struct io_uring_cmd *cmd,
 
 	io = &ubq->ios[pdu->tag];
 	WARN_ON_ONCE(io->cmd != cmd);
-	ublk_cancel_cmd(ubq, io, issue_flags);
+	ublk_cancel_cmd(ubq, io);
 
 	if (need_schedule) {
 		if (ublk_can_use_recovery(ub))
@@ -1484,7 +1482,7 @@ static void ublk_cancel_queue(struct ublk_queue *ubq)
 	int i;
 
 	for (i = 0; i < ubq->q_depth; i++)
-		ublk_cancel_cmd(ubq, &ubq->ios[i], IO_URING_F_UNLOCKED);
+		ublk_cancel_cmd(ubq, &ubq->ios[i]);
 }
 
 /* Cancel all pending commands, must be called after del_gendisk() returns */
@@ -1777,7 +1775,7 @@ static int __ublk_ch_uring_cmd(struct io_uring_cmd *cmd,
 	return -EIOCBQUEUED;
 
  out:
-	io_uring_cmd_done(cmd, ret, 0, issue_flags);
+	io_uring_cmd_complete(cmd, ret, 0);
 	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
 			__func__, cmd_op, tag, ret, io->flags);
 	return -EIOCBQUEUED;
@@ -1842,7 +1840,7 @@ static void ublk_ch_uring_cmd_cb(struct io_uring_cmd *cmd,
 static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	if (unlikely(issue_flags & IO_URING_F_CANCEL)) {
-		ublk_uring_cmd_cancel_fn(cmd, issue_flags);
+		ublk_uring_cmd_cancel_fn(cmd);
 		return 0;
 	}
 
@@ -2930,7 +2928,7 @@ static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
 	if (ub)
 		ublk_put_device(ub);
  out:
-	io_uring_cmd_done(cmd, ret, 0, issue_flags);
+	io_uring_cmd_complete(cmd, ret, 0);
 	pr_devel("%s: cmd done ret %d cmd_op %x, dev id %d qid %d\n",
 			__func__, ret, cmd->cmd_op, header->dev_id, header->queue_id);
 	return -EIOCBQUEUED;
-- 
2.43.0


