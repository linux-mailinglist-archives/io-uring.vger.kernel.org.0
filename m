Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3CE352DEE
	for <lists+io-uring@lfdr.de>; Fri,  2 Apr 2021 18:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234275AbhDBQ4r (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Apr 2021 12:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbhDBQ4q (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Apr 2021 12:56:46 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C222C0613E6
        for <io-uring@vger.kernel.org>; Fri,  2 Apr 2021 09:56:45 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id z6-20020a1c4c060000b029010f13694ba2so2627403wmf.5
        for <io-uring@vger.kernel.org>; Fri, 02 Apr 2021 09:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a6D1LcYlbmCIpob1zuDPXwQZfxcxuqOkwFTIQWkL3KM=;
        b=hiHcUZifNBdAYBvjarxcLM7w5P/c8qxM+Y3LbQzvxvCIuKE4gpLhNoFzo3Ueckmq5U
         l/duwDJphpBZaiLOl9zxAhWRqYYgzehSrfKPs5Ygcvpewn5nusgp8vBZmXX4TrxTQNP1
         NTyvulWUmEmb29q6K3qkW6GevLyEFM+u0b6EkBJhSziaT/XazLnrHbMfbTjC/TZDnrbH
         NOdObzD9VSzFaZl/JFcPiuZk8HpAF6MxoRPHbaBl4WXNJ8L/RklXwx1O+CCVTN+21dgz
         btnOce48pejHtIIa+Zvas8318AttPAlMcAOO95WMbQh4nBkWXChDcCyuyDpXMFzoTeWj
         R19Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=a6D1LcYlbmCIpob1zuDPXwQZfxcxuqOkwFTIQWkL3KM=;
        b=DQtxZ7OYDrSEFs9VYgQsCGEnvQko8zc4Zdp0YBUilb8cKXFIcyBURpbCfZdNoHJHwU
         wq4PrJ5gBYviDLEdHaOaNpUvEupZBeYVsDLj0hiq/QAJcbucRvdhODKIwfJgCglDVYnd
         AytddKYYfzBFwRuml7RBkFFShtvAV41yGTtObZl+2E9/OSYyYTLTYPbzfqcknaIbw2TO
         STcI/IwESEiMGFAHO1jGDYwbY58vfLYoVxnBX4cDetwQns3dQGy6ijNMbIySsMC5g7rY
         7vmnllSFhgtZBVRrpulMiQPcNOgv2uGxQvmZxTZttfhPsZv5DlPzB08+Nb0uJ/qk6K5v
         or5A==
X-Gm-Message-State: AOAM533o/CO/ry5b+GG9X+YhiV6Zz7hGPZ79WBg4drURrfKajSaNGCLT
        DGH4rhEc7SJ0X0R6YlcTFG4ymiiicycUSQ==
X-Google-Smtp-Source: ABdhPJxp1ipmj4EoPHYHVBEOpTJI0Gp06fkKMTGYThHbDtQV+GcGgio/K0THNGZtk4SOwA9aOnXdUw==
X-Received: by 2002:a1c:e912:: with SMTP id q18mr13627678wmc.59.1617382603727;
        Fri, 02 Apr 2021 09:56:43 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.229])
        by smtp.gmail.com with ESMTPSA id s12sm12124022wmj.28.2021.04.02.09.56.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Apr 2021 09:56:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [RFC 5.12] io-wq: cancel unbounded works on io-wq destroy
Date:   Fri,  2 Apr 2021 17:52:32 +0100
Message-Id: <932defeefef1b025b22f69f7f420f162460eb842.1617382191.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

[  491.222908] INFO: task thread-exit:2490 blocked for more than 122 seconds.
[  491.222957] Call Trace:
[  491.222967]  __schedule+0x36b/0x950
[  491.222985]  schedule+0x68/0xe0
[  491.222994]  schedule_timeout+0x209/0x2a0
[  491.223003]  ? tlb_flush_mmu+0x28/0x140
[  491.223013]  wait_for_completion+0x8b/0xf0
[  491.223023]  io_wq_destroy_manager+0x24/0x60
[  491.223037]  io_wq_put_and_exit+0x18/0x30
[  491.223045]  io_uring_clean_tctx+0x76/0xa0
[  491.223061]  __io_uring_files_cancel+0x1b9/0x2e0
[  491.223068]  ? blk_finish_plug+0x26/0x40
[  491.223085]  do_exit+0xc0/0xb40
[  491.223099]  ? syscall_trace_enter.isra.0+0x1a1/0x1e0
[  491.223109]  __x64_sys_exit+0x1b/0x20
[  491.223117]  do_syscall_64+0x38/0x50
[  491.223131]  entry_SYSCALL_64_after_hwframe+0x44/0xae
[  491.223177] INFO: task iou-mgr-2490:2491 blocked for more than 122 seconds.
[  491.223194] Call Trace:
[  491.223198]  __schedule+0x36b/0x950
[  491.223206]  ? pick_next_task_fair+0xcf/0x3e0
[  491.223218]  schedule+0x68/0xe0
[  491.223225]  schedule_timeout+0x209/0x2a0
[  491.223236]  wait_for_completion+0x8b/0xf0
[  491.223246]  io_wq_manager+0xf1/0x1d0
[  491.223255]  ? recalc_sigpending+0x1c/0x60
[  491.223265]  ? io_wq_cpu_online+0x40/0x40
[  491.223272]  ret_from_fork+0x22/0x30

Cancel all unbound works on exit, otherwise do_exit() ->
io_uring_files_cancel() may wait for io-wq destruction for long, e.g.
until somewhat sends a SIGKILL.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

Not quite happy about it as it cancels pipes and sockets, but
is probably better than waiting.

 fs/io-wq.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 433c4d3c3c1c..e2ab569e47b9 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -702,6 +702,11 @@ static void io_wq_cancel_pending(struct io_wq *wq)
 		io_wqe_cancel_pending_work(wq->wqes[node], &match);
 }
 
+static bool io_wq_cancel_unbounded(struct io_wq_work *work, void *data)
+{
+	return work->flags & IO_WQ_WORK_UNBOUND;
+}
+
 /*
  * Manager thread. Tasked with creating new workers, if we need them.
  */
@@ -736,6 +741,8 @@ static int io_wq_manager(void *data)
 
 	if (atomic_dec_and_test(&wq->worker_refs))
 		complete(&wq->worker_done);
+
+	io_wq_cancel_cb(wq, io_wq_cancel_unbounded, NULL, true);
 	wait_for_completion(&wq->worker_done);
 
 	spin_lock_irq(&wq->hash->wait.lock);
-- 
2.24.0

