Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CB9D5664E4
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 10:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230021AbiGEIGe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 04:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbiGEIGe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 04:06:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0B99013DC1
        for <io-uring@vger.kernel.org>; Tue,  5 Jul 2022 01:06:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657008392;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4fZCmfERPxCIi2pHJetmpXi2nv6VKuW6kipE1+bwv2M=;
        b=hBhFSGOszE06sZvRa+RmrGg1GfKX8VyNHC2s4aD99UxhMSKOvg50FSbMK1MDPtZ/MwSwmM
        zOL/8bd/yFA9GcOX2blLLLwswgw1AV5DxAT5YMbU3gqdYa9Ot7DyZNVwdPLToyZS2hITZd
        bkhV5LNtlaKBiA8k5rrtxshluj+mjMM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-587-mS6ohB-HPeCutQXiRm0aIg-1; Tue, 05 Jul 2022 04:06:29 -0400
X-MC-Unique: mS6ohB-HPeCutQXiRm0aIg-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD88A185A7A4;
        Tue,  5 Jul 2022 08:06:28 +0000 (UTC)
Received: from T590 (ovpn-8-22.pek2.redhat.com [10.72.8.22])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7B3F2492C3B;
        Tue,  5 Jul 2022 08:06:21 +0000 (UTC)
Date:   Tue, 5 Jul 2022 16:06:16 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, ming.lei@redhat.com
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Message-ID: <YsPw+HS8ssmVw86u@T590>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com>
 <8735fg4jhb.fsf@collabora.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8735fg4jhb.fsf@collabora.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, Jul 04, 2022 at 06:10:40PM -0400, Gabriel Krisman Bertazi wrote:
> Ming Lei <ming.lei@redhat.com> writes:
> 
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
> > so it should be small/simple enough.
> >
> > [1] ublksrv
> >
> > https://github.com/ming1/ubdsrv
> >
> > Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> Hi Ming,
> 
> A few comments inline:

Hi Gabriel,

Thanks for your review!

> 
> 
> > +#define UBLK_MINORS		(1U << MINORBITS)
> > +
> > +struct ublk_rq_data {
> > +	struct callback_head work;
> > +};
> > +
> > +/* io cmd is active: sqe cmd is received, and its cqe isn't done */
> > +#define UBLK_IO_FLAG_ACTIVE	0x01
> > +
> > +/*
> > + * FETCH io cmd is completed via cqe, and the io cmd is being handled by
> > + * ublksrv, and not committed yet
> > + */
> > +#define UBLK_IO_FLAG_OWNED_BY_SRV 0x02
> > +
> 
> Minor nit: I wonder if the IO life cycle isn't better represented as a
> state machine than flags:
> 
> enum {
>    UBLK_IO_FREE,
>    UBLK_IO_QUEUED
>    UBLK_IO_OWNED_BY_SRV
>    UBLK_IO_COMPLETED,
>    UBLK_IO_ABORTED,
> }
> 
> Since currently, IO_FLAG_ACTIVE and IO_OWNED_BY_SRV should (almost) be
> mutually exclusive.

Right, IO_OWNED_BY_SRV can be killed, and its only purpose could be just
cross-verification.

So only two flags of IO_FLAG_ACTIVE and IO_FLAG_REQ_FAILED are
useful:

1) IO_FLAG_ACTIVE means the io command is owned by ublk driver, and it
becomes zero after completing the io_uring io command, triggered by one
incoming ublk block io request.

2) IO_FLAG_REQ_FAILED is set after aborting is triggered, any inflight
ublk io request and to-be-queued request via this slot should be ended
immediately.

At least it works for current requirements.

Io state machine may not work perfectly here, especially more states
results in more complicated handling, such as, N states may need

	N * (N - 1)

transitions.

Also there isn't UBLK_IO_FREE state, the io slot is always used, either
in ublk driver side, or ublk server side.

No UBLK_IO_QUEUED state too, the handling is to complete the io command
for notifying ublksrv to handle the request, and hard to abstract the
QUEUED state.

UBLK_IO_OWNED_BY_SRV is same with !IO_FLAG_ACTIVE.

UBLK_IO_COMPLETED is basically same with
!IO_FLAG_ACTIVE->IO_FLAG_ACTIVE, and it is one transient state.

UBLK_IO_ABORTED is basically same with IO_FLAG_REQ_FAILED.

So we can solve the problem with simpler abstraction, instead of
making it over complicated.

> 
> 
> > +
> > +static int ublk_ctrl_stop_dev(struct ublk_device *ub)
> > +{
> > +	ublk_stop_dev(ub);
> > +	cancel_work_sync(&ub->stop_work);
> > +	return 0;
> > +}
> > +
> > +static inline bool ublk_queue_ready(struct ublk_queue *ubq)
> > +{
> > +	return ubq->nr_io_ready == ubq->q_depth;
> > +}
> > +
> > +/* device can only be started after all IOs are ready */
> > +static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
> > +{
> > +	mutex_lock(&ub->mutex);
> > +	ubq->nr_io_ready++;
> 
> I think this is still problematic for the case where a FETCH_IO is sent
> from a different thread than the one originally set in ubq_daemon
> (i.e. a userspace bug).  Since ubq_daemon is used to decide what task
> context will do the data copy, If an IO_FETCH_RQ is sent to the same queue
> from two threads, the data copy can happen in the context of the wrong
> task.  I'd suggest something like the check below at the beginning of
> mark_io_ready and a similar on for IO_COMMIT_AND_FETCH_RQ
> 
> 	mutex_lock(&ub->mutex);
>         if (ub->ubq_daemon && ub->ubq_daemon != current) {
>            mutex_unlock(&ub->mutex);
>            return -EINVAL;
>         }
> 	ubq->nr_io_ready++;

The check is good, will add it, but ub->mutex isn't required, especially
IO_COMMIT_AND_FETCH_RQ is in fast path.

>         ...
> > +	if (ublk_queue_ready(ubq)) {
> > +		ubq->ubq_daemon = current;
> > +		get_task_struct(ubq->ubq_daemon);
> > +		ub->nr_queues_ready++;
> > +	}
> > +	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues)
> > +		complete_all(&ub->completion);
> > +	mutex_unlock(&ub->mutex);
> > +}
> > +
> > +static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> > +{
> > +	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
> > +	struct ublk_device *ub = cmd->file->private_data;
> > +	struct ublk_queue *ubq;
> > +	struct ublk_io *io;
> > +	u32 cmd_op = cmd->cmd_op;
> > +	unsigned tag = ub_cmd->tag;
> > +	int ret = -EINVAL;
> > +
> > +	pr_devel("%s: receieved: cmd op %d queue %d tag %d result %d\n",
> 
>                          ^^^
>                          received

OK.

> 
> 
> > +			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
> > +			ub_cmd->result);
> > +
> > +	if (!(issue_flags & IO_URING_F_SQE128))
> > +		goto out;
> > +
> > +	ubq = ublk_get_queue(ub, ub_cmd->q_id);
> > +	if (!ubq || ub_cmd->q_id != ubq->q_id)
> 
> q_id is coming from userspace and is used to access an array inside
> ublk_get_queue().  I think you need to ensure qid < ub->dev_info.nr_hw_queues
> before calling ublk_get_queue() to protect from a kernel bad memory
> access triggered by userspace.

Good catch!

> 
> > +		goto out;
> > +
> > +	if (WARN_ON_ONCE(tag >= ubq->q_depth))
> 
> Userspace shouldn't be able to easily trigger a WARN_ON.

OK, we can simply fail the io command submission.

> 
> > +		goto out;
> > +
> > +	io = &ubq->ios[tag];
> > +
> > +	/* there is pending io cmd, something must be wrong */
> > +	if (io->flags & UBLK_IO_FLAG_ACTIVE) {b
> > +		ret = -EBUSY;
> > +		goto out;
> > +	}
> > +
> > +	switch (cmd_op) {
> > +	case UBLK_IO_FETCH_REQ:
> > +		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
> > +		if (WARN_ON_ONCE(ublk_queue_ready(ubq))) {
> 
> Likewise, this shouldn't trigger a WARN_ON, IMO.

OK.

> 
> > +			ret = -EBUSY;
> > +			goto out;
> > +		}
> > +		/*
> > +		 * The io is being handled by server, so COMMIT_RQ is expected
> > +		 * instead of FETCH_REQ
> > +		 */
> > +		if (io->flags & UBLK_IO_FLAG_OWNED_BY_SRV)
> > +			goto out;
> > +		/* FETCH_RQ has to provide IO buffer */
> > +		if (!ub_cmd->addr)
> > +			goto out;
> > +		io->cmd = cmd;
> > +		io->flags |= UBLK_IO_FLAG_ACTIVE;
> > +		io->addr = ub_cmd->addr;
> > +
> > +		ublk_mark_io_ready(ub, ubq);
> > +		break;
> > +	case UBLK_IO_COMMIT_AND_FETCH_REQ:
> > +		/* FETCH_RQ has to provide IO buffer */
> > +		if (!ub_cmd->addr)
> > +			goto out;
> > +		io->addr = ub_cmd->addr;
> > +		io->flags |= UBLK_IO_FLAG_ACTIVE;
> > +		fallthrough;
> > +	case UBLK_IO_COMMIT_REQ:
> > +		io->cmd = cmd;
> > +		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
> > +			goto out;
> > +		ublk_commit_completion(ub, ub_cmd);
> > +
> > +		/* COMMIT_REQ is supposed to not fetch req */
> 
> I wonder if we could make it without IO_COMMIT_REQ.  Is it useful to be
> able to commit without fetching a new request?

UBLK_IO_COMMIT_AND_FETCH_REQ should cover both, since IO_COMMIT_REQ is
only submitted after aborting, and at that time the fetch action of
IO_COMMIT_AND_FETCH_REQ will be failed in ublk_cancel_queue. So I think
we can remove IO_COMMIT_REQ.


Thanks, 
Ming

