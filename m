Return-Path: <io-uring+bounces-8231-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F269AACF47B
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 18:37:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2E24E17279F
	for <lists+io-uring@lfdr.de>; Thu,  5 Jun 2025 16:37:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4973923F299;
	Thu,  5 Jun 2025 16:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="rm9MUG+0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 434BB1F09AD
	for <io-uring@vger.kernel.org>; Thu,  5 Jun 2025 16:36:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749141397; cv=none; b=Tyyf8tRseYT1+35Fo1lmZNcR96QMqzbrpv+xxhyVxR9QYQ13ZbJfC2M3AuJh/IRi/ZR4PQ8XT9MmPQnsoZZLUVr1m5upSn6RtV9ANlpWKsxm3X62kMgHwTFNwMCt+FyVOQxtDAU9NbiNj1OyUnbezGvnj7dSIBXGsyRD9mcsvc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749141397; c=relaxed/simple;
	bh=zpKXgjtr7q3abW4OPYVHB5vNQzxVD9s6emlqXVVPUbE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODhIqHtJaOBbjLz4azlFHK7FU3llGNzZogws+RTBEKuJAOuOlQ/pIVBhGIjphZb3jBGSnuZeWYX6b+6ON8a7fmFrdx7JUn3XOmMrzkZhSYpwqCVXRZjKeP868TIyiJDjlMbTyk5XU9kMVNn+nCLxYUua3DQnJggmnLn3+2USNuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=rm9MUG+0; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3dd87b83302so5424075ab.0
        for <io-uring@vger.kernel.org>; Thu, 05 Jun 2025 09:36:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749141393; x=1749746193; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WW9SwXsFydnZRuaW58ZLFW+RBMsJFSmz9cC6PDleFlk=;
        b=rm9MUG+0l/LqZGwiYBGhdIB9MKf0DeM1Fdm738M6yKiuvvYoTNryBPU7nFYA5AhUU8
         W/MppmkHDbW61MvxS4WvEjS+pZnfY8pi9IO9QqOBvD7/xHNTNWxhnBAjFQxbqnuMVr8h
         MIsq0w5tKecg1TOQQUBzM0ji6HTFzU3Onow8PWALwFCHeOpmiseeEU79zvBS10bDdLfG
         BMcuN4APNUbnpxwzu3uLv2bklz0LWqWi6uOvwyAS6lc1Nl3lOu4pj2+kT+Y4C9v/upJW
         jmgsuxH6RIga/VZIKTe0o42FGE7pXI9jtJE/DNYHK9Qv8ZtFIefdH7VcV3TWvUKbEDpl
         BBaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749141393; x=1749746193;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WW9SwXsFydnZRuaW58ZLFW+RBMsJFSmz9cC6PDleFlk=;
        b=XF6ZMI42hWN9dw6FoL54aOcYLqnvnkLc8uF2nUqMn9kkHN3Tp0gYae/UeJebXzXia0
         lSTBNVKV4i7kQrIjvb6TAR5lWsOTl22fLQbC8VBP90PeXenqHBbqbPkdQofrd9TAJK8Q
         A/oybmrpNonzBWyszMOnB/aEpm4mZIeCLLBLv4EPj2iOtsocuNcrDhp5HLqD07b1MgVF
         3Titl0cKg4IKDRW59YLvl3pZCPPd4Pga4HCAuGe0KhulPAZPIhKy1P5Sv9p2w5aIkjgt
         Qe62KQmBu/NAhHwO4VzBCb8mIMUpPU6lLoTh1XXdws1loV7aFjEioFkyMype1ddb4CE4
         0yFA==
X-Gm-Message-State: AOJu0Yw3yZqra69KNxUyYm6fB8grYgjnkZK8c9lif853MQODlxY67zj/
	mWrhStloJk2AdTfEbj1Dro8UhFD1eDOKJKW+OJ+T2QXyb/i4/HgLyODcClTrHahnPjrWW0E+8c2
	amyjN
X-Gm-Gg: ASbGnctOLtXh9pjdOJKI6PKI6L+ylQlhluIPrcAsUEotYV7UeSDcn4gOOHkU6x5RVRl
	480ftn1+p8jAZ3eG647DLzJTMp9Yu9ssQoRg084Y5oEz9hrWeGbnMStrl/ctx+3kytYnS7vMWKw
	crYRg6y+MYV92lMUyEqfjpwrMcaQc6M8VVbIuD5i14yjkrrbx74WrEqiwXwZonNTauH7gmeeNnN
	k7Y6O8HPjgZJel4bOYcyRBSfJVFzEXrPAXqj00Bi9i5quHvuerLwpbMDnZ9+Xq7k/Gaf8DBBqBZ
	XRB7sYy6NIGiB6l4BEhndpFB2o/Tk15PwoBihx8T4Af6/Wwbk/2mDaa6Ir0LDBcusg==
X-Google-Smtp-Source: AGHT+IGPoDVG170lcY2e0T/2ATNtWPgi3acSxLh4Qsex+fsIO2FSdWs3cl0q5z1M1dV+nziBsLYHIA==
X-Received: by 2002:a05:6e02:378c:b0:3db:86fc:d328 with SMTP id e9e14a558f8ab-3ddce40afabmr410765ab.5.1749141393583;
        Thu, 05 Jun 2025 09:36:33 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddbee31f15sm10849085ab.62.2025.06.05.09.36.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jun 2025 09:36:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/3] io_uring/uring_cmd: copy SQE only when needed
Date: Thu,  5 Jun 2025 10:30:12 -0600
Message-ID: <20250605163626.97871-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250605163626.97871-1-axboe@kernel.dk>
References: <20250605163626.97871-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If the request is flagged with REQ_F_FORCE_ASYNC or REQ_F_ASYNC_PREP,
then there's a chance that it will get issued out-of-line. For that case,
the SQE must be copied.

Add an SQE copy helper, and use it on the prep side if the request is
flagged as such, and from the main issue path if we get -EAGAIN when
attempting to issue the request.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/uring_cmd.c | 50 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 39 insertions(+), 11 deletions(-)

diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e204f4941d72..76c6b91d249f 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -181,6 +181,17 @@ void io_uring_cmd_done(struct io_uring_cmd *ioucmd, ssize_t ret, u64 res2,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_done);
 
+static void io_uring_cmd_sqe_copy(struct io_kiocb *req)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct io_async_cmd *ac = req->async_data;
+
+	if (ioucmd->sqe != ac->sqes) {
+		memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
+		ioucmd->sqe = ac->sqes;
+	}
+}
+
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -205,19 +216,29 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!ac)
 		return -ENOMEM;
 	ac->data.op_data = NULL;
+	ioucmd->sqe = sqe;
 
-	/*
-	 * Unconditionally cache the SQE for now - this is only needed for
-	 * requests that go async, but prep handlers must ensure that any
-	 * sqe data is stable beyond prep. Since uring_cmd is special in
-	 * that it doesn't read in per-op data, play it safe and ensure that
-	 * any SQE data is stable beyond prep. This can later get relaxed.
-	 */
-	memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
-	ioucmd->sqe = ac->sqes;
+	if (io_req_will_async_issue(req))
+		io_uring_cmd_sqe_copy(req);
 	return 0;
 }
 
+/*
+ * Basic SQE validity check - should never trigger, can be removed later on
+ */
+static bool io_uring_cmd_sqe_verify(struct io_kiocb *req,
+				    struct io_uring_cmd *ioucmd,
+				    unsigned int issue_flags)
+{
+	struct io_async_cmd *ac = req->async_data;
+
+	if (ioucmd->sqe == ac->sqes)
+		return true;
+	if (WARN_ON_ONCE(issue_flags & (IO_URING_F_IOWQ | IO_URING_F_UNLOCKED)))
+		return false;
+	return true;
+}
+
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
@@ -232,6 +253,9 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret)
 		return ret;
 
+	if (unlikely(!io_uring_cmd_sqe_verify(req, ioucmd, issue_flags)))
+		return -EFAULT;
+
 	if (ctx->flags & IORING_SETUP_SQE128)
 		issue_flags |= IO_URING_F_SQE128;
 	if (ctx->flags & IORING_SETUP_CQE32)
@@ -251,8 +275,12 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	ret = file->f_op->uring_cmd(ioucmd, issue_flags);
-	if (ret == -EAGAIN || ret == -EIOCBQUEUED)
-		return ret;
+	if (ret == -EAGAIN) {
+		io_uring_cmd_sqe_copy(req);
+		return -EAGAIN;
+	} else if (ret == -EIOCBQUEUED) {
+		return -EIOCBQUEUED;
+	}
 	if (ret < 0)
 		req_set_fail(req);
 	io_req_uring_cleanup(req, issue_flags);
-- 
2.49.0


