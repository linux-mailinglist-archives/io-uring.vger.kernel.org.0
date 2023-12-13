Return-Path: <io-uring+bounces-283-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C015B811887
	for <lists+io-uring@lfdr.de>; Wed, 13 Dec 2023 17:01:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 028141C20957
	for <lists+io-uring@lfdr.de>; Wed, 13 Dec 2023 16:01:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CC2685374;
	Wed, 13 Dec 2023 16:01:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="czXwa2RD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24859AC
	for <io-uring@vger.kernel.org>; Wed, 13 Dec 2023 08:01:24 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7b70c2422a8so53686039f.0
        for <io-uring@vger.kernel.org>; Wed, 13 Dec 2023 08:01:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1702483282; x=1703088082; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5Ddlfr/9kR5ZjFSN4OOQCOI802wNOLQahmlg9Cy+wAE=;
        b=czXwa2RDe+oMCs24h9MobRtZoUYYEPQPLswLQ31qTQOFRnwKHkb9oNSIwlYMDbPuqU
         GIJmGUtPs0HUd7R/4jMtMfwZAfXATZXhGHJK5kZI/bc4Up0GLEjoh2ad0YUyqKlFQNER
         Q1tr8+1NV2kI6y1Idf9S9QM1tuavudfri0fhUj5lgGYPiWHKAK6i1dbE8D1nowNr03ew
         OSgxg0BmzrxN5phqcD5xMuHII0UDagBpqUwqv4yoXQcOcNkLi9dj7IgzgXNhxLb4nG/O
         SzOIiQHx+18+QVYD0vsAxvE0Sv5kT3oi2CRu6NWtQReqxrWy4fh8NiQEjlY+gTtnLLK8
         yueQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702483282; x=1703088082;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=5Ddlfr/9kR5ZjFSN4OOQCOI802wNOLQahmlg9Cy+wAE=;
        b=GU5Alm6F+iBeYWNmXGCXyiP1U+tHa0ylyc1x8OomlGH/mai3ieGKUMdb6yZEyhkpaz
         CLAdpcIXMT7oKvzx9eLhKTmeHo47l6xeJYexuRJSQcHMM5urA8G4sV/0onPqt7gRGP0A
         OPi0xIpycjVhIE2OA5c/W+Xfow+4oCNeDgnlVdO6dop4P89NV902WSihat2jcjCJ6Rd8
         sxJSiAkd4BXlq10uR5Zpj+TY/g65g6XkiuBG/sggN8wyNY+VyVgNZiarQn+32QK2BehS
         dVywv2JETj+Xc259PnaHt6qWGoz4xQ1nWY+BwNDRTiHqW2IThoXbaUkfkxCQI7WnJoba
         ovGw==
X-Gm-Message-State: AOJu0YzpETGvTVaJqLNKAyETpHNVZSnunYkBHjxug2IDBAToH0GgGAnG
	9pe6Z0jfx4AEDBcv1qowKYi/mD4UCjJ1Z0AFAQAEjg==
X-Google-Smtp-Source: AGHT+IHYay49/07tOlDl3W45p0zKKIXjGR/VUsGW1fUv2SJickLKhbNJCEbQbdlhb9uP2akSP3nwlg==
X-Received: by 2002:a05:6e02:1565:b0:35e:6ae2:a4b7 with SMTP id k5-20020a056e02156500b0035e6ae2a4b7mr14367320ilu.2.1702483282646;
        Wed, 13 Dec 2023 08:01:22 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h6-20020a92c086000000b0035d5935e19bsm3659973ile.65.2023.12.13.08.01.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Dec 2023 08:01:22 -0800 (PST)
Message-ID: <d5f697c5-7505-46a1-b266-cb48a1bbe911@kernel.dk>
Date: Wed, 13 Dec 2023 09:01:20 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/poll: don't enable lazy wake for POLLEXCLUSIVE
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

There are a few quirks around using lazy wake for poll unconditionally,
and one of them is related the EPOLLEXCLUSIVE. Those may trigger
exclusive wakeups, which wake a limited number of entries in the wait
queue. If that wake number is less than the number of entries someone is
waiting for (and that someone is also using DEFER_TASKRUN), then we can
get stuck waiting for more entries while we should be processing the ones
we already got.

If we're doing exclusive poll waits, flag the request as not being
compatible with lazy wakeups.

Reported-by: Pavel Begunkov <asml.silence@gmail.com>
Fixes: 6ce4a93dbb5b ("io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups")
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 805bb635cdf5..239a4f68801b 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -434,6 +434,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_POLL_NO_LAZY_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -501,6 +502,8 @@ enum {
 	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
 	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
+	/* don't use lazy poll wake for this request */
+	REQ_F_POLL_NO_LAZY	= BIT(REQ_F_POLL_NO_LAZY_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index d38d05edb4fa..d59b74a99d4e 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -366,11 +366,16 @@ void io_poll_task_func(struct io_kiocb *req, struct io_tw_state *ts)
 
 static void __io_poll_execute(struct io_kiocb *req, int mask)
 {
+	unsigned flags = 0;
+
 	io_req_set_res(req, mask, 0);
 	req->io_task_work.func = io_poll_task_func;
 
 	trace_io_uring_task_add(req, mask);
-	__io_req_task_work_add(req, IOU_F_TWQ_LAZY_WAKE);
+
+	if (!(req->flags & REQ_F_POLL_NO_LAZY))
+		flags = IOU_F_TWQ_LAZY_WAKE;
+	__io_req_task_work_add(req, flags);
 }
 
 static inline void io_poll_execute(struct io_kiocb *req, int res)
@@ -526,10 +531,19 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 	poll->head = head;
 	poll->wait.private = (void *) wqe_private;
 
-	if (poll->events & EPOLLEXCLUSIVE)
+	if (poll->events & EPOLLEXCLUSIVE) {
+		/*
+		 * Exclusive waits may only wake a limited amount of entries
+		 * rather than all of them, this may interfere with lazy
+		 * wake if someone does wait(events > 1). Ensure we don't do
+		 * lazy wake for those, as we need to process each one as they
+		 * come in.
+		 */
+		req->flags |= REQ_F_POLL_NO_LAZY;
 		add_wait_queue_exclusive(head, &poll->wait);
-	else
+	} else {
 		add_wait_queue(head, &poll->wait);
+	}
 }
 
 static void io_poll_queue_proc(struct file *file, struct wait_queue_head *head,

-- 
Jens Axboe


