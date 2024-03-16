Return-Path: <io-uring+bounces-1044-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7CC5987DB17
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 18:31:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17D9C2829D6
	for <lists+io-uring@lfdr.de>; Sat, 16 Mar 2024 17:31:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 864151BDCE;
	Sat, 16 Mar 2024 17:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Pb09X1EM"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9FDFC18C36
	for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 17:31:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710610273; cv=none; b=ASK6slx2sN6vnGfqFh/30y455LCH6gdM8Sbc8NieNCzSpMseb6KBbhKu4tXuOrPBCY9R2bd0gjm9S3M1ltKGHb0Xt7fjuT8dDVfxGgoGAO6PomfuZEfH5Den27z7PgD1/V+Xo+wlC+PpgdbJqXASla9J8llOUiFHNcOrCIEavKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710610273; c=relaxed/simple;
	bh=zbnkgYjuL2IUCqah1BEnjQ04OSADsvXAnvB2oPFZDDM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHKoG7Mn89y5zetm7IiuzZcljJu92nLvojIbDDZagOHPRkhkgmwG6GeX6LzCOLhj72uW7oqCt2aH/sFGgcUlcZRW+5gCWFXC7g62GN54PFQk+RYHGXrUBEiwMYI6+SZwnUdB4Xv87hC5Fz9Db0kaze4cXwrK7Tytm6UrAeMZBts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Pb09X1EM; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-29f8ae4eae5so29113a91.0
        for <io-uring@vger.kernel.org>; Sat, 16 Mar 2024 10:31:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710610270; x=1711215070; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qf2avq0IgK/iFK0MaT6VQ/bDusw2jr0FlyEeAO9HsnE=;
        b=Pb09X1EMqLtT/4WPo1UuVvx+uv6dmyuqdgcPjHtsdR4HcDJw1kXwe+tQDPjBqpKYWP
         TMcIBQiL7A4bEIUrq6yqk6SsXkhtwDJTW9S6sHZOT7TarESxSBRRBR2U3i/ErVIJR4yg
         nlmumj0KfBkQtmsMRCSgtK+k4Vwj/xFJz6TRIeeR0NvsxpH6SDvYih2WJE+rdu/zBnTs
         +l7oGf77exOsXD9X3XyzCbl8sXcnkbOTHxuudcjZTGjpRyyb9CXgoVRNimPrGjq2kYgG
         05DI90wSO/rPZfDY+deWbMidi1nB18IWhK7ECKs0OrhvJ2idFW3zY1Wa2O1yjP9P7TDS
         GJgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710610270; x=1711215070;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qf2avq0IgK/iFK0MaT6VQ/bDusw2jr0FlyEeAO9HsnE=;
        b=kep0mP1pBCzvFZc5GtuaCIG2KpwDFfu2LAogLflGVXhmUGRNj0DuglwXo1KLGC9MGI
         QZ8T3vk2XsDX38erZTlG5qv56u7AFeR1MpyTyo5jaPwa1is/zJXB45bKOp0+SYVwtiPb
         gc2ncp+tEev0mzWgWn3SF4qJcOhUBMiqFJwgpzIWqQBwtktzPVM2Bgdgb8RuaRpvvalV
         S10a1DMrzQK6u2nDdgJRgDfDizoml1OBhv3RXD/bTm+yOxPz/cP+QUUxwbf5JioziwkC
         vfo0TnQOVUpIolP+6z7/lEHsz+RvtEoFEVS8o3TgSDtDr6G6oV3naupUXFMGTCR6naMA
         Dy/A==
X-Gm-Message-State: AOJu0YwQfo1HOMiv57oPxIIqRR+rS8Luh7matYanzFHg2iFAowmMNYBu
	Jt2LquC7OoDO7zIAUhPULU69MYJ28/APdOV5d+cmJnpm7ORiGpjD86DEPVezPdWHanCQ606csUe
	S
X-Google-Smtp-Source: AGHT+IFMxMZi8/gCZtVMIEfz/Ub6an7BJ028STgjZkeARf0BFEgKab1c8Q+bOjNig3/6YYIvqhIyig==
X-Received: by 2002:a17:90a:7782:b0:29b:d22e:5d54 with SMTP id v2-20020a17090a778200b0029bd22e5d54mr5611837pjk.1.1710610270469;
        Sat, 16 Mar 2024 10:31:10 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id nd16-20020a17090b4cd000b0029deb85bfedsm3978567pjb.28.2024.03.16.10.31.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 16 Mar 2024 10:31:09 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
Subject: [PATCH 2/2] io_uring: clear opcode specific data for an early failure
Date: Sat, 16 Mar 2024 11:29:35 -0600
Message-ID: <20240316173104.577959-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240316173104.577959-1-axboe@kernel.dk>
References: <20240316173104.577959-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

If failure happens before the opcode prep handler is called, ensure that
we clear the opcode specific area of the request, which holds data
specific to that request type. This prevents errors where opcode
handlers either don't get to clear per-request private data since prep
isn't even called.

Reported-and-tested-by: syzbot+f8e9a371388aa62ecab4@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 25 ++++++++++++++++---------
 1 file changed, 16 insertions(+), 9 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3ae4bb988906..5d4b448fdc50 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2181,6 +2181,13 @@ static void io_init_req_drain(struct io_kiocb *req)
 	}
 }
 
+static __cold int io_init_fail_req(struct io_kiocb *req, int err)
+{
+	/* ensure per-opcode data is cleared if we fail before prep */
+	memset(&req->cmd.data, 0, sizeof(req->cmd.data));
+	return err;
+}
+
 static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		       const struct io_uring_sqe *sqe)
 	__must_hold(&ctx->uring_lock)
@@ -2202,29 +2209,29 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 	}
 	def = &io_issue_defs[opcode];
 	if (unlikely(sqe_flags & ~SQE_COMMON_FLAGS)) {
 		/* enforce forwards compatibility on users */
 		if (sqe_flags & ~SQE_VALID_FLAGS)
-			return -EINVAL;
+			return io_init_fail_req(req, -EINVAL);
 		if (sqe_flags & IOSQE_BUFFER_SELECT) {
 			if (!def->buffer_select)
-				return -EOPNOTSUPP;
+				return io_init_fail_req(req, -EOPNOTSUPP);
 			req->buf_index = READ_ONCE(sqe->buf_group);
 		}
 		if (sqe_flags & IOSQE_CQE_SKIP_SUCCESS)
 			ctx->drain_disabled = true;
 		if (sqe_flags & IOSQE_IO_DRAIN) {
 			if (ctx->drain_disabled)
-				return -EOPNOTSUPP;
+				return io_init_fail_req(req, -EOPNOTSUPP);
 			io_init_req_drain(req);
 		}
 	}
 	if (unlikely(ctx->restricted || ctx->drain_active || ctx->drain_next)) {
 		if (ctx->restricted && !io_check_restriction(ctx, req, sqe_flags))
-			return -EACCES;
+			return io_init_fail_req(req, -EACCES);
 		/* knock it to the slow queue path, will be drained there */
 		if (ctx->drain_active)
 			req->flags |= REQ_F_FORCE_ASYNC;
@@ -2237,9 +2244,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	}
 
 	if (!def->ioprio && sqe->ioprio)
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 	if (!def->iopoll && (ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
+		return io_init_fail_req(req, -EINVAL);
 
 	if (def->needs_file) {
 		struct io_submit_state *state = &ctx->submit_state;
@@ -2263,12 +2270,12 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 
 		req->creds = xa_load(&ctx->personalities, personality);
 		if (!req->creds)
-			return -EINVAL;
+			return io_init_fail_req(req, -EINVAL);
 		get_cred(req->creds);
 		ret = security_uring_override_creds(req->creds);
 		if (ret) {
 			put_cred(req->creds);
-			return ret;
+			return io_init_fail_req(req, ret);
 		}
 		req->flags |= REQ_F_CREDS;
 	}
-- 
2.43.0


