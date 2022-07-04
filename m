Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F874565F5C
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 00:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbiGDWKu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jul 2022 18:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiGDWKt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jul 2022 18:10:49 -0400
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8C7DCD;
        Mon,  4 Jul 2022 15:10:46 -0700 (PDT)
Received: from localhost (mtl.collabora.ca [66.171.169.34])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: krisman)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id CAC4B660199B;
        Mon,  4 Jul 2022 23:10:43 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1656972644;
        bh=f7qX9aNdHMeGZi3tiyhpEyLoPPdnaIV/8y9fDqUo/yk=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=DU/88rlbrpqnAbvddnCzw1P0IdJDbM23mf8fyRc60h82Ny3UYojaYxyj/zeSczEQO
         2pIu4uTXuForPLl6YnzNu8Xlb3mPCzldw9WUew0aXrzLqbNSPukds2V59o0vUQcoaO
         7LoxIORbxaDRyvS9IYqEsS0qp+dstIduQ2Bcx6FjrfnvV2uPvgKkFOiDEXeWF2MsY8
         L1tuDLjKCSOybO6nQuPnHhyFdPx36/6hXcN6SB5wGhl89CK5r622pKqKpGsFC01YFW
         M8oY1i282i+SsZBOBgZ95a8+I1V2rCkRWVjYYbR8gU5XXuEGq2wKsLt4B5p4ODskao
         3yziv5xB1+eGA==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Organization: Collabora
References: <20220628160807.148853-1-ming.lei@redhat.com>
        <20220628160807.148853-2-ming.lei@redhat.com>
Date:   Mon, 04 Jul 2022 18:10:40 -0400
In-Reply-To: <20220628160807.148853-2-ming.lei@redhat.com> (Ming Lei's message
        of "Wed, 29 Jun 2022 00:08:07 +0800")
Message-ID: <8735fg4jhb.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming Lei <ming.lei@redhat.com> writes:

> This is the driver part of userspace block driver(ublk driver), the other
> part is userspace daemon part(ublksrv)[1].
>
> The two parts communicate by io_uring's IORING_OP_URING_CMD with one
> shared cmd buffer for storing io command, and the buffer is read only for
> ublksrv, each io command is indexed by io request tag directly, and
> is written by ublk driver.
>
> For example, when one READ io request is submitted to ublk block driver, ublk
> driver stores the io command into cmd buffer first, then completes one
> IORING_OP_URING_CMD for notifying ublksrv, and the URING_CMD is issued to
> ublk driver beforehand by ublksrv for getting notification of any new io request,
> and each URING_CMD is associated with one io request by tag.
>
> After ublksrv gets the io command, it translates and handles the ublk io
> request, such as, for the ublk-loop target, ublksrv translates the request
> into same request on another file or disk, like the kernel loop block
> driver. In ublksrv's implementation, the io is still handled by io_uring,
> and share same ring with IORING_OP_URING_CMD command. When the target io
> request is done, the same IORING_OP_URING_CMD is issued to ublk driver for
> both committing io request result and getting future notification of new
> io request.
>
> Another thing done by ublk driver is to copy data between kernel io
> request and ublksrv's io buffer:
>
> 1) before ubsrv handles WRITE request, copy the request's data into
> ublksrv's userspace io buffer, so that ublksrv can handle the write
> request
>
> 2) after ubsrv handles READ request, copy ublksrv's userspace io buffer
> into this READ request, then ublk driver can complete the READ request
>
> Zero copy may be switched if mm is ready to support it.
>
> ublk driver doesn't handle any logic of the specific user space driver,
> so it should be small/simple enough.
>
> [1] ublksrv
>
> https://github.com/ming1/ubdsrv
>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>

Hi Ming,

A few comments inline:


> +#define UBLK_MINORS		(1U << MINORBITS)
> +
> +struct ublk_rq_data {
> +	struct callback_head work;
> +};
> +
> +/* io cmd is active: sqe cmd is received, and its cqe isn't done */
> +#define UBLK_IO_FLAG_ACTIVE	0x01
> +
> +/*
> + * FETCH io cmd is completed via cqe, and the io cmd is being handled by
> + * ublksrv, and not committed yet
> + */
> +#define UBLK_IO_FLAG_OWNED_BY_SRV 0x02
> +

Minor nit: I wonder if the IO life cycle isn't better represented as a
state machine than flags:

enum {
   UBLK_IO_FREE,
   UBLK_IO_QUEUED
   UBLK_IO_OWNED_BY_SRV
   UBLK_IO_COMPLETED,
   UBLK_IO_ABORTED,
}

Since currently, IO_FLAG_ACTIVE and IO_OWNED_BY_SRV should (almost) be
mutually exclusive.


> +
> +static int ublk_ctrl_stop_dev(struct ublk_device *ub)
> +{
> +	ublk_stop_dev(ub);
> +	cancel_work_sync(&ub->stop_work);
> +	return 0;
> +}
> +
> +static inline bool ublk_queue_ready(struct ublk_queue *ubq)
> +{
> +	return ubq->nr_io_ready == ubq->q_depth;
> +}
> +
> +/* device can only be started after all IOs are ready */
> +static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
> +{
> +	mutex_lock(&ub->mutex);
> +	ubq->nr_io_ready++;

I think this is still problematic for the case where a FETCH_IO is sent
from a different thread than the one originally set in ubq_daemon
(i.e. a userspace bug).  Since ubq_daemon is used to decide what task
context will do the data copy, If an IO_FETCH_RQ is sent to the same queue
from two threads, the data copy can happen in the context of the wrong
task.  I'd suggest something like the check below at the beginning of
mark_io_ready and a similar on for IO_COMMIT_AND_FETCH_RQ

	mutex_lock(&ub->mutex);
        if (ub->ubq_daemon && ub->ubq_daemon != current) {
           mutex_unlock(&ub->mutex);
           return -EINVAL;
        }
	ubq->nr_io_ready++;
        ...
> +	if (ublk_queue_ready(ubq)) {
> +		ubq->ubq_daemon = current;
> +		get_task_struct(ubq->ubq_daemon);
> +		ub->nr_queues_ready++;
> +	}
> +	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues)
> +		complete_all(&ub->completion);
> +	mutex_unlock(&ub->mutex);
> +}
> +
> +static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
> +{
> +	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
> +	struct ublk_device *ub = cmd->file->private_data;
> +	struct ublk_queue *ubq;
> +	struct ublk_io *io;
> +	u32 cmd_op = cmd->cmd_op;
> +	unsigned tag = ub_cmd->tag;
> +	int ret = -EINVAL;
> +
> +	pr_devel("%s: receieved: cmd op %d queue %d tag %d result %d\n",

                         ^^^
                         received


> +			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
> +			ub_cmd->result);
> +
> +	if (!(issue_flags & IO_URING_F_SQE128))
> +		goto out;
> +
> +	ubq = ublk_get_queue(ub, ub_cmd->q_id);
> +	if (!ubq || ub_cmd->q_id != ubq->q_id)

q_id is coming from userspace and is used to access an array inside
ublk_get_queue().  I think you need to ensure qid < ub->dev_info.nr_hw_queues
before calling ublk_get_queue() to protect from a kernel bad memory
access triggered by userspace.

> +		goto out;
> +
> +	if (WARN_ON_ONCE(tag >= ubq->q_depth))

Userspace shouldn't be able to easily trigger a WARN_ON.

> +		goto out;
> +
> +	io = &ubq->ios[tag];
> +
> +	/* there is pending io cmd, something must be wrong */
> +	if (io->flags & UBLK_IO_FLAG_ACTIVE) {b
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	switch (cmd_op) {
> +	case UBLK_IO_FETCH_REQ:
> +		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
> +		if (WARN_ON_ONCE(ublk_queue_ready(ubq))) {

Likewise, this shouldn't trigger a WARN_ON, IMO.

> +			ret = -EBUSY;
> +			goto out;
> +		}
> +		/*
> +		 * The io is being handled by server, so COMMIT_RQ is expected
> +		 * instead of FETCH_REQ
> +		 */
> +		if (io->flags & UBLK_IO_FLAG_OWNED_BY_SRV)
> +			goto out;
> +		/* FETCH_RQ has to provide IO buffer */
> +		if (!ub_cmd->addr)
> +			goto out;
> +		io->cmd = cmd;
> +		io->flags |= UBLK_IO_FLAG_ACTIVE;
> +		io->addr = ub_cmd->addr;
> +
> +		ublk_mark_io_ready(ub, ubq);
> +		break;
> +	case UBLK_IO_COMMIT_AND_FETCH_REQ:
> +		/* FETCH_RQ has to provide IO buffer */
> +		if (!ub_cmd->addr)
> +			goto out;
> +		io->addr = ub_cmd->addr;
> +		io->flags |= UBLK_IO_FLAG_ACTIVE;
> +		fallthrough;
> +	case UBLK_IO_COMMIT_REQ:
> +		io->cmd = cmd;
> +		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
> +			goto out;
> +		ublk_commit_completion(ub, ub_cmd);
> +
> +		/* COMMIT_REQ is supposed to not fetch req */

I wonder if we could make it without IO_COMMIT_REQ.  Is it useful to be
able to commit without fetching a new request?

> +		if (cmd_op == UBLK_IO_COMMIT_REQ) {
> +			ret = UBLK_IO_RES_OK;
> +			goto out;
> +		}
> +		break;
> +	default:
> +		goto out;
> +	}
> +	return -EIOCBQUEUED;
> +
> + out:
> +	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
> +	io_uring_cmd_done(cmd, ret, 0);
> +	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
> +			__func__, cmd_op, tag, ret, io->flags);
> +	return -EIOCBQUEUED;
> +}
> +

Thanks!

-- 
Gabriel Krisman Bertazi
