Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A90227AB4B8
	for <lists+io-uring@lfdr.de>; Fri, 22 Sep 2023 17:25:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjIVPZI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Sep 2023 11:25:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229639AbjIVPZH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Sep 2023 11:25:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDB1A1
        for <io-uring@vger.kernel.org>; Fri, 22 Sep 2023 08:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695396254;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HsCwtHCSzhR/7cF0Xtb0EJX3I3QCEbdjrzLUqhNj8tk=;
        b=Ycy+B4+4E523eQPZZ8hjt6WWSDNmmaqIlPcKF4NpSvuptBExrLcAfbUjFDRoF8H0WS0T83
        uxRAYDrdgf600hknFhPKHWYu32L7hWE25c7x/Msb7ODqGtCVQfutciF4E0+SPbqqTp6Jkm
        z5/1IHS1iFXcmnS6X7Iq0V2QMnzwtr4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-237-fMaPQ54BPSK0W00c_0Bg_g-1; Fri, 22 Sep 2023 11:24:11 -0400
X-MC-Unique: fMaPQ54BPSK0W00c_0Bg_g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D91E7800B35;
        Fri, 22 Sep 2023 15:24:09 +0000 (UTC)
Received: from fedora (unknown [10.72.120.3])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0B35521B2413;
        Fri, 22 Sep 2023 15:24:05 +0000 (UTC)
Date:   Fri, 22 Sep 2023 23:24:01 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@suse.de>,
        ming.lei@redhat.com
Subject: Re: [PATCH V2] io_uring: cancelable uring_cmd
Message-ID: <ZQ2xkRRO6boDo6LD@fedora>
References: <20230922142816.2784777-1-ming.lei@redhat.com>
 <dcdc42db-b3ac-4e91-b318-fb782aa9563e@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dcdc42db-b3ac-4e91-b318-fb782aa9563e@kernel.dk>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 22, 2023 at 09:02:44AM -0600, Jens Axboe wrote:
> On 9/22/23 8:28 AM, Ming Lei wrote:
> > uring_cmd may never complete, such as ublk, in which uring cmd isn't
> > completed until one new block request is coming from ublk block device.
> > 
> > Add cancelable uring_cmd to provide mechanism to driver for cancelling
> > pending commands in its own way.
> > 
> > Add API of io_uring_cmd_mark_cancelable() for driver to mark one command as
> > cancelable, then io_uring will cancel this command in
> > io_uring_cancel_generic(). ->uring_cmd() callback is reused for canceling
> > command in driver's way, then driver gets notified with the cancelling
> > from io_uring.
> > 
> > Add API of io_uring_cmd_get_task() to help driver cancel handler
> > deal with the canceling.
> 
> This looks better, a few comments:
> 
> > diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> > index 8e61f8b7c2ce..29a7a7e71f57 100644
> > --- a/include/uapi/linux/io_uring.h
> > +++ b/include/uapi/linux/io_uring.h
> > @@ -249,10 +249,13 @@ enum io_uring_op {
> >   * sqe->uring_cmd_flags
> >   * IORING_URING_CMD_FIXED	use registered buffer; pass this flag
> >   *				along with setting sqe->buf_index.
> > + * IORING_URING_CANCELABLE	not for userspace
> >   * IORING_URING_CMD_POLLED	driver use only
> >   */
> > -#define IORING_URING_CMD_FIXED	(1U << 0)
> > -#define IORING_URING_CMD_POLLED	(1U << 31)
> > +#define IORING_URING_CMD_FIXED		(1U << 0)
> > +/* set by driver, and handled by io_uring to cancel this cmd */
> > +#define IORING_URING_CMD_CANCELABLE	(1U << 30)
> > +#define IORING_URING_CMD_POLLED		(1U << 31)
> 
> If IORING_URING_CANCELABLE isn't UAPI, why stuff it in here? Should we
> have a split where we retain the upper 8 bits for internal use, or
> something like that?

Yeah, it is for internal use, same with IORING_URING_CMD_POLLED.

I think we can retain upper 8 bits for internal use, and move
the two definitions into kernel header.

> 
> > diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
> > index 783ed0fff71b..a3135fd47a4e 100644
> > --- a/io_uring/io_uring.c
> > +++ b/io_uring/io_uring.c
> > @@ -3256,6 +3256,40 @@ static __cold bool io_uring_try_cancel_iowq(struct io_ring_ctx *ctx)
> >  	return ret;
> >  }
> >  
> > +static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> > +		struct task_struct *task, bool cancel_all)
> > +{
> > +	struct hlist_node *tmp;
> > +	struct io_kiocb *req;
> > +	bool ret = false;
> > +
> > +	mutex_lock(&ctx->uring_lock);
> > +	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
> > +			hash_node) {
> > +		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
> > +				struct io_uring_cmd);
> > +		struct file *file = req->file;
> > +
> > +		if (WARN_ON_ONCE(!file->f_op->uring_cmd))
> > +			continue;
> > +
> > +		if (!cancel_all && req->task != task)
> > +			continue;
> > +
> > +		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
> > +			/* ->sqe isn't available if no async data */
> > +			if (!req_has_async_data(req))
> > +				cmd->sqe = NULL;
> > +			file->f_op->uring_cmd(cmd, IO_URING_F_CANCEL);
> > +			ret = true;
> > +		}
> > +	}
> > +	io_submit_flush_completions(ctx);
> > +	mutex_unlock(&ctx->uring_lock);
> > +
> > +	return ret;
> > +}
> 
> I think it'd be saner to drop uring_lock here, and then:
> 
> > @@ -3307,6 +3341,7 @@ static __cold bool io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
> >  	ret |= io_kill_timeouts(ctx, task, cancel_all);
> >  	if (task)
> >  		ret |= io_run_task_work() > 0;
> > +	ret |= io_uring_try_cancel_uring_cmd(ctx, task, cancel_all);
> >  	return ret;
> >  }
> 
> move this hunk into the uring_lock section. Also ensure that we do run
> task_work for cancelation, should the uring_cmd side require that
> (either now or eventually).

OK, io_run_task_work() has run task_work already.

> 
> > diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> > index 537795fddc87..d6b200a0be33 100644
> > --- a/io_uring/uring_cmd.c
> > +++ b/io_uring/uring_cmd.c
> > @@ -13,6 +13,52 @@
> >  #include "rsrc.h"
> >  #include "uring_cmd.h"
> >  
> > +static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
> > +		unsigned int issue_flags)
> > +{
> > +	if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
> > +		struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> > +		struct io_ring_ctx *ctx = req->ctx;
> > +
> > +		io_ring_submit_lock(ctx, issue_flags);
> > +		cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
> > +		hlist_del(&req->hash_node);
> > +		io_ring_submit_unlock(ctx, issue_flags);
> > +	}
> > +}
> 
> static void io_uring_cmd_del_cancelable(struct io_uring_cmd *cmd,
> 		unsigned int issue_flags)
> {
> 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> 	struct io_ring_ctx *ctx = req->ctx;
> 
> 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE))
> 		return;
> 
> 	io_ring_submit_lock(ctx, issue_flags);
> 	cmd->flags &= ~IORING_URING_CMD_CANCELABLE;
> 	hlist_del(&req->hash_node);
> 	io_ring_submit_unlock(ctx, issue_flags);
> }
> 
> is cleaner imho. Minor nit.
> 
> > +
> > +/*
> > + * Mark this command as concelable, then io_uring_try_cancel_uring_cmd()
> > + * will try to cancel this issued command by sending ->uring_cmd() with
> > + * issue_flags of IO_URING_F_CANCEL.
> > + *
> > + * The command is guaranteed to not be done when calling ->uring_cmd()
> > + * with IO_URING_F_CANCEL, but it is driver's responsibility to deal
> > + * with race between io_uring canceling and normal completion.
> > + */
> > +int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> > +		unsigned int issue_flags)
> > +{
> > +	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> > +	struct io_ring_ctx *ctx = req->ctx;
> > +
> > +	io_ring_submit_lock(ctx, issue_flags);
> > +	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
> > +		cmd->flags |= IORING_URING_CMD_CANCELABLE;
> > +		hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
> > +	}
> > +	io_ring_submit_unlock(ctx, issue_flags);
> > +
> > +	return 0;
> > +}
> 
> A bit inconsistent here in terms of the locking. I'm assuming the
> marking happens within issue, in which case it should be fine to do:
> 
> int io_uring_cmd_mark_cancelable(struct io_uring_cmd *cmd,
> 		unsigned int issue_flags)
> {
> 	struct io_kiocb *req = cmd_to_io_kiocb(cmd);
> 	struct io_ring_ctx *ctx = req->ctx;
> 
> 	if (!(cmd->flags & IORING_URING_CMD_CANCELABLE)) {
> 		cmd->flags |= IORING_URING_CMD_CANCELABLE;
> 		io_ring_submit_lock(ctx, issue_flags);
> 		hlist_add_head(&req->hash_node, &ctx->cancelable_uring_cmd);
> 		io_ring_submit_unlock(ctx, issue_flags);
> 	}

OK, mask & clear bit can be moved out of lock in both two functions.


Thanks,
Ming

