Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227993A349E
	for <lists+io-uring@lfdr.de>; Thu, 10 Jun 2021 22:11:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbhFJUNR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 10 Jun 2021 16:13:17 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35978 "EHLO
        out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbhFJUNR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 10 Jun 2021 16:13:17 -0400
Received: from in02.mta.xmission.com ([166.70.13.52])
        by out01.mta.xmission.com with esmtps  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lrR1M-007Xt1-Ak; Thu, 10 Jun 2021 14:11:20 -0600
Received: from ip68-227-160-95.om.om.cox.net ([68.227.160.95] helo=email.xmission.com)
        by in02.mta.xmission.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <ebiederm@xmission.com>)
        id 1lrR1J-003Jez-V6; Thu, 10 Jun 2021 14:11:19 -0600
From:   ebiederm@xmission.com (Eric W. Biederman)
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Olivier Langlois <olivier@trillion01.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        io-uring <io-uring@vger.kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jens Axboe <axboe@kernel.dk>,
        "Pavel Begunkov\>" <asml.silence@gmail.com>,
        Oleg Nesterov <oleg@redhat.com>
References: <192c9697e379bf084636a8213108be6c3b948d0b.camel@trillion01.com>
        <9692dbb420eef43a9775f425cb8f6f33c9ba2db9.camel@trillion01.com>
        <87h7i694ij.fsf_-_@disp2133>
        <CAHk-=wjC7GmCHTkoz2_CkgSc_Cgy19qwSQgJGXz+v2f=KT3UOw@mail.gmail.com>
        <198e912402486f66214146d4eabad8cb3f010a8e.camel@trillion01.com>
        <87eeda7nqe.fsf@disp2133>
        <b8434a8987672ab16f9fb755c1fc4d51e0f4004a.camel@trillion01.com>
        <87pmwt6biw.fsf@disp2133> <87czst5yxh.fsf_-_@disp2133>
        <CAHk-=wiax83WoS0p5nWvPhU_O+hcjXwv6q3DXV8Ejb62BfynhQ@mail.gmail.com>
        <87y2bh4jg5.fsf@disp2133>
        <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
Date:   Thu, 10 Jun 2021 15:11:11 -0500
In-Reply-To: <CAHk-=wjPiEaXjUp6PTcLZFjT8RrYX+ExtD-RY3NjFWDN7mKLbw@mail.gmail.com>
        (Linus Torvalds's message of "Thu, 10 Jun 2021 12:50:48 -0700")
Message-ID: <87sg1p4h0g.fsf_-_@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lrR1J-003Jez-V6;;;mid=<87sg1p4h0g.fsf_-_@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18hK16UcC6YSRYFbVnqrU+yXlLACZ2upQQ=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on sa06.xmission.com
X-Spam-Level: 
X-Spam-Status: No, score=-0.2 required=8.0 tests=ALL_TRUSTED,BAYES_50,
        DCC_CHECK_NEGATIVE,T_TM2_M_HEADER_IN_MSG autolearn=disabled
        version=3.4.2
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
        *  0.8 BAYES_50 BODY: Bayes spam probability is 40 to 60%
        *      [score: 0.5000]
        *  0.0 T_TM2_M_HEADER_IN_MSG BODY: No description available.
        * -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
        *      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Linus Torvalds <torvalds@linux-foundation.org>
X-Spam-Relay-Country: 
X-Spam-Timing: total 1436 ms - load_scoreonly_sql: 0.09 (0.0%),
        signal_user_changed: 13 (0.9%), b_tie_ro: 11 (0.7%), parse: 1.31
        (0.1%), extract_message_metadata: 18 (1.2%), get_uri_detail_list: 2.2
        (0.2%), tests_pri_-1000: 23 (1.6%), tests_pri_-950: 1.38 (0.1%),
        tests_pri_-900: 1.11 (0.1%), tests_pri_-90: 80 (5.6%), check_bayes: 77
        (5.3%), b_tokenize: 8 (0.5%), b_tok_get_all: 9 (0.6%), b_comp_prob:
        2.9 (0.2%), b_tok_touch_all: 53 (3.7%), b_finish: 1.22 (0.1%),
        tests_pri_0: 1279 (89.1%), check_dkim_signature: 0.67 (0.0%),
        check_dkim_adsp: 3.1 (0.2%), poll_dns_idle: 0.46 (0.0%), tests_pri_10:
        3.5 (0.2%), tests_pri_500: 12 (0.9%), rewrite_mail: 0.00 (0.0%)
Subject: [PATCH] coredump: Limit what can interrupt coredumps
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Olivier Langlois has been struggling with coredumps being incompletely written in
processes using io_uring.

Olivier Langlois <olivier@trillion01.com> writes:
> io_uring is a big user of task_work and any event that io_uring made a
> task waiting for that occurs during the core dump generation will
> generate a TIF_NOTIFY_SIGNAL.
>
> Here are the detailed steps of the problem:
> 1. io_uring calls vfs_poll() to install a task to a file wait queue
>    with io_async_wake() as the wakeup function cb from io_arm_poll_handler()
> 2. wakeup function ends up calling task_work_add() with TWA_SIGNAL
> 3. task_work_add() sets the TIF_NOTIFY_SIGNAL bit by calling
>    set_notify_signal()

The coredump code deliberately supports being interrupted by SIGKILL,
and depends upon prepare_signal to filter out all other signals.   Now
that signal_pending includes wake ups for TIF_NOTIFY_SIGNAL this hack
in dump_emitted by the coredump code no longer works.

Make the coredump code more robust by explicitly testing for all of
the wakeup conditions the coredump code supports.  This prevents
new wakeup conditions from breaking the coredump code, as well
as fixing the current issue.

The filesystem code that the coredump code uses already limits
itself to only aborting on fatal_signal_pending.  So it should
not develop surprising wake-up reasons either.

v2: Don't remove the now unnecessary code in prepare_signal.

Cc: stable@vger.kernel.org
Fixes: 12db8b690010 ("entry: Add support for TIF_NOTIFY_SIGNAL")
Reported-by: Olivier Langlois <olivier@trillion01.com>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---
 fs/coredump.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/coredump.c b/fs/coredump.c
index 2868e3e171ae..c3d8fc14b993 100644
--- a/fs/coredump.c
+++ b/fs/coredump.c
@@ -519,7 +519,7 @@ static bool dump_interrupted(void)
 	 * but then we need to teach dump_write() to restart and clear
 	 * TIF_SIGPENDING.
 	 */
-	return signal_pending(current);
+	return fatal_signal_pending(current) || freezing(current);
 }
 
 static void wait_for_dump_helpers(struct file *file)
-- 
2.20.1

