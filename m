Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8B503FC50D
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 11:53:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240408AbhHaJjN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 05:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbhHaJjL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 05:39:11 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3657AC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 02:38:16 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n5so26545452wro.12
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 02:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sj77ArsvVaXJK9n/N3A/2FYTgiatgeFrhPjt90aJrXU=;
        b=P5UhdOmWU823P0CovD3qIDNNFXiAXGK3jsilFSRR+ZgmjtxYaQ8LUWQZGM4Hxi/agx
         bBM1kNfo7z8oMhqoYFDdDeNGXpYuDnffd6ucDdABSEUu82cDLLttl/LRY6eCmblNaUgI
         i1APkrmqLvHyz7PSWP6oYfEbRUQ2YJsEoiirH77IjdAv7V8ESMDsjV5BRWxYIY22xPjU
         MvytZRyc26NDHHRFpcgkyyUfSDrjwW67h6RrdnGjkyHoKRSllVUNU5gRySuex2GsGoOe
         /SiIwGyIWq+56KaXHCREr+crcEq6njTcId4qP29JBIw2uqnJKVuB0ChUxoNGe22na43N
         d+Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Sj77ArsvVaXJK9n/N3A/2FYTgiatgeFrhPjt90aJrXU=;
        b=OHsWZdqL2rybOGAQ533UkNGSSj7wcJPAtAeWI7FqYCxYEWw0BM0jdYa3C+COjBHK0k
         JH46XWcmHhyDoYHpEfi6DANe0/mHSX57SNNykxoXSXm5it74Z5pOroXi/urohwwJk/T0
         xsYh660YEMPtgvmzS1LtZFiPkOzvIY7jWFKYQfFzuHQDnZf61JdEmsFDQxAGUiTu0cla
         y2FSMzFdUbALvHBAdPovk70fiyqx6uaybfSCJB1nx4ooKM5XTgcVXu/KlyQsCA94zh1Q
         WdCPiz7qmEo8stLuqVskMMqBO6fUvHdtM1zrORCKYKnXt0JSK1tQ/5R2QlbN6zLFZi8r
         tmBw==
X-Gm-Message-State: AOAM531tUuee0BGdt6K1Qfwp3QA2WTn4S5mL+G+FrqLjbdH5wObtEEOy
        C0oZb0H8BfzazGTMzAT31gbSWCJDOXg=
X-Google-Smtp-Source: ABdhPJxbCJBhna6QrjFd1XqiL0hTKOqbpzZdxCyRG0IfV/sluFfW6Aq0ymtXoXBTMXy7vuQK/AYkIw==
X-Received: by 2002:adf:9151:: with SMTP id j75mr30571061wrj.68.1630402694882;
        Tue, 31 Aug 2021 02:38:14 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id v21sm19158825wra.92.2021.08.31.02.38.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 02:38:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+f9704d1878e290eddf73@syzkaller.appspotmail.com
Subject: [PATCH] io_uring: fix queueing half-created requests
Date:   Tue, 31 Aug 2021 10:37:35 +0100
Message-Id: <e210f34d4a03cd00dc0944b787049a4205355608.1630402618.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
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
 fs/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 473a977c7979..a531c7324ea8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6717,6 +6717,8 @@ static inline void io_queue_sqe(struct io_kiocb *req)
 	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL)))) {
 		__io_queue_sqe(req);
 	} else if (req->flags & REQ_F_FAIL) {
+		/* fail all, we don't submit */
+		req->flags &= ~REQ_F_HARDLINK;
 		io_req_complete_failed(req, req->result);
 	} else {
 		int ret = io_req_prep_async(req);
-- 
2.33.0

