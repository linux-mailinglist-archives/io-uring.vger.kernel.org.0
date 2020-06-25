Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A28E5209C02
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2020 11:39:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390909AbgFYJiz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Jun 2020 05:38:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390025AbgFYJiz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Jun 2020 05:38:55 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F387C0613ED;
        Thu, 25 Jun 2020 02:38:54 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id f7so2127303wrw.1;
        Thu, 25 Jun 2020 02:38:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gbehXZV5tRYEa1E4Qwo7fazcweKReJSEwBqzK+8JNbw=;
        b=atr6qyOp8MQUayyErsZRJ8CY+v+nU1JTYunWplEL7sH5yXSLibjFxUqUIXY6yIB/mC
         xZOy1WF0AngIZ/AhgJVBzjRXEdiW0wiPPFD5asMCPV//hMCXht0qk787VlHIObfEMR3Y
         pmo2RU//SiF3h1sijJf4ZJrAcD5ea5FqFR/jQKItNKnRjjJPxDkKqeobMBV0lW+W41Mo
         RiJKqf8/RsLhBKNzAq5rBEyATYmm/gNwC7PKBu9PJsCTotps7n+TRnKJd2/IgsKNmTUR
         8zmQGe2xK3hs9BrBeaa7N3AjtDwQKKfy/btz9M9GxzNvj4GX83KniL3pabXNJLoDOuFP
         sCEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gbehXZV5tRYEa1E4Qwo7fazcweKReJSEwBqzK+8JNbw=;
        b=KjPNKxrAr1JAv2jlvQ6BPaiS1/KriaSHTxhXxLvKgpSPthzA3cpCe6+v3WAO6RhBbk
         dKqoclg27RtHmLSrOQWtx3iStjRJZSDdMPjDEDnUmiR2RbD9h6fovmQ5gi5axhCVh33e
         3DDIbX5ALPv+3YS6cjLg3XKouPIoqH8jWX+Tq0zF13iLVWFmZeHgXHQ1HFMn9jbX2srG
         tTBAWpzeZAZYKvExF0/UvsOgqf/6bT3/cDd/L81jTN1YocKqx/SIyAzDhZv4AD1i8T+M
         zXIFGR3lBEKlM8NyVTczSta/cIQ9cfYj1HN4/I+5K76URAkqPmX5y963Ia0H8QnmFy90
         /4hQ==
X-Gm-Message-State: AOAM533j2JxuUyg/F0EFrOWnFjF80SrHTmtcJhyPP0lWodXuA3+bBxSU
        NEFfFOaGuWB+1Gwybe2fs58=
X-Google-Smtp-Source: ABdhPJxzszlDepKwr7iKSSbFQ2Y2W7jslc+pibHzXxoF/vV36nCkSk6Pc/cJZawzWNF1TZ4fZLesBg==
X-Received: by 2002:adf:efc9:: with SMTP id i9mr292288wrp.77.1593077933120;
        Thu, 25 Jun 2020 02:38:53 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id v5sm11067282wre.87.2020.06.25.02.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Jun 2020 02:38:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/2] io_uring: fix current->mm NULL dereference on exit
Date:   Thu, 25 Jun 2020 12:37:11 +0300
Message-Id: <b8616e6552c8f887c3cd42ae9d12d0f9530bde08.1593077359.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593077359.git.asml.silence@gmail.com>
References: <cover.1593077359.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't reissue requests from io_iopoll_reap_events(), the task may not
have mm, which ends up with NULL. It's better to kill everything off on
exit anyway.

[  677.734670] RIP: 0010:io_iopoll_complete+0x27e/0x630
...
[  677.734679] Call Trace:
[  677.734695]  ? __send_signal+0x1f2/0x420
[  677.734698]  ? _raw_spin_unlock_irqrestore+0x24/0x40
[  677.734699]  ? send_signal+0xf5/0x140
[  677.734700]  io_iopoll_getevents+0x12f/0x1a0
[  677.734702]  io_iopoll_reap_events.part.0+0x5e/0xa0
[  677.734703]  io_ring_ctx_wait_and_kill+0x132/0x1c0
[  677.734704]  io_uring_release+0x20/0x30
[  677.734706]  __fput+0xcd/0x230
[  677.734707]  ____fput+0xe/0x10
[  677.734709]  task_work_run+0x67/0xa0
[  677.734710]  do_exit+0x35d/0xb70
[  677.734712]  do_group_exit+0x43/0xa0
[  677.734713]  get_signal+0x140/0x900
[  677.734715]  do_signal+0x37/0x780
[  677.734717]  ? enqueue_hrtimer+0x41/0xb0
[  677.734718]  ? recalibrate_cpu_khz+0x10/0x10
[  677.734720]  ? ktime_get+0x3e/0xa0
[  677.734721]  ? lapic_next_deadline+0x26/0x30
[  677.734723]  ? tick_program_event+0x4d/0x90
[  677.734724]  ? __hrtimer_get_next_event+0x4d/0x80
[  677.734726]  __prepare_exit_to_usermode+0x126/0x1c0
[  677.734741]  prepare_exit_to_usermode+0x9/0x40
[  677.734742]  idtentry_exit_cond_rcu+0x4c/0x60
[  677.734743]  sysvec_reschedule_ipi+0x92/0x160
[  677.734744]  ? asm_sysvec_reschedule_ipi+0xa/0x20
[  677.734745]  asm_sysvec_reschedule_ipi+0x12/0x20

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fb88a537f471..21bc86670c56 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -894,6 +894,7 @@ static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
 static int io_grab_files(struct io_kiocb *req);
+static void io_complete_rw_common(struct kiocb *kiocb, long res);
 static void io_cleanup_req(struct io_kiocb *req);
 static int io_file_get(struct io_submit_state *state, struct io_kiocb *req,
 		       int fd, struct file **out_file, bool fixed);
@@ -1756,6 +1757,14 @@ static void io_iopoll_queue(struct list_head *again)
 	do {
 		req = list_first_entry(again, struct io_kiocb, list);
 		list_del(&req->list);
+
+		/* shouldn't happen unless io_uring is dying, cancel reqs */
+		if (unlikely(!current->mm)) {
+			io_complete_rw_common(&req->rw.kiocb, -EAGAIN);
+			io_put_req(req);
+			continue;
+		}
+
 		refcount_inc(&req->refs);
 		io_queue_async_work(req);
 	} while (!list_empty(again));
-- 
2.24.0

