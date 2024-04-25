Return-Path: <io-uring+bounces-1627-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AF3CF8B24DB
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 17:16:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 294DC1F215D9
	for <lists+io-uring@lfdr.de>; Thu, 25 Apr 2024 15:16:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AFFF03BBE5;
	Thu, 25 Apr 2024 15:16:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="0vCN5OI7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AB437152
	for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 15:16:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714058201; cv=none; b=n9fI3rvaRWrfv8zJe61O3kU6UQyPkCfEfM1ZefP9O4bdUL/YBMoXzNg0HQl448FbHVB5WWxTMeRNS5R9n9ZrSYmMaPrh9ic3GF33RlEOvlOwY8Za05r4tW4RpRa7ZUTEdJJ/SSocujer/nPdMoYMwqqMSrvAUcy060uqtPPDph0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714058201; c=relaxed/simple;
	bh=O24RCIdmgaSw8A83ApoPGk7xnERRIUHWEwKoKKxDHOs=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=aVBiXKjsrmrbctePwG8PC0jmv7zdkBiXoYdBPiIcEiqfBouTfJUceXDVTn6J16DwUGp+pNWBieojwrlZfuqD3nSBWQZV+yUsu1p3ljXqTaSvK0g+UWTGA6C14BMuszGCubTEONoLd7YL4TxLrepAnCPjje4U9jGbcrY2rlfF6b0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=0vCN5OI7; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7de9c791a26so6572439f.1
        for <io-uring@vger.kernel.org>; Thu, 25 Apr 2024 08:16:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1714058197; x=1714662997; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dloQR773UbUq+vMLAd1SwoCkzZOd9x/cRnuJPpkszsk=;
        b=0vCN5OI7/gLOG/bkpSpgLLZ/fjOZFilCFtwYkfsF1DOsV/3fscpZYDDAvTHXvt30Ws
         1MLKGsMDRdHrigKM7lbZSfy1cYs4D9q3AJspvdsUZpYJ9eBbAe+p0I117TAtKhkX3DXG
         BWPk30QKguolBmENgcrODSMGlvkQINn57mTH83Axc8jZElTVKfpCVluKgjud+UN3+bpk
         JyfUGD7HTgESY2wD01Y22nbDsgTBDDFoIap1sCU96e56XKfcgXeCLj+/pws1M1SvGr1i
         b1zIDZ3oWj5T7AVr6pYbUIhb5LfPL+jkD/BrnQKOfrxtPqSpZex+kIdDK77m39NvHwuy
         GCeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714058197; x=1714662997;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dloQR773UbUq+vMLAd1SwoCkzZOd9x/cRnuJPpkszsk=;
        b=q35mZTvtlcH8l0JyIJF+Wl3tgI39BFKz3TaAdE3jfpkNgGx8Ph9FKqyMw+N+qBb3PS
         eKHxlGiyRXfC4jj7EI7GWFBp7A5k8xGueHfeKraI8ctR03ppSKj1OTk9VNr5agnCDCrc
         i/ou0dVgyGFN0eDQqFkByoY2Uh004LD6JkXpwHuN/S43M1JwDHq9uZVsMbMo8VGHq0kN
         +6XsZNhpI+Ck/Qw/okNy7pDkYeQYQ1Tmjl/xLf2lgckezX9TxCIDvEmMJiAzvgcUkxxN
         OGtjziRm892AlEw8aCkJCfMqq8jNXdDGfp6xFQz1oXSxmtG6TfNQ6cjc4QIe36LWbxtN
         i8QQ==
X-Gm-Message-State: AOJu0Yzn2Qi1rAXDUz3ugg9ExU5LHfkCO9EAme6MhBMAJtGE00gCzwhc
	tsxbwYKPS0s9QMlGyhSh+8OnLXcp+zGR998f8ms1oTkLcjoNnjD8VlH08EyH1jeySzqKv3PQFj3
	y
X-Google-Smtp-Source: AGHT+IGszkTSvDKQGOGGF5VggdTgZhZ2yY1LnbZfFAwixqvEVGC2KeYysSL0oaZS2XZeVq53xMrd7A==
X-Received: by 2002:a5d:954f:0:b0:7da:7278:be09 with SMTP id a15-20020a5d954f000000b007da7278be09mr6815578ios.2.1714058197418;
        Thu, 25 Apr 2024 08:16:37 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l10-20020a05663814ca00b0048485c3d865sm4940972jak.101.2024.04.25.08.16.36
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Apr 2024 08:16:37 -0700 (PDT)
Message-ID: <8e74cff8-2a7f-4883-9bff-1fbc22570a47@kernel.dk>
Date: Thu, 25 Apr 2024 09:16:36 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: reinstate thread check for retries
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Allowing retries for everything is arguably the right thing to do, now
that every command type is async read from the start. But it's exposed a
few issues around missing check for a retry (which cca6571381a0 exposed),
and the fixup commit for that isn't necessarily 100% sound in terms of
iov_iter state.

For now, just revert these two commits. This unfortunately then re-opens
the fact that -EAGAIN can get bubbled to userspace for some cases where
the kernel very well could just sanely retry them. But until we have all
the conditions covered around that, we cannot safely enable that.

This reverts commit df604d2ad480fcf7b39767280c9093e13b1de952.
This reverts commit cca6571381a0bdc88021a1f7a4c2349df21279f7.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 64845634d89f..2675cffbd9a4 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -527,19 +527,6 @@ static void io_queue_iowq(struct io_kiocb *req)
 		io_queue_linked_timeout(link);
 }
 
-static void io_tw_requeue_iowq(struct io_kiocb *req, struct io_tw_state *ts)
-{
-	req->flags &= ~REQ_F_REISSUE;
-	io_queue_iowq(req);
-}
-
-void io_tw_queue_iowq(struct io_kiocb *req)
-{
-	req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
-	req->io_task_work.func = io_tw_requeue_iowq;
-	io_req_task_work_add(req);
-}
-
 static __cold void io_queue_deferred(struct io_ring_ctx *ctx)
 {
 	while (!list_empty(&ctx->defer_list)) {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index b83a719c5443..624ca9076a50 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -75,7 +75,6 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
-void io_tw_queue_iowq(struct io_kiocb *req);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4fed829fe97c..a6bf2ea8db91 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -396,9 +396,16 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 	return NULL;
 }
 
+#ifdef CONFIG_BLOCK
+static void io_resubmit_prep(struct io_kiocb *req)
+{
+	struct io_async_rw *io = req->async_data;
+
+	iov_iter_restore(&io->iter, &io->iter_state);
+}
+
 static bool io_rw_should_reissue(struct io_kiocb *req)
 {
-#ifdef CONFIG_BLOCK
 	umode_t mode = file_inode(req->file)->i_mode;
 	struct io_ring_ctx *ctx = req->ctx;
 
@@ -414,11 +421,23 @@ static bool io_rw_should_reissue(struct io_kiocb *req)
 	 */
 	if (percpu_ref_is_dying(&ctx->refs))
 		return false;
+	/*
+	 * Play it safe and assume not safe to re-import and reissue if we're
+	 * not in the original thread group (or in task context).
+	 */
+	if (!same_thread_group(req->task, current) || !in_task())
+		return false;
 	return true;
+}
 #else
+static void io_resubmit_prep(struct io_kiocb *req)
+{
+}
+static bool io_rw_should_reissue(struct io_kiocb *req)
+{
 	return false;
-#endif
 }
+#endif
 
 static void io_req_end_write(struct io_kiocb *req)
 {
@@ -455,7 +474,7 @@ static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 			 * current cycle.
 			 */
 			io_req_io_end(req);
-			io_tw_queue_iowq(req);
+			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
 			return true;
 		}
 		req_set_fail(req);
@@ -521,7 +540,7 @@ static void io_complete_rw_iopoll(struct kiocb *kiocb, long res)
 		io_req_end_write(req);
 	if (unlikely(res != req->cqe.res)) {
 		if (res == -EAGAIN && io_rw_should_reissue(req)) {
-			io_tw_queue_iowq(req);
+			req->flags |= REQ_F_REISSUE | REQ_F_BL_NO_RECYCLE;
 			return;
 		}
 		req->cqe.res = res;
@@ -583,10 +602,8 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	}
 
 	if (req->flags & REQ_F_REISSUE) {
-		struct io_async_rw *io = req->async_data;
-
 		req->flags &= ~REQ_F_REISSUE;
-		iov_iter_restore(&io->iter, &io->iter_state);
+		io_resubmit_prep(req);
 		return -EAGAIN;
 	}
 	return IOU_ISSUE_SKIP_COMPLETE;
@@ -839,8 +856,7 @@ static int __io_read(struct io_kiocb *req, unsigned int issue_flags)
 	ret = io_iter_do_read(rw, &io->iter);
 
 	if (ret == -EAGAIN || (req->flags & REQ_F_REISSUE)) {
-		if (req->flags & REQ_F_REISSUE)
-			return IOU_ISSUE_SKIP_COMPLETE;
+		req->flags &= ~REQ_F_REISSUE;
 		/* If we can poll, just do that. */
 		if (io_file_can_poll(req))
 			return -EAGAIN;
@@ -1035,8 +1051,10 @@ int io_write(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		ret2 = -EINVAL;
 
-	if (req->flags & REQ_F_REISSUE)
-		return IOU_ISSUE_SKIP_COMPLETE;
+	if (req->flags & REQ_F_REISSUE) {
+		req->flags &= ~REQ_F_REISSUE;
+		ret2 = -EAGAIN;
+	}
 
 	/*
 	 * Raw bdev writes will return -EOPNOTSUPP for IOCB_NOWAIT. Just

-- 
Jens Axboe


