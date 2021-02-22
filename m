Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C32232156C
	for <lists+io-uring@lfdr.de>; Mon, 22 Feb 2021 12:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbhBVLuy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 06:50:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229989AbhBVLut (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 06:50:49 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73585C061574
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 03:49:53 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id a207so14057778wmd.1
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 03:49:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DlxILE/BLQIgnwTL85rd5K+PS4DOVogCskeZzk4Muh4=;
        b=fdQJ8PzRka2+ZTSAANTOaEC003H6MV35GWZGV9tYeq2z9j5dpCnQyLEgInDkyRtr1m
         D9iEnF95VFy0JSvOH0wjlpRZ7sbz6Nw26pS+Vnk2NrQRigZjRltEtCF1GOH7ZOU4HFPl
         aOkWZ7zCs4ANp2XYS8DcK2Y9liVU1cuf1CiUmL2XL3LRTu/I3k+J8ifGOwT15js7Km7h
         nR1JFSCaUwdlnPFAZopXY/+AbLC8YHJ+LeoVZxpU+izvzGAmcGzvr8E7YLSz7fE9F1i1
         L9+S7yBnS9lkuqw0vi8+dz0ZFsTyyUvoCZvAW2rCMyIjtkcBUXmwZgNmbTVV8IPFWwnA
         WFBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=DlxILE/BLQIgnwTL85rd5K+PS4DOVogCskeZzk4Muh4=;
        b=SYeRnjyAFJffpkO+/vpNrsoA+wtP7c+ceBmmuorvFoPG44Obxw53bzgj3MvtsfblGd
         QShyG8wXTM8KObCK5aE02AN9OZWN9uWS8BYh3U1LICxkKw7CEf9CEs9YDZ0pbXmqFcJL
         jybURwfudFw2mrI1FPfeMBMR8IZEyd1xgYsGCFFa+k+ZateLy8yYBndI0FeJgfPeXzaZ
         5r7FldG1F2vsQLjgCgGy0HZjjMwVgpFDXvR0XPhxkMe9ModWMSaC6vwnKfR8FSbNy3Km
         2+QIsdGTUMkJYnNdw4IajLtrMoo9VyifrtQ5Tbeb5640cchBH/qu6XQAGlxXeQQlrF3f
         Zprw==
X-Gm-Message-State: AOAM533qs4RLuAOXu/9YPxtaOTlAxYG6X6KtDAOap7EqMBqOTs/y2Gre
        HgEI9EtVox8RnFTSG6Eh+Ug=
X-Google-Smtp-Source: ABdhPJzmyaFWwjsq1pqeSXeKffUMCfPmpd2itLgpUqwsjzGyXWxzYhnL1Gpr/UOr87uVtXpDVm8/Hg==
X-Received: by 2002:a05:600c:20f:: with SMTP id 15mr12479774wmi.88.1613994592274;
        Mon, 22 Feb 2021 03:49:52 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id o129sm26271126wme.21.2021.02.22.03.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 03:49:51 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     syzbot+30b4936dcdb3aafa4fb4@syzkaller.appspotmail.com
Subject: [PATCH] io_uring: double freeing req caches
Date:   Mon, 22 Feb 2021 11:45:55 +0000
Message-Id: <756158e9db165fcb380f1f60c347b1d70bc65491.1613994305.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

BUG: KASAN: double-free or invalid-free in io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709

Workqueue: events_unbound io_ring_exit_work
Call Trace:
 [...]
 __cache_free mm/slab.c:3424 [inline]
 kmem_cache_free_bulk+0x4b/0x1b0 mm/slab.c:3744
 io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709
 io_ring_ctx_free fs/io_uring.c:8764 [inline]
 io_ring_exit_work+0x518/0x6b0 fs/io_uring.c:8846
 process_one_work+0x98d/0x1600 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x3b1/0x4a0 kernel/kthread.c:292
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

Freed by task 11900:
 [...]
 kmem_cache_free_bulk+0x4b/0x1b0 mm/slab.c:3744
 io_req_caches_free.constprop.0+0x3ce/0x530 fs/io_uring.c:8709
 io_uring_flush+0x483/0x6e0 fs/io_uring.c:9237
 filp_close+0xb4/0x170 fs/open.c:1286
 close_files fs/file.c:403 [inline]
 put_files_struct fs/file.c:418 [inline]
 put_files_struct+0x1d0/0x350 fs/file.c:415
 exit_files+0x7e/0xa0 fs/file.c:435
 do_exit+0xc27/0x2ae0 kernel/exit.c:820
 do_group_exit+0x125/0x310 kernel/exit.c:922
 [...]

io_req_caches_free() doesn't zero submit_state->free_reqs, so io_uring
considers just freed requests to be good and sound and will reuse or
double free them. Zero the counter.

Reported-by: syzbot+30b4936dcdb3aafa4fb4@syzkaller.appspotmail.com
Fixes: 41be53e94fb04 ("io_uring: kill cached requests from exiting task closing the ring")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 1501f20fde84..47f3968b8272 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8704,9 +8704,11 @@ static void io_req_caches_free(struct io_ring_ctx *ctx, struct task_struct *tsk)
 
 	mutex_lock(&ctx->uring_lock);
 
-	if (submit_state->free_reqs)
+	if (submit_state->free_reqs) {
 		kmem_cache_free_bulk(req_cachep, submit_state->free_reqs,
 				     submit_state->reqs);
+		submit_state->free_reqs = 0;
+	}
 
 	io_req_cache_free(&submit_state->comp.free_list, NULL);
 
-- 
2.24.0

