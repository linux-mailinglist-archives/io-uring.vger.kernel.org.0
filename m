Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6ADB31FD9D
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229743AbhBSRKv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:10:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhBSRKu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:10:50 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C267FC06121D
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:29 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id u20so6325894iot.9
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=raLBwz2z/RlvS5+a1Mc61Ms6j5oHYmtVohpqfBdAIdA=;
        b=dLXU3iJxtbKIdjfArcufz0cpGh6e9pv1coOgNG/ADVhK1Jucpp2E0zGiQus4Y0baEU
         Ac6C9dZM79gxjZ8K/CeX9xkAvI7kSgsGqXJlV7HbugWfI34NKDSXhXWwHn/8kwKAdciW
         /nUi0bVT3M7RCCl2+VwzzYxZ4c3KoNxhrcVkHuy4xOvWz/2n8TO1mIgXUrNgMnwWgxLC
         JBOoQPOPlAuPw5/hDSpjQv7gOH03qNbLWX4eknzyFqSra07BmxRUogTeUQoMwF74y3Pm
         DHK8JHDc/AnplDGrjEvCbkyiv2SshYuKe0wwxg1xNdr3cqQ2nJ8IEypCoRqwgQgxuGR0
         BmXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=raLBwz2z/RlvS5+a1Mc61Ms6j5oHYmtVohpqfBdAIdA=;
        b=mCnWJWO83SYuOl6rk5OSgYXdQSjF3/H1wUlHwF1lxAdMn24Uq/SZvyaxM5Vu0QZtFW
         DvcP0JrqDaYpPOmMcVZljynCOFXPzrbcOKoXvHwQJz+quTuifBCgy3vGC/YlUq97y0cX
         cWxfBF+xy5abeZn00aLVFlxndGoejC72i/12d2ADlkQl0gNC+owZM0uGaJmoeZVAKu9d
         HIUu4mhi8QBuQD/WEfGJ0mq7yh1BqwkzyWNGM/H1IvWMAFAamcA8WMAirgv8AF8VR2Eb
         nU/9uSYs82K/5UM0ofu1HZaYbN+9/43TOODBsucjPku7zeUi2BlzjpPupk+cx/Nu7Drq
         aayg==
X-Gm-Message-State: AOAM530TtG7qdVg5L+divHeUOtFCqj3aQFEbE4BRMQ3j5iVm8snNuIiO
        HZme44N/uAxYtvzO67hsvuOOzO9NukdOiLy9
X-Google-Smtp-Source: ABdhPJyUpaaUNDg+PYA86yp6zIn7Ge3uJbQQS8COyu8H88y4QSgjA/JZ5MmqMeHOQb7l7XloQOk5Ng==
X-Received: by 2002:a05:6638:388e:: with SMTP id b14mr10651972jav.96.1613754629011;
        Fri, 19 Feb 2021 09:10:29 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:28 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 14/18] io-wq: make io_wq_fork_thread() available to other users
Date:   Fri, 19 Feb 2021 10:10:06 -0700
Message-Id: <20210219171010.281878-15-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We want to use this in io_uring proper as well, for the SQPOLL thread.
Rename it from fork_thread() to io_wq_fork_thread(), and make it
available through the io-wq.h header.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 8 ++++----
 fs/io-wq.h | 2 ++
 2 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 3a506f1c7838..b0d09f60200b 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -592,7 +592,7 @@ static int task_thread_unbound(void *data)
 	return task_thread(data, IO_WQ_ACCT_UNBOUND);
 }
 
-static pid_t fork_thread(int (*fn)(void *), void *arg)
+pid_t io_wq_fork_thread(int (*fn)(void *), void *arg)
 {
 	unsigned long flags = CLONE_FS|CLONE_FILES|CLONE_SIGHAND|CLONE_THREAD|
 				CLONE_IO|SIGCHLD;
@@ -622,9 +622,9 @@ static bool create_io_worker(struct io_wq *wq, struct io_wqe *wqe, int index)
 	spin_lock_init(&worker->lock);
 
 	if (index == IO_WQ_ACCT_BOUND)
-		pid = fork_thread(task_thread_bound, worker);
+		pid = io_wq_fork_thread(task_thread_bound, worker);
 	else
-		pid = fork_thread(task_thread_unbound, worker);
+		pid = io_wq_fork_thread(task_thread_unbound, worker);
 	if (pid < 0) {
 		kfree(worker);
 		return false;
@@ -1012,7 +1012,7 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	refcount_set(&wq->refs, 1);
 
 	current->flags |= PF_IO_WORKER;
-	ret = fork_thread(io_wq_manager, wq);
+	ret = io_wq_fork_thread(io_wq_manager, wq);
 	current->flags &= ~PF_IO_WORKER;
 	if (ret >= 0) {
 		wait_for_completion(&wq->done);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index c187d54dc5cd..3c63a99d1629 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -106,6 +106,8 @@ void io_wq_destroy(struct io_wq *wq);
 void io_wq_enqueue(struct io_wq *wq, struct io_wq_work *work);
 void io_wq_hash_work(struct io_wq_work *work, void *val);
 
+pid_t io_wq_fork_thread(int (*fn)(void *), void *arg);
+
 static inline bool io_wq_is_hashed(struct io_wq_work *work)
 {
 	return work->flags & IO_WQ_WORK_HASHED;
-- 
2.30.0

