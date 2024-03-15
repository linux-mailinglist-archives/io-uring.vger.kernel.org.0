Return-Path: <io-uring+bounces-959-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 785D287D054
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 16:31:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 392AE2829E7
	for <lists+io-uring@lfdr.de>; Fri, 15 Mar 2024 15:31:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4275B3D97F;
	Fri, 15 Mar 2024 15:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hv/mggmY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62D5D405F2;
	Fri, 15 Mar 2024 15:31:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710516681; cv=none; b=LzMUVAsG258kU3+53ShL+Nyov4q7KU8z5jK9aqZwRJxFkV9V1HDLQ6Rpy43OFHL6kEjqKx/3087NidM1lBHzQ8KRTHh2B87QL6sjh0xRl6HmWoRJuKJ3tjXjFJWH2vBGbpZC/hB4MQa24PD5PgByy5d4UaSQsLrSfJnI/PWu6nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710516681; c=relaxed/simple;
	bh=qr+OEoI4upU9Yi8B9mRLbLGrCTyXCm30+PolMuN56HQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UYN8vUlJ1Vt0vly6853eNfDSvgvps+Du4DWwyJH7ZzlQHPRQGSM153ZE34x6z4zJjzxKu1BhwcsQAmeCQihsfiRYLOc0hk2t1mOMtV4irPPOqr66G3pjE1QkDucYXgYsW3wCCoTmgpmvCT+VG8myn+5LrI2aNt53hjj2XBqipck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hv/mggmY; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-33ec8aa8b6bso1345666f8f.3;
        Fri, 15 Mar 2024 08:31:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710516677; x=1711121477; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eGBFnnncz6Ltll0EYPFfWplud6SFUjJrE80gGTXdd+Q=;
        b=hv/mggmYETy9XB0Wom4kneyLWrZu55233qAWY7Zi+2jP5y6zMCa4sRaZeCpcUDitKS
         Nv5hDH/330HyZenV5adRCht0OfstNlrSHLjLT2obc25JyqQn7QKQExL0EhNYBhYPBmpv
         JJ+5XgioEj+oY8i+EAqhMSON5BY+mYsncloMsVdehJtyJ1rZz+gcnl/Dl1Zc+s2ytfeQ
         XNjuqirPzwpCIwbIgs8OTZJOj2thMj1fVoqKDLMTJKtmUqUCUbNzLeONwY9f7ZnEJy3I
         XZE8kQ4xY+UHOXIArv3C7CY4umWz9JLkMqDkGkl4cBL6xRDR0OqVTK5sMq2qjH6f/I0R
         Bmbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710516677; x=1711121477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eGBFnnncz6Ltll0EYPFfWplud6SFUjJrE80gGTXdd+Q=;
        b=gibHdyGt2MjJv3hL6v4tnuSv0hfQplrr722GV643xuYiPNIGg76Nm8UjkufdQ7xEgD
         f5M4181c44pul4yYPqWRE1g3LpS4LxpQm2ybGGLJtuDmTWwJHOMXKHAj6w7mEprHlzJN
         4hWFwhpEhX6gbvHJPgn4VUehHVqQbY7n+37KBFQDx4l4lurmVXmuw9VRH8xV+nGQ4C5g
         zo8S8KpK2Q77jN9lfoTYu6v0waHNlaHY2/+ZvjjgxVeh/b5ci8IvLSqh88Z4TVZWLNMr
         PyLCqDJIi4/EUtEB5ddgc2MJxA6MVTE2YyC7vJzYxPzx+nGSc3ooN589d49d2SnCfjQY
         vD4w==
X-Gm-Message-State: AOJu0YxIJxvHyArpP9Zb53bY7mF4hgNCk2jhMSCPNoJEMcWgWkGOZ9iD
	ynE4v+rLJEtcVRU/z5AFB2fLo+hyI0aJC9qoPSc102BJSsO9oQGIrNUErXHC
X-Google-Smtp-Source: AGHT+IEHPfIrmHQOGaR2L7bbEgKtH+Dbk8yUbaOIs5ku+arMHilyRycdAH50Ph1DFBF4SUg4CT9sIA==
X-Received: by 2002:a5d:680b:0:b0:33e:ae46:f9d with SMTP id w11-20020a5d680b000000b0033eae460f9dmr3639618wru.4.1710516677558;
        Fri, 15 Mar 2024 08:31:17 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.141.58])
        by smtp.gmail.com with ESMTPSA id u3-20020a5d6ac3000000b0033dd2c3131fsm3415671wrw.65.2024.03.15.08.31.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Mar 2024 08:31:17 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: linux-block@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Kanchan Joshi <joshi.k@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH 07/11] io_uring/rw: avoid punting to io-wq directly
Date: Fri, 15 Mar 2024 15:29:57 +0000
Message-ID: <595021a813bebf0256e80b95bcc594377096e08b.1710514702.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1710514702.git.asml.silence@gmail.com>
References: <cover.1710514702.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kiocb_done() should care to specifically redirecting requests to io-wq.
Remove the hopping to tw to then queue an io-wq, return -EAGAIN and let
the core code io_uring handle offloading.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 8 ++++----
 io_uring/io_uring.h | 1 -
 io_uring/rw.c       | 8 +-------
 3 files changed, 5 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3ae4bb988906..4ad85460ed2a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -498,7 +498,7 @@ static void io_prep_async_link(struct io_kiocb *req)
 	}
 }
 
-void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use)
+static void io_queue_iowq(struct io_kiocb *req)
 {
 	struct io_kiocb *link = io_prep_linked_timeout(req);
 	struct io_uring_task *tctx = req->task->io_uring;
@@ -1505,7 +1505,7 @@ void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts)
 	if (unlikely(req->task->flags & PF_EXITING))
 		io_req_defer_failed(req, -EFAULT);
 	else if (req->flags & REQ_F_FORCE_ASYNC)
-		io_queue_iowq(req, ts);
+		io_queue_iowq(req);
 	else
 		io_queue_sqe(req);
 }
@@ -2088,7 +2088,7 @@ static void io_queue_async(struct io_kiocb *req, int ret)
 		break;
 	case IO_APOLL_ABORTED:
 		io_kbuf_recycle(req, 0);
-		io_queue_iowq(req, NULL);
+		io_queue_iowq(req);
 		break;
 	case IO_APOLL_OK:
 		break;
@@ -2135,7 +2135,7 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 		if (unlikely(req->ctx->drain_active))
 			io_drain_req(req);
 		else
-			io_queue_iowq(req, NULL);
+			io_queue_iowq(req);
 	}
 }
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 6426ee382276..472ba5692ba8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -79,7 +79,6 @@ struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 void __io_req_task_work_add(struct io_kiocb *req, unsigned flags);
 bool io_alloc_async_data(struct io_kiocb *req);
 void io_req_task_queue(struct io_kiocb *req);
-void io_queue_iowq(struct io_kiocb *req, struct io_tw_state *ts_dont_use);
 void io_req_task_complete(struct io_kiocb *req, struct io_tw_state *ts);
 void io_req_task_queue_fail(struct io_kiocb *req, int ret);
 void io_req_task_submit(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 0585ebcc9773..576934dbf833 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -187,12 +187,6 @@ static inline loff_t *io_kiocb_update_pos(struct io_kiocb *req)
 	return NULL;
 }
 
-static void io_req_task_queue_reissue(struct io_kiocb *req)
-{
-	req->io_task_work.func = io_queue_iowq;
-	io_req_task_work_add(req);
-}
-
 #ifdef CONFIG_BLOCK
 static bool io_resubmit_prep(struct io_kiocb *req)
 {
@@ -405,7 +399,7 @@ static int kiocb_done(struct io_kiocb *req, ssize_t ret,
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		if (io_resubmit_prep(req))
-			io_req_task_queue_reissue(req);
+			return -EAGAIN;
 		else
 			io_req_task_queue_fail(req, final_ret);
 	}
-- 
2.43.0


