Return-Path: <io-uring+bounces-1154-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A64488090B
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 192321C22858
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E18391364;
	Wed, 20 Mar 2024 01:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vyXi3EiI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C907464
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897798; cv=none; b=IjKQ1IPpgbb5eJeH6Xu9ntY8ocNF27+x6cyI652AYUtXK6AOqfhT3UdS8qY654wK3tJUULDiG9SPAoaeRzuzsYEkcwWuYMW47qTTlqRsFSvLmriJlwQjBIlQM/41X7062MMcLXiJIBdD1qDiP0MLfWmrDc/b1Ngn4KoEeCsUx50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897798; c=relaxed/simple;
	bh=+WgeA4b9DCM/hDBAIePgIIKsF1SEwqqNZprjMVCttqc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=czl2L7umlmKXKKBfajBPsbPzjsaTGIAF8hsfDsTsYrAFXbnTYPaIjze0nSOgH3fj4jBD3oKkxl9NpgkBiWrbX55/3FkkEPaqzQgKrl9fpbCDqALM3BuYteMgq7Lmwxn/ovnvZ3Jh4ANzI0BY5uNN5rIprLnBzjD1nWyAmsphPGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vyXi3EiI; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6e6c38be762so941747b3a.1
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897796; x=1711502596; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=746DtLrVdQ8v1/CM9YQD2PftzJISWXc3wAsFo4NIgVk=;
        b=vyXi3EiIXblFp4V2q2gvYbJ30rSAkq8x0EBGidekTD3aOwuSgpyaH/GDddInl64bM5
         dmSBx6EIY+klQT40w5DWA6F0Ll+RzIMxxNM7YzKJtaqCXOpO1V+Hyl+eYxA1EYVW/WrI
         /dGDh5RmK13pZW4ZsGzl/hw+Y29aiivcBLt8swrX+lzQLKjDVnomQDboNUGd3xyZO5x/
         Vcgx/l9Ek9db2ZBGEiuvs+D5iHkWqG00IQrNXorwEVB6VVFFkAyX+OEqWwc3oj8ldBWB
         npfceT8mtgvTAnRYKfOp11AccPMcICEh4LvWGWB2D9IKLcwIS7jTYN4QPuY+TajfmU2+
         036Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897796; x=1711502596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=746DtLrVdQ8v1/CM9YQD2PftzJISWXc3wAsFo4NIgVk=;
        b=DqBsUyRTgMzV2TvwnJ3Q78gOxm5Gxr+cOnBw6dEx1Ex8uBIB42TZAmuXfrCwDL4eAQ
         mhmV57XuWOCoogeV5eLMohjH3IS5A4ZaP/NUWjVFuDyrmjx5pjp1mcOiQ7fN413RP7Kd
         qjZBE9VR/T3EMYCrm3U/5i2ynYTn7aCRefW50R+kGxLRwknCogGPqWQJPvR7LFGexKic
         VraZF0gDo12SuH7TEoPXbgwX2G/gO5ojWeUdZ5QfGHGxa3BEUkFqkLZ+Qq3/Wogp1alL
         +bWgWMQ8F/2QL2xxBwx7CjFwGaoJTnMINiJZoAOw3tQE4yVYmAlWuRl2X7Bcyg9i7oJm
         EinA==
X-Gm-Message-State: AOJu0Yy2MZPeVw4MHdA0phXJoW2VxOpGdVJODWJovhXgmldf0nXspzhs
	MSs6Fbn81aQDpIkkj06BX7rvpjOfxgEhyB0VhKOzTm8jLyyeEdOu4PL+GPRnEvZq+jYgkiX9dgt
	P
X-Google-Smtp-Source: AGHT+IGRWiB3fvdEcbj8gox7/5nJ170+AoDmP1aaT7rlB/Owlg2mr6Wop/Z3Z9VedrTJReae85a7rQ==
X-Received: by 2002:a05:6a00:9382:b0:6e6:864d:767 with SMTP id ka2-20020a056a00938200b006e6864d0767mr4279103pfb.3.1710897795733;
        Tue, 19 Mar 2024 18:23:15 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:15 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 11/15] io_uring: get rid of struct io_rw_state
Date: Tue, 19 Mar 2024 19:17:39 -0600
Message-ID: <20240320012251.1120361-12-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240320012251.1120361-1-axboe@kernel.dk>
References: <20240320012251.1120361-1-axboe@kernel.dk>
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
 io_uring/rw.h |  7 +++----
 2 files changed, 26 insertions(+), 26 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 054e6f381460..f26e1dd5acaf 100644
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
 
@@ -187,7 +187,7 @@ static int io_prep_rw_setup(struct io_kiocb *req, int ddir, bool do_import)
 	if (unlikely(ret < 0))
 		return ret;
 
-	iov_iter_save_state(&rw->s.iter, &rw->s.iter_state);
+	iov_iter_save_state(&rw->iter, &rw->iter_state);
 	return 0;
 }
 
@@ -279,8 +279,8 @@ static int io_prep_rw_fixed(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	io_req_set_rsrc_node(req, ctx, 0);
 
 	io = req->async_data;
-	ret = io_import_fixed(ddir, &io->s.iter, req->imu, rw->addr, rw->len);
-	iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+	ret = io_import_fixed(ddir, &io->iter, req->imu, rw->addr, rw->len);
+	iov_iter_save_state(&io->iter, &io->iter_state);
 	return ret;
 }
 
@@ -345,7 +345,7 @@ static void io_resubmit_prep(struct io_kiocb *req)
 {
 	struct io_async_rw *io = req->async_data;
 
-	iov_iter_restore(&io->s.iter, &io->s.iter_state);
+	iov_iter_restore(&io->iter, &io->iter_state);
 }
 
 static bool io_rw_should_reissue(struct io_kiocb *req)
@@ -779,7 +779,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_rw_init_file(req, FMODE_READ);
 	if (unlikely(ret))
 		return ret;
-	req->cqe.res = iov_iter_count(&io->s.iter);
+	req->cqe.res = iov_iter_count(&io->iter);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
@@ -797,7 +797,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(ret))
 		return ret;
 
-	ret = io_iter_do_read(rw, &io->s.iter);
+	ret = io_iter_do_read(rw, &io->iter);
 
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
 		req->flags &= ~REQ_F_REISSUE;
@@ -824,7 +824,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	 * untouched in case of error. Restore it and we'll advance it
 	 * manually if we need to.
 	 */
-	iov_iter_restore(&io->s.iter, &io->s.iter_state);
+	iov_iter_restore(&io->iter, &io->iter_state);
 
 	do {
 		/*
@@ -832,11 +832,11 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -844,19 +844,19 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
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
@@ -953,7 +953,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_rw_init_file(req, FMODE_WRITE);
 	if (unlikely(ret))
 		return ret;
-	req->cqe.res = iov_iter_count(&io->s.iter);
+	req->cqe.res = iov_iter_count(&io->iter);
 
 	if (force_nonblock) {
 		/* If the file doesn't support async, just async punt */
@@ -983,9 +983,9 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	kiocb->ki_flags |= IOCB_WRITE;
 
 	if (likely(req->file->f_op->write_iter))
-		ret2 = call_write_iter(req->file, kiocb, &io->s.iter);
+		ret2 = call_write_iter(req->file, kiocb, &io->iter);
 	else if (req->file->f_op->write)
-		ret2 = loop_rw_iter(WRITE, rw, &io->s.iter);
+		ret2 = loop_rw_iter(WRITE, rw, &io->iter);
 	else
 		ret2 = -EINVAL;
 
@@ -1019,7 +1019,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 			 * in the worker. Also update bytes_done to account for
 			 * the bytes already written.
 			 */
-			iov_iter_save_state(&io->s.iter, &io->s.iter_state);
+			iov_iter_save_state(&io->iter, &io->iter_state);
 			io->bytes_done += ret2;
 
 			if (kiocb->ki_flags & IOCB_WRITE)
@@ -1030,7 +1030,7 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 		ret = kiocb_done(req, ret2, issue_flags);
 	} else {
 ret_eagain:
-		iov_iter_restore(&io->s.iter, &io->s.iter_state);
+		iov_iter_restore(&io->iter, &io->iter_state);
 		if (kiocb->ki_flags & IOCB_WRITE)
 			io_req_end_write(req);
 		return -EAGAIN;
@@ -1130,5 +1130,6 @@ void io_rw_cache_free(struct io_cache_entry *entry)
 	struct io_async_rw *rw;
 
 	rw = container_of(entry, struct io_async_rw, cache);
+	kfree(rw->free_iovec);
 	kfree(rw);
 }
diff --git a/io_uring/rw.h b/io_uring/rw.h
index f7905070d10b..56fb1703dc5a 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -3,9 +3,6 @@
 #include <linux/pagemap.h>
 
 struct io_rw_state {
-	struct iov_iter			iter;
-	struct iov_iter_state		iter_state;
-	struct iovec			fast_iov[UIO_FASTIOV];
 };
 
 struct io_async_rw {
@@ -13,7 +10,9 @@ struct io_async_rw {
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


