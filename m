Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C467574A7A
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 12:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231953AbiGNKUs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 Jul 2022 06:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237888AbiGNKUq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 Jul 2022 06:20:46 -0400
Received: from out199-14.us.a.mail.aliyun.com (out199-14.us.a.mail.aliyun.com [47.90.199.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390F7222B7;
        Thu, 14 Jul 2022 03:20:42 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R301e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=7;SR=0;TI=SMTPD_---0VJJ3DbJ_1657794038;
Received: from 30.97.56.179(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VJJ3DbJ_1657794038)
          by smtp.aliyun-inc.com;
          Thu, 14 Jul 2022 18:20:39 +0800
Message-ID: <a4249561-84a0-a314-c377-b96d28b7b20b@linux.alibaba.com>
Date:   Thu, 14 Jul 2022 18:20:38 +0800
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
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <20220713140711.97356-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/7/13 22:07, Ming Lei wrote:
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
> so it is small/simple enough.
> 
> [1] ublksrv
> 
> https://github.com/ming1/ubdsrv
> 
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---


Hi, Ming

I find that a big change from v4 to v5 is the simplification of locks.

In v5 you remove ubq->abort_lock, and I want to ask why it is OK to remove it?

If you have time, could you explain how ublk deals with potential race on:
1)queue_rq 2)ublk_abort_queue 3) ublk_ctrl_stop_dev 4) ublk_rq_task_work.
(Lock in ublk really confuses me...)


[...]

> +
> +/*
> + * __ublk_fail_req() may be called from abort context or ->ubq_daemon
> + * context during exiting, so lock is required.
> + *
> + * Also aborting may not be started yet, keep in mind that one failed
> + * request may be issued by block layer again.
> + */
> +static void __ublk_fail_req(struct ublk_io *io, struct request *req)
> +{
> +	WARN_ON_ONCE(io->flags & UBLK_IO_FLAG_ACTIVE);
> +
> +	if (!(io->flags & UBLK_IO_FLAG_ABORTED)) {
> +		io->flags |= UBLK_IO_FLAG_ABORTED;
> +		blk_mq_end_request(req, BLK_STS_IOERR);
> +	}
> +}
> +

[...]

> +
> +/*
> + * When ->ubq_daemon is exiting, either new request is ended immediately,
> + * or any queued io command is drained, so it is safe to abort queue
> + * lockless
> + */
> +static void ublk_abort_queue(struct ublk_device *ub, struct ublk_queue *ubq)
> +{
> +	int i;
> +
> +	if (!ublk_get_device(ub))
> +		return;
> +
> +	for (i = 0; i < ubq->q_depth; i++) {
> +		struct ublk_io *io = &ubq->ios[i];
> +
> +		if (!(io->flags & UBLK_IO_FLAG_ACTIVE)) {
> +			struct request *rq;
> +
> +			/*
> +			 * Either we fail the request or ublk_rq_task_work_fn
> +			 * will do it
> +			 */
> +			rq = blk_mq_tag_to_rq(ub->tag_set.tags[ubq->q_id], i);
> +			if (rq)
> +				__ublk_fail_req(io, rq);
> +		}
> +	}
> +	ublk_put_device(ub);
> +}
> +


Another problem: 

1) comment of __ublk_fail_req():  "so lock is required"

2) comment of ublk_abort_queue(): "so it is safe to abort queue lockless"

3) ublk_abort_queue() calls _ublk_fail_req() on all ubqs.

Perhaps you need to update the comments?


Regards,
Zhang

