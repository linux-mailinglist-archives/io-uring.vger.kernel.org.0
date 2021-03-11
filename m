Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15109338187
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 00:34:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229603AbhCKXeT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Mar 2021 18:34:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhCKXdo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Mar 2021 18:33:44 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8B4C061574
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:43 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id o26so2735771wmc.5
        for <io-uring@vger.kernel.org>; Thu, 11 Mar 2021 15:33:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=GGDEvL0UrrMpno7LhZSaw+mlHt+ua0hVWa0K+gwg63E=;
        b=tZYHoHWGKdXgUdgXbiEHgy6To2alaLDjTwUWkfe077XZNbl0ofYLxmAiRyxKrxKyCJ
         a4KqV+Omh1SAL8q7/TXjGIr+eOA41RZ20D/0IaIyeyRNFYsFzNqAN36Kfvz+8SzlE6FA
         0onJ0blh4Sn+mMhSo9x1qAmqPIQenp1Chrjzui5Qr7hBbUMwY7n3MpQbuiRb2jHnPnnG
         VPMEunVNO/SvQVxF+g5ZVZGqO7c+5d8LCkPTiVrxghkKxXVKDsViT7ztrF5m40rSMoYi
         an6wUu8069bW1XRjwwZJbyMUKxcTk+7bOA3Gp8B4GDnilo6Kz/kWhWl/humslicuF7sW
         8yNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GGDEvL0UrrMpno7LhZSaw+mlHt+ua0hVWa0K+gwg63E=;
        b=Of22O1xA3UzDNkRutPi3YWZDNZFyLYWoqNKsSzUDVFEmcbmmchNbAjH6dBI5TuU/eg
         csMoozGcopTp3AlNMZh7z3P9X6FwHohT1/NZc2QYyFcj3fyeozavDf9CwXteflzmux7a
         2poeMo2aJ8Y4Ow8oPy/qqpO3E4juarwZwNf3ZCadVsE+7bg2fn+H7DGmSGxqPn2Kwq7k
         s8n9nfqk4b6si8dsheRD2DOPm5ehpXHbD7dBBIDlh/eoELrbleae7tRu1GNID7ljPB3+
         qvRzb7A+f1EMSsOgSvY1qLDzxlyPCeUh/zds8GEkvV6R67f2mM1t64nFqwILPZS4U/UH
         NW9w==
X-Gm-Message-State: AOAM531aTBa3ro8xc00+3w09oTTLjta0gjEDnqv3irIDOJ9b6bGYQscC
        q47s8uikBLeb6JTBB761dhl548nE5XE8mQ==
X-Google-Smtp-Source: ABdhPJzpzQKrjIgi0A8HUH/lcExy+c7WWhplMIYGX8wLY9uyi/p495QVgCgUUPowoDitm3wlkU9nmQ==
X-Received: by 2002:a1c:195:: with SMTP id 143mr10050604wmb.81.1615505622303;
        Thu, 11 Mar 2021 15:33:42 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.148])
        by smtp.gmail.com with ESMTPSA id m11sm5828062wrz.40.2021.03.11.15.33.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Mar 2021 15:33:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: remove useless ->startup completion
Date:   Thu, 11 Mar 2021 23:29:36 +0000
Message-Id: <5fc14345c09b987a5b48e61025f0a25b5f871526.1615504663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615504663.git.asml.silence@gmail.com>
References: <cover.1615504663.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We always do complete(&sqd->startup) almost right after sqd->thread
creation, either in the success path or in io_sq_thread_finish(). It's
specifically created not started for us to be able to set some stuff
like sqd->thread and io_uring_alloc_task_context() before following
right after wake_up_new_task().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 56f3d8f408c9..6349374d715d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -272,7 +272,6 @@ struct io_sq_data {
 	pid_t			task_tgid;
 
 	unsigned long		state;
-	struct completion	startup;
 	struct completion	exited;
 };
 
@@ -6656,8 +6655,6 @@ static int io_sq_thread(void *data)
 		set_cpus_allowed_ptr(current, cpu_online_mask);
 	current->flags |= PF_NO_SETAFFINITY;
 
-	wait_for_completion(&sqd->startup);
-
 	down_read(&sqd->rw_lock);
 
 	while (!test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state)) {
@@ -7080,7 +7077,6 @@ static void io_sq_thread_finish(struct io_ring_ctx *ctx)
 	struct io_sq_data *sqd = ctx->sq_data;
 
 	if (sqd) {
-		complete(&sqd->startup);
 		io_sq_thread_park(sqd);
 		list_del(&ctx->sqd_list);
 		io_sqd_update_thread_idle(sqd);
@@ -7144,7 +7140,6 @@ static struct io_sq_data *io_get_sq_data(struct io_uring_params *p)
 	INIT_LIST_HEAD(&sqd->ctx_list);
 	init_rwsem(&sqd->rw_lock);
 	init_waitqueue_head(&sqd->wait);
-	init_completion(&sqd->startup);
 	init_completion(&sqd->exited);
 	return sqd;
 }
@@ -7856,7 +7851,6 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
-		complete(&sqd->startup);
 	} else if (p->flags & IORING_SETUP_SQ_AFF) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
-- 
2.24.0

