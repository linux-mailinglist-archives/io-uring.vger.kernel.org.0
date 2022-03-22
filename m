Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B99A4E4687
	for <lists+io-uring@lfdr.de>; Tue, 22 Mar 2022 20:16:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiCVTRt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Mar 2022 15:17:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231359AbiCVTRO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Mar 2022 15:17:14 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E4A2B87D
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 12:15:46 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id b16so21408892ioz.3
        for <io-uring@vger.kernel.org>; Tue, 22 Mar 2022 12:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:content-language:to:from
         :subject:content-transfer-encoding;
        bh=Zd9a1e/9e1x7kvl5ShKwo4Hb1wt5zDKk6XqzCte1EEg=;
        b=GythQq+XZOgnHAmUXcGRpNeLMAHiEow3m7keualSaY1JH/4xetssuZDJi94nMH8vTj
         FDsw4YQ17HaXNasuMxB+dZiQME15IfjL8nujCDaxGw7e7mastRPPmC/vzFcXfRXfRaQx
         Mt8yduapBUOAuym7q0s2YU37vPQZpG4dPyjS0QHlW+gy0akh/B5bc3pDvfXsw7QwV7h7
         JWytMpCe1QY58JUrpQC2Fneq5/qJ82m9I1z1UfBE36m05+PBKam4eqssk8ua4uo+De5t
         6Y7yDV7PISQMKrsAmJo5yERPcgBz/pNWD4NC+zF2QMw0qkg9gAqJK5iqIe1nVRBvWgdn
         NaPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:content-transfer-encoding;
        bh=Zd9a1e/9e1x7kvl5ShKwo4Hb1wt5zDKk6XqzCte1EEg=;
        b=JLDmirXomeXEGUeeseTQXC5e/hoz0aSAqBNDnkxnNZ2TWvkS3boqDIFiJEaciXB8o0
         MVTJr/GlkVgii+7C7bBwKjSokEwaxsDN7sdsjwISwBYd1AWlG/14bn6wPY2t9S0u0Rz+
         R43PQyxpsP2mMZUyim6RHGfzgz1ktLGGbzrSwWi6b/8RwDN2uQxX85og9nptSQbDR9Be
         0tMVJWt2cu6d2iYauJiTvtcWXLodxAP8CD/+O7kEpKzIUZjGCfxtDhWMf+lgOgMcsMRD
         ClI6xeIjk5LEw9FR/NkIROo37dKBIJomPIhfi1z4jXT5xwtbN0S8F1w8MLEzKlgFocwv
         BL/w==
X-Gm-Message-State: AOAM531QSS94tV9O42i1AP56EbzLz/uBbqCywufyaL0E6qmIpaAtpM8s
        MSd+AEmtFwIr+ErhSPRC0+cDn3x1ujZkYpnQ
X-Google-Smtp-Source: ABdhPJzUGpzxF/b5EjotyVNSty0dVhhVO82AwotyxgYRf9FWBt/JFqEFYXtyA2w2K/pChPbGC8PGbg==
X-Received: by 2002:a05:6602:2b0d:b0:649:b2f:6290 with SMTP id p13-20020a0566022b0d00b006490b2f6290mr13442362iov.94.1647976545162;
        Tue, 22 Mar 2022 12:15:45 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id m14-20020a924b0e000000b002c851d50838sm531150ilg.30.2022.03.22.12.15.44
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Mar 2022 12:15:44 -0700 (PDT)
Message-ID: <34ac3b4c-8bd3-2346-2e78-f3050cf8c9ce@kernel.dk>
Date:   Tue, 22 Mar 2022 13:15:43 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix assuming triggered poll waitqueue is the single
 poll
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

syzbot reports a recent regression:

BUG: KASAN: use-after-free in __wake_up_common+0x637/0x650 kernel/sched/wait.c:101
Read of size 8 at addr ffff888011e8a130 by task syz-executor413/3618

CPU: 0 PID: 3618 Comm: syz-executor413 Tainted: G        W         5.17.0-syzkaller-01402-g8565d64430f8 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 print_address_description.constprop.0.cold+0x8d/0x303 mm/kasan/report.c:255
 __kasan_report mm/kasan/report.c:442 [inline]
 kasan_report.cold+0x83/0xdf mm/kasan/report.c:459
 __wake_up_common+0x637/0x650 kernel/sched/wait.c:101
 __wake_up_common_lock+0xd0/0x130 kernel/sched/wait.c:138
 tty_release+0x657/0x1200 drivers/tty/tty_io.c:1781
 __fput+0x286/0x9f0 fs/file_table.c:317
 task_work_run+0xdd/0x1a0 kernel/task_work.c:164
 exit_task_work include/linux/task_work.h:32 [inline]
 do_exit+0xaff/0x29d0 kernel/exit.c:806
 do_group_exit+0xd2/0x2f0 kernel/exit.c:936
 __do_sys_exit_group kernel/exit.c:947 [inline]
 __se_sys_exit_group kernel/exit.c:945 [inline]
 __x64_sys_exit_group+0x3a/0x50 kernel/exit.c:945
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f439a1fac69

which is due to leaving the request on the waitqueue mistakenly. The
reproducer is using a tty device, which means we end up arming the same
poll queue twice (it uses the same poll waitqueue for both), but in
io_poll_wake() we always just clear REQ_F_SINGLE_POLL regardless of which
entry triggered. This leaves one waitqueue potentially armed after we're
done, which then blows up in tty when the waitqueue is attempted removed.

We have no room to store this information, so simply encode it in the
wait_queue_entry->private where we store the io_kiocb request pointer.

Fixes: 91eac1c69c20 ("io_uring: cache poll/double-poll state with a request flag")
Reported-by: syzbot+09ad4050dd3a120bfccd@syzkaller.appspotmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 15c4c60decd3..b12bbb5f0cf7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6032,10 +6032,13 @@ static void io_poll_cancel_req(struct io_kiocb *req)
 	io_poll_execute(req, 0, 0);
 }
 
+#define wqe_to_req(wait)	((void *)((unsigned long) (wait)->private & ~1))
+#define wqe_is_double(wait)	((unsigned long) (wait)->private & 1)
+
 static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 			void *key)
 {
-	struct io_kiocb *req = wait->private;
+	struct io_kiocb *req = wqe_to_req(wait);
 	struct io_poll_iocb *poll = container_of(wait, struct io_poll_iocb,
 						 wait);
 	__poll_t mask = key_to_poll(key);
@@ -6073,7 +6076,10 @@ static int io_poll_wake(struct wait_queue_entry *wait, unsigned mode, int sync,
 		if (mask && poll->events & EPOLLONESHOT) {
 			list_del_init(&poll->wait.entry);
 			poll->head = NULL;
-			req->flags &= ~REQ_F_SINGLE_POLL;
+			if (wqe_is_double(wait))
+				req->flags &= ~REQ_F_DOUBLE_POLL;
+			else
+				req->flags &= ~REQ_F_SINGLE_POLL;
 		}
 		__io_poll_execute(req, mask, poll->events);
 	}
@@ -6085,6 +6091,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			    struct io_poll_iocb **poll_ptr)
 {
 	struct io_kiocb *req = pt->req;
+	unsigned long wqe_private = (unsigned long) req;
 
 	/*
 	 * The file being polled uses multiple waitqueues for poll handling
@@ -6110,6 +6117,8 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 			pt->error = -ENOMEM;
 			return;
 		}
+		/* mark as double wq entry */
+		wqe_private |= 1;
 		req->flags |= REQ_F_DOUBLE_POLL;
 		io_init_poll_iocb(poll, first->events, first->wait.func);
 		*poll_ptr = poll;
@@ -6120,7 +6129,7 @@ static void __io_queue_proc(struct io_poll_iocb *poll, struct io_poll_table *pt,
 	req->flags |= REQ_F_SINGLE_POLL;
 	pt->nr_entries++;
 	poll->head = head;
-	poll->wait.private = req;
+	poll->wait.private = (void *) wqe_private;
 
 	if (poll->events & EPOLLEXCLUSIVE)
 		add_wait_queue_exclusive(head, &poll->wait);
@@ -6147,7 +6156,6 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	INIT_HLIST_NODE(&req->hash_node);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
-	poll->wait.private = req;
 
 	ipt->pt._key = mask;
 	ipt->req = req;

-- 
Jens Axboe

