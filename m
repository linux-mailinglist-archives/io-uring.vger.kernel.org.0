Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 907F11DC52C
	for <lists+io-uring@lfdr.de>; Thu, 21 May 2020 04:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726943AbgEUC2G (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 May 2020 22:28:06 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20390 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726833AbgEUC2G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 May 2020 22:28:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590028084;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=HiJAaDRSg5DnM9NEbapqZa54OkdMt62Nfi59/wxsSTk=;
        b=hwpQzUazhe24rfDk9LqbVJ1q5DQqcyKOgp080qZhlLv4wNSagQG7go5xh8ipDiqqhoUSqy
        4tf7LiuaRcCJ+qLuQQtyECtQ4CM6hZd6UGu6JwSSm7EqFeaAXVWT0nN4nrfgy//y50YV5c
        fvTtwg+bSyx4nmiwMipmjpi/uZRxj+o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-114-FDsArPCQMPSgD6E4nTNMkg-1; Wed, 20 May 2020 22:28:00 -0400
X-MC-Unique: FDsArPCQMPSgD6E4nTNMkg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D12F800688;
        Thu, 21 May 2020 02:27:59 +0000 (UTC)
Received: from T590 (ovpn-13-123.pek2.redhat.com [10.72.13.123])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 5350382A24;
        Thu, 21 May 2020 02:27:50 +0000 (UTC)
Date:   Thu, 21 May 2020 10:27:46 +0800
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
Message-ID: <20200521022746.GA730422@T590>
References: <20200519015420.GA70957@T590>
 <20200519153000.GB22286@lst.de>
 <20200520011823.GA415158@T590>
 <20200520030424.GI416136@T590>
 <20200520080357.GA4197@lst.de>
 <8f893bb8-66a9-d311-ebd8-d5ccd8302a0d@kernel.dk>
 <448d3660-0d83-889b-001f-a09ea53fa117@kernel.dk>
 <87tv0av1gu.fsf@nanos.tec.linutronix.de>
 <2a12a7aa-c339-1e51-de0d-9bc6ced14c64@kernel.dk>
 <87eereuudh.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87eereuudh.fsf@nanos.tec.linutronix.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, May 21, 2020 at 12:14:18AM +0200, Thomas Gleixner wrote:
> Jens Axboe <axboe@kernel.dk> writes:
> 
> > On 5/20/20 1:41 PM, Thomas Gleixner wrote:
> >> Jens Axboe <axboe@kernel.dk> writes:
> >>> On 5/20/20 8:45 AM, Jens Axboe wrote:
> >>>> It just uses kthread_create_on_cpu(), nothing home grown. Pretty sure
> >>>> they just break affinity if that CPU goes offline.
> >>>
> >>> Just checked, and it works fine for me. If I create an SQPOLL ring with
> >>> SQ_AFF set and bound to CPU 3, if CPU 3 goes offline, then the kthread
> >>> just appears unbound but runs just fine. When CPU 3 comes online again,
> >>> the mask appears correct.
> >> 
> >> When exactly during the unplug operation is it unbound?
> >
> > When the CPU has been fully offlined. I check the affinity mask, it
> > reports 0. But it's still being scheduled, and it's processing work.
> > Here's an example, PID 420 is the thread in question:
> >
> > [root@archlinux cpu3]# taskset -p 420
> > pid 420's current affinity mask: 8
> > [root@archlinux cpu3]# echo 0 > online 
> > [root@archlinux cpu3]# taskset -p 420
> > pid 420's current affinity mask: 0
> > [root@archlinux cpu3]# echo 1 > online 
> > [root@archlinux cpu3]# taskset -p 420
> > pid 420's current affinity mask: 8
> >
> > So as far as I can tell, it's working fine for me with the goals
> > I have for that kthread.
> 
> Works for me is not really useful information and does not answer my
> question:
> 
> >> When exactly during the unplug operation is it unbound?
> 
> The problem Ming and Christoph are trying to solve requires that the
> thread is migrated _before_ the hardware queue is shut down and
> drained. That's why I asked for the exact point where this happens.
> 
> When the CPU is finally offlined, i.e. the CPU cleared the online bit in
> the online mask is definitely too late simply because it still runs on
> that outgoing CPU _after_ the hardware queue is shut down and drained.

IMO, the patch in Christoph's blk-mq-hotplug.2 still works for percpu
kthread.

It is just not optimal in the retrying, but it should be fine. When the
percpu kthread is scheduled on the CPU to be offlined:

- if the kthread doesn't observe the INACTIVE flag, the allocated request
will be drained.

- otherwise, the kthread just retries and retries to allocate & release,
and sooner or later, its time slice is consumed, and migrated out, and the
cpu hotplug handler will get chance to run and move on, then the cpu is
shutdown.

- After the cpu is shutdown, the percpu kthread becomes unbound, and
the allocation from new online cpu will succeed.

Thanks,
Ming

