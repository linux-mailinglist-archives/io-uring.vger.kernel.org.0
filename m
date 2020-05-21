Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 50CAE1DD623
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2020 20:39:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgEUSjg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 14:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728240AbgEUSjg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 14:39:36 -0400
Received: from Galois.linutronix.de (Galois.linutronix.de [IPv6:2a0a:51c0:0:12e:550::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DDB0C061A0E;
        Thu, 21 May 2020 11:39:36 -0700 (PDT)
Received: from p5de0bf0b.dip0.t-ipconnect.de ([93.224.191.11] helo=nanos.tec.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tglx@linutronix.de>)
        id 1jbq6A-0006og-PX; Thu, 21 May 2020 20:39:19 +0200
Received: by nanos.tec.linutronix.de (Postfix, from userid 1000)
        id E386A100C2D; Thu, 21 May 2020 20:39:16 +0200 (CEST)
From:   Thomas Gleixner <tglx@linutronix.de>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set data->ctx and data->hctx in blk_mq_alloc_request_hctx
In-Reply-To: <20200521092340.GA751297@T590>
References: <20200520011823.GA415158@T590> <20200520030424.GI416136@T590> <20200520080357.GA4197@lst.de> <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk> <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk> <87tv0av1gu.fsf@nanos.tec.linutronix.de> <2a12a7aa-c339-1e51-de0d-9bc6ced14c64@kernel.dk> <87eereuudh.fsf@nanos.tec.linutronix.de> <20200521022746.GA730422@T590> <87367tvh6g.fsf@nanos.tec.linutronix.de> <20200521092340.GA751297@T590>
Date:   Thu, 21 May 2020 20:39:16 +0200
Message-ID: <87pnaxt9nv.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Ming,

Ming Lei <ming.lei@redhat.com> writes:
> On Thu, May 21, 2020 at 10:13:59AM +0200, Thomas Gleixner wrote:
>> Ming Lei <ming.lei@redhat.com> writes:
>> > On Thu, May 21, 2020 at 12:14:18AM +0200, Thomas Gleixner wrote:
>> > - otherwise, the kthread just retries and retries to allocate & release,
>> > and sooner or later, its time slice is consumed, and migrated out, and the
>> > cpu hotplug handler will get chance to run and move on, then the cpu is
>> > shutdown.
>> 
>> 1) This is based on the assumption that the kthread is in the SCHED_OTHER
>>    scheduling class. Is that really a valid assumption?
>
> Given it is unlikely path, we can add msleep() before retrying when INACTIVE bit
> is observed by current thread, and this way can avoid spinning and should work
> for other schedulers.

That should work, but pretty is something else

>> 
>> 2) What happens in the following scenario:
>> 
>>    unplug
>> 
>>      mq_offline
>>        set_ctx_inactive()
>>        drain_io()
>>        
>>    io_kthread()
>>        try_queue()
>>        wait_on_ctx()
>> 
>>    Can this happen and if so what will wake up that thread?
>
> drain_io() releases all tag of this hctx, then wait_on_ctx() will be waken up
> after any tag is released.

drain_io() is already done ...

So looking at that thread function:

static int io_sq_thread(void *data)
{
	struct io_ring_ctx *ctx = data;

        while (...) {
              ....
	      to_submit = io_sqring_entries(ctx);

--> preemption

hotplug runs
   mq_offline()
      set_ctx_inactive();
      drain_io();
      finished();

--> thread runs again

      mutex_lock(&ctx->uring_lock);
      ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
      mutex_unlock(&ctx->uring_lock);

      ....

      if (!to_submit || ret == -EBUSY)
          ...
      	  wait_on_ctx();

Can this happen or did drain_io() already take care of the 'to_submit'
items and the call to io_submit_sqes() turns into a zero action ?

If the above happens then nothing will wake it up because the context
draining is done and finished.

Thanks,

        tglx
