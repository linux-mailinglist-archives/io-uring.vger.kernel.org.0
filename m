Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C3116634A
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 17:39:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgBTQjw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 11:39:52 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47346 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728090AbgBTQjw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 11:39:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=Czln9zO1MbNs+5/lq7jslZJ9cOfAoIa1zN/EhrpDmYk=; b=Q22463E0pu4m0S3aqVEg59g5qL
        fjzSbHQjBc0yf0umZxpa5ninACLCbCT6ftB7wuTUM2zwh810nAwY/cIoYujEDFWOzIZc15BIJifi0
        TLzW6HbaFgtAa8EuhgdglcbrGAfj1nIKr+9BPnIyOIvm+c80ESX5ynPsOxLSaIOXAH6GWWbKm1vrF
        d8QrIAJwamnMRsY/mRgLt7r4T9MbBu6AjpVObWJIbwFv+T+hbQXoZUmww4lCaKBt+Jd8fPdqbszTI
        w8KP8yolwhNdCooyrDCVDN3rcL46IuNDZZbRSsT58afx5I5XNA5OQ5/1KqFS2hI0WkEkYn+DNr7Dn
        UFp7c2Jw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4orX-0000Hj-A1; Thu, 20 Feb 2020 16:39:43 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3E6F1300606;
        Thu, 20 Feb 2020 17:37:45 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 429C829D73548; Thu, 20 Feb 2020 17:39:38 +0100 (CET)
Date:   Thu, 20 Feb 2020 17:39:38 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Oleg Nesterov <oleg@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
Message-ID: <20200220163938.GA18400@hirez.programming.kicks-ass.net>
References: <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218155017.GD3466@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 18, 2020 at 04:50:18PM +0100, Oleg Nesterov wrote:
> As Peter pointed out, task_work() can avoid ->pi_lock and cmpxchg()
> if task->task_works == NULL && !PF_EXITING.
> 
> And in fact the only reason why task_work_run() needs ->pi_lock is
> the possible race with task_work_cancel(), we can optimize this code
> and make the locking more clear.
> 
> Signed-off-by: Oleg Nesterov <oleg@redhat.com>
> ---

Still playing with my try_cmpxchg() patches, how does the below look on
top?

---
--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -27,14 +27,13 @@ static struct callback_head work_exited;
 int
 task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
-	struct callback_head *head;
+	struct callback_head *head = READ_ONCE(tsk->task_works);
 
 	do {
-		head = READ_ONCE(task->task_works);
 		if (unlikely(head == &work_exited))
 			return -ESRCH;
 		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
+	} while (!try_cmpxchg(&task->task_works, &head, work))
 
 	if (notify)
 		set_notify_resume(task);
@@ -90,26 +89,24 @@ task_work_cancel(struct task_struct *tas
 void task_work_run(void)
 {
 	struct task_struct *task = current;
-	struct callback_head *work, *head, *next;
+	struct callback_head *work, *next;
 
 	for (;;) {
-		/*
-		 * work->func() can do task_work_add(), do not set
-		 * work_exited unless the list is empty.
-		 */
-		do {
-			head = NULL;
-			work = READ_ONCE(task->task_works);
-			if (!work) {
-				if (task->flags & PF_EXITING)
-					head = &work_exited;
-				else
-					break;
-			}
-		} while (cmpxchg(&task->task_works, work, head) != work);
+		work = READ_ONCE(task->task_works);
+		if (!work) {
+			if (!(task->flags & PF_EXITING))
+				return;
+
+			/*
+			 * work->func() can do task_work_add(), do not set
+			 * work_exited unless the list is empty.
+			 */
+			if (try_cmpxchg(&task->task_works, &work, &work_exited))
+				return;
+		}
+
+		work = xchg(&task->task_works, NULL);
 
-		if (!work)
-			break;
 		/*
 		 * Synchronize with task_work_cancel(). It can not remove
 		 * the first entry == work, cmpxchg(task_works) must fail.
