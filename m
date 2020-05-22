Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBE51DDCD4
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2020 03:57:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726693AbgEVB5i (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 21:57:38 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:34705 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726335AbgEVB5i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 21:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590112656;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+wDdNyvkCFMdN0Oe8Nl6A+nCz6R/E6o7nQrNSLAaN6Y=;
        b=hH9HDUNlrTy70dnwSWQh4ziDzXKe6Rk1cotoejQ8hb3mnsB4nMsfEEXwy5we9CDpuug/5f
        PODle6imhWtCzVUHob40uw1SQ4U5YofVyFqox035McaH65CdUC1Zd1LNhZ4qdLfVKfrGgY
        CjsKla9ZxUHeTcN34ZQj5dVCsqYbQBw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-389-93omiG20O--1Yrc9dX2vLA-1; Thu, 21 May 2020 21:57:34 -0400
X-MC-Unique: 93omiG20O--1Yrc9dX2vLA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A36C41005510;
        Fri, 22 May 2020 01:57:32 +0000 (UTC)
Received: from T590 (ovpn-13-78.pek2.redhat.com [10.72.13.78])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 0BBDD795A9;
        Fri, 22 May 2020 01:57:23 +0000 (UTC)
Date:   Fri, 22 May 2020 09:57:19 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>, io-uring@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: io_uring vs CPU hotplug, was Re: [PATCH 5/9] blk-mq: don't set
 data->ctx and data->hctx in blk_mq_alloc_request_hctx
Message-ID: <20200522015719.GB755458@T590>
References: <20200520080357.GA4197@lst.de>
 <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk>
 <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
 <87tv0av1gu.fsf@nanos.tec.linutronix.de>
 <2a12a7aa-c339-1e51-de0d-9bc6ced14c64@kernel.dk>
 <87eereuudh.fsf@nanos.tec.linutronix.de>
 <20200521022746.GA730422@T590>
 <87367tvh6g.fsf@nanos.tec.linutronix.de>
 <20200521092340.GA751297@T590>
 <87pnaxt9nv.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pnaxt9nv.fsf@nanos.tec.linutronix.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 21, 2020 at 08:39:16PM +0200, Thomas Gleixner wrote:
> Ming,
> 
> Ming Lei <ming.lei@redhat.com> writes:
> > On Thu, May 21, 2020 at 10:13:59AM +0200, Thomas Gleixner wrote:
> >> Ming Lei <ming.lei@redhat.com> writes:
> >> > On Thu, May 21, 2020 at 12:14:18AM +0200, Thomas Gleixner wrote:
> >> > - otherwise, the kthread just retries and retries to allocate & release,
> >> > and sooner or later, its time slice is consumed, and migrated out, and the
> >> > cpu hotplug handler will get chance to run and move on, then the cpu is
> >> > shutdown.
> >> 
> >> 1) This is based on the assumption that the kthread is in the SCHED_OTHER
> >>    scheduling class. Is that really a valid assumption?
> >
> > Given it is unlikely path, we can add msleep() before retrying when INACTIVE bit
> > is observed by current thread, and this way can avoid spinning and should work
> > for other schedulers.
> 
> That should work, but pretty is something else
> 
> >> 
> >> 2) What happens in the following scenario:
> >> 
> >>    unplug
> >> 
> >>      mq_offline
> >>        set_ctx_inactive()
> >>        drain_io()
> >>        
> >>    io_kthread()
> >>        try_queue()
> >>        wait_on_ctx()
> >> 
> >>    Can this happen and if so what will wake up that thread?
> >
> > drain_io() releases all tag of this hctx, then wait_on_ctx() will be waken up
> > after any tag is released.
> 
> drain_io() is already done ...
> 
> So looking at that thread function:
> 
> static int io_sq_thread(void *data)
> {
> 	struct io_ring_ctx *ctx = data;
> 
>         while (...) {
>               ....
> 	      to_submit = io_sqring_entries(ctx);
> 
> --> preemption
> 
> hotplug runs
>    mq_offline()
>       set_ctx_inactive();
>       drain_io();
>       finished();
> 
> --> thread runs again
> 
>       mutex_lock(&ctx->uring_lock);
>       ret = io_submit_sqes(ctx, to_submit, NULL, -1, true);
>       mutex_unlock(&ctx->uring_lock);
> 
>       ....
> 
>       if (!to_submit || ret == -EBUSY)
>           ...
>       	  wait_on_ctx();
> 
> Can this happen or did drain_io() already take care of the 'to_submit'
> items and the call to io_submit_sqes() turns into a zero action ?
> 
> If the above happens then nothing will wake it up because the context
> draining is done and finished.

As Jens replied, you mixed the ctx from io uring and blk-mq, both are in
two worlds.

Any wait in this percpu kthread should just wait for generic resource,
not directly related with blk-mq's inactive hctx. Once this thread is
migrated to other online cpu, it will move on.


Thanks,
Ming

