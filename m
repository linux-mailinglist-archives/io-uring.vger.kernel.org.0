Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D76082E88A0
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 22:07:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbhABVFu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 16:05:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726687AbhABVFt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 16:05:49 -0500
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7592C061573;
        Sat,  2 Jan 2021 13:05:08 -0800 (PST)
Received: by mail-pg1-x52f.google.com with SMTP id p18so16249904pgm.11;
        Sat, 02 Jan 2021 13:05:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U+9nqyimA47vW9KsG5PfL1LIdMRkpOZ4DJaxX52rJX4=;
        b=gSUB0YUnzW8Fcun1EKR9fsOlo4DIv1VNDEKGC2K0qWXCx3PSZjs+7IwGA7dVPB1ISp
         G4cdlkl8MkwiyQKKnB24DsLOZ9pHLdLYrShEeQ5zzRyXMh+/jchRqNqiQ0seD5ZHEhwJ
         aOhAYM8yLc1DF3wFGw1XMWvaxRf9fNF+e6Qq/94X1ESjdmw78/ySa3r6SK2nX4KHkOlg
         J58UTxcDtllhQug/uoftpJDMqFzjfBsQdqNgg/CY+kmO97FHz14bic4bZ+bJKoRHsYY1
         MdsrD4Vs9x1hgAP4GgAfdPh9S5YCtup25sdeUveFr6O+mABhozXeVUgsZqEHC4zu4pbn
         zw/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=U+9nqyimA47vW9KsG5PfL1LIdMRkpOZ4DJaxX52rJX4=;
        b=UsdEnBCnM9AO1IKqKE+lA+PYdCX8DrkY3hN3EaNqp8Be0ma2BdI7AcFE9AFFSkvjg9
         y/AhpnT0W0NFcew+yCU2yiY/izs35fRH+J5JKQyXCnN6L+bbsIKwGBfiF3mWOSMgnjKe
         9CjetNNA/5XAjm9HY3Kz7+qxOyv2Q3PfTkMnTJJ2ARezbkU7FQAPCMV4NRWcFyabk+ig
         8H9//XpOvw4uDPOBS9uv/lr5LYtN/g4oFcbkPAG9n1Sa4DVWs7xUqCGbt0a+2o47JHo0
         YVRKQz732HobZtH592mQItkPbfoZnmMSuSfsIvMLk4bo90i/tAlIlRz7Do8mwdO/Gwle
         EJbQ==
X-Gm-Message-State: AOAM531TpUlZAh5OGnMoUo61dlXZG8tZgpvnyl8N/O5UdzhmkOK4r2ZV
        Ax75XkHCMBkf3w9MvZgIMH8=
X-Google-Smtp-Source: ABdhPJxz1ulLAO2NemL3/AKFUxrLpZSfqvofIvaC8qjRwzqJs6p67lmgSgSVXnjRdFcEyQ+vZvibnQ==
X-Received: by 2002:a63:5f13:: with SMTP id t19mr66004315pgb.193.1609621508185;
        Sat, 02 Jan 2021 13:05:08 -0800 (PST)
Received: from noah.webpass.net (113.167.25.136.in-addr.arpa. [136.25.167.113])
        by smtp.googlemail.com with ESMTPSA id il14sm16239330pjb.51.2021.01.02.13.05.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 13:05:07 -0800 (PST)
From:   noah <goldstein.w.n@gmail.com>
Cc:     goldstein.w.n@gmail.com, Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        io-uring@vger.kernel.org (open list:IO_URING),
        linux-fsdevel@vger.kernel.org (open list:FILESYSTEMS (VFS and
        infrastructure)), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] fs/io_uring.c: remove unnecessary boolean instructions that add uops
Date:   Sat,  2 Jan 2021 16:04:51 -0500
Message-Id: <20210102210452.106399-1-goldstein.w.n@gmail.com>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This patch drops unnecessary comparisons to turn return values into
booleans. There is no reason to do a != for cancelled and posted as
they can be set to a boolean directly more efficiently.

Signed-off-by: noah <goldstein.w.n@gmail.com>
---
 fs/io_uring.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ca46f314640b..6a46594e749a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1607,11 +1607,11 @@ static bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	list_for_each_entry_safe(req, tmp, &ctx->timeout_list, timeout.list) {
 		if (io_match_task(req, tsk, files)) {
 			io_kill_timeout(req);
-			canceled++;
+			canceled = 1;
 		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
-	return canceled != 0;
+	return canceled;
 }
 
 static void __io_queue_deferred(struct io_ring_ctx *ctx)
@@ -5491,7 +5491,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 		list = &ctx->cancel_hash[i];
 		hlist_for_each_entry_safe(req, tmp, list, hash_node) {
 			if (io_match_task(req, tsk, files))
-				posted += io_poll_remove_one(req);
+				posted |= io_poll_remove_one(req);
 		}
 	}
 	spin_unlock_irq(&ctx->completion_lock);
@@ -5499,7 +5499,7 @@ static bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	if (posted)
 		io_cqring_ev_posted(ctx);
 
-	return posted != 0;
+	return posted;
 }
 
 static int io_poll_cancel(struct io_ring_ctx *ctx, __u64 sqe_addr)
-- 
2.29.2

