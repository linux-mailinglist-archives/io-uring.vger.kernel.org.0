Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 770CF20C74D
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726069AbgF1JyW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1JyV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:21 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45D83C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:21 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id p20so13327908ejd.13
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cilG4gzWHjSy9Cb9/aAw+fgXJh3Ynt0J35NCA4wQg7o=;
        b=jRjsH7sVYvFFZz5GbJSMOACcYRWuyxWPfIzUGRK7pSz45zmNQO/BGZsi8b5SvAwhmZ
         cvb7P2v59YkjLovjssiRWtgWumrHdn9bqjW5xOcovv0zD2ykp6YKhVo/WvfiYSLNz/dY
         UVGc27wes/4HtnsE+lbN6garXJlVBQ0/Rt/w2eNj3H9CQO9EtSuc8fJHq9Ff78HoZvER
         lR4ONLrsg1hnzj/s5XlalJMSsrguRM99CBoVfDJ6P5Cs4HBKB3TO09KjVxAmOXzh8P/6
         iKgu75/0SJGegFo0HhNYR2u0sCym9QzK8ELZyLOXAHt1eguCpIz5uGjvceZrezkObv83
         b8Jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cilG4gzWHjSy9Cb9/aAw+fgXJh3Ynt0J35NCA4wQg7o=;
        b=Rzkow698ccGz+hpzSeAc0qsiyXihhUscVEoeuaiKZpjhfL8kccsEETQtWGffD+AuEn
         5K1tVpWov+M2t7xqzooXVGg9W69DKZ/89WAZLQtG/prXcwArlm8MwjmHYToPcwTfQzzd
         Ayq3SYP4iGMTl90j4nkRUT9CxinrJPy5M6KJDjilXorRzUC+1BDWl7I5V9ocfJ77q8C/
         MutwV14YKHkWD0wiROQVZf6cgSL/JjE3omrKjNPdZVh7FD0h5g4Yy1UWebrWoHBHTH33
         6Ufn9rYAoGpFuTLeJrkFalYkEyytQa2a85XtjhIKZZeFsf2lR8Z0geneRGAR3g58RmWo
         ul2w==
X-Gm-Message-State: AOAM533tpHsojznPxtt4TfZ3Nbd1V9i3maN9PRcYieug1gfSHatZIZZV
        ygtj6mGRYVj71p4npn9zK3JgcJMN
X-Google-Smtp-Source: ABdhPJxPazXgMNcCRUhKyte3F/DtcLndEeHSszff1c4MsuVBFbcT0djc9ODLqigGxLTIXWKC4OfjHQ==
X-Received: by 2002:a17:906:8406:: with SMTP id n6mr9253212ejx.250.1593338059937;
        Sun, 28 Jun 2020 02:54:19 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/10] io_uring: fix refs underflow in io_iopoll_queue()
Date:   Sun, 28 Jun 2020 12:52:29 +0300
Message-Id: <8122af4ead0571f80143c3509d71cae16b17535a.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Now io_complete_rw_common() puts a ref, extra io_req_put()
in io_iopoll_queue() causes undeflow. Remove it.

[  455.998620] refcount_t: underflow; use-after-free.
[  455.998743] WARNING: CPU: 6 PID: 285394 at lib/refcount.c:28
	refcount_warn_saturate+0xae/0xf0
[  455.998772] CPU: 6 PID: 285394 Comm: read-write2 Tainted: G
          I E     5.8.0-rc2-00048-g1b1aa738f167-dirty #509
[  455.998772] RIP: 0010:refcount_warn_saturate+0xae/0xf0
...
[  455.998778] Call Trace:
[  455.998778]  io_put_req+0x44/0x50
[  455.998778]  io_iopoll_complete+0x245/0x370
[  455.998779]  io_iopoll_getevents+0x12f/0x1a0
[  455.998779]  io_iopoll_reap_events.part.0+0x5e/0xa0
[  455.998780]  io_ring_ctx_wait_and_kill+0x132/0x1c0
[  455.998780]  io_uring_release+0x20/0x30
[  455.998780]  __fput+0xcd/0x230
[  455.998781]  ____fput+0xe/0x10
[  455.998781]  task_work_run+0x67/0xa0
[  455.998781]  do_exit+0x35d/0xb70
[  455.998782]  do_group_exit+0x43/0xa0
[  455.998783]  get_signal+0x140/0x900
[  455.998783]  do_signal+0x37/0x780
[  455.998784]  __prepare_exit_to_usermode+0x126/0x1c0
[  455.998785]  __syscall_return_slowpath+0x3b/0x1c0
[  455.998785]  do_syscall_64+0x5f/0xa0
[  455.998785]  entry_SYSCALL_64_after_hwframe+0x44/0xa9

Fixes: a1d7c393c47 ("io_uring: enable READ/WRITE to use deferred completions")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf236ba10601..52441f2465fe 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1904,7 +1904,6 @@ static void io_iopoll_queue(struct list_head *again)
 		/* shouldn't happen unless io_uring is dying, cancel reqs */
 		if (unlikely(!current->mm)) {
 			io_complete_rw_common(&req->rw.kiocb, -EAGAIN, NULL);
-			io_put_req(req);
 			continue;
 		}
 
-- 
2.24.0

