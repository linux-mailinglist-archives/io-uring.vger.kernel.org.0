Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DAB3F5886B1
	for <lists+io-uring@lfdr.de>; Wed,  3 Aug 2022 07:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232287AbiHCFDF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Aug 2022 01:03:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiHCFDF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Aug 2022 01:03:05 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA0AE1902F;
        Tue,  2 Aug 2022 22:03:03 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id c3so12120275qko.1;
        Tue, 02 Aug 2022 22:03:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uVXW0Uy4uUbhDpgN7+ORPCX7CU++KL6atoUXVVGMX04=;
        b=GYLOGQfv4Csm0/5P5UXlkqmgpySaPoYMB3N3pcaxe6OzzYNEhb2cjJvGoYzGESWik+
         1sAg1d1RgqafxVoflsfy6YConAXVE5eDYxLOKMFpWlNHcWXdlxkaqL1slVe2lxjanuDv
         bAxyIX7QqUnpfVGIh6FJZFRs3YZYPHJ3qbH95x/etzVZ4JooHTsU7LfNcgDbJxnxCF1m
         r0Q1fORFoB6568a9GK/ZNGzaiHfaxILGiMWtb7/fWxeBFkUsDZEXBj9AiQ5gYKe5dSHu
         FK4GPKbftDaufad4jDXZ1hAd15hJYZlTrpywq6DjuWPM9Qb/Sn1kZjouCcrS+0PfLIwl
         6jlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=uVXW0Uy4uUbhDpgN7+ORPCX7CU++KL6atoUXVVGMX04=;
        b=FptzxadmdX/ZhYU3taL1rQgnPIPLbFVHJEzxDRtVBqeo+nmJm7hdiAbhZlTrH2bn3s
         hzGtHF1G1W8A7EH8gtCc1QSOfhRRtjpQ4+TovqEzIP66HL41mkR72w+ucCwmEZdgMtEx
         vphgvELZCqCN833exG5cd2ztiiA8tdkFDBGGeAQyxUNwLn4zw1c9vPNtvXtlJrP757kS
         PmsijTv4vdCfVwgHCUm0O9sJlnXh3panv/QJwtTduKFIlnu3sB7k6Ie4+8z3dBJEAqoW
         BWpjN+UBK6Q8e4vhkqE4yq3+VlMvMmO0fY6kZ6iaijScrzzku3ySqP9/FuADCHTJdrx0
         8+xw==
X-Gm-Message-State: AJIora8RzSiKTfj3VC31lJyRhjMU4ARxApi9HWcI/nsYFxanWF/bnlQz
        xASaNiLCFpP5CZ2PfTHqkg==
X-Google-Smtp-Source: AGRyM1v8I+fKQMI8kklagMtT2p4ecs0kmq7Ny6EvoPp7eDjY/UgwGMfIhAg4BcHt6sb1s8CEB/8jTQ==
X-Received: by 2002:a05:620a:138b:b0:6b5:d5eb:aabf with SMTP id k11-20020a05620a138b00b006b5d5ebaabfmr17334494qki.393.1659502982588;
        Tue, 02 Aug 2022 22:03:02 -0700 (PDT)
Received: from bytedance.attlocal.net (ec2-52-52-7-82.us-west-1.compute.amazonaws.com. [52.52.7.82])
        by smtp.gmail.com with ESMTPSA id x22-20020a05622a001600b0033d1ac2517esm1260993qtw.64.2022.08.02.22.03.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 22:03:02 -0700 (PDT)
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Paul Moore <paul@paul-moore.com>,
        Eric Paris <eparis@redhat.com>
Cc:     Peilin Ye <peilin.ye@bytedance.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-audit@redhat.com,
        Peilin Ye <yepeilin.cs@gmail.com>
Subject: [PATCH] audit, io_uring, io-wq: Fix memory leak in io_sq_thread() and io_wqe_worker()
Date:   Tue,  2 Aug 2022 22:02:30 -0700
Message-Id: <20220803050230.30152-1-yepeilin.cs@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Peilin Ye <peilin.ye@bytedance.com>

Currently @audit_context is allocated twice for io_uring workers:

  1. copy_process() calls audit_alloc();
  2. io_sq_thread() or io_wqe_worker() calls audit_alloc_kernel() (which
     is effectively audit_alloc()) and overwrites @audit_context,
     causing:

  BUG: memory leak
  unreferenced object 0xffff888144547400 (size 1024):
<...>
    hex dump (first 32 bytes):
      00 00 00 00 00 00 00 00 01 00 00 00 00 00 00 00  ................
      00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    backtrace:
      [<ffffffff8135cfc3>] audit_alloc+0x133/0x210
      [<ffffffff81239e63>] copy_process+0xcd3/0x2340
      [<ffffffff8123b5f3>] create_io_thread+0x63/0x90
      [<ffffffff81686604>] create_io_worker+0xb4/0x230
      [<ffffffff81686f68>] io_wqe_enqueue+0x248/0x3b0
      [<ffffffff8167663a>] io_queue_iowq+0xba/0x200
      [<ffffffff816768b3>] io_queue_async+0x113/0x180
      [<ffffffff816840df>] io_req_task_submit+0x18f/0x1a0
      [<ffffffff816841cd>] io_apoll_task_func+0xdd/0x120
      [<ffffffff8167d49f>] tctx_task_work+0x11f/0x570
      [<ffffffff81272c4e>] task_work_run+0x7e/0xc0
      [<ffffffff8125a688>] get_signal+0xc18/0xf10
      [<ffffffff8111645b>] arch_do_signal_or_restart+0x2b/0x730
      [<ffffffff812ea44e>] exit_to_user_mode_prepare+0x5e/0x180
      [<ffffffff844ae1b2>] syscall_exit_to_user_mode+0x12/0x20
      [<ffffffff844a7e80>] do_syscall_64+0x40/0x80

Then,

  3. io_sq_thread() or io_wqe_worker() frees @audit_context using
     audit_free();
  4. do_exit() eventually calls audit_free() again, which is okay
     because audit_free() does a NULL check.

Free the old @audit_context first in audit_alloc_kernel(), and delete
the redundant calls to audit_free() for less confusion.

Fixes: 5bd2182d58e9 ("audit,io_uring,io-wq: add some basic audit support to io_uring")
Cc: stable@vger.kernel.org
Signed-off-by: Peilin Ye <peilin.ye@bytedance.com>
---
Hi all,

A better way to fix this memleak would probably be checking
@args->io_thread in copy_process()?  Something like:

    if (args->io_thread)
	retval = audit_alloc_kernel();
    else
	retval = audit_alloc();

But I didn't want to add another if to copy_process() for this bugfix.
Please suggest, thanks!

Peilin Ye

 fs/io-wq.c       | 1 -
 fs/io_uring.c    | 2 --
 kernel/auditsc.c | 1 +
 3 files changed, 1 insertion(+), 3 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index 824623bcf1a5..0f4804a5e873 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -670,7 +670,6 @@ static int io_wqe_worker(void *data)
 	if (test_bit(IO_WQ_BIT_EXIT, &wq->state))
 		io_worker_handle_work(worker);
 
-	audit_free(current);
 	io_worker_exit(worker);
 	return 0;
 }
diff --git a/fs/io_uring.c b/fs/io_uring.c
index e8e769be9ed0..0f27914f37f2 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9283,8 +9283,6 @@ static int io_sq_thread(void *data)
 	io_run_task_work();
 	mutex_unlock(&sqd->lock);
 
-	audit_free(current);
-
 	complete(&sqd->exited);
 	do_exit(0);
 }
diff --git a/kernel/auditsc.c b/kernel/auditsc.c
index 3a8c9d744800..7948090fd12f 100644
--- a/kernel/auditsc.c
+++ b/kernel/auditsc.c
@@ -1095,6 +1095,7 @@ int audit_alloc_kernel(struct task_struct *tsk)
 	 * 2. The {set,clear}_task_syscall_work() ops likely have zero effect
 	 * on these internal kernel tasks, but they probably don't hurt either.
 	 */
+	__audit_free(current);
 	return audit_alloc(tsk);
 }
 
-- 
2.20.1

