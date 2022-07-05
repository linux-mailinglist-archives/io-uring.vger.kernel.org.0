Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 841ED566227
	for <lists+io-uring@lfdr.de>; Tue,  5 Jul 2022 06:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbiGEEQO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 5 Jul 2022 00:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230432AbiGEEQO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 5 Jul 2022 00:16:14 -0400
Received: from out30-56.freemail.mail.aliyun.com (out30-56.freemail.mail.aliyun.com [115.124.30.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F0D613CE3;
        Mon,  4 Jul 2022 21:16:11 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R961e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VIQHI6I_1656994568;
Received: from 30.97.57.39(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VIQHI6I_1656994568)
          by smtp.aliyun-inc.com;
          Tue, 05 Jul 2022 12:16:09 +0800
Message-ID: <ebd6754e-57bf-88a7-df04-3f38864b0c52@linux.alibaba.com>
Date:   Tue, 5 Jul 2022 12:16:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH V3 1/1] ublk: add io_uring based userspace block driver
Content-Language: en-US
To:     Gabriel Krisman Bertazi <krisman@collabora.com>,
        Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <20220628160807.148853-1-ming.lei@redhat.com>
 <20220628160807.148853-2-ming.lei@redhat.com> <8735fg4jhb.fsf@collabora.com>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <8735fg4jhb.fsf@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/7/5 06:10, Gabriel Krisman Bertazi wrote:
> Ming Lei <ming.lei@redhat.com> writes:
> 
>> This is the driver part of userspace block driver(ublk driver), the other
>> part is userspace daemon part(ublksrv)[1].
>>
>> The two parts communicate by io_uring's IORING_OP_URING_CMD with one
>> shared cmd buffer for storing io command, and the buffer is read only for
>> ublksrv, each io command is indexed by io request tag directly, and
>> is written by ublk driver.
>>
>> For example, when one READ io request is submitted to ublk block driver, ublk
>> driver stores the io command into cmd buffer first, then completes one
>> IORING_OP_URING_CMD for notifying ublksrv, and the URING_CMD is issued to
>> ublk driver beforehand by ublksrv for getting notification of any new io request,
>> and each URING_CMD is associated with one io request by tag.
>>
>> After ublksrv gets the io command, it translates and handles the ublk io
>> request, such as, for the ublk-loop target, ublksrv translates the request
>> into same request on another file or disk, like the kernel loop block
>> driver. In ublksrv's implementation, the io is still handled by io_uring,
>> and share same ring with IORING_OP_URING_CMD command. When the target io
>> request is done, the same IORING_OP_URING_CMD is issued to ublk driver for
>> both committing io request result and getting future notification of new
>> io request.
>>
>> Another thing done by ublk driver is to copy data between kernel io
>> request and ublksrv's io buffer:
>>
>> 1) before ubsrv handles WRITE request, copy the request's data into
>> ublksrv's userspace io buffer, so that ublksrv can handle the write
>> request
>>
>> 2) after ubsrv handles READ request, copy ublksrv's userspace io buffer
>> into this READ request, then ublk driver can complete the READ request
>>
>> Zero copy may be switched if mm is ready to support it.
>>
>> ublk driver doesn't handle any logic of the specific user space driver,
>> so it should be small/simple enough.
>>
>> [1] ublksrv
>>
>> https://github.com/ming1/ubdsrv
>>
>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> 
> Hi Ming,
> 
> A few comments inline:
> 
> 
>> +#define UBLK_MINORS		(1U << MINORBITS)
>> +
>> +struct ublk_rq_data {
>> +	struct callback_head work;
>> +};
>> +
>> +/* io cmd is active: sqe cmd is received, and its cqe isn't done */
>> +#define UBLK_IO_FLAG_ACTIVE	0x01
>> +
>> +/*
>> + * FETCH io cmd is completed via cqe, and the io cmd is being handled by
>> + * ublksrv, and not committed yet
>> + */
>> +#define UBLK_IO_FLAG_OWNED_BY_SRV 0x02
>> +
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
> 
> 
>> +
>> +static int ublk_ctrl_stop_dev(struct ublk_device *ub)
>> +{
>> +	ublk_stop_dev(ub);
>> +	cancel_work_sync(&ub->stop_work);
>> +	return 0;
>> +}
>> +
>> +static inline bool ublk_queue_ready(struct ublk_queue *ubq)
>> +{
>> +	return ubq->nr_io_ready == ubq->q_depth;
>> +}
>> +
>> +/* device can only be started after all IOs are ready */
>> +static void ublk_mark_io_ready(struct ublk_device *ub, struct ublk_queue *ubq)
>> +{
>> +	mutex_lock(&ub->mutex);
>> +	ubq->nr_io_ready++;
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
>         ...
>> +	if (ublk_queue_ready(ubq)) {
>> +		ubq->ubq_daemon = current;
>> +		get_task_struct(ubq->ubq_daemon);
>> +		ub->nr_queues_ready++;
>> +	}
>> +	if (ub->nr_queues_ready == ub->dev_info.nr_hw_queues)
>> +		complete_all(&ub->completion);
>> +	mutex_unlock(&ub->mutex);
>> +}
>> +
>> +static int ublk_ch_uring_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
>> +{
>> +	struct ublksrv_io_cmd *ub_cmd = (struct ublksrv_io_cmd *)cmd->cmd;
>> +	struct ublk_device *ub = cmd->file->private_data;
>> +	struct ublk_queue *ubq;
>> +	struct ublk_io *io;
>> +	u32 cmd_op = cmd->cmd_op;
>> +	unsigned tag = ub_cmd->tag;
>> +	int ret = -EINVAL;
>> +
>> +	pr_devel("%s: receieved: cmd op %d queue %d tag %d result %d\n",
> 
>                          ^^^
>                          received
> 
> 
>> +			__func__, cmd->cmd_op, ub_cmd->q_id, tag,
>> +			ub_cmd->result);
>> +
>> +	if (!(issue_flags & IO_URING_F_SQE128))
>> +		goto out;
>> +
>> +	ubq = ublk_get_queue(ub, ub_cmd->q_id);
>> +	if (!ubq || ub_cmd->q_id != ubq->q_id)
> 
> q_id is coming from userspace and is used to access an array inside
> ublk_get_queue().  I think you need to ensure qid < ub->dev_info.nr_hw_queues
> before calling ublk_get_queue() to protect from a kernel bad memory
> access triggered by userspace.
> 
>> +		goto out;
>> +
>> +	if (WARN_ON_ONCE(tag >= ubq->q_depth))
> 
> Userspace shouldn't be able to easily trigger a WARN_ON.
> 
>> +		goto out;
>> +
>> +	io = &ubq->ios[tag];
>> +
>> +	/* there is pending io cmd, something must be wrong */
>> +	if (io->flags & UBLK_IO_FLAG_ACTIVE) {b
>> +		ret = -EBUSY;
>> +		goto out;
>> +	}
>> +
>> +	switch (cmd_op) {
>> +	case UBLK_IO_FETCH_REQ:
>> +		/* UBLK_IO_FETCH_REQ is only allowed before queue is setup */
>> +		if (WARN_ON_ONCE(ublk_queue_ready(ubq))) {
> 
> Likewise, this shouldn't trigger a WARN_ON, IMO.
> 
>> +			ret = -EBUSY;
>> +			goto out;
>> +		}
>> +		/*
>> +		 * The io is being handled by server, so COMMIT_RQ is expected
>> +		 * instead of FETCH_REQ
>> +		 */
>> +		if (io->flags & UBLK_IO_FLAG_OWNED_BY_SRV)
>> +			goto out;
>> +		/* FETCH_RQ has to provide IO buffer */
>> +		if (!ub_cmd->addr)
>> +			goto out;
>> +		io->cmd = cmd;
>> +		io->flags |= UBLK_IO_FLAG_ACTIVE;
>> +		io->addr = ub_cmd->addr;
>> +
>> +		ublk_mark_io_ready(ub, ubq);
>> +		break;
>> +	case UBLK_IO_COMMIT_AND_FETCH_REQ:
>> +		/* FETCH_RQ has to provide IO buffer */
>> +		if (!ub_cmd->addr)
>> +			goto out;
>> +		io->addr = ub_cmd->addr;
>> +		io->flags |= UBLK_IO_FLAG_ACTIVE;
>> +		fallthrough;
>> +	case UBLK_IO_COMMIT_REQ:
>> +		io->cmd = cmd;
>> +		if (!(io->flags & UBLK_IO_FLAG_OWNED_BY_SRV))
>> +			goto out;
>> +		ublk_commit_completion(ub, ub_cmd);
>> +
>> +		/* COMMIT_REQ is supposed to not fetch req */
> 
> I wonder if we could make it without IO_COMMIT_REQ.  Is it useful to be
> able to commit without fetching a new request?

UBLK_IO_COMMIT_REQ is not necessary, IMO. 
In current version of ubd_drv.c I find UBLK_IO_COMMIT_REQ is sent by ublksrv
after it gets one UBD_IO_RES_ABORT beacuse ubd_drv wants to abort IOs and let
the ublk daemon exit.

We can use UBLK_IO_COMMIT_AND_FETCH_REQ to replace UBLK_IO_COMMIT_REQ.
The data flow could be:

1) UBLK_IO_COMMIT_AND_FETCH_REQ from ublksrv

2) ubd_drv receives IO's sqe with UBLK_IO_COMMIT_AND_FETCH_REQ
   and sets the IO's status to UBLK_IO_QUEUED

3) ubd_drv wants to abort IOs so it just completes
   this IO's cqe(UBD_IO_RES_ABORT)

I successfully removed UBLK_IO_COMMIT_REQ when developing libubd
although I choose the earliest version of ubd_drv.c(v5.17-ubd-dev)
which may be a buggy version.

> 
>> +		if (cmd_op == UBLK_IO_COMMIT_REQ) {
>> +			ret = UBLK_IO_RES_OK;
>> +			goto out;
>> +		}
>> +		break;
>> +	default:
>> +		goto out;
>> +	}
>> +	return -EIOCBQUEUED;
>> +
>> + out:
>> +	io->flags &= ~UBLK_IO_FLAG_ACTIVE;
>> +	io_uring_cmd_done(cmd, ret, 0);
>> +	pr_devel("%s: complete: cmd op %d, tag %d ret %x io_flags %x\n",
>> +			__func__, cmd_op, tag, ret, io->flags);
>> +	return -EIOCBQUEUED;
>> +}
>> +
> 
> Thanks!
> 
