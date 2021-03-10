Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F938334BD9
	for <lists+io-uring@lfdr.de>; Wed, 10 Mar 2021 23:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233781AbhCJWoo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Mar 2021 17:44:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232828AbhCJWo2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Mar 2021 17:44:28 -0500
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FACEC061574
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:06 -0800 (PST)
Received: by mail-pj1-x102f.google.com with SMTP id kr3-20020a17090b4903b02900c096fc01deso8326300pjb.4
        for <io-uring@vger.kernel.org>; Wed, 10 Mar 2021 14:44:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1qQ1cxUfw5ggWUx/8N12SPJ6urhXZ55AxTN/3i6nQbA=;
        b=nEEFLt1wKtSl+LIO5dkwkOF9xs7Z5bciTVW1OrqP8TURtgh5i54+Nmljytbf9YSI/Q
         rOZ97nC9NdcTU87roJ8aAIfJ+0VrWhfkpi7dD1WHso2vEskgXW6OUKq9xy9RFuSWT6MI
         wE3Fqw9qogn3vXpyOcU31TEd25yj/KTlXfG5xCsdhq8ZvfIIYHeIqJ45bfbDinR2FvqI
         33sRWDCMosbO2g/v9MCZ1WKmqNLaZN57Owou7v6lx6CBr7BuLwAzYo/Hg6NE0isiQvXI
         4VqIfFnYNJsLzp5CoeV32A+l3mxmkz8xPWTY6gEEgdQUNMhCuy7ZDeNYF9SJJwqEBFgP
         aRTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1qQ1cxUfw5ggWUx/8N12SPJ6urhXZ55AxTN/3i6nQbA=;
        b=MdgnBuFuqWO+cgHmeUNr8hABeRdkhYO5jXE94ksY9VgvP0fof3xw/YIZR2rLftADrg
         meRD1iVa2KMV1pG/5Zsh2pOWIGKS+5rZxB8YloN/fXsFt2kUzq+Qz0Fc7SfgCxHGg9YS
         ZdoKlowOdN+H/6eqsaJS+aMeF2pxHPH4dFCBuwpdZWpcTplNiPwJrwSAPMOaJEBtUDZt
         9N/gM+8g2Z9NKNkNKRyiwuj/3tVzE9lj3yrHrx7eDsuvzuxYKepJ/QpMtl/aTAGnzm84
         /a9VNuzYZgD6ABC5Lyzk9maX287vvZvdnwxXe/yM8EChIO+HZEqd/fTM3dr/R9sC81pr
         BaUg==
X-Gm-Message-State: AOAM533+LZFUbSGY5hZv3iJExs2uqn//IG5J8JuM9xPuF6Ril2ZAhILt
        QVIbXvK+mGu+UE5tyQODj+6CBCd/DIutjw==
X-Google-Smtp-Source: ABdhPJxbecLZWRKmLlUfwxvw77dJ0622nM+ObRt2igWpDmyfCrZMURwudQYpERE13rc1osgC69sDwQ==
X-Received: by 2002:a17:902:8217:b029:e6:2875:b1d9 with SMTP id x23-20020a1709028217b02900e62875b1d9mr5081732pln.70.1615416245814;
        Wed, 10 Mar 2021 14:44:05 -0800 (PST)
Received: from localhost.localdomain ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id j23sm475783pfn.94.2021.03.10.14.44.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 14:44:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 01/27] io-wq: fix race in freeing 'wq' and worker access
Date:   Wed, 10 Mar 2021 15:43:32 -0700
Message-Id: <20210310224358.1494503-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310224358.1494503-1-axboe@kernel.dk>
References: <20210310224358.1494503-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ran into a use-after-free on the main io-wq struct, wq. It has a worker
ref and completion event, but the manager itself isn't holding a
reference. This can lead to a race where the manager thinks there are
no workers and exits, but a worker is being added. That leads to the
following trace:

BUG: KASAN: use-after-free in io_wqe_worker+0x4c0/0x5e0
Read of size 8 at addr ffff888108baa8a0 by task iou-wrk-3080422/3080425

CPU: 5 PID: 3080425 Comm: iou-wrk-3080422 Not tainted 5.12.0-rc1+ #110
Hardware name: Micro-Star International Co., Ltd. MS-7C60/TRX40 PRO 10G (MS-7C60), BIOS 1.60 05/13/2020
Call Trace:
 dump_stack+0x90/0xbe
 print_address_description.constprop.0+0x67/0x28d
 ? io_wqe_worker+0x4c0/0x5e0
 kasan_report.cold+0x7b/0xd4
 ? io_wqe_worker+0x4c0/0x5e0
 __asan_load8+0x6d/0xa0
 io_wqe_worker+0x4c0/0x5e0
 ? io_worker_handle_work+0xc00/0xc00
 ? recalc_sigpending+0xe5/0x120
 ? io_worker_handle_work+0xc00/0xc00
 ? io_worker_handle_work+0xc00/0xc00
 ret_from_fork+0x1f/0x30

Allocated by task 3080422:
 kasan_save_stack+0x23/0x60
 __kasan_kmalloc+0x80/0xa0
 kmem_cache_alloc_node_trace+0xa0/0x480
 io_wq_create+0x3b5/0x600
 io_uring_alloc_task_context+0x13c/0x380
 io_uring_add_task_file+0x109/0x140
 __x64_sys_io_uring_enter+0x45f/0x660
 do_syscall_64+0x32/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Freed by task 3080422:
 kasan_save_stack+0x23/0x60
 kasan_set_track+0x20/0x40
 kasan_set_free_info+0x24/0x40
 __kasan_slab_free+0xe8/0x120
 kfree+0xa8/0x400
 io_wq_put+0x14a/0x220
 io_wq_put_and_exit+0x9a/0xc0
 io_uring_clean_tctx+0x101/0x140
 __io_uring_files_cancel+0x36e/0x3c0
 do_exit+0x169/0x1340
 __x64_sys_exit+0x34/0x40
 do_syscall_64+0x32/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Have the manager itself hold a reference, and now both drop points drop
and complete if we hit zero, and the manager can unconditionally do a
wait_for_completion() instead of having a race between reading the ref
count and waiting if it was non-zero.

Fixes: fb3a1f6c745c ("io-wq: have manager wait for all workers to exit")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io-wq.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 28868eb4cd09..1bfdb86336e4 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -722,9 +722,9 @@ static int io_wq_manager(void *data)
 		io_wq_for_each_worker(wq->wqes[node], io_wq_worker_wake, NULL);
 	rcu_read_unlock();
 
-	/* we might not ever have created any workers */
-	if (atomic_read(&wq->worker_refs))
-		wait_for_completion(&wq->worker_done);
+	if (atomic_dec_and_test(&wq->worker_refs))
+		complete(&wq->worker_done);
+	wait_for_completion(&wq->worker_done);
 
 	spin_lock_irq(&wq->hash->wait.lock);
 	for_each_node(node)
@@ -774,7 +774,8 @@ static int io_wq_fork_manager(struct io_wq *wq)
 	if (wq->manager)
 		return 0;
 
-	reinit_completion(&wq->worker_done);
+	init_completion(&wq->worker_done);
+	atomic_set(&wq->worker_refs, 1);
 	tsk = create_io_thread(io_wq_manager, wq, NUMA_NO_NODE);
 	if (!IS_ERR(tsk)) {
 		wq->manager = get_task_struct(tsk);
@@ -782,6 +783,9 @@ static int io_wq_fork_manager(struct io_wq *wq)
 		return 0;
 	}
 
+	if (atomic_dec_and_test(&wq->worker_refs))
+		complete(&wq->worker_done);
+
 	return PTR_ERR(tsk);
 }
 
@@ -1018,13 +1022,9 @@ struct io_wq *io_wq_create(unsigned bounded, struct io_wq_data *data)
 	init_completion(&wq->exited);
 	refcount_set(&wq->refs, 1);
 
-	init_completion(&wq->worker_done);
-	atomic_set(&wq->worker_refs, 0);
-
 	ret = io_wq_fork_manager(wq);
 	if (!ret)
 		return wq;
-
 err:
 	io_wq_put_hash(data->hash);
 	cpuhp_state_remove_instance_nocalls(io_wq_online, &wq->cpuhp_node);
-- 
2.30.2

