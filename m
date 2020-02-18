Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C431628F2
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 15:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbgBRO4z (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 09:56:55 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:53874 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726540AbgBRO4y (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 09:56:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582037813;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Q31XUITBYUDgelay51ZGFeoRFTX+LU6SfnNcMWjnStI=;
        b=FkOGCI4lYVqt7Fdlth0mvz15Sirk/ofYfjSXlD3sWzKb1wCla7tUA887/SNNlG+L9BSeI9
        hu4rjvrRIExnekbIkk4E3vy+8sca5Cvw3Ph7p6kQlW4BHAhnyCA0dVmv3ZGFqPeB12L7sY
        1d3m81uS7H9EZgTC+T+olddm6PZ+FRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-ljhHeChzO8uqm4XMH2e9Ug-1; Tue, 18 Feb 2020 09:56:49 -0500
X-MC-Unique: ljhHeChzO8uqm4XMH2e9Ug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CFF51005516;
        Tue, 18 Feb 2020 14:56:48 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 2597E60BE1;
        Tue, 18 Feb 2020 14:56:46 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 18 Feb 2020 15:56:48 +0100 (CET)
Date:   Tue, 18 Feb 2020 15:56:46 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200218145645.GB3466@redhat.com>
References: <5995f84e-8a6c-e774-6bb5-5b9b87a9cd3c@kernel.dk>
 <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/18, Peter Zijlstra wrote:
>
> But this has me wondering about task_work_run(), as it is it will
> unconditionally take pi_lock,

because spin_unlock_wait() was removed ;) task_work_run() doesn't
really need to take pi_lock at all. 

> would not something like this make sense?

I think yes, but see below.

> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -93,16 +93,20 @@ void task_work_run(void)
>  	struct callback_head *work, *head, *next;
>
>  	for (;;) {
> +		work = READ_ONCE(task->task_work);
> +		if (!work)
> +			break

This is wrong if PF_EXITING is set, in this case we must set
task->task_works = work_exited.

> +
>  		/*
>  		 * work->func() can do task_work_add(), do not set
>  		 * work_exited unless the list is empty.
>  		 */
>  		raw_spin_lock_irq(&task->pi_lock);
>  		do {
> -			work = READ_ONCE(task->task_works);
> -			head = !work && (task->flags & PF_EXITING) ?
> -				&work_exited : NULL;
> -		} while (cmpxchg(&task->task_works, work, head) != work);
> +			head = NULL;
> +			if (unlikely(!work && (task->flags & PF_EXITING)))
> +				head = &work_exited;
> +		} while (!try_cmpxchg(&task->task_works, &work, head));
>  		raw_spin_unlock_irq(&task->pi_lock);
>
>  		if (!work)

otherwise I think this is correct, but how about the patch below?
Then this code can be changed to use try_cmpxchg().

Oleg.

--- a/kernel/task_work.c
+++ b/kernel/task_work.c
@@ -97,17 +97,24 @@ void task_work_run(void)
 		 * work->func() can do task_work_add(), do not set
 		 * work_exited unless the list is empty.
 		 */
-		raw_spin_lock_irq(&task->pi_lock);
 		do {
+			head = NULL;
 			work = READ_ONCE(task->task_works);
-			head = !work && (task->flags & PF_EXITING) ?
-				&work_exited : NULL;
+			if (!work) {
+				if (task->flags & PF_EXITING)
+					head = &work_exited;
+				else
+					break;
+			}
 		} while (cmpxchg(&task->task_works, work, head) != work);
-		raw_spin_unlock_irq(&task->pi_lock);
 
 		if (!work)
 			break;
 
+		// Synchronize with task_work_cancel()
+		raw_spin_lock_irq(&task->pi_lock);
+		raw_spin_unlock_irq(&task->pi_lock);
+
 		do {
 			next = work->next;
 			work->func(work);

