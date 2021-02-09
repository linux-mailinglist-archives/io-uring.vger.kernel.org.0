Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42031314A00
	for <lists+io-uring@lfdr.de>; Tue,  9 Feb 2021 09:10:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhBIIJn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 9 Feb 2021 03:09:43 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229637AbhBIIJ3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 9 Feb 2021 03:09:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612858081;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IYR2IB+oPrGXBiiDGk1HRlMpOZPu3IKUy/SEjPBieFE=;
        b=LVqN18gOIKiQsgTvYlj9t1R+T9XXX1O48oyHEWl5IX+Zr+GpNcRSOoDCXZuv0aCt6etXkD
        BP28eX0lsz6VZc0hEWY3/csKqF9ZkdVlsuuaABfv0Zwk6BkBB+DgraQmyZ6sSVhyclVunw
        QM9TSS0fsSLuk/eNzuGPNGratazMBX0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-563-nfpIHJDHM_yf6KeL1QbdCQ-1; Tue, 09 Feb 2021 03:07:59 -0500
X-MC-Unique: nfpIHJDHM_yf6KeL1QbdCQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1A9BC804043;
        Tue,  9 Feb 2021 08:07:58 +0000 (UTC)
Received: from T590 (ovpn-12-18.pek2.redhat.com [10.72.12.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1D9CF5D9DC;
        Tue,  9 Feb 2021 08:07:43 +0000 (UTC)
Date:   Tue, 9 Feb 2021 16:07:39 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     snitzer@redhat.com, axboe@kernel.dk, joseph.qi@linux.alibaba.com,
        caspar@linux.alibaba.com, hch@lst.de, linux-block@vger.kernel.org,
        dm-devel@redhat.com, io-uring@vger.kernel.org
Subject: Re: [PATCH v3 09/11] dm: support IO polling for bio-based dm device
Message-ID: <20210209080739.GB94287@T590>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com>
 <20210208085243.82367-10-jefflexu@linux.alibaba.com>
 <20210209031122.GA63798@T590>
 <a499a33f-da2e-b5aa-5266-9e7c76a34b48@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a499a33f-da2e-b5aa-5266-9e7c76a34b48@linux.alibaba.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Feb 09, 2021 at 02:13:38PM +0800, JeffleXu wrote:
> 
> 
> On 2/9/21 11:11 AM, Ming Lei wrote:
> > On Mon, Feb 08, 2021 at 04:52:41PM +0800, Jeffle Xu wrote:
> >> DM will iterate and poll all polling hardware queues of all target mq
> >> devices when polling IO for dm device. To mitigate the race introduced
> >> by iterating all target hw queues, a per-hw-queue flag is maintained
> > 
> > What is the per-hw-queue flag?
> 
> Sorry I forgot to update the commit message as the implementation
> changed. Actually this mechanism is implemented by patch 10 of this
> patch set.

It is hard to associate patch 10's spin_trylock() with per-hw-queue
flag. Also scsi's poll implementation is in-progress, and scsi's poll may
not be implemented in this way.

> 
> > 
> >> to indicate whether this polling hw queue currently being polled on or
> >> not. Every polling hw queue is exclusive to one polling instance, i.e.,
> >> the polling instance will skip this polling hw queue if this hw queue
> >> currently is being polled by another polling instance, and start
> >> polling on the next hw queue.
> > 
> > Not see such skip in dm_poll_one_dev() in which
> > queue_for_each_poll_hw_ctx() is called directly for polling all POLL
> > hctxs of the request queue, so can you explain it a bit more about this
> > skip mechanism?
> > 
> 
> It is implemented as patch 10 of this patch set. When spin_trylock()
> fails, the polling instance will return immediately, instead of busy
> waiting.
> 
> 
> > Even though such skipping is implemented, not sure if good performance
> > can be reached because hctx poll may be done in ping-pong style
> > among several CPUs. But blk-mq hctx is supposed to have its cpu affinities.
> > 
> 
> Yes, the mechanism of iterating all hw queues can make the competition
> worse.
> 
> If every underlying data device has **only** one polling hw queue, then
> this ping-pong style polling still exist, even when we implement split
> bio tracking mechanism, i.e., acquiring the specific hw queue the bio
> enqueued into. Because multiple polling instance has to compete for the
> only polling hw queue.
> 
> But if multiple polling hw queues per device are reserved for multiple
> polling instances, (e.g., every underlying data device has 3 polling hw
> queues when there are 3 polling instances), just as what we practice on
> mq polling, then the current implementation of iterating all hw queues
> will indeed works in a ping-pong style, while this issue shall not exist
> when accurate split bio tracking mechanism could be implemented.

In reality it could be possible to have one hw queue for each numa node.

And you may re-use blk_mq_map_queue() for getting the proper hw queue for poll.


-- 
Ming

