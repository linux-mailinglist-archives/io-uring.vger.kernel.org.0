Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C588A1A0DF1
	for <lists+io-uring@lfdr.de>; Tue,  7 Apr 2020 14:47:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728447AbgDGMr1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Apr 2020 08:47:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:35268 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728304AbgDGMr0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Apr 2020 08:47:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=rJFwx60lMvR2sVcAkKRtg6CYbWWdZSDgF7t1rDY0bM0=; b=FV4Um1NJhvdLfBCjaRH+ALQmYd
        o9RTLlYTVUTT+sOT01To24uoU/PgGH4EtO0dBBUJ3YVPuivLJm/+V6v2We7qE6c1tNrKjbLFcQJtK
        SDyIdkvGOPfsStSKXtt5ymvCENZe0s1fCenZjAAYJ7mUHXAcgCh5Fzx1tQDpH7lLjxIgBf/2XqhMY
        QBIg8F2QwmZb/0T/gYa1m+AF2BfpU8A6XBoK0tudW5dAmXEkupEnCA6sIg9ngTyxeSHPmTI/5IZAe
        pVk5g7eskRnY8pHpQu/l5hIeaUbsTYoe25YAQUwbvtCeJw+F6f43dgS9dJv9NeUaYOGpZHaP6OzlQ
        wSxKcyag==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jLndT-0004hI-GP; Tue, 07 Apr 2020 12:47:23 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id F2BDB3011DD;
        Tue,  7 Apr 2020 14:47:21 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id D4A4E2B907A8D; Tue,  7 Apr 2020 14:47:21 +0200 (CEST)
Date:   Tue, 7 Apr 2020 14:47:21 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH 2/4] task_work: don't run task_work if task_work_exited
 is queued
Message-ID: <20200407124721.GX20730@hirez.programming.kicks-ass.net>
References: <20200406194853.9896-1-axboe@kernel.dk>
 <20200406194853.9896-3-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200406194853.9896-3-axboe@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


You seem to have lost Oleg and Al from the Cc list..

On Mon, Apr 06, 2020 at 01:48:51PM -0600, Jens Axboe wrote:
> If task_work has already been run on task exit, we don't always know
> if it's safe to run again. Check for task_work_exited in the
> task_work_pending() helper. This makes it less fragile in calling
> from the exit files path, for example.
> 
> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> ---
>  include/linux/task_work.h | 4 +++-
>  kernel/task_work.c        | 8 ++++----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/task_work.h b/include/linux/task_work.h
> index 54c911bbf754..24f977a8fc35 100644
> --- a/include/linux/task_work.h
> +++ b/include/linux/task_work.h
> @@ -7,6 +7,8 @@
>  
>  typedef void (*task_work_func_t)(struct callback_head *);
>  
> +extern struct callback_head task_work_exited;
> +
>  static inline void
>  init_task_work(struct callback_head *twork, task_work_func_t func)
>  {
> @@ -19,7 +21,7 @@ void __task_work_run(void);
>  
>  static inline bool task_work_pending(void)
>  {
> -	return current->task_works;
> +	return current->task_works && current->task_works != &task_work_exited;
>  }

Hurmph..  not sure I like this. It inlines that second condition to
every caller of task_work_run() even though for pretty much all of them
this is impossible.
