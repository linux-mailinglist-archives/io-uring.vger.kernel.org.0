Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D0981669B5
	for <lists+io-uring@lfdr.de>; Thu, 20 Feb 2020 22:17:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbgBTVRt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Feb 2020 16:17:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41052 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726670AbgBTVRt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Feb 2020 16:17:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=/b7fIjL1lfjwcl4cEf7j1xkFRktIBlr1P6FJ5rqEnx4=; b=lRlYMfTVSSRTxehBOQdaF/ykaF
        5CA/LfH5NpycwgNYDTWJlIxrwbs7TYSA2WKRMjCqSEHDWA9WUEHXceYqWIVoTnjHxDjqMMHWD6sSK
        zsLJM4mAfsbEH3egXIUOArEWDdhLlHk/kRLXLJ3TNX+zvqZtd+vs9f88kyQTslPRw/69vVFwdm38H
        xjYO9ALxFykFkALZ8iSdbqY2axB+cWJwmwpehGDEQuHMt8/Ry8XtNqKy4SJI/C6rj5N48bcj51gRd
        Xy5La020tCjGbabVNA2VNPCMt7CJD6f5ZQ/moKluI7YV8C9GlbhYe/Au6h1ON3qLwVX6yU+S1JINT
        ezyxC2hg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j4tCc-0005UB-69; Thu, 20 Feb 2020 21:17:46 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id 5CBC9980E56; Thu, 20 Feb 2020 22:17:44 +0100 (CET)
Date:   Thu, 20 Feb 2020 22:17:44 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, glauber@scylladb.com,
        asml.silence@gmail.com
Subject: Re: [PATCH 6/9] sched: add a sched_work list
Message-ID: <20200220211744.GN11457@worktop.programming.kicks-ass.net>
References: <20200220203151.18709-1-axboe@kernel.dk>
 <20200220203151.18709-7-axboe@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200220203151.18709-7-axboe@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 20, 2020 at 01:31:48PM -0700, Jens Axboe wrote:
> This is similar to the task_works, and uses the same infrastructure, but
> the sched_work list is run when the task is being scheduled in or out.
> 
> The intended use case here is for core code to be able to add work
> that should be automatically run by the task, without the task needing
> to do anything. This is done outside of the task, one example would be
> from waitqueue handlers, or anything else that is invoked out-of-band
> from the task itself.
> 


> diff --git a/kernel/task_work.c b/kernel/task_work.c
> index 3445421266e7..ba62485d5b3d 100644
> --- a/kernel/task_work.c
> +++ b/kernel/task_work.c
> @@ -3,7 +3,14 @@
>  #include <linux/task_work.h>
>  #include <linux/tracehook.h>
>  
> -static struct callback_head work_exited; /* all we need is ->next == NULL */
> +static void task_exit_func(struct callback_head *head)
> +{
> +}
> +
> +static struct callback_head work_exited = {
> +	.next	= NULL,
> +	.func	= task_exit_func,
> +};

Do we really need this? It seems to suggest we're trying to execute
work_exited, which would be an error.

Doing so would be the result of calling sched_work_run() after
exit_task_work(). I suppose that's actually possible.. the problem is
that that would reset sched_work to NULL and re-allow queueing works,
which would then leak.

I'll look at it in more detail tomorrow, I'm tired...

