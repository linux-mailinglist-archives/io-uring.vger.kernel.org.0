Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F13D5EFB74
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 19:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbiI2RAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Sep 2022 13:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbiI2RA2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Sep 2022 13:00:28 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A69B57569
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 10:00:28 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id d14so1010037ilf.2
        for <io-uring@vger.kernel.org>; Thu, 29 Sep 2022 10:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date;
        bh=ovBTWy4pASe9BmSeJ62HNtp5kRaKjOJvf50MqD4mJLk=;
        b=eCRjNXTVIVjBFxvd4Ht/oLCZ0VZPdxIQNlP5ZP7nUkaZ2WiecoiFQVwWuimSgyIVVi
         uHHUDXh/LX33aAEMZcunq7qEzEpoVAvBTOpqhALPDCT5L/p8D1eys0JoDxPcg8yf9jPw
         53YRJlW1mRxsgSmIoet5b470vG6bDpL92MPpeU4yTuaJKLzDIJDAeFvRpbDRkdikQfLn
         1pO3AOxAKgR2CO7UmKs1AVX5Uh4oOHg8Kdl2SHGjc+m4zU4F9L/csWLetC7O1bA99pDZ
         PxQIUhXPC3xKfTqrHr1eZd9Zots3nOhsvEKmBH8dvC3z116pvBzcAZ8Lj8KMsm+gNWQv
         Ev3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date;
        bh=ovBTWy4pASe9BmSeJ62HNtp5kRaKjOJvf50MqD4mJLk=;
        b=jKMduJIE7YtHe9p9+yVrxEhmMvPDAYv3fv8N89ltgb9FoJnFo1Ia0kBd5jXbMF5Kn2
         p01gxugQgtVfXgcev6UL7Oswhi0IVpsLBWJQs4H1nkg4CCAv28l9ooH0U4NKdZLZkQ06
         QKbdz4Xlthf3n3kmCOcSVS8Jmq+hOiDnK4AbXCawWu5T7Rt+KbAalx40vPDNEi+vun4y
         wH2yJbwLsKfALZj+9iyIv6zOtjbSXXoLRQO2X8cxHE+G68/M0FPq1BkQ6u86FH9/sa0Y
         xQiZalelE1qy3XWMpFkalUqqpB3IyYyqyfTlpHT2Aa37m6RVp6MEOmccgQ0WA75S2ri2
         Kz+w==
X-Gm-Message-State: ACrzQf1S07GQKGpMG6eAj/1Rn8WVjAJ3Zw64uA7vEgjizAgt0xH+RC5I
        17mgN4miWFv4l3uQBL4YbozCTXMDIAL2bA==
X-Google-Smtp-Source: AMsMyM4w3JADuB2dw9hFE45uhen2+2X6mYPIStH5FwOPdojZXkKWITXIiQ5vaP49OjVOCoxYl0wA2A==
X-Received: by 2002:a05:6e02:164d:b0:2f1:9b43:9157 with SMTP id v13-20020a056e02164d00b002f19b439157mr2173598ilu.94.1664470827168;
        Thu, 29 Sep 2022 10:00:27 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id x21-20020a056638027500b00358cfb04225sm3176350jaq.25.2022.09.29.10.00.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Sep 2022 10:00:26 -0700 (PDT)
Message-ID: <8cc4528f-ebce-d570-086f-f2f1098b532d@kernel.dk>
Date:   Thu, 29 Sep 2022 11:00:25 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
Cc:     Jan Kara <jack@suse.cz>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: defer fsnotify calls to task context
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can't call these off the kiocb completion as that might be off
soft/hard irq context. Defer the calls to when we process the
task_work for this request. That avoids valid complaints like:

stack backtrace:
CPU: 1 PID: 0 Comm: swapper/1 Not tainted 6.0.0-rc6-syzkaller-00321-g105a36f3694e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 08/26/2022
Call Trace:
 <IRQ>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_usage_bug kernel/locking/lockdep.c:3961 [inline]
 valid_state kernel/locking/lockdep.c:3973 [inline]
 mark_lock_irq kernel/locking/lockdep.c:4176 [inline]
 mark_lock.part.0.cold+0x18/0xd8 kernel/locking/lockdep.c:4632
 mark_lock kernel/locking/lockdep.c:4596 [inline]
 mark_usage kernel/locking/lockdep.c:4527 [inline]
 __lock_acquire+0x11d9/0x56d0 kernel/locking/lockdep.c:5007
 lock_acquire kernel/locking/lockdep.c:5666 [inline]
 lock_acquire+0x1ab/0x570 kernel/locking/lockdep.c:5631
 __fs_reclaim_acquire mm/page_alloc.c:4674 [inline]
 fs_reclaim_acquire+0x115/0x160 mm/page_alloc.c:4688
 might_alloc include/linux/sched/mm.h:271 [inline]
 slab_pre_alloc_hook mm/slab.h:700 [inline]
 slab_alloc mm/slab.c:3278 [inline]
 __kmem_cache_alloc_lru mm/slab.c:3471 [inline]
 kmem_cache_alloc+0x39/0x520 mm/slab.c:3491
 fanotify_alloc_fid_event fs/notify/fanotify/fanotify.c:580 [inline]
 fanotify_alloc_event fs/notify/fanotify/fanotify.c:813 [inline]
 fanotify_handle_event+0x1130/0x3f40 fs/notify/fanotify/fanotify.c:948
 send_to_group fs/notify/fsnotify.c:360 [inline]
 fsnotify+0xafb/0x1680 fs/notify/fsnotify.c:570
 __fsnotify_parent+0x62f/0xa60 fs/notify/fsnotify.c:230
 fsnotify_parent include/linux/fsnotify.h:77 [inline]
 fsnotify_file include/linux/fsnotify.h:99 [inline]
 fsnotify_access include/linux/fsnotify.h:309 [inline]
 __io_complete_rw_common+0x485/0x720 io_uring/rw.c:195
 io_complete_rw+0x1a/0x1f0 io_uring/rw.c:228
 iomap_dio_complete_work fs/iomap/direct-io.c:144 [inline]
 iomap_dio_bio_end_io+0x438/0x5e0 fs/iomap/direct-io.c:178
 bio_endio+0x5f9/0x780 block/bio.c:1564
 req_bio_endio block/blk-mq.c:695 [inline]
 blk_update_request+0x3fc/0x1300 block/blk-mq.c:825
 scsi_end_request+0x7a/0x9a0 drivers/scsi/scsi_lib.c:541
 scsi_io_completion+0x173/0x1f70 drivers/scsi/scsi_lib.c:971
 scsi_complete+0x122/0x3b0 drivers/scsi/scsi_lib.c:1438
 blk_complete_reqs+0xad/0xe0 block/blk-mq.c:1022
 __do_softirq+0x1d3/0x9c6 kernel/softirq.c:571
 invoke_softirq kernel/softirq.c:445 [inline]
 __irq_exit_rcu+0x123/0x180 kernel/softirq.c:650
 irq_exit_rcu+0x5/0x20 kernel/softirq.c:662
 common_interrupt+0xa9/0xc0 arch/x86/kernel/irq.c:240

Link: https://lore.kernel.org/all/20220929135627.ykivmdks2w5vzrwg@quack3/
Reported-by: syzbot+dfcc5f4da15868df7d4d@syzkaller.appspotmail.com
Reported-by: Jan Kara <jack@suse.cz>
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1ae1e52ab4cb..a25cd44cd415 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -236,14 +236,6 @@ static void kiocb_end_write(struct io_kiocb *req)
 
 static bool __io_complete_rw_common(struct io_kiocb *req, long res)
 {
-	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
-
-	if (rw->kiocb.ki_flags & IOCB_WRITE) {
-		kiocb_end_write(req);
-		fsnotify_modify(req->file);
-	} else {
-		fsnotify_access(req->file);
-	}
 	if (unlikely(res != req->cqe.res)) {
 		if ((res == -EAGAIN || res == -EOPNOTSUPP) &&
 		    io_rw_should_reissue(req)) {
@@ -270,6 +262,20 @@ static inline int io_fixup_rw_res(struct io_kiocb *req, long res)
 	return res;
 }
 
+static void io_req_rw_complete(struct io_kiocb *req, bool *locked)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+	if (rw->kiocb.ki_flags & IOCB_WRITE) {
+		kiocb_end_write(req);
+		fsnotify_modify(req->file);
+	} else {
+		fsnotify_access(req->file);
+	}
+
+	io_req_task_complete(req, locked);
+}
+
 static void io_complete_rw(struct kiocb *kiocb, long res)
 {
 	struct io_rw *rw = container_of(kiocb, struct io_rw, kiocb);
@@ -278,7 +284,7 @@ static void io_complete_rw(struct kiocb *kiocb, long res)
 	if (__io_complete_rw_common(req, res))
 		return;
 	io_req_set_res(req, io_fixup_rw_res(req, res), 0);
-	req->io_task_work.func = io_req_task_complete;
+	req->io_task_work.func = io_req_rw_complete;
 	io_req_task_work_add(req);
 }
 
-- 
Jens Axboe
