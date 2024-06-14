Return-Path: <io-uring+bounces-2216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DB2819090D1
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 18:58:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 723BB2858B4
	for <lists+io-uring@lfdr.de>; Fri, 14 Jun 2024 16:58:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3F38E192B8F;
	Fri, 14 Jun 2024 16:58:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="GShl0MH5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B33EB180A90
	for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 16:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718384329; cv=none; b=YMu62BwR2jPBOC1OGHoSRrNWj0+4XIz98iNRw5ZFGAvCL/s1BeICC/b5yKT1VF8Hqk2169o2FUfDN5wnNMa6aB10u19HRuavVV8OhfP2YJyE6xLuGguwyfHK6sG/71DUt5Vpow1e5GdqKwYGW0JO8jhNPJdBQ8PSXmn9r4QKHZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718384329; c=relaxed/simple;
	bh=/jnuDi+OpBZTy9KTUBfNfzCTNa69W+aTZSmuwL+hawI=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=U9ScErJX7iNzywcUj8mYhr32lUVDjm72l5Ti0+7zSyf9z/SP2RX3M67xuUJn9DJA7aXlxd70ko/Z5bZNBOv8T0GyY5zZ/uvQncDBO74oDvJRkrVfyetxlYWF5NcOm5UxJy7X6r14mgd/R2Zhs7H253orWheFvIl/ryIgcs2Vt2I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=GShl0MH5; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-2c2c91c9279so391822a91.0
        for <io-uring@vger.kernel.org>; Fri, 14 Jun 2024 09:58:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718384323; x=1718989123; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v5NSmPeu29fQ8r06G+QoQPTpF8PSGviJpOiks3bM0dQ=;
        b=GShl0MH5cswRpcaCwu4vEb5GChDrdDoj3CWU85QbQ1tI2YMQbMi8gGef1GdiQmdUzD
         02pDjk5Up2cFtvm5tez7EB2QoZSF4sQqr6Frn83exm/b+z2TbG5u9WqQ+W6PXd5fvCQF
         n6gGHA7DPNW8FsfAHO2wzmsxB8+FClkphZaQtJoUTApA0A98lvIgEcjHkF5C93fevq9f
         /dNFRD9hWViAF/srQuzTFwZrIyLfnm8ZnSHHesdLY/m7ybmQZqw2a7fdmois52IoyN7V
         kSFmjCnMugiVxGXdjkEQ/Sy/0PMAEhASWgePSRhWsDsnrSkskm/nOK3wnQusG+CBj7Sh
         ea7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718384323; x=1718989123;
        h=content-transfer-encoding:subject:from:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v5NSmPeu29fQ8r06G+QoQPTpF8PSGviJpOiks3bM0dQ=;
        b=qYOa0OAdGn6pZPX+CcxTTHkQO3Gzwn4pJlFrAqFn6j2fqbyDc1YZjHWTlZXg/DIR04
         4Wp3ZRERtrOY2pWs04Puuc6EWNmrQrhOs0A/OdlGxbHoYMzllLiWWiuQn2+dEZxMyOyG
         paMueqES9fsyo/gox72cFX4y/ksLP8QLa2lp2NhNsGkIeU1rvUMDBkKyM9MvfommCiTS
         PmvbhBHgsSkMpBjDId3IR4CwQJGFpzI5G/QJkVEEoyKlfKUoXI+ID9akUNYMt6Ki3VL9
         UL4tCC01JP61Bq2ZNnWNSV2w+OZRcHuRawMmg+X8REvihZyyvYP7tPfi6Fry+K0YYbil
         4SPw==
X-Gm-Message-State: AOJu0Yz2NikR2qp0MuCVHFIlgFcdEIxzHgC/n7phYrq9UaomHWlpJ+qb
	FFH7TO/PCntmj8K4+TW8cUPOgKM5V+gkYSFgGSGka6mhd96rvOWxpRSH6ieojJ/xkV0goi5pTOA
	L
X-Google-Smtp-Source: AGHT+IHYQE4jL2eFEX5dAx4EBc8D9OoQbPsEvQj9N6xD5jJCcR5RWRANSiAh5nqKeJdlSaQfJjCINQ==
X-Received: by 2002:a05:6a21:18e:b0:1b4:5605:ddf3 with SMTP id adf61e73a8af0-1bae8291da4mr3744495637.4.1718384323138;
        Fri, 14 Jun 2024 09:58:43 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-1f855f58d61sm34330665ad.299.2024.06.14.09.58.42
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jun 2024 09:58:42 -0700 (PDT)
Message-ID: <867c8031-6e02-4ce3-96a8-c87314b59804@kernel.dk>
Date: Fri, 14 Jun 2024 10:58:41 -0600
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
Subject: [PATCH for-next] io_uring/io-wq: make io_wq_work flags atomic
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

The work flags can be set/accessed from different tasks, both the
originator of the request, and the io-wq workers. While modifications
aren't concurrent, it still makes KMSAN unhappy. There's no real
downside to just making the flag reading/manipulation use proper
atomics here.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index a2227ab7fd16..d3f88b5e1195 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -50,7 +50,7 @@ struct io_wq_work_list {
 
 struct io_wq_work {
 	struct io_wq_work_node list;
-	unsigned flags;
+	atomic_t flags;
 	/* place it here instead of io_kiocb as it fills padding and saves 4B */
 	int cancel_seq;
 };
diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d1c47a9d9215..c3b9b2b269ff 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -159,7 +159,7 @@ static inline struct io_wq_acct *io_get_acct(struct io_wq *wq, bool bound)
 static inline struct io_wq_acct *io_work_get_acct(struct io_wq *wq,
 						  struct io_wq_work *work)
 {
-	return io_get_acct(wq, !(work->flags & IO_WQ_WORK_UNBOUND));
+	return io_get_acct(wq, !(atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND));
 }
 
 static inline struct io_wq_acct *io_wq_get_acct(struct io_worker *worker)
@@ -451,7 +451,7 @@ static void __io_worker_idle(struct io_wq *wq, struct io_worker *worker)
 
 static inline unsigned int io_get_work_hash(struct io_wq_work *work)
 {
-	return work->flags >> IO_WQ_HASH_SHIFT;
+	return atomic_read(&work->flags) >> IO_WQ_HASH_SHIFT;
 }
 
 static bool io_wait_on_hash(struct io_wq *wq, unsigned int hash)
@@ -592,8 +592,9 @@ static void io_worker_handle_work(struct io_wq_acct *acct,
 
 			next_hashed = wq_next_work(work);
 
-			if (unlikely(do_kill) && (work->flags & IO_WQ_WORK_UNBOUND))
-				work->flags |= IO_WQ_WORK_CANCEL;
+			if (do_kill &&
+			    (atomic_read(&work->flags) & IO_WQ_WORK_UNBOUND))
+				atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 			wq->do_work(work);
 			io_assign_current_work(worker, NULL);
 
@@ -891,7 +892,7 @@ static bool io_wq_worker_wake(struct io_worker *worker, void *data)
 static void io_run_cancel(struct io_wq_work *work, struct io_wq *wq)
 {
 	do {
-		work->flags |= IO_WQ_WORK_CANCEL;
+		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		wq->do_work(work);
 		work = wq->free_work(work);
 	} while (work);
@@ -926,7 +927,7 @@ static bool io_wq_work_match_item(struct io_wq_work *work, void *data)
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 {
 	struct io_wq_acct *acct = io_work_get_acct(wq, work);
-	unsigned long work_flags = work->flags;
+	unsigned long work_flags = atomic_read(&work->flags);
 	struct io_cb_cancel_data match;
 	bool do_create;
 
@@ -935,7 +936,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	 * been marked as one that should not get executed, cancel it here.
 	 */
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
-	    (work->flags & IO_WQ_WORK_CANCEL)) {
+	    (atomic_read(&work->flags) & IO_WQ_WORK_CANCEL)) {
 		io_run_cancel(work, wq);
 		return;
 	}
@@ -982,7 +983,7 @@ void io_wq_hash_work(struct io_wq_work *work, void *val)
 	unsigned int bit;
 
 	bit = hash_ptr(val, IO_WQ_HASH_ORDER);
-	work->flags |= (IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT));
+	atomic_or(IO_WQ_WORK_HASHED | (bit << IO_WQ_HASH_SHIFT), &work->flags);
 }
 
 static bool __io_wq_worker_cancel(struct io_worker *worker,
@@ -990,7 +991,7 @@ static bool __io_wq_worker_cancel(struct io_worker *worker,
 				  struct io_wq_work *work)
 {
 	if (work && match->fn(work, match->data)) {
-		work->flags |= IO_WQ_WORK_CANCEL;
+		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		__set_notify_signal(worker->task);
 		return true;
 	}
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index 2b2a6406dd8e..b3b004a7b625 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -56,7 +56,7 @@ bool io_wq_worker_stopped(void);
 
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
-	return work->flags & IO_WQ_WORK_HASHED;
+	return atomic_read(&work->flags) & IO_WQ_WORK_HASHED;
 }
 
 typedef bool (work_cancel_fn)(struct io_wq_work *, void *);
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0c86f504fc66..872477412726 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -462,9 +462,9 @@ static void io_prep_async_work(struct io_kiocb *req)
 	}
 
 	req->work.list.next = NULL;
-	req->work.flags = 0;
+	atomic_set(&req->work.flags, 0);
 	if (req->flags & REQ_F_FORCE_ASYNC)
-		req->work.flags |= IO_WQ_WORK_CONCURRENT;
+		atomic_or(IO_WQ_WORK_CONCURRENT, &req->work.flags);
 
 	if (req->file && !(req->flags & REQ_F_FIXED_FILE))
 		req->flags |= io_file_get_flags(req->file);
@@ -480,7 +480,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 			io_wq_hash_work(&req->work, file_inode(req->file));
 	} else if (!req->file || !S_ISBLK(file_inode(req->file)->i_mode)) {
 		if (def->unbound_nonreg_file)
-			req->work.flags |= IO_WQ_WORK_UNBOUND;
+			atomic_or(IO_WQ_WORK_UNBOUND, &req->work.flags);
 	}
 }
 
@@ -520,7 +520,7 @@ static void io_queue_iowq(struct io_kiocb *req)
 	 * worker for it).
 	 */
 	if (WARN_ON_ONCE(!same_thread_group(req->task, current)))
-		req->work.flags |= IO_WQ_WORK_CANCEL;
+		atomic_or(IO_WQ_WORK_CANCEL, &req->work.flags);
 
 	trace_io_uring_queue_async_work(req, io_wq_is_hashed(&req->work));
 	io_wq_enqueue(tctx->io_wq, &req->work);
@@ -1736,14 +1736,14 @@ void io_wq_submit_work(struct io_wq_work *work)
 	io_arm_ltimeout(req);
 
 	/* either cancelled or io-wq is dying, so don't touch tctx->iowq */
-	if (work->flags & IO_WQ_WORK_CANCEL) {
+	if (atomic_read(&work->flags) & IO_WQ_WORK_CANCEL) {
 fail:
 		io_req_task_queue_fail(req, err);
 		return;
 	}
 	if (!io_assign_file(req, def, issue_flags)) {
 		err = -EBADF;
-		work->flags |= IO_WQ_WORK_CANCEL;
+		atomic_or(IO_WQ_WORK_CANCEL, &work->flags);
 		goto fail;
 	}
 
-- 
Jens Axboe


