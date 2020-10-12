Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0019528BF02
	for <lists+io-uring@lfdr.de>; Mon, 12 Oct 2020 19:27:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404039AbgJLR1u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 12 Oct 2020 13:27:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:40582 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390753AbgJLR1u (ORCPT <rfc822;io-uring@vger.kernel.org>);
        Mon, 12 Oct 2020 13:27:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 458A6AC6C;
        Mon, 12 Oct 2020 17:27:49 +0000 (UTC)
Date:   Mon, 12 Oct 2020 19:27:48 +0200 (CEST)
From:   Miroslav Benes <mbenes@suse.cz>
To:     Jens Axboe <axboe@kernel.dk>
cc:     Oleg Nesterov <oleg@redhat.com>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, peterz@infradead.org, tglx@linutronix.de,
        live-patching@vger.kernel.org
Subject: Re: [PATCHSET RFC v3 0/6] Add support for TIF_NOTIFY_SIGNAL
In-Reply-To: <9a01ab10-3140-3fa6-0fcf-07d3179973f2@kernel.dk>
Message-ID: <alpine.LSU.2.21.2010121921420.10435@pobox.suse.cz>
References: <20201005150438.6628-1-axboe@kernel.dk> <20201008145610.GK9995@redhat.com> <alpine.LSU.2.21.2010090959260.23400@pobox.suse.cz> <e33ec671-3143-d720-176b-a8815996fd1c@kernel.dk> <9a01ab10-3140-3fa6-0fcf-07d3179973f2@kernel.dk>
User-Agent: Alpine 2.21 (LSU 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, 10 Oct 2020, Jens Axboe wrote:

> On 10/9/20 9:21 AM, Jens Axboe wrote:
> > On 10/9/20 2:01 AM, Miroslav Benes wrote:
> >> On Thu, 8 Oct 2020, Oleg Nesterov wrote:
> >>
> >>> On 10/05, Jens Axboe wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> The goal is this patch series is to decouple TWA_SIGNAL based task_work
> >>>> from real signals and signal delivery.
> >>>
> >>> I think TIF_NOTIFY_SIGNAL can have more users. Say, we can move
> >>> try_to_freeze() from get_signal() to tracehook_notify_signal(), kill
> >>> fake_signal_wake_up(), and remove freezing() from recalc_sigpending().
> >>>
> >>> Probably the same for TIF_PATCH_PENDING, klp_send_signals() can use
> >>> set_notify_signal() rather than signal_wake_up().
> >>
> >> Yes, that was my impression from the patch set too, when I accidentally 
> >> noticed it.
> >>
> >> Jens, could you CC our live patching ML when you submit v4, please? It 
> >> would be a nice cleanup.
> > 
> > Definitely, though it'd be v5 at this point. But we really need to get
> > all archs supporting TIF_NOTIFY_SIGNAL first. Once we have that, there's
> > a whole slew of cleanups that'll fall out naturally:
> > 
> > - Removal of JOBCTL_TASK_WORK
> > - Removal of special path for TWA_SIGNAL in task_work
> > - TIF_PATCH_PENDING can be converted and then removed
> > - try_to_freeze() cleanup that Oleg mentioned
> > 
> > And probably more I'm not thinking of right now :-)
> 
> Here's the current series, I took a stab at converting all archs to
> support TIF_NOTIFY_SIGNAL so we have a base to build on top of. Most
> of them were straight forward, but I need someone to fixup powerpc,
> verify arm and s390.
> 
> But it's a decent start I think, and means that we can drop various
> bits as is done at the end of the series. I could swap things around
> a bit and avoid having the intermediate step, but I envision that
> getting this in all archs will take a bit longer than just signing off
> on the generic/x86 bits. So probably best to keep the series as it is
> for now, and work on getting the arch bits verified/fixed/tested.
> 
> https://git.kernel.dk/cgit/linux-block/log/?h=tif-task_work

Thanks, Jens.

Crude diff for live patching on top of the series is below. Tested only on 
x86_64, but it passes the tests without an issue.

Miroslav

---
diff --git a/kernel/livepatch/transition.c b/kernel/livepatch/transition.c
index f6310f848f34..3a4beb9395c4 100644
--- a/kernel/livepatch/transition.c
+++ b/kernel/livepatch/transition.c
@@ -9,6 +9,7 @@
 
 #include <linux/cpu.h>
 #include <linux/stacktrace.h>
+#include <linux/tracehook.h>
 #include "core.h"
 #include "patch.h"
 #include "transition.h"
@@ -369,9 +370,7 @@ static void klp_send_signals(void)
                         * Send fake signal to all non-kthread tasks which are
                         * still not migrated.
                         */
-                       spin_lock_irq(&task->sighand->siglock);
-                       signal_wake_up(task, 0);
-                       spin_unlock_irq(&task->sighand->siglock);
+                       set_notify_signal(task);
                }
        }
        read_unlock(&tasklist_lock);
diff --git a/kernel/signal.c b/kernel/signal.c
index a15c584a0455..b7cf4eda8611 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -181,8 +181,7 @@ void recalc_sigpending_and_wake(struct task_struct *t)
 
 void recalc_sigpending(void)
 {
-       if (!recalc_sigpending_tsk(current) && !freezing(current) &&
-           !klp_patch_pending(current))
+       if (!recalc_sigpending_tsk(current) && !freezing(current))
                clear_thread_flag(TIF_SIGPENDING);
 
 }

