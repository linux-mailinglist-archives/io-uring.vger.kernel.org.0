Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D62A41DC9F0
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2020 11:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728871AbgEUJYA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 May 2020 05:24:00 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:43351 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728794AbgEUJYA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 May 2020 05:24:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590053039;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oXqIwCuxexwEMT6sWq3yw4kZ4MgmT2D4JiPVuLqvuPk=;
        b=AlNLna3X782FM7V8rh+845nfAK57YCBK2stKXVUPMJT9qD+IwvVnC1Jyf3Ng4w8bhaucrU
        VQ91VjiAwiSQ7rAgB1kwLrnPTpbcMRmzcWQ+94AMSBr9rMcltzIvLOdDl/jabh/BZzY+Ot
        tnL4ptt+smlwjoLnEQN2pX6nrNY49KM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-417-p2H3ENIzNh-rGh7Us0gPdA-1; Thu, 21 May 2020 05:23:55 -0400
X-MC-Unique: p2H3ENIzNh-rGh7Us0gPdA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 04B4D107BEF5;
        Thu, 21 May 2020 09:23:53 +0000 (UTC)
Received: from T590 (ovpn-13-123.pek2.redhat.com [10.72.13.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 191865EE0E;
        Thu, 21 May 2020 09:23:44 +0000 (UTC)
Date:   Thu, 21 May 2020 17:23:40 +0800
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
Message-ID: <20200521092340.GA751297@T590>
References: <20200520011823.GA415158@T590>
 <20200520030424.GI416136@T590>
 <20200520080357.GA4197@lst.de>
 <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk>
 <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
 <87tv0av1gu.fsf@nanos.tec.linutronix.de>
 <2a12a7aa-c339-1e51-de0d-9bc6ced14c64@kernel.dk>
 <87eereuudh.fsf@nanos.tec.linutronix.de>
 <20200521022746.GA730422@T590>
 <87367tvh6g.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87367tvh6g.fsf@nanos.tec.linutronix.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Thomas,

On Thu, May 21, 2020 at 10:13:59AM +0200, Thomas Gleixner wrote:
> Ming Lei <ming.lei@redhat.com> writes:
> > On Thu, May 21, 2020 at 12:14:18AM +0200, Thomas Gleixner wrote:
> >> When the CPU is finally offlined, i.e. the CPU cleared the online bit in
> >> the online mask is definitely too late simply because it still runs on
> >> that outgoing CPU _after_ the hardware queue is shut down and drained.
> >
> > IMO, the patch in Christoph's blk-mq-hotplug.2 still works for percpu
> > kthread.
> >
> > It is just not optimal in the retrying, but it should be fine. When the
> > percpu kthread is scheduled on the CPU to be offlined:
> >
> > - if the kthread doesn't observe the INACTIVE flag, the allocated request
> > will be drained.
> >
> > - otherwise, the kthread just retries and retries to allocate & release,
> > and sooner or later, its time slice is consumed, and migrated out, and the
> > cpu hotplug handler will get chance to run and move on, then the cpu is
> > shutdown.
> 
> 1) This is based on the assumption that the kthread is in the SCHED_OTHER
>    scheduling class. Is that really a valid assumption?

Given it is unlikely path, we can add msleep() before retrying when INACTIVE bit
is observed by current thread, and this way can avoid spinning and should work
for other schedulers.

> 
> 2) What happens in the following scenario:
> 
>    unplug
> 
>      mq_offline
>        set_ctx_inactive()
>        drain_io()
>        
>    io_kthread()
>        try_queue()
>        wait_on_ctx()
> 
>    Can this happen and if so what will wake up that thread?

drain_io() releases all tag of this hctx, then wait_on_ctx() will be waken up
after any tag is released.

If wait_on_ctx() waits for other generic resource, it will be waken up
after this resource is available.

thanks,
Ming

