Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19919574F17
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 15:24:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232127AbiGNNYp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 09:24:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239452AbiGNNYa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 09:24:30 -0400
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84DCC2652;
        Thu, 14 Jul 2022 06:23:44 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R351e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046059;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VJJmwxW_1657805021;
Received: from 30.97.56.179(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VJJmwxW_1657805021)
          by smtp.aliyun-inc.com;
          Thu, 14 Jul 2022 21:23:41 +0800
Message-ID: <fe9508ae-f12a-2216-1160-145308d746f5@linux.alibaba.com>
Date:   Thu, 14 Jul 2022 21:23:40 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.11.0
Subject: Re: [PATCH V5 1/2] ublk_drv: add io_uring based userspace block
 driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
References: <20220713140711.97356-1-ming.lei@redhat.com>
 <20220713140711.97356-2-ming.lei@redhat.com>
 <a4249561-84a0-a314-c377-b96d28b7b20b@linux.alibaba.com>
 <Ys/0jTxQCEHdI560@T590>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <Ys/0jTxQCEHdI560@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/7/14 18:48, Ming Lei wrote:
> On Thu, Jul 14, 2022 at 06:20:38PM +0800, Ziyang Zhang wrote:
>> On 2022/7/13 22:07, Ming Lei wrote:
>>> This is the driver part of userspace block driver(ublk driver), the other
>>> part is userspace daemon part(ublksrv)[1].
>>>
>>> The two parts communicate by io_uring's IORING_OP_URING_CMD with one
>>> shared cmd buffer for storing io command, and the buffer is read only for
>>> ublksrv, each io command is indexed by io request tag directly, and
>>> is written by ublk driver.
>>>
>>> For example, when one READ io request is submitted to ublk block driver, ublk
>>> driver stores the io command into cmd buffer first, then completes one
>>> IORING_OP_URING_CMD for notifying ublksrv, and the URING_CMD is issued to
>>> ublk driver beforehand by ublksrv for getting notification of any new io request,
>>> and each URING_CMD is associated with one io request by tag.
>>>
>>> After ublksrv gets the io command, it translates and handles the ublk io
>>> request, such as, for the ublk-loop target, ublksrv translates the request
>>> into same request on another file or disk, like the kernel loop block
>>> driver. In ublksrv's implementation, the io is still handled by io_uring,
>>> and share same ring with IORING_OP_URING_CMD command. When the target io
>>> request is done, the same IORING_OP_URING_CMD is issued to ublk driver for
>>> both committing io request result and getting future notification of new
>>> io request.
>>>
>>> Another thing done by ublk driver is to copy data between kernel io
>>> request and ublksrv's io buffer:
>>>
>>> 1) before ubsrv handles WRITE request, copy the request's data into
>>> ublksrv's userspace io buffer, so that ublksrv can handle the write
>>> request
>>>
>>> 2) after ubsrv handles READ request, copy ublksrv's userspace io buffer
>>> into this READ request, then ublk driver can complete the READ request
>>>
>>> Zero copy may be switched if mm is ready to support it.
>>>
>>> ublk driver doesn't handle any logic of the specific user space driver,
>>> so it is small/simple enough.
>>>
>>> [1] ublksrv
>>>
>>> https://github.com/ming1/ubdsrv
>>>
>>> Signed-off-by: Ming Lei <ming.lei@redhat.com>
>>> ---
>>
>>
>> Hi, Ming
>>
>> I find that a big change from v4 to v5 is the simplification of locks.
>>
>> In v5 you remove ubq->abort_lock, and I want to ask why it is OK to remove it?
> 
> Actually V4 and previous version dealt with the issue too complicated.
> 
>>
>> If you have time, could you explain how ublk deals with potential race on:
>> 1)queue_rq 2)ublk_abort_queue 3) ublk_ctrl_stop_dev 4) ublk_rq_task_work.
>> (Lock in ublk really confuses me...)
> 
> One big change is the following code:
> 
> __ublk_rq_task_work():
> 	bool task_exiting = current != ubq->ubq_daemon ||
>                 (current->flags & PF_EXITING);
> 	...
> 	if (unlikely(task_exiting)) {
>                 blk_mq_end_request(req, BLK_STS_IOERR);
>                 mod_delayed_work(system_wq, &ub->monitor_work, 0);
>                 return;
>     }
> 
> Abort is always started after PF_EXITING is set, but if PF_EXITING is
> set, __ublk_rq_task_work fails the request immediately, then io->flags
> won't be touched, then no race with abort. Also PF_EXITING is
> per-task flag, can only be set before calling __ublk_rq_task_work(),
> and setting it actually serialized with calling task work func.
> 
> In ublk_queue_rq(), we don't touch io->flags, so there isn't race
> with abort.
> 
> Wrt. ublk_ctrl_stop_dev(), it isn't related with abort directly, and
> if del_gendisk() waits for inflight IO, abort work will be started
> for making forward progress. After del_gendisk() returns, there can't
> be any inflight io, so it is safe to cancel other pending io command.
> 

Thanks, Ming. I understand the aborting code now. And it looks good to me.

Previously I think maybe monitor_work and task_work
may be scheduled at the same time while task is exiting
and blk_mq_end_request() on the same tag could be called twice.

But I find there is a check on ublk_io's flag(UBLK_IO_FLAG_ACTIVE)
in ublk_daemon_monitor_work() and ublk_io is aborted in task_work
immediately(with UBLK_IO_FLAG_ACTIVE set, not cleared yet)

So there is no chance to call a send blk_mq_end_request() on the same tag.

Besides, for ublk_ios with UBLK_IO_FLAG_ACTIVE unset, 
stop_work scheduled in monitor work will call ublk_cancel_queue() by sending
cqes with UBLK_IO_RES_ABORT.

Put it together:

When daemon is PF_EXITING:

1) current ublk_io: aborted immediately in task_work

2) UBLK_IO_FLAG_ACTIVE set: aborted in ublk_daemon_monitor_work

3) UBLK_IO_FLAG_ACTIVE unset: send cqe with UBLK_IO_RES_ABORT


Hope I'm correct this time. :)

>>
>>
>> [...]
>>
>>> +
>>> +/*
>>> + * __ublk_fail_req() may be called from abort context or ->ubq_daemon
>>> + * context during exiting, so lock is required.
>>> + *
>>> + * Also aborting may not be started yet, keep in mind that one failed
>>> + * request may be issued by block layer again.
>>> + */
>>> +static void __ublk_fail_req(struct ublk_io *io, struct request *req)
>>> +{
>>> +	WARN_ON_ONCE(io->flags & UBLK_IO_FLAG_ACTIVE);
>>> +
>>> +	if (!(io->flags & UBLK_IO_FLAG_ABORTED)) {
>>> +		io->flags |= UBLK_IO_FLAG_ABORTED;
>>> +		blk_mq_end_request(req, BLK_STS_IOERR);
>>> +	}
>>> +}
>>> +
>>
>> [...]
>>
>>> +
>>> +/*
>>> + * When ->ubq_daemon is exiting, either new request is ended immediately,
>>> + * or any queued io command is drained, so it is safe to abort queue
>>> + * lockless
>>> + */
>>> +static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
>>> +{
>>> +	int i;
>>> +
>>> +	if (!ublk_get_device(ub))
>>> +		return;
>>> +
>>> +	for (i = 0; i < ubq->q_depth; i++) {
>>> +		struct ublk_io *io = &ubq->ios[i];
>>> +
>>> +		if (!(io->flags & UBLK_IO_FLAG_ACTIVE)) {
>>> +			struct request *rq;
>>> +
>>> +			/*
>>> +			 * Either we fail the request or ublk_rq_task_work_fn
>>> +			 * will do it
>>> +			 */
>>> +			rq = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], i);
>>> +			if (rq)
>>> +				__ublk_fail_req(io, rq);
>>> +		}
>>> +	}
>>> +	ublk_put_device(ub);
>>> +}
>>> +
>>
>>
>> Another problem: 
>>
>> 1) comment of __ublk_fail_req():  "so lock is required"
> 
> Yeah, now __ublk_fail_req is only called in abort context, and no race
> with task work any more, so lock isn't needed.

Ok, I see.

> 
>>
>> 2) comment of ublk_abort_queue(): "so it is safe to abort queue lockless"
> 
> This comment is updated in v5, and it is correct.
> 
>>
>> 3) ublk_abort_queue() calls _ublk_fail_req() on all ubqs.
> 
> No, ublk_abort_queue() only aborts the passed ubq, so if one ubq daemon
> is aborted, other ubqs can still handle IO during deleting disk.

Ok, I see.

I think if one ubq daemon is killed(and blk-mq requests related to it are aborted), 
stop work should call del_gendisk() and other ubq daemons can still complete blk-mq requests
but no new blk-mq requests will be issued. 
After that, these unkilled ubq daemons will get UBLK_IO_RES_ABORT cqes
and exit by themselves.


> 
> 
> Thanks,
> Ming
