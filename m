Return-Path: <io-uring+bounces-1172-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B7A838819B3
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 23:58:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D55A282E0B
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 22:58:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1F481E87E;
	Wed, 20 Mar 2024 22:58:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="TiiMK0u9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23E4A8593C
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 22:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710975495; cv=none; b=oO2yAxvUZn98FVVqwTbzgDeRgkJBV6YG5QQRf1JLyWe22iRJJHP6SxJqX7UGd7qnd0Vm89EquNeAk+CGsQA+BlWtcKJBIO1HSqq6bSSyatgkFbKIWf6TyNOj0H8rFkYYEpZWiHUT/Qt636+XkqYwC7DTDkvFdldj2ZjSRSQ9lQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710975495; c=relaxed/simple;
	bh=kP5mcTi3CROgTV2jL7W/XAFDP9BtxqoA4JB+ostteOE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ClyqnExAL8jrWN7x9EAgQxSoxNOhajGJMD29J3Xr49t6CaF8ED0ZEkXTWunIBOQMASk70sKmO9mHCGxi5aVv4zEFuc3QIlTyy+k/LU8jpCuyeSqYtC49awGqOOQWjyzcusELiBwiOEiAsz3hAEFRR2XhM/oIO5+PfIbWS9WRN1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=TiiMK0u9; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-3667b0bb83eso574615ab.0
        for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 15:58:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710975493; x=1711580293; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xnPLbnZoILIxEGmuUDdw9jcTDSwtSkgiLb2dTvZ1A9w=;
        b=TiiMK0u9QKInO71TCYTS41Cj2CuQaT3Kr8RB6lljmvTDxWhA9e4XfaCcYEDZxZ/4Ux
         jT/gD8traNmOD/3wP8veWeX18aCOBtRO66Szv2bcaw3XNX7HuX0v4/ikE+vfqYRP+Ku0
         l1QMUUuA1okvFTVwpE+3SKOJGp6mQM8IxoE9ME3MwsuV9dNKtrkJZC1u8TpyBxAXNNb0
         S4KBTxD79Gx/mOznf80MvIJCAVonLniHZ23nAjcGPy5NAypKzfbSsW/+QPJlbh/IkOmJ
         wIWSopYMhXtgzvFVtb0ow5BlKStLHOVCD4sTuAnSYZ5kN66CXwPeAAtm6OmdujtVZkLE
         P51Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710975493; x=1711580293;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xnPLbnZoILIxEGmuUDdw9jcTDSwtSkgiLb2dTvZ1A9w=;
        b=U0GeUvENOcjIdTvxK6OGIhn8dcLcdlR645G0v14jOUquZG6Ed5hodOTDu546054JbK
         vxobTqVSlfpcuh6tjxM2IYgKszf7YyHpP5Jc8oEDXRlo11pw8TYXVmNiDnNh/Tsp0IrU
         GZMcBAK4cA+0Aq7z1MAmTxbCpdKIGIOIYeL41GC972Xrblo0NK6mJM9eP+Wo4q9stCRP
         i6ZC3jwzxT4Asl0OZ/RwvVg7iv+dTj3HUuKVIv7IzDJAAcd2Tb0QDAYokiLA2wGB3+EV
         CyaczyLjYu08KlIOhI/ZWXMhxo5yFSOzSzmc1KlwlxHjgg+woRqGlFloHq3FVvBMdh5I
         Ytiw==
X-Gm-Message-State: AOJu0YzI2Yc59bX0e2mBWuNrpuVRNBoADynWSINP98itJrsW78N1Dev9
	nNsgDV4j21mC4JbqrsLXpKHVTCXO+0Evm+FIQAQfnXYyMtXs4vr7WR6xlV5sJYFTT4Ea4QGu5HV
	4
X-Google-Smtp-Source: AGHT+IGyZTPlMvxuuA4lU1GDYJg92lbbkf9dhTD6EQPOzQmtwuwzGN7Be7aXv7EOYm16uZPL3tHsgQ==
X-Received: by 2002:a5e:a80c:0:b0:7cf:24de:c5f with SMTP id c12-20020a5ea80c000000b007cf24de0c5fmr1835839ioa.1.1710975492665;
        Wed, 20 Mar 2024 15:58:12 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id z19-20020a6b0a13000000b007cf23a498dcsm434384ioi.38.2024.03.20.15.58.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Mar 2024 15:58:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/17] io_uring: get rid of struct io_rw_state
Date: Wed, 20 Mar 2024 16:55:26 -0600
Message-ID: <20240320225750.1769647-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320225750.1769647-1-axboe@kernel.dk>
References: <20240320225750.1769647-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

A separate state struct is not needed anymore, just fold it in with
io_async_rw.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 45 +++++++++++++++++++++++----------------------
 io_uring/rw.h | 10 +++-------
 2 files changed, 26 insertions(+), 29 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 583fe61a0acb..19e866929cd3 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -96,12 +96,12 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
 			rw->len = sqe_len;
 		}
 
-		return import_ubuf(ddir, buf, sqe_len, &io->s.iter);
+		return import_ubuf(ddir, buf, sqe_len, &io->iter);
 	}
 
-	io->free_iovec = io->s.fast_iov;
+	io->free_iovec = io->fast_iov;
 	return __import_iovec(ddir, buf, sqe_len, UIO_FASTIOV, &io->free_iovec,
-				&io->s.iter, req->ctx->compat);
+				&io->iter, req->ctx->compat);
 }
 
 static inline int io_import_iovec(int rw, struct io_kiocb *req,
@@ -114,7 +114,7 @@ static inline int io_import_iovec(int rw, struct io_kiocb *req,
 	if (unlikely(ret < 0))
 		return ret;
 
-	iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+	iov_iter_save_state(&io->iter, &io->iter_state);
 	return 0;
 }
 
@@ -216,7 +216,7 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	if (unlikely(ret < 0))
 		return ret;
 
-	iov_iter_save_state(&rw->s.iter, &rw->s.iter_state);
+	iov_iter_save_state(&rw->iter, &rw->iter_state);
 	return 0;
 }
 
@@ -308,8 +308,8 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	io_req_set_rsrc_node(req, ctx, 0);
 
 	io = req->async_data;
-	ret = io_import_fixed(ddir, &io->s.iter, req->imu, rw->addr, rw->len);
-	iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+	ret = io_import_fixed(ddir, &io->iter, req->imu, rw->addr, rw->len);
+	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
 
@@ -374,7 +374,7 @@ static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
 
-	iov_iter_restore(&io->s.iter, &io->s.iter_state);
+	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
 static bool io_rw_should_reissue(struct io_kiocb *req)
@@ -808,7 +808,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_rw_init_file(req, FMODE_READ);
 	if (unlikely(ret))
 		return ret;
-	req->cqe.res = iov_iter_count(&io->s.iter);
+	req->cqe.res = iov_iter_count(&io->iter);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
@@ -826,7 +826,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	ret = io_iter_do_read(rw, &io->s.iter);
+	ret = io_iter_do_read(rw, &io->iter);
 
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
@@ -853,7 +853,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * untouched in case of error. Restore it and we'll advance it
 	 * manually if we need to.
 	 */
-	iov_iter_restore(&io->s.iter, &io->s.iter_state);
+	iov_iter_restore(&io->iter, &io->iter_state);
 
 	do {
 		/*
@@ -861,11 +861,11 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 		 * above or inside this loop. Advance the iter by the bytes
 		 * that were consumed.
 		 */
-		iov_iter_advance(&io->s.iter, ret);
-		if (!iov_iter_count(&io->s.iter))
+		iov_iter_advance(&io->iter, ret);
+		if (!iov_iter_count(&io->iter))
 			break;
 		io->bytes_done += ret;
-		iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+		iov_iter_save_state(&io->iter, &io->iter_state);
 
 		/* if we can retry, do so with the callbacks armed */
 		if (!io_rw_should_retry(req)) {
@@ -873,19 +873,19 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		}
 
-		req->cqe.res = iov_iter_count(&io->s.iter);
+		req->cqe.res = iov_iter_count(&io->iter);
 		/*
 		 * Now retry read with the IOCB_WAITQ parts set in the iocb. If
 		 * we get -EIOCBQUEUED, then we'll get a notification when the
 		 * desired page gets unlocked. We can also get a partial read
 		 * here, and if we do, then just retry at the new offset.
 		 */
-		ret = io_iter_do_read(rw, &io->s.iter);
+		ret = io_iter_do_read(rw, &io->iter);
 		if (ret == -EIOCBQUEUED)
 			return IOU_ISSUE_SKIP_COMPLETE;
 		/* we got some bytes, but not all. retry. */
 		kiocb->ki_flags &= ~IOCB_WAITQ;
-		iov_iter_restore(&io->s.iter, &io->s.iter_state);
+		iov_iter_restore(&io->iter, &io->iter_state);
 	} while (ret > 0);
 done:
 	/* it's faster to check here then delegate to kfree */
@@ -982,7 +982,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_rw_init_file(req, FMODE_WRITE);
 	if (unlikely(ret))
 		return ret;
-	req->cqe.res = iov_iter_count(&io->s.iter);
+	req->cqe.res = iov_iter_count(&io->iter);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
@@ -1012,9 +1012,9 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (likely(req->file->f_op->write_iter))
-		ret2 = call_write_iter(req->file, kiocb, &io->s.iter);
+		ret2 = call_write_iter(req->file, kiocb, &io->iter);
 	else if (req->file->f_op->write)
-		ret2 = loop_rw_iter(WRITE, rw, &io->s.iter);
+		ret2 = loop_rw_iter(WRITE, rw, &io->iter);
 	else
 		ret2 = -EINVAL;
 
@@ -1046,7 +1046,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 			 * in the worker. Also update bytes_done to account for
 			 * the bytes already written.
 			 */
-			iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+			iov_iter_save_state(&io->iter, &io->iter_state);
 			io->bytes_done += ret2;
 
 			if (kiocb->ki_flags & IOCB_WRITE)
@@ -1057,7 +1057,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		ret = kiocb_done(req, ret2, issue_flags);
 	} else {
 ret_eagain:
-		iov_iter_restore(&io->s.iter, &io->s.iter_state);
+		iov_iter_restore(&io->iter, &io->iter_state);
 		if (kiocb->ki_flags & IOCB_WRITE)
 			io_req_end_write(req);
 		return -EAGAIN;
@@ -1157,5 +1157,6 @@ void io_rw_cache_free(struct io_cache_entry *entry)
 	struct io_async_rw *rw;
 
 	rw = container_of(entry, struct io_async_rw, cache);
+	kfree(rw->free_iovec);
 	kfree(rw);
 }
diff --git a/io_uring/rw.h b/io_uring/rw.h
index f7905070d10b..7824896dc52d 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -2,18 +2,14 @@
 
 #include <linux/pagemap.h>
 
-struct io_rw_state {
-	struct iov_iter			iter;
-	struct iov_iter_state		iter_state;
-	struct iovec			fast_iov[UIO_FASTIOV];
-};
-
 struct io_async_rw {
 	union {
 		size_t			bytes_done;
 		struct io_cache_entry	cache;
 	};
-	struct io_rw_state		s;
+	struct iov_iter			iter;
+	struct iov_iter_state		iter_state;
+	struct iovec			fast_iov[UIO_FASTIOV];
 	struct iovec			*free_iovec;
 	struct wait_page_queue		wpq;
 };
-- 
2.43.0


