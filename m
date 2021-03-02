Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5231D32B54B
	for <lists+io-uring@lfdr.de>; Wed,  3 Mar 2021 07:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245695AbhCCGm7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 01:42:59 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:47880 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1835403AbhCBTFz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 2 Mar 2021 14:05:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614711863;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WQxbA1PhZkKy7mqy3MPmoeD7hbqef+YoioB+uiK7JR0=;
        b=dYGR17GK97hhZ3TuyIaB6/BywEvvuaMxKGyZ8sjaSJmhHhqlNqQuSdC/QoONNhUGRURff2
        n3SAwvk+B7BVr0duUHQ/ze7sbPPNA0LDsykEEllPGNHywMtsw96VQHISxNKoidqIOZLdIH
        +vkopwRWiXRk+zyXzq9UJbprwMl3+PU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-304-yxb4KF5XNoug1SZwn2NZoA-1; Tue, 02 Mar 2021 14:04:08 -0500
X-MC-Unique: yxb4KF5XNoug1SZwn2NZoA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0CB6B814318;
        Tue,  2 Mar 2021 19:04:07 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A5C9B62465;
        Tue,  2 Mar 2021 19:03:56 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 122J3uSc011834;
        Tue, 2 Mar 2021 14:03:56 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 122J3sh4011830;
        Tue, 2 Mar 2021 14:03:55 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Tue, 2 Mar 2021 14:03:54 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     JeffleXu <jefflexu@linux.alibaba.com>
cc:     axboe@kernel.dk, snitzer@redhat.com, caspar@linux.alibaba.com,
        io-uring@vger.kernel.org, linux-block@vger.kernel.org,
        joseph.qi@linux.alibaba.com, dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH v3 11/11] dm: fastpath of bio-based polling
In-Reply-To: <af9223b9-8960-1ed4-799a-bcd56299c587@linux.alibaba.com>
Message-ID: <alpine.LRH.2.02.2103021353490.9353@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210208085243.82367-1-jefflexu@linux.alibaba.com> <20210208085243.82367-12-jefflexu@linux.alibaba.com> <alpine.LRH.2.02.2102191351200.10545@file01.intranet.prod.int.rdu2.redhat.com> <af9223b9-8960-1ed4-799a-bcd56299c587@linux.alibaba.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Fri, 26 Feb 2021, JeffleXu wrote:

> 
> 
> On 2/20/21 3:38 AM, Mikulas Patocka wrote:
> > 
> > 
> > On Mon, 8 Feb 2021, Jeffle Xu wrote:
> > 
> >> Offer one fastpath of bio-based polling when bio submitted to dm device
> >> is not split.
> >>
> >> In this case, there will be only one bio submitted to only one polling
> >> hw queue of one underlying mq device, and thus we don't need to track
> >> all split bios or iterate through all polling hw queues. The pointer to
> >> the polling hw queue the bio submitted to is returned here as the
> >> returned cookie.
> > 
> > This doesn't seem safe - note that between submit_bio() and blk_poll(), no 
> > locks are held - so the device mapper device may be reconfigured 
> > arbitrarily. When you call blk_poll() with a pointer returned by 
> > submit_bio(), the pointer may point to a stale address.
> > 
> 
> Thanks for the feedback. Indeed maybe it's not a good idea to directly
> return a 'struct blk_mq_hw_ctx *' pointer as the returned cookie.
> 
> Currently I have no idea to fix it, orz... The
> blk_get_queue()/blk_put_queue() tricks may not work in this case.
> Because the returned cookie may not be used at all. Before calling
> blk_poll(), the polling routine may find that the corresponding IO has
> already completed, and thus won't call blk_poll(), in which case we have
> no place to put the refcount.
> 
> But I really don't want to drop this optimization, since this
> optimization is quite intuitive when dm device maps to a lot of
> underlying devices. Though this optimization doesn't actually achieve
> reasonable performance gain in my test, maybe because there are at most
> seven nvme devices in my test machine.
> 
> Any thoughts?
> 
> Thanks,
> Jeffle

Hi

I reworked device mapper polling, so that we poll in the function 
__split_and_process_bio. The pointer to a queue and the polling cookie is 
passed only inside device mapper code, it never leaves it.

I'll send you my patches - try them and tell me how does it perform 
compared to your patchset.

Mikulas

