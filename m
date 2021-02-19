Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50B1331FDAA
	for <lists+io-uring@lfdr.de>; Fri, 19 Feb 2021 18:13:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhBSRLW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Feb 2021 12:11:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbhBSRLP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Feb 2021 12:11:15 -0500
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE6B5C06121C
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:28 -0800 (PST)
Received: by mail-io1-xd31.google.com with SMTP id u8so6314468ior.13
        for <io-uring@vger.kernel.org>; Fri, 19 Feb 2021 09:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p7EH7kdsmVJL44jz0DF1rZHfYXwHkXGHRTUSdaNLw3I=;
        b=pymxzAovHnuNA81cI9qzXvmxIPccVw6DjR1ups2m7+0yjVK43LRY5mFXX1mc2tI8Zh
         Xj0WlN82US0nPojrkCj1X5KrH5xIUfPpLHg8b5/kHuq2tuk7W/8VVF2CYUtLQa1gdNxH
         J2OXQ4CLqfIZo6dTqMvg8Kae0i8Bc+bMGhCmS3FCNPAdNohs9BFTTQqRqd87EOcjkoc4
         GV/2qi4/Rgbhzlc0meInY7C2j/Iu8rXS2Sqgx5hBgRVR0QrgjIKO1lXQy+ASoUfkUWHn
         we6mL2KFT82Iyz5+o80uOLOXGycX2MwZrFWMx4FCgAQts3jdRMudB4RLyccXGA1kDLSg
         Xa+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p7EH7kdsmVJL44jz0DF1rZHfYXwHkXGHRTUSdaNLw3I=;
        b=YRYfYcPVSSjaVmBAMgFCPQNdfdbpjFPK3h0oCQ1mji+5x/HvqmGegJnsBmhMOPOK18
         5Tu+dtmprnJtBEKvFPsqvEnoiUcyvu2WjiI2ovNYzzDGRGWnZQQ45TQu9kgTK6Dh5QTt
         mYZtUKzM2A+Txgp2uJNKMG2j2BpCfXucodNkOPUsmvvT1dDY/8OOD/IcetFLjfTQopJV
         jcH9/NYP/KJ80zoKfYNl7T+gUZLndIEl2ORdRVE3fxnpFJiet47rDSIYnw9PA2ARwXMS
         NxKIgYfub0WvkpLWQAdZyBqrnpBjCADYf+6HzXFoikHSZ+JlcblGHhgpHrM+lF55oANP
         i6KQ==
X-Gm-Message-State: AOAM530wuV9a1t5ZG+/9yV7bbwZzssAy5YU23N2asTC7RAovNcPdcEQT
        +IRTVlCHZsjLQGBzz5YjwBw0ROcg4SETgQjv
X-Google-Smtp-Source: ABdhPJy4fQ5uou7hcrDLWH4ZMmcLnuoJBJicIfR7N1ZNQeRtkKnvjxaa7ib7S6Tu0B1cBrRrKZJPUw==
X-Received: by 2002:a05:6638:22cd:: with SMTP id j13mr10756964jat.52.1613754628182;
        Fri, 19 Feb 2021 09:10:28 -0800 (PST)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o17sm4805431ilo.73.2021.02.19.09.10.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Feb 2021 09:10:27 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     ebiederm@xmission.com, viro@zeniv.linux.org.uk,
        torvalds@linux-foundation.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 13/18] io-wq: only remove worker from free_list, if it was there
Date:   Fri, 19 Feb 2021 10:10:05 -0700
Message-Id: <20210219171010.281878-14-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210219171010.281878-1-axboe@kernel.dk>
References: <20210219171010.281878-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If the worker isn't on the free_list, don't attempt to delete it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index acc67ed3a52c..3a506f1c7838 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -155,6 +155,7 @@ static void io_worker_exit(struct io_worker *worker)
 {
 	struct io_wqe *wqe = worker->wqe;
 	struct io_wqe_acct *acct = io_wqe_get_acct(worker);
+	unsigned flags;
 
 	/*
 	 * If we're not at zero, someone else is holding a brief reference
@@ -167,9 +168,11 @@ static void io_worker_exit(struct io_worker *worker)
 
 	preempt_disable();
 	current->flags &= ~PF_IO_WORKER;
-	if (worker->flags & IO_WORKER_F_RUNNING)
+	flags = worker->flags;
+	worker->flags = 0;
+	if (flags & IO_WORKER_F_RUNNING)
 		atomic_dec(&acct->nr_running);
-	if (!(worker->flags & IO_WORKER_F_BOUND))
+	if (!(flags & IO_WORKER_F_BOUND))
 		atomic_dec(&wqe->wq->user->processes);
 	worker->flags = 0;
 	preempt_enable();
@@ -180,7 +183,8 @@ static void io_worker_exit(struct io_worker *worker)
 	}
 
 	raw_spin_lock_irq(&wqe->lock);
-	hlist_nulls_del_rcu(&worker->nulls_node);
+	if (flags & IO_WORKER_F_FREE)
+		hlist_nulls_del_rcu(&worker->nulls_node);
 	list_del_rcu(&worker->all_list);
 	acct->nr_workers--;
 	raw_spin_unlock_irq(&wqe->lock);
-- 
2.30.0

