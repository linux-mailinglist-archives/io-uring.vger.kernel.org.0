Return-Path: <io-uring+bounces-75-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7F08E7E5AE9
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 17:14:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AD8E11C20B1E
	for <lists+io-uring@lfdr.de>; Wed,  8 Nov 2023 16:14:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0299230D1E;
	Wed,  8 Nov 2023 16:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="e83Yh2/g"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCD03064B
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 16:14:23 +0000 (UTC)
Received: from mail-io1-xd29.google.com (mail-io1-xd29.google.com [IPv6:2607:f8b0:4864:20::d29])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 371A119A5
	for <io-uring@vger.kernel.org>; Wed,  8 Nov 2023 08:14:23 -0800 (PST)
Received: by mail-io1-xd29.google.com with SMTP id ca18e2360f4ac-7748ca56133so74226039f.0
        for <io-uring@vger.kernel.org>; Wed, 08 Nov 2023 08:14:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1699460062; x=1700064862; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7FANGRKJdd1K1gxSe0vb51y9V3G9dxp/SdL5JmaNK1Y=;
        b=e83Yh2/gt9l43NtVKRQ3M7/qmpGzGH9iEwo8BrYvx6KYIpaEEQZk2Qxvmfkrx7WHE3
         ihOtUc6j0psTsld0UgIAJ31k0jVO3qtJR3ed7SCM+2M14HCY3yt6anuT1ZOZVCJBt8GY
         Q0JKkr+cMpH6nqA7PtMXWH6dPbTadzwBcQYD3impnETbb5K9iszMXUhWrw/vCSHixtdA
         L6+ORPRd40mv82PHi0mj1gTF80INSRS/kQJc0eZCM4H96e1D1KzlmH9+VKO3nVzTt8Q+
         /y2qK2MuyApdPf29TmsVnG0QEWgvIZnVeSrYVjt/8w9zVb2d79VIvxxPYNakQid71ud0
         GxMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699460062; x=1700064862;
        h=content-transfer-encoding:in-reply-to:references:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7FANGRKJdd1K1gxSe0vb51y9V3G9dxp/SdL5JmaNK1Y=;
        b=ERw+yv/fh6oRAd0WDzbWY2kKYxf7Ks5wVsINroKLVTFV+vC/UEsZKyLN45+7C70imp
         vhQXDKP8mvQDzo9X3TLWd2m49EHsb5XAAawU5+RqhKnp1c+Ae1W4T1YVa4OdwXZWc73r
         jgpMmQRTZ/e/b/4/UKnk76kYf6MI/iPlrHAQ1qjQrWAdn0Vj+pVQHbhRa719pqwzv6k5
         jB+Ep4mMtomKaC9jMwO4BBhL/c9+4kMmtR3owNAB0aSLBpbMCUdic8nEDemyGJQtyzcx
         jsfRElk6Wl4i43qqTuWnYDwsnkiSlNPYAlvm8G+jgYxqsOxRvApG/xYr31qaSpsWW6Q2
         Vm6w==
X-Gm-Message-State: AOJu0YzIXX0wh6e9+EkiqOvqtNlqgPk/daYAY96NA4ET9X6HyWzehlrU
	0p6/9XBKybibQHGCjl06h/jM4Q==
X-Google-Smtp-Source: AGHT+IFh7EhNQnH5PoYC6wt5tltq0YFZh3+7jNoI8LjLWYWgg4BfllyUpKCBbR9/pQv20swyVyFbRA==
X-Received: by 2002:a5d:9306:0:b0:7ad:5c6f:18db with SMTP id l6-20020a5d9306000000b007ad5c6f18dbmr2426528ion.0.1699460062506;
        Wed, 08 Nov 2023 08:14:22 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h10-20020a056638062a00b00439f2a2cdfbsm3293378jar.138.2023.11.08.08.14.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Nov 2023 08:14:21 -0800 (PST)
Message-ID: <bc86e6cf-1c15-466b-a4f9-074af944d7da@kernel.dk>
Date: Wed, 8 Nov 2023 09:14:21 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/poll: use IOU_F_TWQ_LAZY_WAKE for wakeups
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
To: Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>
References: <e6bcdcb4-8a3d-48a1-8301-623cd30430e6@kernel.dk>
 <55fe5c04-f3c2-5d39-0ff3-e086bf4a13cc@gmail.com>
 <faa79714-a894-4f19-b798-176e12fbf96f@kernel.dk>
In-Reply-To: <faa79714-a894-4f19-b798-176e12fbf96f@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

In the spirit of getting some closure/progress on this, how about this
for starters? Disables lazy wake for poll_exclusive, and provides a flag
that can otherwise be set to disable it as well.
 
diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index d3009d56af0b..03401c6ce5bb 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -431,6 +431,7 @@ enum {
 	/* keep async read/write and isreg together and in order */
 	REQ_F_SUPPORT_NOWAIT_BIT,
 	REQ_F_ISREG_BIT,
+	REQ_F_POLL_NO_LAZY_BIT,
 
 	/* not a real bit, just to check we're not overflowing the space */
 	__REQ_F_LAST_BIT,
@@ -498,6 +499,8 @@ enum {
 	REQ_F_CLEAR_POLLIN	= BIT(REQ_F_CLEAR_POLLIN_BIT),
 	/* hashed into ->cancel_hash_locked, protected by ->uring_lock */
 	REQ_F_HASH_LOCKED	= BIT(REQ_F_HASH_LOCKED_BIT),
+	/* don't use lazy poll wake for this request */
+	REQ_F_POLL_NO_LAZY	= BIT(REQ_F_POLL_NO_LAZY_BIT),
 };
 
 typedef void (*io_req_tw_func_t)(struct io_kiocb *req, struct io_tw_state *ts);
diff --git a/io_uring/poll.c b/io_uring/poll.c
index d38d05edb4fa..4fed5514c379 100644
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
@@ -526,10 +531,17 @@ static void __io_queue_proc(struct io_poll *poll, struct io_poll_table *pt,
 	poll->head = head;
 	poll->wait.private = (void *) wqe_private;
 
-	if (poll->events & EPOLLEXCLUSIVE)
+	if (poll->events & EPOLLEXCLUSIVE) {
+		/*
+		 * Exclusive waits may only wake a limited amount of entries
+		 * rather than all of them, this may interfere with lazy
+		 * wake if someone does wait(events > 1).
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


