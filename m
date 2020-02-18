Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8CAE16290D
	for <lists+io-uring@lfdr.de>; Tue, 18 Feb 2020 16:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726762AbgBRPH6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Feb 2020 10:07:58 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:28888 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726754AbgBRPH6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Feb 2020 10:07:58 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1582038477;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Csihf+yC5wp9Zjgw8iwbaFl0vMLJ/l7ONnGLpyNywMw=;
        b=STjCcx3qjplHEE4bCLXzsxspPRE7H+4gsA3fSVmZepLJpP0h6wMd5O5L/gcNuLM0KM7OPN
        vuzG0XLE03pXiD6z444UYq3RkYnv6DKk2MUJXO5TPIbaPaU/V7cl8DkEpAC6OhiM2awwog
        9WQ1f9XemIxzt1a41IFzCoB2c7V3fm8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-288-a1QYYBk_NG2RvPL4vCLc8A-1; Tue, 18 Feb 2020 10:07:53 -0500
X-MC-Unique: a1QYYBk_NG2RvPL4vCLc8A-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C488F802692;
        Tue, 18 Feb 2020 15:07:48 +0000 (UTC)
Received: from dhcp-27-174.brq.redhat.com (unknown [10.43.17.70])
        by smtp.corp.redhat.com (Postfix) with SMTP id 55E1860FFB;
        Tue, 18 Feb 2020 15:07:46 +0000 (UTC)
Received: by dhcp-27-174.brq.redhat.com (nbSMTP-1.00) for uid 1000
        oleg@redhat.com; Tue, 18 Feb 2020 16:07:48 +0100 (CET)
Date:   Tue, 18 Feb 2020 16:07:45 +0100
From:   Oleg Nesterov <oleg@redhat.com>
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Carter Li =?utf-8?B?5p2O6YCa5rSy?= <carter.li@eoitek.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Subject: Re: [ISSUE] The time cost of IOSQE_IO_LINK
Message-ID: <20200218150745.GC3466@redhat.com>
References: <7c4c3996-4886-eb58-cdee-fe0951907ab5@kernel.dk>
 <addcd44e-ed9b-5f82-517d-c1ed3ee2d85c@kernel.dk>
 <b8069e62-7ea4-c7f3-55a3-838241951068@kernel.dk>
 <20200217120920.GQ14914@hirez.programming.kicks-ass.net>
 <53de3581-b902-89ba-3f53-fd46b052df40@kernel.dk>
 <43c066d1-a892-6a02-82e7-7be850d9454d@kernel.dk>
 <20200217174610.GU14897@hirez.programming.kicks-ass.net>
 <592cf069-41ee-0bc1-1f83-e058e5dd53ff@kernel.dk>
 <20200218131310.GZ14914@hirez.programming.kicks-ass.net>
 <20200218145645.GB3466@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200218145645.GB3466@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 02/18, Oleg Nesterov wrote:
>
> otherwise I think this is correct, but how about the patch below?
> Then this code can be changed to use try_cmpxchg().

You have already sent the patch which adds the generic try_cmpxchg,
so the patch below can be trivially adapted.

But I'd prefer another change, I think both task_work_add() and
task_work_cancel() can use try_cmpxchg() too.

> 
> Oleg.
> 
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -97,17 +97,24 @@ void task_work_run(void)
>  		 * work->func() can do task_work_add(), do not set
>  		 * work_exited unless the list is empty.
>  		 */
> -		raw_spin_lock_irq(&task->pi_lock);
>  		do {
> +			head = NULL;
>  			work = READ_ONCE(task->task_works);
> -			head = !work && (task->flags & PF_EXITING) ?
> -				&work_exited : NULL;
> +			if (!work) {
> +				if (task->flags & PF_EXITING)
> +					head = &work_exited;
> +				else
> +					break;
> +			}
>  		} while (cmpxchg(&task->task_works, work, head) != work);
> -		raw_spin_unlock_irq(&task->pi_lock);
>  
>  		if (!work)
>  			break;
>  
> +		// Synchronize with task_work_cancel()
> +		raw_spin_lock_irq(&task->pi_lock);
> +		raw_spin_unlock_irq(&task->pi_lock);
> +
>  		do {
>  			next = work->next;
>  			work->func(work);

