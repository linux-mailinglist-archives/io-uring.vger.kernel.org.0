Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C1CD2A50DE
	for <lists+io-uring@lfdr.de>; Tue,  3 Nov 2020 21:28:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729249AbgKCU2j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Nov 2020 15:28:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729213AbgKCU2j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Nov 2020 15:28:39 -0500
Received: from mail-il1-x141.google.com (mail-il1-x141.google.com [IPv6:2607:f8b0:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5CCCC0613D1
        for <io-uring@vger.kernel.org>; Tue,  3 Nov 2020 12:28:37 -0800 (PST)
Received: by mail-il1-x141.google.com with SMTP id k1so17307534ilc.10
        for <io-uring@vger.kernel.org>; Tue, 03 Nov 2020 12:28:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/S4w9M4u+DDdIkWqnT1Wxl7vmr1gd9AcNYVduZNQbBY=;
        b=i+y31n67dRfY1JBJSMBD9zq+EzhVT2Fb6i0aDSXvxE+rSNyMakyaOspnU2/Rw2CdI6
         TNJ1ZsF3+chMlp8UqNghKrprMEN93Jz6BwX68+fyxbM/MRY+rNrXt38U/mNV3rTtbwAR
         XGolRUqXiaacrlq29dQPEHr3tH8IQsyPqL2A5YG82aXtRZJHx2e1R6H2E9Qrs/C7/5aJ
         JkJ2RhP0DdSLQZWiGiJNDq+WTVXkzq9i5YzMxNuV//1ofVSGhXwVg6zJWHWc1fHe7EGA
         li0sUFAfdEww2FkLwSdig4NAiTaLN2q5go2Nza7iHbCNonXmAtBES58LggKKnMoRUI0h
         XUOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/S4w9M4u+DDdIkWqnT1Wxl7vmr1gd9AcNYVduZNQbBY=;
        b=QulrRg3A6L/6ySoFCq8rV0sbwatbb5h8erFQaiHUho5QkoSmY2QLjDIKDiPfaYo1Kx
         VSeKvEy+keAqoM44hPKUDNj57yUsmXtphLkMLFi0iHbb9p9dvnMOEWnounHe2P4PE7/2
         x7qA7bQ3nmWZeqIV3Qb5o7bC1jFwg6pRGgdCoa4S6BmhtJ7HmnlcJw0qT/1kboaSZop9
         JIYkZTyLZ0g56dyqG9FknQonpowoPAjHLF0HhslIC6AYZrco9l2ZSvbdEaZrvjqbNQqW
         bHMJ6fMpm1JPXFNFbivkyVFMlEkzO/3Vu/or+UuCKBZi9Ztw4AtM3r0l9Zl9qq4oAYgB
         9PjA==
X-Gm-Message-State: AOAM5336em/o3Yhhs/ehSTstiB0qdSJ1Na5ndE3DLDDle97AIx6P6Lt+
        ya3H2JflIXK8Psk3gI0WiUnDigF/qNJq5A==
X-Google-Smtp-Source: ABdhPJxG1q5cc1ovb6VK3ZjTqQybpkjvdGsW6c4NSC8rGlVj8IGKhSFMBgMDu81AOO3DY1YDF2v7dA==
X-Received: by 2002:a92:b617:: with SMTP id s23mr12398425ili.20.1604435317041;
        Tue, 03 Nov 2020 12:28:37 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id d6sm13472902ilf.19.2020.11.03.12.28.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2020 12:28:36 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com
Subject: [PATCH 3/4] io_uring: ensure consistent view of original task ->mm from SQPOLL
Date:   Tue,  3 Nov 2020 13:28:31 -0700
Message-Id: <20201103202832.923305-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103202832.923305-1-axboe@kernel.dk>
References: <20201103202832.923305-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ensure we get a valid view of the task mm, by using task_lock() when
attempting to grab the original task mm.

Reported-by: syzbot+b57abf7ee60829090495@syzkaller.appspotmail.com
Fixes: 2aede0e417db ("io_uring: stash ctx task reference for SQPOLL")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 27 ++++++++++++++++++++-------
 1 file changed, 20 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e6e7cec301b3..1f555e3c44cd 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -995,20 +995,33 @@ static void io_sq_thread_drop_mm(void)
 	if (mm) {
 		kthread_unuse_mm(mm);
 		mmput(mm);
+		current->mm = NULL;
 	}
 }
 
 static int __io_sq_thread_acquire_mm(struct io_ring_ctx *ctx)
 {
-	if (!current->mm) {
-		if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL) ||
-			     !ctx->sqo_task->mm ||
-			     !mmget_not_zero(ctx->sqo_task->mm)))
-			return -EFAULT;
-		kthread_use_mm(ctx->sqo_task->mm);
+	struct mm_struct *mm;
+
+	if (current->mm)
+		return 0;
+
+	/* Should never happen */
+	if (unlikely(!(ctx->flags & IORING_SETUP_SQPOLL)))
+		return -EFAULT;
+
+	task_lock(ctx->sqo_task);
+	mm = ctx->sqo_task->mm;
+	if (unlikely(!mm || !mmget_not_zero(mm)))
+		mm = NULL;
+	task_unlock(ctx->sqo_task);
+
+	if (mm) {
+		kthread_use_mm(mm);
+		return 0;
 	}
 
-	return 0;
+	return -EFAULT;
 }
 
 static int io_sq_thread_acquire_mm(struct io_ring_ctx *ctx,
-- 
2.29.2

