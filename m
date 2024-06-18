Return-Path: <io-uring+bounces-2253-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F1EB890DBD9
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 20:47:06 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 014C31C2281E
	for <lists+io-uring@lfdr.de>; Tue, 18 Jun 2024 18:47:06 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC32C14F9E6;
	Tue, 18 Jun 2024 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3MXZ59Va"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3022447773
	for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 18:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718736423; cv=none; b=HSUXorbCHOTh721H6BhXXGm4X5giO33tjKynY3jCDuEydjrNP31oOYhMl2gJww3um1wsgLWkGsnek/0LQnaLViPILCPx8nkgAMH4McOLRZhTY1ZOyjUNIaSGQ7draPDjcbSC0S8flEucExQcyxc5OVS/TymWf3i/sa0wacuHSRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718736423; c=relaxed/simple;
	bh=6I7S3LD+MF4Y3yKr44LYVQSEPoCHIZGettAFAnQ2d/g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=isn4/xisMRhOC6myWmK6OGTNGcdg/OCdG1jshJXbYNzdVWqdJnpttgkbvJE2P/VJVRoyLVoS3SEvlOU8N92eYXnIGdH6XdQoQqsE67YdCikt+wTBkoiEooFHHPAaKxx0iGRwkE4wR6ZRFCIT9cga3EDMfxR8xL/n1MGX2VGT8ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3MXZ59Va; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-250aa23752dso617144fac.3
        for <io-uring@vger.kernel.org>; Tue, 18 Jun 2024 11:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1718736418; x=1719341218; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/GASY44HJ12uOYit25Y+j0bioaQc7cr1ASiKsbOuWMI=;
        b=3MXZ59Van2msneH+NIua3Bmy/7jXVRkwtKJl/p/7UEER3LD3Zwktml9RDwPXOBPjtN
         AaAJwYuswB4+Bdq3E2J0Q5eepuhbKlBlfPJwSDoFXsJXoVNsSMlfRdj49h/0617kwHHF
         yfs7CK/9QRE80w/mh6Sk6ZgWL3SYx43URJm+jb1FvhtxlULpehaaHCX7/CeQ4uAwpmKW
         jXWq06Beiy3tUgZw3r7Soo1oz6IYo0coGUwQpOaYJpcEbgmZ7qBy4/+SSq2npMc0hVU7
         S7fBQKnVlDyxhJ3yqFQrI4RzcdTdGuI0rGXROwFzBCHbUOxWCIr8D9rPigSvQyKdjOn2
         GUrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718736418; x=1719341218;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/GASY44HJ12uOYit25Y+j0bioaQc7cr1ASiKsbOuWMI=;
        b=bpAgYVwJ+FGJ2tPoHDNC65c4Xdx0tLpGArLy6cMfcPiQz2/W6tskIwjSwdGx/16Iy4
         Z3HJaUWqemgbJbmQAhz6cZCu2mOWEiyFQxQ9lZKtZ4P8ttrpt2EjWT+/1kiUfS8oicKI
         k7S1GYSNah323jt8tolVcBXkdpL5NHjqbA2Z4B0ox4sr4jeWQfEKhjfDgF6XzTVv6JPd
         3B+pxcQTGDN7Kyzv+cSH/P23exlWsCevn1Hv0vKGfYEZGVnCdf52jF90vab/1waJ9nre
         zLW+44SdRpA6FYYrXSUchtSWN0qdBoHn16rT0j3IdSzCh4/o7qSvIzmPH/27G/hbKV5N
         bj/A==
X-Gm-Message-State: AOJu0YzDDhW6lvoGrpe3pT1vyRt9z86DZAcEpIREgDg4eRylkDp2N8ww
	IiRKrQJrRpgAC1Ivu5nsC36Zc4PhO7JcUgUCK+OFMynHZWP/f9m8HHx93V+ofc32HO1tEydkz92
	5
X-Google-Smtp-Source: AGHT+IHitW0Xxo+4RsvBn4oL3gURnpRNBJ6DWJvKJac00k4jFAYaVP6hwx/cHfHye5MNCBEpm4o/XA==
X-Received: by 2002:a05:6871:3311:b0:259:862f:b898 with SMTP id 586e51a60fabf-25c94e0cb59mr673446fac.5.1718736417723;
        Tue, 18 Jun 2024 11:46:57 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-2567aa5e68asm3297475fac.30.2024.06.18.11.46.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jun 2024 11:46:56 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@r7625.kernel.dk>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/io-wq: make io_wq_work flags atomic
Date: Tue, 18 Jun 2024 12:43:52 -0600
Message-ID: <20240618184652.71433-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240618184652.71433-1-axboe@kernel.dk>
References: <20240618184652.71433-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Jens Axboe <axboe@r7625.kernel.dk>

The work flags can be set/accessed from different tasks, both the
originator of the request, and the io-wq workers. While modifications
aren't concurrent, it still makes KMSAN unhappy. There's no real
downside to just making the flag reading/manipulation use proper
atomics here.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 +-
 io_uring/io-wq.c               | 19 ++++++++++---------
 io_uring/io-wq.h               |  2 +-
 io_uring/io_uring.c            | 12 ++++++------
 4 files changed, 18 insertions(+), 17 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 850e30be9322..1052a68fd68d 100644
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
index 7d3316fe9bfc..913c92249522 100644
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
+	unsigned int work_flags = atomic_read(&work->flags);
 	struct io_cb_cancel_data match = {
 		.fn		= io_wq_work_match_item,
 		.data		= work,
@@ -939,7 +940,7 @@ void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work)
 	 * been marked as one that should not get executed, cancel it here.
 	 */
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state) ||
-	    (work->flags & IO_WQ_WORK_CANCEL)) {
+	    (work_flags & IO_WQ_WORK_CANCEL)) {
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
index 57382e523b33..438c44ca3abd 100644
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
2.43.0


