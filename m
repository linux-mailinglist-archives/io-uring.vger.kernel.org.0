Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0645C207995
	for <lists+io-uring@lfdr.de>; Wed, 24 Jun 2020 18:52:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405253AbgFXQwM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Jun 2020 12:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404017AbgFXQvy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Jun 2020 12:51:54 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C785FC0613ED;
        Wed, 24 Jun 2020 09:51:52 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id 22so2971588wmg.1;
        Wed, 24 Jun 2020 09:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SK/e5vP7M6ohq5nkty8Hp7ehFT7bTOqt8+HLXcuKNbU=;
        b=NWjR63Oa5eenCo3FEW0tIQajmtVUOom0fwJQedcDSdHN6QNteFZCObuoLUxATpP2nm
         y/QdIZ6MEF+luEyR9IyI9B4Ik2SAqakU5YUtfXde2+TiaGe0SL/uIurMbU7iO+eeR5GD
         LTLynX9CBiqR0aojZJzXyY10jjIDQWA1q/ZDMDc+Bu3XdTX6NbCTKJ7ODKAZhbtkO3BX
         5ec0YjLheYkdFINmLEH4XzVJ3zAC9tvsm4PDOyciWWjXCvNyRhSoM2JGJk9anoni88c4
         ubihIt7/p7Sp57LRxt1/n7g9FcOq93heOSf+uJDEW1IsdSKr5BKP87ie61CAzgMMCeon
         bf4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SK/e5vP7M6ohq5nkty8Hp7ehFT7bTOqt8+HLXcuKNbU=;
        b=gZQ/Z9296RQ/9+oktK6dJWp/Ia3MW1x3rTR1Y33rM/KScvdmuMy73iPiNG04M4sM9S
         yo8nK0h5aZYeFOEoQpZ5cK+XQ/42ygpOOJg8VnfVS6ZOZUsgd/7vdXmr+fSgISyePhuS
         uSFf3UrM+DqTr3tN8991C86tHAHQQsKzZt4ngr/ugZYM9coJGTj3fau6LG6hqH1f+DXF
         mTh1mBX09GRunrARv5swOQ2VeOSTJKLJotGivBcVPWHxJ/h1aty7C+lGvSzsNucfHFJX
         elkKDBsdFL4lRS45vkfFd9UkDSGWHkwHO3qDOOg7Bsw5KaWN3HX6cVVXl3QBl0KCR9ox
         8ILw==
X-Gm-Message-State: AOAM533pzpUiLP5wUsCOoAUaXmI0mUH+YRzk53lZwGrmEBSFLmT0Vsl9
        EjYFB5sxfzOibHpCzdnib1Y=
X-Google-Smtp-Source: ABdhPJzjoGAgCdgms0gyBzPVtelZ90wmSdC9lkBXCP8uhk4uONrUcYGH/VL1KIj0q728dJKxckhv2w==
X-Received: by 2002:a1c:4989:: with SMTP id w131mr2124051wma.34.1593017511441;
        Wed, 24 Jun 2020 09:51:51 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.85])
        by smtp.gmail.com with ESMTPSA id z16sm18138182wrr.35.2020.06.24.09.51.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Jun 2020 09:51:51 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/3] io_uring: fix current->mm NULL dereference on exit
Date:   Wed, 24 Jun 2020 19:50:08 +0300
Message-Id: <c57f2702db6a13acc194b20a34bdef06eafcc00f.1593016907.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593016907.git.asml.silence@gmail.com>
References: <cover.1593016907.git.asml.silence@gmail.com>
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
index fb88a537f471..578ec2e39712 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -884,6 +884,7 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
+static void io_complete_rw_common(struct kiocb *kiocb, long res);
 static void io_wq_submit_work(struct io_wq_work **workptr);
 static void io_cqring_fill_event(struct io_kiocb *req, long res);
 static void io_put_req(struct io_kiocb *req);
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

