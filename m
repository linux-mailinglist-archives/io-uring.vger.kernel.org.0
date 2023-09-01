Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B7478FA58
	for <lists+io-uring@lfdr.de>; Fri,  1 Sep 2023 10:57:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233083AbjIAI5n (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 Sep 2023 04:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231932AbjIAI5m (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 Sep 2023 04:57:42 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFAEC10E7
        for <io-uring@vger.kernel.org>; Fri,  1 Sep 2023 01:56:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693558611;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OzJDhAyLKubYXZZE76aMOcUPyVW0b0dVYWdxcDbcDFg=;
        b=UA4HIuJVvDBhnE5dREEGLdn6qMIAZKXuglYWeb4sA4NSzAvpMnr7iJ+9nhvfW0dsTn6rJx
        xrr2do6WAQB1gc0ESvke67+ykA6INjbmZAqKeNfpS4y18pbCDcLsTADW6/l9aFtq+vbn46
        S0HLXS69tW4g6A7p1/68/PUswwAoPvw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-350-b5Yf7zf0NO-lsBfitzoPLg-1; Fri, 01 Sep 2023 04:56:48 -0400
X-MC-Unique: b5Yf7zf0NO-lsBfitzoPLg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 79781801005;
        Fri,  1 Sep 2023 08:56:48 +0000 (UTC)
Received: from fedora (unknown [10.72.120.15])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 6E95D2026D35;
        Fri,  1 Sep 2023 08:56:43 +0000 (UTC)
Date:   Fri, 1 Sep 2023 16:56:38 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Chengming Zhou <zhouchengming@bytedance.com>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] io_uring: fix IO hang in io_wq_put_and_exit from
 do_exit()
Message-ID: <ZPGnRhDhFyFwjNl3@fedora>
References: <20230831074221.2309565-1-ming.lei@redhat.com>
 <7a083b4e-f9f3-552b-0e6c-32bf44982d8f@bytedance.com>
 <ZPFH1RArR07g+ldL@fedora>
 <22bde4fc-6dd8-e9de-5b28-96de14f51323@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <22bde4fc-6dd8-e9de-5b28-96de14f51323@bytedance.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 01, 2023 at 10:17:25AM +0800, Chengming Zhou wrote:
> On 2023/9/1 10:09, Ming Lei wrote:
> > On Fri, Sep 01, 2023 at 09:50:02AM +0800, Chengming Zhou wrote:
> >> On 2023/8/31 15:42, Ming Lei wrote:
> >>> io_wq_put_and_exit() is called from do_exit(), but all requests in io_wq
> >>> aren't cancelled in io_uring_cancel_generic() called from do_exit().
> >>> Meantime io_wq IO code path may share resource with normal iopoll code
> >>> path.
> >>>
> >>> So if any HIPRI request is pending in io_wq_submit_work(), this request
> >>> may not get resouce for moving on, given iopoll isn't possible in
> >>> io_wq_put_and_exit().
> >>>
> >>> The issue can be triggered when terminating 't/io_uring -n4 /dev/nullb0'
> >>> with default null_blk parameters.
> >>>
> >>> Fix it by always cancelling all requests in io_wq from io_uring_cancel_generic(),
> >>> and this way is reasonable because io_wq destroying follows cancelling
> >>> requests immediately. Based on one patch from Chengming.
> >>
> >> Thanks much for this work, I'm still learning these code, so maybe some
> >> silly questions below.
> >>
> >>>
> >>> Closes: https://lore.kernel.org/linux-block/3893581.1691785261@warthog.procyon.org.uk/
> >>> Reported-by: David Howells <dhowells@redhat.com>
> >>> Cc: Chengming Zhou <zhouchengming@bytedance.com>,
> >>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> >>> ---
> >>>  io_uring/io_uring.c | 40 ++++++++++++++++++++++++++++------------
> >>>  1 file changed, 28 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> >>> index e7675355048d..18d5ab969c29 100644
> >>> --- a/io_uring/io_uring.c
> >>> +++ b/io_uring/io_uring.c
> >>> @@ -144,7 +144,7 @@ struct io_defer_entry {
> >>>  
> >>>  static bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
> >>>  					 struct task_struct *task,
> >>> -					 bool cancel_all);
> >>> +					 bool cancel_all, bool *wq_cancelled);
> >>>  
> >>>  static void io_queue_sqe(struct io_kiocb *req);
> >>>  
> >>> @@ -3049,7 +3049,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
> >>>  		if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
> >>>  			io_move_task_work_from_local(ctx);
> >>>  
> >>> -		while (io_uring_try_cancel_requests(ctx, NULL, true))
> >>> +		while (io_uring_try_cancel_requests(ctx, NULL, true, NULL))
> >>>  			cond_resched();
> >>>  
> >>>  		if (ctx->sq_data) {
> >>> @@ -3231,12 +3231,13 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
> >>>  
> >>>  static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
> >>>  						struct task_struct *task,
> >>> -						bool cancel_all)
> >>> +						bool cancel_all, bool *wq_cancelled)
> >>>  {
> >>> -	struct io_task_cancel cancel = { .task = task, .all = cancel_all, };
> >>> +	struct io_task_cancel cancel = { .task = task, .all = true, };
> >>>  	struct io_uring_task *tctx = task ? task->io_uring : NULL;
> >>>  	enum io_wq_cancel cret;
> >>>  	bool ret = false;
> >>> +	bool wq_active = false;
> >>>  
> >>>  	/* set it so io_req_local_work_add() would wake us up */
> >>>  	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN) {
> >>> @@ -3249,7 +3250,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
> >>>  		return false;
> >>>  
> >>>  	if (!task) {
> >>> -		ret |= io_uring_try_cancel_iowq(ctx);
> >>> +		wq_active = io_uring_try_cancel_iowq(ctx);
> >>>  	} else if (tctx && tctx->io_wq) {
> >>>  		/*
> >>>  		 * Cancels requests of all rings, not only @ctx, but
> >>> @@ -3257,11 +3258,20 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
> >>>  		 */
> >>>  		cret = io_wq_cancel_cb(tctx->io_wq, io_cancel_task_cb,
> >>>  				       &cancel, true);
> >>> -		ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
> >>> +		wq_active = (cret != IO_WQ_CANCEL_NOTFOUND);
> >>>  	}
> >>> +	ret |= wq_active;
> >>> +	if (wq_cancelled)
> >>> +		*wq_cancelled = !wq_active;
> >>
> >> Here it seems "wq_cancelled" means no any pending or running work anymore.
> > 
> > wq_cancelled means all requests in io_wq are canceled.
> > 
> >>
> >> Why not just use the return value "loop", instead of using this new "wq_cancelled"?
> >>
> >> If return value "loop" is true, we know there is still any request need to cancel,
> >> so we will loop the cancel process until there is no any request.
> >>
> >> Ah, I guess you may want to cover one case: !wq_active && loop == true
> > 
> > If we just reply on 'loop', things could be like passing 'cancel_all' as
> > true, that might be over-kill. And I am still not sure why not canceling
> > all requests(cancel_all is true) in do_exit()?
> > 
> 
> Yes, I'm also confused by this. Could we just remove the "cancel_all"?
> 
> If we always cancel all requests, these code would be much simpler,
> and we can free task_ctx here, instead of in the last reference put
> of task_struct.

Thinking of further, switch to `cancel_all`(maybe `global` is easier to follow)
has risk, including this patch, io_uring_ctx instance can be used
from multiple pthreads, if other pthreads submit IOs, then new live lock
is caused by reaping events on ctx->iopoll_list.

And the 1st approach[1] should work by stopping reap when io_wq is
destroyed, after fixing issue of ordering io_uring_del_tctx_node and
io_wq_put_and_exit().

[1] https://lore.kernel.org/io-uring/20230825090959.1866771-3-ming.lei@redhat.com/

> 
> > But here it is enough to cancel all requests in io_wq only for solving
> > this IO hang issue.
> 
> Ok, get it.
> 
> > 
> >>
> >>>  
> >>> -	/* SQPOLL thread does its own polling */
> >>> -	if ((!(ctx->flags & IORING_SETUP_SQPOLL) && cancel_all) ||
> >>> +	/*
> >>> +	 * SQPOLL thread does its own polling
> >>> +	 *
> >>> +	 * io_wq may share IO resources(such as requests) with iopoll, so
> >>> +	 * iopoll requests have to be reapped for providing forward
> >>> +	 * progress to io_wq cancelling
> >>> +	 */
> >>> +	if (!(ctx->flags & IORING_SETUP_SQPOLL) ||
> >>>  	    (ctx->sq_data && ctx->sq_data->thread == current)) {
> >>>  		while (!wq_list_empty(&ctx->iopoll_list)) {
> >>>  			io_iopoll_try_reap_events(ctx);
> >>> @@ -3313,11 +3323,12 @@ __cold void io_uring_cancel_generic(bool cancel_all, struct io_sq_data *sqd)
> >>>  	atomic_inc(&tctx->in_cancel);
> >>>  	do {
> >>>  		bool loop = false;
> >>> +		bool wq_cancelled;
> >>>  
> >>>  		io_uring_drop_tctx_refs(current);
> >>>  		/* read completions before cancelations */
> >>>  		inflight = tctx_inflight(tctx, !cancel_all);
> >>> -		if (!inflight)
> >>> +		if (!inflight && !tctx->io_wq)
> >>>  			break;
> >>>  
> >>
> >> I think this inflight check should put after the cancel loop, because the
> >> cancel loop make sure there is no any request need to cancel, then we can
> >> loop inflight checking to make sure all inflight requests to complete.
> > 
> > But it is fine to break immediately in case that (!inflight && !tctx->io_wq) is true.
> > 
> 
> This inflight will used after cancel, maybe some requests become inflight during cancel process?
> So we use a stale inflight value? I'm not sure.

Yeah, it could be possible, such as new submission from io_run_local_work(), but it
is easy to handle, such as, kill the 'if (!inflight) break', meantime not sleep
in case of !inflight.


Thanks,
Ming

