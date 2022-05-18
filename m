Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1F052B1FD
	for <lists+io-uring@lfdr.de>; Wed, 18 May 2022 07:57:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbiERFxT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 May 2022 01:53:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230183AbiERFxS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 May 2022 01:53:18 -0400
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE75344A2E;
        Tue, 17 May 2022 22:53:15 -0700 (PDT)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R681e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04395;MF=ziyangzhang@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0VDbwwQE_1652853191;
Received: from 30.39.86.92(mailfrom:ZiyangZhang@linux.alibaba.com fp:SMTPD_---0VDbwwQE_1652853191)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 18 May 2022 13:53:12 +0800
Message-ID: <9df54909-8110-ff2b-021d-d54746a77ff4@linux.alibaba.com>
Date:   Wed, 18 May 2022 13:53:11 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.8.1
Subject: Re: [PATCH V2 1/1] ubd: add io_uring based userspace block driver
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Harris James R <james.r.harris@intel.com>,
        io-uring@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20220517055358.3164431-1-ming.lei@redhat.com>
 <20220517055358.3164431-2-ming.lei@redhat.com>
 <55d724a8-ed7d-ae92-ca6d-3582e13587db@linux.alibaba.com>
 <YoObOMur7x/u0w1C@T590>
From:   Ziyang Zhang <ZiyangZhang@linux.alibaba.com>
In-Reply-To: <YoObOMur7x/u0w1C@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-12.0 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2022/5/17 20:55, Ming Lei wrote:
> On Tue, May 17, 2022 at 06:00:57PM +0800, Ziyang Zhang wrote:
>> On 2022/5/17 13:53, Ming Lei wrote:
>>
>>> +
>>> +static void ubd_cancel_queue(struct ubd_queue *ubq)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < ubq->q_depth; i++) {
>>> +		struct ubd_io *io = &ubq->ios[i];
>>> +
>>> +		if (io->flags & UBD_IO_FLAG_ACTIVE) {
>>> +			io->flags &= ~UBD_IO_FLAG_ACTIVE;
>>> +			io_uring_cmd_done(io->cmd, UBD_IO_RES_ABORT, 0);
>>> +		}
>>> +	}
>>> +}
>>
>> Hi Ming,
>>
>> When ubdsrv sends STOP_DEV and all active IOs in ubd_drv are done(UBD_IO_RES_ABORT),
>> there may be still some IOs handled by ubdsrv(UBD_IO_FLAG_ACTIVE not set).
>> When these IOs complete and return to ubd_drv, how to handle them?
> 
> Either UBD_IO_COMMIT_AND_FETCH_REQ or UBD_IO_COMMIT_REQ will be sent to ubd_drv
> for completing these IOs. And finally ubd_cancel_dev() in ubd driver will
> cancel all pending io commands, so io_uring can be exited. I guess
> UBD_IO_COMMIT_REQ can be removed too.

Yes, I think UBD_IO_COMMIT_REQ can be removed.

> 
>> I find that UBD_IO_FETCH_REQ are still set,
>> so will these IOs be issued to ubdsrv again or canceled?
>> (I see ubd_drv fails IOs when the daemon is dying 
>> but maybe here the daemon is still alive)
> 
> If daemon is alive, ubd_drv will rely on ubq_daemon for completing
> all inflight IOs. Otherwise, the monitor work will be triggered for
> completing/failing inflight IOs. The mechanism is actually very simple:
> 
> static void ubd_stop_dev(struct ubd_device *ub)
> {
>         mutex_lock(&ub->mutex);
>         if (!disk_live(ub->ub_disk))
>                 goto unlock;
> 
>         del_gendisk(ub->ub_disk);	// drain & wait in-flight IOs
>         ub->dev_info.state = UBD_S_DEV_DEAD;
>         ub->dev_info.ubdsrv_pid = -1;
>         ubd_cancel_dev(ub);	   //No IO is possible now, so cancel pending io commands
>  unlock:
>         mutex_unlock(&ub->mutex);
>         cancel_delayed_work_sync(&ub->monitor_work);
> }
> 
> When waiting for IO completion in del_gendisk(), in case that ubq_daemon
> is exiting/dying, monitor work will be triggered to call ubd_abort_queue() to
> fail in-flight requests for making forward progress. ubd_abort_queue() may
> looks a bit tricky to try using task work for aborting request, that
> is just for sync with ubd_rq_task_work_fn().
> 

Thanks for explanation because this part really confuses me.  :)
But I still concern about the complicity of handling exiting/dying ubq_daemon
and aborting queues and I'm trying to find out a simpler way...

Another question is that using task_work functions require UBD to be built in kernel.
However for users, maybe they are willing to use an external UBD module.
Shall we discuss about this now?

Regards,
Zhang
