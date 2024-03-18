Return-Path: <io-uring+bounces-1067-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5327487E150
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 01:44:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0909B282FBC
	for <lists+io-uring@lfdr.de>; Mon, 18 Mar 2024 00:44:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E271E880;
	Mon, 18 Mar 2024 00:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XhonV++Z"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lj1-f176.google.com (mail-lj1-f176.google.com [209.85.208.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C451E53A;
	Mon, 18 Mar 2024 00:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710722626; cv=none; b=quqO78mJOKvFqfmI2yGJbIee9W89zi7tTeOiqR661VQ3FGOMUr5rWeFG9VjQqcVraP9YgvVFiwZU/TWlWW0nmH8gIpO+jVY2dtiQNp+reLUKm5yjtM+uh4wsdD+RVez9FNzAUwUIYimI4L49IvSmzVFA39pwXopOpzI/uTMr5/U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710722626; c=relaxed/simple;
	bh=2YNAhpdedsrTS00Mv1/nJs8615L2dx3VtYzU37e96po=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K5M3Szc9Ss1DSS1oHuW5sVmOIjnA0/ZYoXqhhGgFS9/FSBkO4Jds+ik/4Adi383PAtY3oZAqERt8/Ptf5YRLxpuN8VY9iTQ35nHLTP/7+3gKXhrnd25xczjf/muo0Q8vrMSQQoJE84HrGAuKHbDm034LslQZ3f+Th/KMpnG3sTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XhonV++Z; arc=none smtp.client-ip=209.85.208.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f176.google.com with SMTP id 38308e7fff4ca-2d29aad15a5so46489631fa.3;
        Sun, 17 Mar 2024 17:43:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710722622; x=1711327422; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZxmPTulNs2Gq+0rppneuvhvFDS8ypZJZX543PVINW9c=;
        b=XhonV++ZhgTn/ygtIcq2YVo1+zv1ID+Q5i/Vvl1MesNuJZXaVqCqWZ+RDeX/o8/y2o
         +6qpRtHj03qvhat7uyyMVo45orJihr4HbNzrYDJW+asqDs7HEH/f1IpxNDiMxwz5vjkL
         C1WQy2bCxQ9QJpi/yjtR+HFBHkh4Z6MWo1a9NK9kAVW19ESdE/Z2A5sLnS8v2dSguSiR
         MzyJRSBAmExwAPQKtyi2eoq7cZyCn/VX0VYjrtrpIykVqCEkZ8OnyVuh/VIbhR/7A0nb
         g3eqYpgjireJFl8Wp9KEfpazKuPLh7H2HIwopLb9WJnJrVwtaoAGmvTCPXyR6Yp1d1Es
         GoDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710722622; x=1711327422;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZxmPTulNs2Gq+0rppneuvhvFDS8ypZJZX543PVINW9c=;
        b=pOyw6KOPH/G0uy2nWpLKewU02AIw2DLxIItS3zbLn7plEfJR3gDWX0NLFZljqbx++E
         eztv0NYW3+JyM7f00TuIWJI1eL87fCGQ5BClCgPck7l1Zcuhszptspujpne+Pmbi57Y6
         s74OprO+96UwaRwNPheyUtI6kZHT8gWWCudwcPLGYpCaACCnb77CC5AltnziHworbGN5
         iiTY+yh2MyUD48D1skrdEiqjix3vb80N4DZi07OOOhbal7XL5hfsE/V17rcbpUDbLBfa
         jucBzOIuZ6Lnli05Hlrs0V+TQwVVlftZMLiQZ6Mx+Y0HDMQFA9mtz6GfEuBen+mT3I9k
         PRZQ==
X-Gm-Message-State: AOJu0YyEVmtVHqfO9akLukaaqvWgeO8Ch0a+9oYfF+D8tlNGFO47fcz5
	dXRLs2Zh5F1KIPuR2FssuG2Tm3oqYkaDMKu+VLgaWTBLiSkM8cgnwG3ggcAG
X-Google-Smtp-Source: AGHT+IFuo2sTulBUQJ39TA92S8vpjPrTmR57rDtiouFuE9yKzW+XpT/vJMmnLBmFwhw1GyTi6zudkQ==
X-Received: by 2002:a2e:7a02:0:b0:2d2:d3de:44fd with SMTP id v2-20020a2e7a02000000b002d2d3de44fdmr4959213ljc.29.1710722622565;
        Sun, 17 Mar 2024 17:43:42 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.255.232.181])
        by smtp.gmail.com with ESMTPSA id p13-20020a05640243cd00b00568d55c1bbasm888465edc.73.2024.03.17.17.43.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 Mar 2024 17:43:41 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH v2 05/14] ublk: don't hard code IO_URING_F_UNLOCKED
Date: Mon, 18 Mar 2024 00:41:50 +0000
Message-ID: <a3928d3de14d2569efc2edd7fb654a4795ae7f86.1710720150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <cover.1710720150.git.asml.silence@gmail.com>
References: <cover.1710720150.git.asml.silence@gmail.com>
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
Link: https://lore.kernel.org/r/2f7bc9fbc98b11412d10b8fd88e58e35614e3147.1710514702.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
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
2.44.0


