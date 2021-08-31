Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02F273FC7F5
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 15:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhHaNOr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 09:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230175AbhHaNOr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 09:14:47 -0400
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE733C061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 06:13:51 -0700 (PDT)
Received: by mail-wm1-x332.google.com with SMTP id k20-20020a05600c0b5400b002e87ad6956eso2527406wmr.1
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 06:13:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wSRKnLpT4Mp1c2byT3h+utzM8dy0Daidc+ZDPfgbzEE=;
        b=G4gB0XJ7AK20vGBXUgNMJl5GYgo5B8sQFdTPHaCKQo5yAjMRor8j+J6pst5tqzoEz4
         gM5tha4NKX8ETmPmSp6zTuyIF9AVAhrS9LRikpJzaVFn0CBpsT0YZOm/SvgrrreBvz8c
         239Xg22RIXX9nErJOnSjWwmuAElKGYpYaTekz5Iv6Y/sK1M4fjVTd47SB59IHgzKawJj
         uMAedwDzG9odQxfacyU8AzeMuSu66j32yVMlyJ3gUY4pDIFqGyu+QPV6ggwFT1y58McN
         HdNgLEy97NW9Kf52/DlGPxMokhGawgn4QdWYy4L74I8z1sADCS31tMz/c5roZq/u3mbk
         PTnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wSRKnLpT4Mp1c2byT3h+utzM8dy0Daidc+ZDPfgbzEE=;
        b=K0700meUc1ZRjYY/J8IvfkB/goEJ/Y9nENDV8xDP4p7iwLKe3xePOPttZf+ezHMH8D
         3AK5Hf9iuDrKqIw/l9iG4gTOxIynh+o7Kcpx4lhj5C9hCl8CfGPoV+fNnvOdzi9K0/HO
         GFb1EoPgnbKmE+cgL7fSWlveY0VzCbeNKF03574d0/mzqwJ9U26vwX8VVtt+VP9DnH/V
         PmXXBXKzs7XCXDiU01sC34B6Fa9olTk1wPYYYyVHBUHKv8T/olnL7unfZscQWIUxRtBc
         VzhAqO9RNrnm0kpbUYA6SEQy1GtGWI3SSZCH2KjYSRufhAGCkvy9EstNy5B0AE5z5L85
         6QCQ==
X-Gm-Message-State: AOAM530be9gStG7mdkqhjky652rQhV0rIHHq+qLL2WmorHEFzEnON1SG
        QNXg/42NYHc3hQpnc/td1Es=
X-Google-Smtp-Source: ABdhPJzeGUC+OnZ/Tj+v0ODWuvGVlfwLNmTbGTa7qAMq7CLjA0FFJ7hRilwwDfnbfxklEUxc6z8atQ==
X-Received: by 2002:a05:600c:3b84:: with SMTP id n4mr4183580wms.50.1630415630415;
        Tue, 31 Aug 2021 06:13:50 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id t14sm18246586wrw.59.2021.08.31.06.13.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 06:13:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>,
        syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com
Subject: [PATCH v2 1/2] io_uring: fix queueing half-created requests
Date:   Tue, 31 Aug 2021 14:13:10 +0100
Message-Id: <70b513848c1000f88bd75965504649c6bb1415c0.1630415423.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1630415423.git.asml.silence@gmail.com>
References: <cover.1630415423.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[   27.259845] general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] SMP KASAN PTI
[   27.261043] KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
[   27.263730] RIP: 0010:sock_from_file+0x20/0x90
[   27.272444] Call Trace:
[   27.272736]  io_sendmsg+0x98/0x600
[   27.279216]  io_issue_sqe+0x498/0x68d0
[   27.281142]  __io_queue_sqe+0xab/0xb50
[   27.285830]  io_req_task_submit+0xbf/0x1b0
[   27.286306]  tctx_task_work+0x178/0xad0
[   27.288211]  task_work_run+0xe2/0x190
[   27.288571]  exit_to_user_mode_prepare+0x1a1/0x1b0
[   27.289041]  syscall_exit_to_user_mode+0x19/0x50
[   27.289521]  do_syscall_64+0x48/0x90
[   27.289871]  entry_SYSCALL_64_after_hwframe+0x44/0xae

io_req_complete_failed() -> io_req_complete_post() ->
io_req_task_queue() still would try to enqueue hard linked request,
which can be half prepared (e.g. failed init), so we can't allow
that to happen.

Fixes: a8295b982c46d ("io_uring: fix failed linkchain code logic")
Reported-by: syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 473a977c7979..6e07456d9842 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1823,6 +1823,17 @@ static void io_req_complete_failed(struct io_kiocb *req, long res)
 	io_req_complete_post(req, res, 0);
 }
 
+static void io_req_complete_fail_submit(struct io_kiocb *req)
+{
+	/*
+	 * We don't submit, fail them all, for that replace hardlinks with
+	 * normal links. Extra REQ_F_LINK is tolerated.
+	 */
+	req->flags &= ~REQ_F_HARDLINK;
+	req->flags |= REQ_F_LINK;
+	io_req_complete_failed(req, req->result);
+}
+
 /*
  * Don't initialise the fields below on every allocation, but do that in
  * advance and keep them valid across allocations.
@@ -6717,7 +6728,7 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
 		__io_queue_sqe(req);
 	} else if (req->flags & REQ_F_FAIL) {
-		io_req_complete_failed(req, req->result);
+		io_req_complete_fail_submit(req);
 	} else {
 		int ret = io_req_prep_async(req);
 
-- 
2.33.0

