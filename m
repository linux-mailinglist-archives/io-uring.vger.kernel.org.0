Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6E791E14B9
	for <lists+io-uring@lfdr.de>; Mon, 25 May 2020 21:21:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390005AbgEYTVs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 May 2020 15:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389460AbgEYTVr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 May 2020 15:21:47 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C736CC061A0E;
        Mon, 25 May 2020 12:21:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=aSyd7Ks+R9jE8AEEQmkCXKqSftrCpG8jlbljNIExdqw=; b=BWwkSFn9VhfEAfEk+BxrpC5gJL
        QuabQWUhNlCyVUY11jPxH9i0mji0la1hyMl1qiqLbrTtg76/aSydvL5geCd4IAdEY17ytDzqwYqyS
        olGJs9P76N0dKb2XazS63xkwRKYZodtvI2FUZWtirLEb+1EkGOf9cZgWotG4ijTVKzQJnEuYOEo2u
        wFc9utzGsln6xJRkxmkHEDAACcqzm6WncY9UT8h5AqM6gMR2PywTYSen5r6IuZ2WMLtqdfVBWhB4y
        c5GhKNqzi+ARdgjd0Nt1DRReiKWONXz/y/CrivnFjfmEasIU28rttP53pVfTG2ujqSKbXLF6SgbWI
        hmhCExSQ==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jdIfS-0007l7-Cm; Mon, 25 May 2020 19:21:46 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 3C8573011E6;
        Mon, 25 May 2020 21:21:44 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id E6C8220BD4F38; Mon, 25 May 2020 21:21:43 +0200 (CEST)
Date:   Mon, 25 May 2020 21:21:43 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefano Garzarella <sgarzare@redhat.com>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: io_uring: BUG: kernel NULL pointer dereference
Message-ID: <20200525192143.GG317569@hirez.programming.kicks-ass.net>
References: <20200525103051.lztpbl33hsgv6grz@steredhat>
 <20200525134552.5dyldwmeks3t6vj6@steredhat>
 <b1689238-b236-cc93-9909-c09120e7975c@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1689238-b236-cc93-9909-c09120e7975c@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 25, 2020 at 08:10:27AM -0600, Jens Axboe wrote:
> I think the odd part here is that task_tick_numa() checks for a
> valid mm, and queues work if the task has it. But for the sqpoll
> kthread, the mm can come and go. By the time the task work is run,
> the mm is gone and we oops on current->mm == NULL.
> 
> I think the below should fix it:
> 
> diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
> index 538ba5d94e99..24a8557f001f 100644
> --- a/kernel/sched/fair.c
> +++ b/kernel/sched/fair.c
> @@ -2908,7 +2908,8 @@ static void task_tick_numa(struct rq *rq, struct task_struct *curr)
>  	/*
>  	 * We don't care about NUMA placement if we don't have memory.
>  	 */
> -	if (!curr->mm || (curr->flags & PF_EXITING) || work->next != work)
> +	if (!curr->mm || (curr->flags & (PF_EXITING | PF_KTHREAD)) ||
> +	    work->next != work)
>  		return;

Ah, I think that's one more instance of '!p->mm' != is_kthread(). A
while ago someone went and cleaned a bunch of them up. Clearly this one
was missed.

I'm thinking just:

	if ((curr->flags & (PF_EXITING | PF_KTHREAD)) || work->next != work)

should be enough.
