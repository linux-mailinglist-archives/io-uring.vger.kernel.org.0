Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0795E7AA6FC
	for <lists+io-uring@lfdr.de>; Fri, 22 Sep 2023 04:26:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjIVC0a (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Sep 2023 22:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229550AbjIVC0a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Sep 2023 22:26:30 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77E1F18F
        for <io-uring@vger.kernel.org>; Thu, 21 Sep 2023 19:25:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1695349537;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=n5x8QCZX33ubTK4YMUbpV9Hg7NOTSRj8DrNQXw3m09E=;
        b=UqxydWHkFguGgvPMqUy4d4ETFJ7EsqR0f8NxKC23C2poJoQAzkLFQ7qzqjDjdcSTB6Mwhx
        tdAcAk2YiiVW5nR4RrIZxkXOBRUhD0CzvD9kOzRGdf0KzXXa5s4hk8I1OD4cRucoF1Qem6
        xXrMHJgzJFLx9qZ683L0eVkLChAWRV4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-547-5KOZf2VWNSisuzIwR0JSHQ-1; Thu, 21 Sep 2023 22:25:34 -0400
X-MC-Unique: 5KOZf2VWNSisuzIwR0JSHQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8E6A7101A529;
        Fri, 22 Sep 2023 02:25:33 +0000 (UTC)
Received: from fedora (unknown [10.72.120.5])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 253AC20268D6;
        Fri, 22 Sep 2023 02:25:28 +0000 (UTC)
Date:   Fri, 22 Sep 2023 10:25:23 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Gabriel Krisman Bertazi <krisman@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, ming.lei@redhat.com,
        Breno Leitao <leitao@debian.org>
Subject: Re: [PATCH] io_uring: cancelable uring_cmd
Message-ID: <ZQz7E7L3wHpEX//+@fedora>
References: <20230921042434.2500190-1-ming.lei@redhat.com>
 <878r8znz3s.fsf@suse.de>
 <ZQzk6PW+4HHzCFrw@fedora>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZQzk6PW+4HHzCFrw@fedora>
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

On Fri, Sep 22, 2023 at 08:50:48AM +0800, Ming Lei wrote:
> Hello Gabriel,
> 
> On Thu, Sep 21, 2023 at 02:46:31PM -0400, Gabriel Krisman Bertazi wrote:
> > Ming Lei <ming.lei@redhat.com> writes:
> > 
> > > uring_cmd may never complete, such as ublk, in which uring cmd isn't
> > > completed until one new block request is coming from ublk block device.
> > >
> > > Add cancelable uring_cmd to provide mechanism to driver to cancel
> > > pending commands in its own way.
> > >
> > > Add API of io_uring_cmd_mark_cancelable() for driver to mark one
> > > command as cancelable, then io_uring will cancel this command in
> > > io_uring_cancel_generic(). Driver callback is provided for canceling
> > > command in driver's way, meantime driver gets notified with exiting of
> > > io_uring task or context.
> > >
> > > Suggested-by: Jens Axboe <axboe@kernel.dk>
> > > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > > ---
> > >
> > > ublk patches:
> > >
> > > 	https://github.com/ming1/linux/commits/uring_exit_and_ublk
> > >
> > >  include/linux/io_uring.h       | 22 +++++++++++++++++-
> > >  include/linux/io_uring_types.h |  6 +++++
> > >  include/uapi/linux/io_uring.h  |  7 ++++--
> > >  io_uring/io_uring.c            | 30 ++++++++++++++++++++++++
> > >  io_uring/uring_cmd.c           | 42 ++++++++++++++++++++++++++++++++++
> > >  5 files changed, 104 insertions(+), 3 deletions(-)
> > >
> > > diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
> > > index 106cdc55ff3b..5b98308a154f 100644
> > > --- a/include/linux/io_uring.h
> > > +++ b/include/linux/io_uring.h
> > > @@ -22,6 +22,9 @@ enum io_uring_cmd_flags {
> > >  	IO_URING_F_IOPOLL		= (1 << 10),
> > >  };
> > >  
> > > +typedef void (uring_cmd_cancel_fn)(struct io_uring_cmd *,
> > > +		unsigned int issue_flags, struct task_struct *task);
> > > +
> > 
> > Hi Ming,
> > 
> > I wonder if uring_cmd_cancel shouldn't just be a new file operation, pairing
> > with f_op->uring_cmd.  it would, of course, also mean don't need to pass
> > it here occupying the pdu or explicitly registering it. iiuc, would also
> > allow you to drop the flag and just assume it is cancelable if the operation
> > exists, further simplifying the code.
> 
> If there are more such use cases, it is probably not a bad idea to add
> new operation for canceling command.
> 
> But definitely there are not, so not good to add one new operation now,
> since new operation field is added to all drivers/FSs actually, 99% of
> them shouldn't pay for such cost.
> 
> Also I don't see how much simplification is made with new operation,
> cause the approach in this patch just needs one flag & callback for canceling,
> both are freely available, only driver with such feature needs to pay
> the extra callback cost(8bytes in uring_cmd->pdu[]).

Another way is to reserve some cmd op range for io_uring use, then
we can define CANCEL_CMD and pass it to ->uring_cmd(), such as reserving
the following range:

	_IOWR(0xFF, 0, 0xFF) ~ _IOWR(0xFF, 0x7F, 0xFF)	//user visible
	_IOWR(0xFF, 0x80, 0xFF) ~ _IOWR(0xFF, 0xFF, 0xFF)	//io_uring internal

even SOCKET_URING_OP_SIOCINQ/SOCKET_URING_OP_SIOCOUTQ can be covered
since they are just merged to v6.6-rc1, then we have fixed cmd op range
for io_uring for future use cases.

Jens & Gabriel, which way do you think better?

> 
> > 
> > > +static bool io_uring_try_cancel_uring_cmd(struct io_ring_ctx *ctx,
> > > +					  struct task_struct *task,
> > > +					  bool cancel_all)
> > > +{
> > > +	struct hlist_node *tmp;
> > > +	struct io_kiocb *req;
> > > +	bool ret = false;
> > > +
> > > +	mutex_lock(&ctx->uring_lock);
> > > +	hlist_for_each_entry_safe(req, tmp, &ctx->cancelable_uring_cmd,
> > > +			hash_node) {
> > > +		struct io_uring_cmd *cmd = io_kiocb_to_cmd(req,
> > > +				struct io_uring_cmd);
> > > +
> > > +		if (!cancel_all && req->task != task)
> > > +			continue;
> > > +
> > > +		/* safe to call ->cancel_fn() since cmd isn't done yet */
> > > +		if (cmd->flags & IORING_URING_CMD_CANCELABLE) {
> > > +			cmd->cancel_fn(cmd, 0, task);
> > 
> > I find it weird to pass task here.  Also, it seems you use it only to
> > sanity check it is the same as ubq->ubq_daemon.  Can you just recover it
> > from cmd_to_io_kiocb(cmd)->task? it should be guaranteed to be the same
> > as task by the check immediately before.
> 
> 'task' parameter is very important for ublk use case, in future I plan to
> support multiple tasks per queue(io_uring_ctx) for ublk queue for
> relaxing the current (more stict) limit of single task/context for
> single queue. So when one task is exiting, ublk driver will just need to
> cancel commands queued from this task, not necessarily to cancel the
> whole queue/device.
> 
> Also cmd_to_io_kiocb(cmd)->task shouldn't work since io_kiocb can be
> thought as being not exported to driver strictly speaking.

new API of io_uring_cmd_get_task() can be added which should be just
used for handling CANCEL_CMD if we take ->uring_cmd().

Thanks,
Ming

