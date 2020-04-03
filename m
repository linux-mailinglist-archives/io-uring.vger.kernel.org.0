Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B99719DD32
	for <lists+io-uring@lfdr.de>; Fri,  3 Apr 2020 19:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728366AbgDCRwv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 3 Apr 2020 13:52:51 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40790 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727882AbgDCRwv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 3 Apr 2020 13:52:51 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so2988751plk.7
        for <io-uring@vger.kernel.org>; Fri, 03 Apr 2020 10:52:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=YdV0wz9pZK1U4jEmmXWQ/dvZRqgGT+g94HH9cHELPh0=;
        b=j718H2qnGG2LrwZKqvAvOKMkk6GCaj18iEgzTa3NawM4dRQrSIWUXuB5XLbqj7kSLM
         PNPLEFnCAfwCqRMxQrlG6oiLnvsk9Rn17Fjq91qGrQ+cq1dRsI9klPmzii2HPnrcFCwD
         WpSYa+p6ad5kbJtl6DQLmpYqLoeQ+6uig8GdrsknZH7ksnSnctx8zbW69QF63zjfIViO
         o7D6mDV06we7RqkeUPMrY9JEHgvIySx3df1F+0LQw51WqQAlmQ78JCxfd6aAdkbFZHru
         +CSUl/mUabnEBZw1ELAsdydOwRQ9MorNQ3yF9f1Gs2qHdCCqG981uYukbVzzmYwSO8C7
         Goyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YdV0wz9pZK1U4jEmmXWQ/dvZRqgGT+g94HH9cHELPh0=;
        b=k1X3jZfxZ0Yj4iIxwjdTwuOUnqumIDpXsl+/2/k4EFL/y3g7qgmciRWnrLarmmP7MU
         /QfNcAHZa9gG+k0ql+B99b3pkfGpAtvvPR3o7ylAld8y0VnP0npQgtMEY7MMHEscZMgd
         yskYgmRl2M5hNmUg06Qtfd9kRtCJ6S/Iw1/PMIVpntz+egSyGV6g97BA14lnRzJ3WR/K
         5uznN4roE7VA3qy/j3BFcd9NVv1TiBkHE1Fo+7hjvQoNn8JALQaJ8sYs15Q6t7htY1fC
         8RReLI71mGJRoO90mwUbn04hcJy71qBhZwm+NeNgzimVaykDnbL5i9HWZaCIu12Hwm76
         2rqw==
X-Gm-Message-State: AGi0PuYaPWCQIKjPeE//IfwYAVJx+iWV3mX1HJwAnrbb8buATmYJSsW8
        lfUDvPU9za1/i2iKKukcjxOyT+0gY8qsZA==
X-Google-Smtp-Source: APiQypLbyi0J54VAmGajdtth8EmA1fh2AXLQBIH1bGeZrWvv+235LVHee3JIZqAw7k2z2r9V7wVXsg==
X-Received: by 2002:a17:902:be15:: with SMTP id r21mr8968205pls.312.1585936369455;
        Fri, 03 Apr 2020 10:52:49 -0700 (PDT)
Received: from x1.localdomain ([2620:10d:c090:400::5:8ed0])
        by smtp.gmail.com with ESMTPSA id f8sm6168449pfq.178.2020.04.03.10.52.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Apr 2020 10:52:49 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, Dan Melnic <dmm@fb.com>
Subject: [PATCH 2/3] io_uring: grab task reference for poll requests
Date:   Fri,  3 Apr 2020 11:52:42 -0600
Message-Id: <20200403175243.14009-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200403175243.14009-1-axboe@kernel.dk>
References: <20200403175243.14009-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can have a task exit if it's not the owner of the ring. Be safe and
grab an actual reference to it, to avoid a potential use-after-free.

Reported-by: Dan Melnic <dmm@fb.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 19 +++++++------------
 1 file changed, 7 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ad4a151994d..b343525a4d2e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -615,10 +615,8 @@ struct io_kiocb {
 	struct list_head	list;
 	unsigned int		flags;
 	refcount_t		refs;
-	union {
-		struct task_struct	*task;
-		unsigned long		fsize;
-	};
+	struct task_struct	*task;
+	unsigned long		fsize;
 	u64			user_data;
 	u32			result;
 	u32			sequence;
@@ -1336,6 +1334,7 @@ static struct io_kiocb *io_get_req(struct io_ring_ctx *ctx,
 	req->flags = 0;
 	/* one is dropped after submission, the other at completion */
 	refcount_set(&req->refs, 2);
+	req->task = NULL;
 	req->result = 0;
 	INIT_IO_WORK(&req->work, io_wq_submit_work);
 	return req;
@@ -1372,6 +1371,8 @@ static void __io_req_aux_free(struct io_kiocb *req)
 	kfree(req->io);
 	if (req->file)
 		io_put_file(req, req->file, (req->flags & REQ_F_FIXED_FILE));
+	if (req->task)
+		put_task_struct(req->task);
 
 	io_req_work_drop_env(req);
 }
@@ -4256,10 +4257,7 @@ static bool io_arm_poll_handler(struct io_kiocb *req)
 	req->flags |= REQ_F_POLLED;
 	memcpy(&apoll->work, &req->work, sizeof(req->work));
 
-	/*
-	 * Don't need a reference here, as we're adding it to the task
-	 * task_works list. If the task exits, the list is pruned.
-	 */
+	get_task_struct(current);
 	req->task = current;
 	req->apoll = apoll;
 	INIT_HLIST_NODE(&req->hash_node);
@@ -4482,10 +4480,7 @@ static int io_poll_add_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 	events = READ_ONCE(sqe->poll_events);
 	poll->events = demangle_poll(events) | EPOLLERR | EPOLLHUP;
 
-	/*
-	 * Don't need a reference here, as we're adding it to the task
-	 * task_works list. If the task exits, the list is pruned.
-	 */
+	get_task_struct(current);
 	req->task = current;
 	return 0;
 }
-- 
2.26.0

