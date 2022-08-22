Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 873FA59CB68
	for <lists+io-uring@lfdr.de>; Tue, 23 Aug 2022 00:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237724AbiHVW2B convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Mon, 22 Aug 2022 18:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232461AbiHVW2B (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Aug 2022 18:28:01 -0400
X-Greylist: delayed 4256 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 22 Aug 2022 15:27:59 PDT
Received: from cloud48395.mywhc.ca (cloud48395.mywhc.ca [173.209.37.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693D1491F2;
        Mon, 22 Aug 2022 15:27:59 -0700 (PDT)
Received: from [45.44.224.220] (port=49006 helo=[192.168.1.179])
        by cloud48395.mywhc.ca with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <olivier@trillion01.com>)
        id 1oQEn7-0007uE-5u;
        Mon, 22 Aug 2022 17:17:01 -0400
Message-ID: <61abfb5a517e0ee253b0dc7ba9cd32ebd558bcb0.camel@trillion01.com>
Subject: Re: [PATCH 2/2] coredump: Allow coredumps to pipes to work with
 io_uring
From:   Olivier Langlois <olivier@trillion01.com>
To:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 22 Aug 2022 17:16:59 -0400
In-Reply-To: <87mtd3rals.fsf_-_@email.froward.int.ebiederm.org>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
         <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
         <87h7i694ij.fsf_-_@disp2133>
         <1b519092-2ebf-3800-306d-c354c24a9ad1@gmail.com>
         <b3e43e07c68696b83a5bf25664a3fa912ba747e2.camel@trillion01.com>
         <13250a8d-1a59-4b7b-92e4-1231d73cbdda@gmail.com>
         <878rw9u6fb.fsf@email.froward.int.ebiederm.org>
         <303f7772-eb31-5beb-2bd0-4278566591b0@gmail.com>
         <87ilsg13yz.fsf@email.froward.int.ebiederm.org>
         <8218f1a245d054c940e25142fd00a5f17238d078.camel@trillion01.com>
         <a29a1649-5e50-4221-9f44-66a35fbdff80@kernel.dk>
         <87y1wnrap0.fsf_-_@email.froward.int.ebiederm.org>
         <87mtd3rals.fsf_-_@email.froward.int.ebiederm.org>
Organization: Trillion01 Inc
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8BIT
User-Agent: Evolution 3.44.3 
MIME-Version: 1.0
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - cloud48395.mywhc.ca
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - trillion01.com
X-Get-Message-Sender-Via: cloud48395.mywhc.ca: authenticated_id: olivier@trillion01.com
X-Authenticated-Sender: cloud48395.mywhc.ca: olivier@trillion01.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, 2022-07-20 at 11:51 -0500, Eric W. Biederman wrote:
> 
> Now that io_uring like everything else stops for coredumps in
> get_signal the code can once again allow any interruptible
> condition after coredump_wait to interrupt the coredump.
> 
> Clear TIF_NOTIFY_SIGNAL after coredump_wait, to guarantee that
> anything that sets TIF_NOTIFY_SIGNAL before coredump_wait completed
> won't cause the coredumps to interrupted.
> 
> With all of the other threads in the process stopped io_uring doesn't
> call task_work_add on the thread running do_coredump.  Combined with
> the clearing of TIF_NOTIFY_SIGNAL this allows processes that use
> io_uring to coredump through pipes.
> 
> Restore dump_interrupted to be a simple call to signal_pending
> effectively reverting commit 06af8679449d ("coredump: Limit what can
> interrupt coredumps").  At this point only SIGKILL delivered to the
> coredumping thread should be able to cause signal_pending to return
> true.
> 
> A nice followup would be to find a reliable race free way to modify
> task_work_add and probably set_notify_signal to skip setting
> TIF_NOTIFY_SIGNAL once it is clear a task will no longer process
> signals and other interruptible conditions.  That would allow
> TIF_NOTIFY_SIGNAL to be cleared where TIF_SIGPENDING is cleared in
> coredump_zap_process.
> 
> To be as certain as possible that this works, I tested this with
> commit 1d5f5ea7cb7d ("io-wq: remove worker to owner tw dependency")
> reverted.  Which means that not only is TIF_NOTIFY_SIGNAL prevented
> from stopping coredumps to pipes, the sequence of stopping threads to
> participate in the coredump avoids deadlocks that were possible
> previously.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> 
Hi Eric,

What is stopping the task calling do_coredump() to be interrupted and
call task_work_add() from the interrupt context?

This is precisely what I was experiencing last summer when I did work
on this issue.

My understanding of how async I/O works with io_uring is that the task
is added to a wait queue without being put to sleep and when the
io_uring callback is called from the interrupt context, task_work_add()
is called so that the next time io_uring syscall is invoked, pending
work is processed to complete the I/O.

So if:

1. io_uring request is initiated AND the task is in a wait queue
2. do_coredump() is called before the I/O is completed

IMHO, this is how you end up having task_work_add() called while the
coredump is generated.

So far, the only way that I have found making sure that this was not
happening was to cancel every pending io_uring requests before writing
the coredump by calling io_uring_task_cancel():

--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -43,7 +43,7 @@
 #include <linux/timekeeping.h>
 #include <linux/sysctl.h>
 #include <linux/elf.h>
-
+#include <linux/io_uring.h>
 #include <linux/uaccess.h>
 #include <asm/mmu_context.h>
 #include <asm/tlb.h>
@@ -561,6 +561,8 @@
 		need_suid_safe = true;
 	}
 
+	io_uring_task_cancel();
+
 	retval = coredump_wait(siginfo->si_signo, &core_state);
 	if (retval < 0)
 		goto fail_creds;


Greetings,

