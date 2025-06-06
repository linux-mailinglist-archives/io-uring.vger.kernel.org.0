Return-Path: <io-uring+bounces-8273-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AB4B6AD09CB
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 23:56:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3F94D7A2230
	for <lists+io-uring@lfdr.de>; Fri,  6 Jun 2025 21:55:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 58E60238C34;
	Fri,  6 Jun 2025 21:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="OvTuSxi7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f179.google.com (mail-il1-f179.google.com [209.85.166.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1C5823959D
	for <io-uring@vger.kernel.org>; Fri,  6 Jun 2025 21:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749247004; cv=none; b=Djc+XPruZi7pkeISMhSHs16DMdKBj0tX6MCA8E+9CKvAwN2cGwVo3SqseqH6cANt/O5Jca8RDvyOqYzThwOGlVOdTbnSFZw1vu6ocyNVLWJNfF8hQ0sPVD/zm2eqBCFBfd4LKRqdCBQR4IqkCqeg3grUfOgEMAOU1/m1uZ+Vn68=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749247004; c=relaxed/simple;
	bh=AIt9116TS1xkEk9yi9xQTpeP2dBuMXf6Nb9Wu1BHh/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oVwvA8TV1znsUvKWFhKsUO0RMuXn3RFW2YbP9vEPsDHyHeAyfbjtmi3Cw4IBNHnx4b6PP9biRtFl+vzpmEJwU7B/x7x/B0vaABp18eEZEE8H0J/49UxNfxieIIMGtbk4JmZggVw8ySTghEQv/rzIBVgUv8BLvRwWO75MpOwaT50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=OvTuSxi7; arc=none smtp.client-ip=209.85.166.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f179.google.com with SMTP id e9e14a558f8ab-3ddc9872e69so6996205ab.1
        for <io-uring@vger.kernel.org>; Fri, 06 Jun 2025 14:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749247001; x=1749851801; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qdf+RCmR7TmBmkUL0FjrvbMziiYbzmr5OnLjJPmVBzo=;
        b=OvTuSxi7K2l5H3CS6577R3dh8oiB2B1iJz/e0UuHBxabc4m3qgf7Wn/MCQfty98Nil
         OWtAOwacQZGLjsCJ3sN0phDW/XT9EZ4EmPex08vtpdexHLn59WtCcNrqvPL+NCf8FjTc
         /W35QqoRZ2oaMfQtqKm1w+vSMFbNE7FY8s4fevCg/MJm5a2xZVzdJWRtS+ltPnI1El5/
         mgoB90khNQ7NeCZYKk+L/BUDxs+PKt69Fgjw4VaMOMlRzJ2beQBokI/IE4YomM0z/IxN
         BX3zNt4i1gM/x1uyKMoKBjR+9VAzSOkM4LHzB03UpTG+kBFsE4WH2cFX9W/V9zpbesjZ
         XGBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749247001; x=1749851801;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qdf+RCmR7TmBmkUL0FjrvbMziiYbzmr5OnLjJPmVBzo=;
        b=mMQu8ICAR3NaBeZB9u81j2FKFIYykfoBQhe1SB5H3jG8eUKGytyruOxzmiPp7+tTnB
         4qK16M/gJSbCKAs5T2NJHeKHXD4b4IuCZIPh3ohPtO4g/+XtIuxRx5e0MtShh4aZNY/4
         9cdyn8uKkEfub9cpWfWYCtantQjE7ZWo9LbFPKmRd4xHJhDpdSqB8FjewKmLzRRQGYDz
         uIndNM3Et/G2Asm6J5zoD/RiOr/iwJXnQzfjCSPQyTGk3vfiI/F06giqnppam3j3+ciD
         vU9joq6pZNdLTHJT9kQo8gsq9da+JyaAzcH9BNcUALkr/XDo0cMMg2O7Ox5sa1BoWr8L
         ggOg==
X-Gm-Message-State: AOJu0YyjjJ1IpXIW1ow3tlKKTJE/5W6gTPSsVuyUNDEP/XWkN1NK3w/W
	hUFYiCWEUibiBP2PsumYf0XAolQkBjeUNqYJt1BeY7fXGG8Ayya+pWsShJr7ybwTLMeNdO3q1Lu
	0JLXN
X-Gm-Gg: ASbGncuOA1WtQbPBUJmmj0uJGACjEiqFExvNQ7hwKA0533iyMxx6AbY+L+UBMXberSC
	qZ7lAOizU0K8GsJ//esGn0uaXnJ8IBA+NM2KoBYkVt/vTt7OKlpSf3epPB4AJOBUvOkvFRDjSmx
	5rsaDISElnXksV0BNBbUZy57W0XrBsAexoyqvyxUB1L31esLf+t001UyhYehtl22znFdSi1IdZF
	AXorgLPKTI9z7n7Cpo/lZKr/tlMqAc6QUy7OtjEtP57DgjyPiRxxZaBYadGj5MKLskspyaPMiJO
	kcYjmfoilxV0NAevSjU5QfopCewNLSeHJzZEneZyADCA1HkGO0z1vOOQH1k9oEkM6cc=
X-Google-Smtp-Source: AGHT+IGU1+kT3vcDBwmDRIZskZ2q5JNJyVkRfPIiHrIZYt9ECLTU77Au1Orpcyamyon0yOwep+26yw==
X-Received: by 2002:a92:ca07:0:b0:3dc:76ad:7990 with SMTP id e9e14a558f8ab-3ddce495dfbmr59854605ab.15.1749247001540;
        Fri, 06 Jun 2025 14:56:41 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddcf1585bfsm5735105ab.30.2025.06.06.14.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Jun 2025 14:56:40 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: csander@purestorage.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] io_uring/uring_cmd: implement ->sqe_copy() to avoid unnecessary copies
Date: Fri,  6 Jun 2025 15:54:29 -0600
Message-ID: <20250606215633.322075-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250606215633.322075-1-axboe@kernel.dk>
References: <20250606215633.322075-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

uring_cmd currently copies the full SQE at prep time, just in case it
needs it to be stable. However, for inline completions or requests that
get queued up on the device side, there's no need to ever copy the SQE.
This is particularly important, as various use cases of uring_cmd will
be using 128b sized SQEs.

Opt in to using ->sqe_copy() to let the core of io_uring decide when to
copy SQEs, rather than to it upfront unconditionally.

This provides two checks to see if ioucmd->sqe is still valid:

1) IO_URING_F_INLINE must be set, indicating the ->sqe_copy() call is
   happening inline from the syscal submitting the IO. As long as we're
   in that context, the SQE cannot have been reused.

2) If the SQE being passed in is NULL, then we're off the task_work
   submission path. This check could be combined with IO_URING_F_INLINE,
   but it'd require an additional branch-and-check in SQE queueing.

If either of these aren't true and the SQE hasn't been copied already,
then fail the request with -EFAULT and trigger a WARN_ON_ONCE() to
indicate that there's a bug to figure out. With that, it should not be
possible to ever reuse an SQE outside of the direct syscall path.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/opdef.c     |  1 +
 io_uring/uring_cmd.c | 21 ++++++++++++---------
 io_uring/uring_cmd.h |  1 +
 3 files changed, 14 insertions(+), 9 deletions(-)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 6e0882b051f9..287f9a23b816 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -759,6 +759,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_URING_CMD] = {
 		.name			= "URING_CMD",
+		.sqe_copy		= io_uring_cmd_sqe_copy,
 		.cleanup		= io_uring_cmd_cleanup,
 	},
 	[IORING_OP_SEND_ZC] = {
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index e204f4941d72..a99dc2f9c4b5 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -205,17 +205,20 @@ int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!ac)
 		return -ENOMEM;
 	ac->data.op_data = NULL;
+	ioucmd->sqe = sqe;
+	return 0;
+}
+
+void io_uring_cmd_sqe_copy(struct io_kiocb *req)
+{
+	struct io_uring_cmd *ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+	struct io_async_cmd *ac = req->async_data;
 
-	/*
-	 * Unconditionally cache the SQE for now - this is only needed for
-	 * requests that go async, but prep handlers must ensure that any
-	 * sqe data is stable beyond prep. Since uring_cmd is special in
-	 * that it doesn't read in per-op data, play it safe and ensure that
-	 * any SQE data is stable beyond prep. This can later get relaxed.
-	 */
-	memcpy(ac->sqes, sqe, uring_sqe_size(req->ctx));
+	/* already copied, nothing to do */
+	if (ioucmd->sqe == ac->sqes)
+		return;
+	memcpy(ac->sqes, ioucmd->sqe, uring_sqe_size(req->ctx));
 	ioucmd->sqe = ac->sqes;
-	return 0;
 }
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
diff --git a/io_uring/uring_cmd.h b/io_uring/uring_cmd.h
index e6a5142c890e..a6dad47afc6b 100644
--- a/io_uring/uring_cmd.h
+++ b/io_uring/uring_cmd.h
@@ -11,6 +11,7 @@ struct io_async_cmd {
 
 int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags);
 int io_uring_cmd_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+void io_uring_cmd_sqe_copy(struct io_kiocb *req);
 void io_uring_cmd_cleanup(struct io_kiocb *req);
 
 bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
-- 
2.49.0


