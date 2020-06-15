Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC26A1F9915
	for <lists+io-uring@lfdr.de>; Mon, 15 Jun 2020 15:38:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730516AbgFONiF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 15 Jun 2020 09:38:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730167AbgFONiF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 15 Jun 2020 09:38:05 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40FF7C061A0E;
        Mon, 15 Jun 2020 06:38:05 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id r7so17191581wro.1;
        Mon, 15 Jun 2020 06:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6A2VRUPxBUIMLQR9yYCehptCwpY51GrOQNgUB87WIm4=;
        b=gE6dp8cQ114eWfj2kjRIbj5tceBVc+ddyVxx54uO/6zDzDK9YjgMuf9mGISUMMmKDz
         fu+5m0PpBabL8WYRkngmmCum6nrpGYSuxALrrtXiAVRdBOVvUnkNQn0NRD3CdEDIF3jS
         w5jipOUxN2wV2Ko7q533g+QGFJ4g5/6tuS5otbH6QT8g7IAedCWqnWcDMHHv6dfJWIN0
         wb+V5d4YYrJrPUrpaK49Ot8UHBa4rSSc9kKQKk9jO+0AzQUq+QfbwPIibJeF7m9iBhUu
         lFb5vQdQTW0ApesBHtIhRTtTyDsDT/RDv4tHA8mEvYG7XXobi0v5i/iO4RFeH2n79NjT
         1bZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=6A2VRUPxBUIMLQR9yYCehptCwpY51GrOQNgUB87WIm4=;
        b=tsbSD15l4EHzEDLie56OieG9D5x9cje1eDckSvfPcIRslYivniyWlRYUGzbeyOcerH
         KPXjK9Z0FzbumJ9NOkg8/qfk0LuFbNq5cKDBjD87B7cAqGOTmKcIhtkbMjYbRm6iV+0k
         Fq/tRhhQt4dHsQ+ol8VIxLswUTiedronhYl7SvLM/MuvZKa/SVLvzoCPpgtjlrSLVjx4
         LagZaCYGTjsN0bagFSW45NGxtvyJ4PjzkC/+DfxbsWruEqkRY+6EtaDNlkm33BfOgxoZ
         QFxChEYsK+xR+o+/hHh12T4MLDMRm7YETpkBJ3qR9HCEEKVAUmVauDUQVuIVfXYq0SxO
         CLIw==
X-Gm-Message-State: AOAM532aGa03LNJ9ISAhcDOA5RQiOlb7/Cv8XPiCDg2jeY1gb/HJs6n3
        McY6OFo3qwrJcdO3IY52T/0JE7dv
X-Google-Smtp-Source: ABdhPJwOPEjXrfC2UmSbyWXvtITfiYi+xA2OUdX1KJUrfG5SKbcABWv2Ir0Hu9wU13+Bgv8VyEhuiw==
X-Received: by 2002:a05:6000:10c3:: with SMTP id b3mr30697121wrx.53.1592228283249;
        Mon, 15 Jun 2020 06:38:03 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id u4sm22839520wmb.48.2020.06.15.06.38.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Jun 2020 06:38:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     jiufei.xue@linux.alibaba.com
Subject: [PATCH 1/1] io_uring: fix lazy work init
Date:   Mon, 15 Jun 2020 16:36:30 +0300
Message-Id: <a75c1537cc655cb766e8e2517e18f74e13d60f1b.1592228129.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't leave garbage in req.work before punting async on -EAGAIN
in io_iopoll_queue().

[  140.922099] general protection fault, probably for non-canonical
     address 0xdead000000000100: 0000 [#1] PREEMPT SMP PTI
...
[  140.922105] RIP: 0010:io_worker_handle_work+0x1db/0x480
...
[  140.922114] Call Trace:
[  140.922118]  ? __next_timer_interrupt+0xe0/0xe0
[  140.922119]  io_wqe_worker+0x2a9/0x360
[  140.922121]  ? _raw_spin_unlock_irqrestore+0x24/0x40
[  140.922124]  kthread+0x12c/0x170
[  140.922125]  ? io_worker_handle_work+0x480/0x480
[  140.922126]  ? kthread_park+0x90/0x90
[  140.922127]  ret_from_fork+0x22/0x30

Fixes: 7cdaf587de7c ("io_uring: avoid whole io_wq_work copy for requests
completed inline")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54addaba742d..410b2df16c71 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1105,6 +1105,7 @@ static inline void io_prep_async_work(struct io_kiocb *req,
 			req->work.flags |= IO_WQ_WORK_UNBOUND;
 	}
 
+	io_req_init_async(req);
 	io_req_work_grab_env(req, def);
 
 	*link = io_prep_linked_timeout(req);
-- 
2.24.0

