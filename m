Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E3C2574B1F
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 12:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238560AbiGNKtS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 06:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238538AbiGNKtB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 06:49:01 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 7971ED7A
        for <io-uring@vger.kernel.org>; Thu, 14 Jul 2022 03:48:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657795738;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DzTeR2rmk7qmr31e8W4zO+N/0UYr/rJ97WwWMsCN/PI=;
        b=RLSqGjQsDvivrGrQ2SalsieWO6RMOh8ME3B4Rw85HKusl6vR7snmdSd9/x1DGNojllQvsM
        9QK0fLahqJ1ZobR389tB4mmcSyEyu5yiQEQvGU8Qycxx4wyzn3b/Kk8WiRb4xowyDlxU/7
        cwtjPmq+9quA6FpLoz+7PkHBXpt7hKk=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-563-eBwoO6OIM6aOnMs7XGa7jg-1; Thu, 14 Jul 2022 06:48:55 -0400
X-MC-Unique: eBwoO6OIM6aOnMs7XGa7jg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 1AF443C0D195;
        Thu, 14 Jul 2022 10:48:55 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 32C48141511D;
        Thu, 14 Jul 2022 10:48:49 +0000 (UTC)
Date:   Thu, 14 Jul 2022 18:48:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        ming.lei@redhat.com
Subject: Re: [PATCH V5 1/2] ublk_drv: add io_uring based userspace block
 driver
Message-ID: <Ys/0jTxQCEHdI560@T590>
References: <20220713140711.97356-1-ming.lei@redhat.com>
 <20220713140711.97356-2-ming.lei@redhat.com>
 <a4249561-84a0-a314-c377-b96d28b7b20b@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a4249561-84a0-a314-c377-b96d28b7b20b@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.7
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 14, 2022 at 06:20:38PM +0800, Ziyang Zhang wrote:
> On 2022/7/13 22:07, Ming Lei wrote:
> > This is the driver part of userspace block driver(ublk driver), the other
> > part is userspace daemon part(ublksrv)[1].
> > 
> > The two parts communicate by io_uring's IORING_OP_URING_CMD with one
> > shared cmd buffer for storing io command, and the buffer is read only for
> > ublksrv, each io command is indexed by io request tag directly, and
> > is written by ublk driver.
> > 
> > For example, when one READ io request is submitted to ublk block driver, ublk
> > driver stores the io command into cmd buffer first, then completes one
> > IORING_OP_URING_CMD for notifying ublksrv, and the URING_CMD is issued to
> > ublk driver beforehand by ublksrv for getting notification of any new io request,
> > and each URING_CMD is associated with one io request by tag.
> > 
> > After ublksrv gets the io command, it translates and handles the ublk io
> > request, such as, for the ublk-loop target, ublksrv translates the request
> > into same request on another file or disk, like the kernel loop block
> > driver. In ublksrv's implementation, the io is still handled by io_uring,
> > and share same ring with IORING_OP_URING_CMD command. When the target io
> > request is done, the same IORING_OP_URING_CMD is issued to ublk driver for
> > both committing io request result and getting future notification of new
> > io request.
> > 
> > Another thing done by ublk driver is to copy data between kernel io
> > request and ublksrv's io buffer:
> > 
> > 1) before ubsrv handles WRITE request, copy the request's data into
> > ublksrv's userspace io buffer, so that ublksrv can handle the write
> > request
> > 
> > 2) after ubsrv handles READ request, copy ublksrv's userspace io buffer
> > into this READ request, then ublk driver can complete the READ request
> > 
> > Zero copy may be switched if mm is ready to support it.
> > 
> > ublk driver doesn't handle any logic of the specific user space driver,
> > so it is small/simple enough.
> > 
> > [1] ublksrv
> > 
> > https://github.com/ming1/ubdsrv
> > 
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> > ---
> 
> 
> Hi, Ming
> 
> I find that a big change from v4 to v5 is the simplification of locks.
> 
> In v5 you remove ubq->abort_lock, and I want to ask why it is OK to remove it?

Actually V4 and previous version dealt with the issue too complicated.

> 
> If you have time, could you explain how ublk deals with potential race on:
> 1)queue_rq 2)ublk_abort_queue 3) ublk_ctrl_stop_dev 4) ublk_rq_task_work.
> (Lock in ublk really confuses me...)

One big change is the following code:

__ublk_rq_task_work():
	bool task_exiting = current != ubq->ubq_daemon ||
                (current->flags & PF_EXITING);
	...
	if (unlikely(task_exiting)) {
                blk_mq_end_request(req, BLK_STS_IOERR);
                mod_delayed_work(system_wq, &ub->monitor_work, 0);
                return;
    }

Abort is always started after PF_EXITING is set, but if PF_EXITING is
set, __ublk_rq_task_work fails the request immediately, then io->flags
won't be touched, then no race with abort. Also PF_EXITING is
per-task flag, can only be set before calling __ublk_rq_task_work(),
and setting it actually serialized with calling task work func.

In ublk_queue_rq(), we don't touch io->flags, so there isn't race
with abort.

Wrt. ublk_ctrl_stop_dev(), it isn't related with abort directly, and
if del_gendisk() waits for inflight IO, abort work will be started
for making forward progress. After del_gendisk() returns, there can't
be any inflight io, so it is safe to cancel other pending io command.

> 
> 
> [...]
> 
> > +
> > +/*
> > + * __ublk_fail_req() may be called from abort context or ->ubq_daemon
> > + * context during exiting, so lock is required.
> > + *
> > + * Also aborting may not be started yet, keep in mind that one failed
> > + * request may be issued by block layer again.
> > + */
> > +static void __ublk_fail_req(struct ublk_io *io, struct request *req)
> > +{
> > +	WARN_ON_ONCE(io->flags & UBLK_IO_FLAG_ACTIVE);
> > +
> > +	if (!(io->flags & UBLK_IO_FLAG_ABORTED)) {
> > +		io->flags |= UBLK_IO_FLAG_ABORTED;
> > +		blk_mq_end_request(req, BLK_STS_IOERR);
> > +	}
> > +}
> > +
> 
> [...]
> 
> > +
> > +/*
> > + * When ->ubq_daemon is exiting, either new request is ended immediately,
> > + * or any queued io command is drained, so it is safe to abort queue
> > + * lockless
> > + */
> > +static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
> > +{
> > +	int i;
> > +
> > +	if (!ublk_get_device(ub))
> > +		return;
> > +
> > +	for (i = 0; i < ubq->q_depth; i++) {
> > +		struct ublk_io *io = &ubq->ios[i];
> > +
> > +		if (!(io->flags & UBLK_IO_FLAG_ACTIVE)) {
> > +			struct request *rq;
> > +
> > +			/*
> > +			 * Either we fail the request or ublk_rq_task_work_fn
> > +			 * will do it
> > +			 */
> > +			rq = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], i);
> > +			if (rq)
> > +				__ublk_fail_req(io, rq);
> > +		}
> > +	}
> > +	ublk_put_device(ub);
> > +}
> > +
> 
> 
> Another problem: 
> 
> 1) comment of __ublk_fail_req():  "so lock is required"

Yeah, now __ublk_fail_req is only called in abort context, and no race
with task work any more, so lock isn't needed.

> 
> 2) comment of ublk_abort_queue(): "so it is safe to abort queue lockless"

This comment is updated in v5, and it is correct.

> 
> 3) ublk_abort_queue() calls _ublk_fail_req() on all ubqs.

No, ublk_abort_queue() only aborts the passed ubq, so if one ubq daemon
is aborted, other ubqs can still handle IO during deleting disk.


Thanks,
Ming

