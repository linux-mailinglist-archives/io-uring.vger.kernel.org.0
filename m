Return-Path: <io-uring+bounces-1156-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 01F7C88090C
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 02:23:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 73AF91F24395
	for <lists+io-uring@lfdr.de>; Wed, 20 Mar 2024 01:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D4C6AB9;
	Wed, 20 Mar 2024 01:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="FkpqG+vZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 196862582
	for <io-uring@vger.kernel.org>; Wed, 20 Mar 2024 01:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710897801; cv=none; b=X82cYTbTWzzTxruPT45kW0130HF3oupv6i+fupz8ckiOVZ8CQPltct0rLa2hkmkai1I9cA91SKgo1bHEgBveiV4puNPOwDZeYljLD1zVZFbnmpZt6jrFFzO3UgBABqwTc4kZDDNKUnORwjtmvX512pIGgknhPHx/xqAmelGdg2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710897801; c=relaxed/simple;
	bh=CC220oEvVsaltoIJxMcIegTRorS7Geg9OJonzp7wZq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VW7oi1ot3z++UKRYHHpo6EPZ0a7VWpho2mLqY3OcxnQbvhAgIIq6pvDa6rBV4XeqOPak/atBEHfAbEL29gSdKrCJfPYpKGfN9Jd6raB5GNCPh0+kDC1Hsg3GHrKpgWl0MSa8iaz1+4KlGENkyQ6ygo1AJytFodRZqfTb3FWzJEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=FkpqG+vZ; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-5a4e0859b65so177425eaf.0
        for <io-uring@vger.kernel.org>; Tue, 19 Mar 2024 18:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1710897799; x=1711502599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EW4Jpwuf3NZTpANDCQrLOB/VQc3CBX3tLAnEuFHW/4c=;
        b=FkpqG+vZwTPEnpFERoo4xpEDiiCRadIWAKNT+FVfIp5t3AVMCHy+uExVXtjCYxX7gz
         lGVPXTOeKSRulE2CpaH313xgAZN1utSOgZK1mRjv281SfJ6OD63Qja2vE9mQG7anPz0f
         CIlk1K7l32sch5vEUgVrnaHpsb7Wt8LqoLtwXNFFmeo3Ut776VQXvTXzR+WT/4Hswccm
         eYuJx1lQhthyiIU9kJ05DbF8XMugw7DTcb1ltyznImyMBqs09WIwu/IAwSkwH1Qemcm4
         uAG7CIqaBIwfjuOH6BssVIF0ltr0luDF7NqNwdEDb7Bf36hz48wfUYXc1nRiN7+bZjou
         bpqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710897799; x=1711502599;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EW4Jpwuf3NZTpANDCQrLOB/VQc3CBX3tLAnEuFHW/4c=;
        b=mheLr1Od69iVCQoUV7qElk0EbR0T3MepOFKOsAdahCCaDsc+itUIkkJ8YoBEtaDgs0
         sfYyPtiEjGnYZlNX0mfwsWH6VvsvSngDUzcVnwHFewxay6R61HsUy33u3M+izdXii9/X
         rH4p2CGYtB8uPbxnsQOkZV/pUj1jmkwkzqR2sE7ChLZkRTjLAlnURZgLpnZLBXux5K10
         OEE+FUbE7SXqS4GPe8xhJ2ReBcZ7Xq9BElsaPdjTmMWNdNWxjZK88OeEf9XiP/yPCTM7
         x4s0GzKQzPzQPQzcNwE9Op0fK6s7RN7dxuzwVYkhnbBoJqTD3OcOYFakD8c/HbHVmH1V
         /g+Q==
X-Gm-Message-State: AOJu0YySwUNaia4fwpDMPEepRLuEE5UVvdlVBZ55YvvW4w3T0Uf3J3vR
	F4On4Tk/JFpaAIedo4WXAzD3824DfC4cVI+QitWKHrEu15Cl8hNigPKMOuOgRPtVfUq80AbUY52
	n
X-Google-Smtp-Source: AGHT+IH/k4OBrhSQSyZHfzzDnyJI3SiO7+gT93/MPAF23CueuN15BF8eoATFs15uARa7eZGvLA6+BQ==
X-Received: by 2002:a05:6358:6f9d:b0:17e:bc8b:fbac with SMTP id s29-20020a0563586f9d00b0017ebc8bfbacmr4152526rwn.3.1710897798831;
        Tue, 19 Mar 2024 18:23:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id v22-20020a634816000000b005dc26144d96sm9618007pga.75.2024.03.19.18.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 19 Mar 2024 18:23:16 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 12/15] io_uring/rw: add iovec recycling
Date: Tue, 19 Mar 2024 19:17:40 -0600
Message-ID: <20240320012251.1120361-13-axboe@kernel.dk>
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

Let the io_async_rw hold on to the iovec and reuse it, rather than always
allocate and free them.

While doing so, shrink io_async_rw by getting rid of the bigger embedded
fast iovec. Since iovecs are being recycled now, shrink it from 8 to 1.
This reduces the io_async_rw size from 264 to 160 bytes, a 40% reduction.

Includes KASAN tracking as well, if that is turned on.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/rw.c | 38 ++++++++++++++++++++++++++++++++------
 io_uring/rw.h |  3 ++-
 2 files changed, 34 insertions(+), 7 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index f26e1dd5acaf..71ef417373c2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -81,7 +81,9 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
 {
 	const struct io_issue_def *def = &io_issue_defs[req->opcode];
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct iovec *iov;
 	void __user *buf;
+	int nr_segs, ret;
 	size_t sqe_len;
 
 	buf = u64_to_user_ptr(rw->addr);
@@ -99,9 +101,23 @@ static int __io_import_iovec(int ddir, struct io_kiocb *req,
 		return import_ubuf(ddir, buf, sqe_len, &io->iter);
 	}
 
-	io->free_iovec = io->fast_iov;
-	return __import_iovec(ddir, buf, sqe_len, UIO_FASTIOV, &io->free_iovec,
-				&io->iter, req->ctx->compat);
+	if (io->free_iovec) {
+		nr_segs = io->free_iov_nr;
+		iov = io->free_iovec;
+	} else {
+		iov = &io->fast_iov;
+		nr_segs = 1;
+	}
+	ret = __import_iovec(ddir, buf, sqe_len, nr_segs, &iov, &io->iter,
+				req->ctx->compat);
+	if (unlikely(ret < 0))
+		return ret;
+	if (iov) {
+		io->free_iov_nr = io->iter.nr_segs;
+		kfree(io->free_iovec);
+		io->free_iovec = iov;
+	}
+	return 0;
 }
 
 static inline int io_import_iovec(int rw, struct io_kiocb *req,
@@ -122,6 +138,7 @@ static void io_rw_iovec_free(struct io_async_rw *rw)
 {
 	if (rw->free_iovec) {
 		kfree(rw->free_iovec);
+		rw->free_iov_nr = 0;
 		rw->free_iovec = NULL;
 	}
 }
@@ -134,6 +151,8 @@ static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 		io_rw_iovec_free(rw);
 		return;
 	}
+	if (rw->free_iovec)
+		kasan_mempool_poison_object(rw->free_iovec);
 	if (io_alloc_cache_put(&req->ctx->rw_cache, &rw->cache)) {
 		req->async_data = NULL;
 		req->flags &= ~REQ_F_ASYNC_DATA;
@@ -155,15 +174,19 @@ static int io_rw_alloc_async(struct io_kiocb *req)
 	entry = io_alloc_cache_get(&ctx->rw_cache);
 	if (entry) {
 		rw = container_of(entry, struct io_async_rw, cache);
-		req->flags |= REQ_F_ASYNC_DATA;
+		if (rw->free_iovec)
+			kasan_mempool_unpoison_object(rw->free_iovec,
+					rw->free_iov_nr * sizeof(struct iovec));
+		req->flags |= REQ_F_ASYNC_DATA | REQ_F_NEED_CLEANUP;
 		req->async_data = rw;
 		goto done;
 	}
 
 	if (!io_alloc_async_data(req)) {
 		rw = req->async_data;
-done:
 		rw->free_iovec = NULL;
+		rw->free_iov_nr = 0;
+done:
 		rw->bytes_done = 0;
 		return 0;
 	}
@@ -1130,6 +1153,9 @@ void io_rw_cache_free(struct io_cache_entry *entry)
 	struct io_async_rw *rw;
 
 	rw = container_of(entry, struct io_async_rw, cache);
-	kfree(rw->free_iovec);
+	if (rw->free_iovec)
+		kasan_mempool_unpoison_object(rw->free_iovec,
+				rw->free_iov_nr * sizeof(struct iovec));
+	io_rw_iovec_free(rw);
 	kfree(rw);
 }
diff --git a/io_uring/rw.h b/io_uring/rw.h
index 56fb1703dc5a..26dfa12e2306 100644
--- a/io_uring/rw.h
+++ b/io_uring/rw.h
@@ -12,8 +12,9 @@ struct io_async_rw {
 	};
 	struct iov_iter			iter;
 	struct iov_iter_state		iter_state;
-	struct iovec			fast_iov[UIO_FASTIOV];
+	struct iovec			fast_iov;
 	struct iovec			*free_iovec;
+	int				free_iov_nr;
 	struct wait_page_queue		wpq;
 };
 
-- 
2.43.0


