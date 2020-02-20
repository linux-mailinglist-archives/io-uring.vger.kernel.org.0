Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24389166469
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 18:23:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728951AbgBTRW1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 12:22:27 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:45159 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728956AbgBTRW1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 12:22:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582219346;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oXI9WDxpGrp9K/GguTTn23zQAGWmtfml14JW+Pao87A=;
        b=a09E/tS00/aDdd6DIuDAMyDd8JyJusSFV2lJe2JoiBdkLXp+7DZa0rzvQo9utHA1wW4Hzj
        88K9YS9FVSOcr2WaJn+cqzj+u9CBJ7vMExkPok1/sW8GIOrZkrUTou21bVA3WG79f4pKlK
        /mLn7fq2zWIqmqtJXYWH1L1JT5eAUFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-74-wZ4YNsC3P_Op-d5VksTedg-1; Thu, 20 Feb 2020 12:22:06 -0500
X-MC-Unique: wZ4YNsC3P_Op-d5VksTedg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 694C01007270;
        Thu, 20 Feb 2020 17:22:05 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 0885E60C63;
        Thu, 20 Feb 2020 17:22:03 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Thu, 20 Feb 2020 18:22:04 +0100 (CET)
Date:   Thu, 20 Feb 2020 18:22:02 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [PATCH] task_work_run: don't take ->pi_lock unconditionally
Message-ID: <20200220172201.GC27143@redhat.com>
References: <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
 <20200218150756.GC14914@hirez.programming.kicks-ass.net>
 <20200218155017.GD3466@redhat.com>
 <20200220163938.GA18400@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220163938.GA18400@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/20, Peter Zijlstra wrote:
>
> Still playing with my try_cmpxchg() patches, how does the below look on
> top?

I too made a simple patch right after you sent "[PATCH] asm-generic/atomic:
Add try_cmpxchg() fallbacks", see below.

But I am fine with your version, with one exception

>  void task_work_run(void)
>  {
>  	struct task_struct *task = current;
> -	struct callback_head *work, *head, *next;
> +	struct callback_head *work, *next;
>  
>  	for (;;) {
> -		/*
> -		 * work->func() can do task_work_add(), do not set
> -		 * work_exited unless the list is empty.
> -		 */
> -		do {
> -			head = NULL;
> -			work = READ_ONCE(task->task_works);
> -			if (!work) {
> -				if (task->flags & PF_EXITING)
> -					head = &work_exited;
> -				else
> -					break;
> -			}
> -		} while (cmpxchg(&task->task_works, work, head) != work);
> +		work = READ_ONCE(task->task_works);
> +		if (!work) {
> +			if (!(task->flags & PF_EXITING))
> +				return;
> +
> +			/*
> +			 * work->func() can do task_work_add(), do not set
> +			 * work_exited unless the list is empty.
> +			 */
> +			if (try_cmpxchg(&task->task_works, &work, &work_exited))
> +				return;
> +		}
> +
> +		work = xchg(&task->task_works, NULL);
>  
> -		if (!work)
> -			break;

You can't remove the "if (!work)" check, cancel_task_work() can remove
a single callback between READ_ONCE() and xchg().

Oleg.

--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -27,14 +27,11 @@ static struct callback_head work_exited; /* all we need is ->next == NULL */
 int
 task_work_add(struct task_struct *task, struct callback_head *work, bool notify)
 {
-	struct callback_head *head;
-
+	work->next = READ_ONCE(task->task_works);
 	do {
-		head = READ_ONCE(task->task_works);
-		if (unlikely(head == &work_exited))
+		if (unlikely(work->next == &work_exited))
 			return -ESRCH;
-		work->next = head;
-	} while (cmpxchg(&task->task_works, head, work) != head);
+	} while (!try_cmpxchg(&task->task_works, &work->next, work));
 
 	if (notify)
 		set_notify_resume(task);
@@ -68,10 +65,10 @@ task_work_cancel(struct task_struct *task, task_work_func_t func)
 	 * we raced with task_work_run(), *pprev == NULL/exited.
 	 */
 	raw_spin_lock_irqsave(&task->pi_lock, flags);
-	while ((work = READ_ONCE(*pprev))) {
+	for (work = READ_ONCE(*pprev); work; ) {
 		if (work->func != func)
 			pprev = &work->next;
-		else if (cmpxchg(pprev, work, work->next) == work)
+		else if (try_cmpxchg(pprev, &work, work->next))
 			break;
 	}
 	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
@@ -97,16 +94,16 @@ void task_work_run(void)
 		 * work->func() can do task_work_add(), do not set
 		 * work_exited unless the list is empty.
 		 */
+		work = READ_ONCE(task->task_works);
 		do {
 			head = NULL;
-			work = READ_ONCE(task->task_works);
 			if (!work) {
 				if (task->flags & PF_EXITING)
 					head = &work_exited;
 				else
 					break;
 			}
-		} while (cmpxchg(&task->task_works, work, head) != work);
+		} while (!try_cmpxchg(&task->task_works, &work, head));
 
 		if (!work)
 			break;

