Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C432F32C5AC
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233485AbhCDAYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:30603 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1842917AbhCCKWe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 05:22:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614766867;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WEHgjz6/FP1rmehlGd9kgHsqB+jD47VZkOkNcRGSeHE=;
        b=LupNyjk4rRSQ6zfvanOOlzU26DdoUbuO/b3CKcudvBJQO/BrFg7FfpE1P17QZU+wi4ZXyj
        Oz7iy9WmCrIpLRIblONsMImmQBBTqU/ifGG2KO+MEmhpb0GyCoHK9b5ERydHOFciGjlF6c
        z+tAwOMK2o7naU60hXZrWOz/6WzYPFk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-99-M7QVroaiPRm4jGliw5o2IQ-1; Wed, 03 Mar 2021 05:05:37 -0500
X-MC-Unique: M7QVroaiPRm4jGliw5o2IQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4D108100A8EA;
        Wed,  3 Mar 2021 10:05:36 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 84D3410013C1;
        Wed,  3 Mar 2021 10:05:32 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 123A5VJq001824;
        Wed, 3 Mar 2021 05:05:31 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 123A5Uda001816;
        Wed, 3 Mar 2021 05:05:31 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 3 Mar 2021 05:05:30 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     JeffleXu <jefflexu@linux.alibaba.com>
cc:     Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH 2/4] block: dont clear REQ_HIPRI for bio-based
 drivers
In-Reply-To: <3e8b3b2e-f1f4-e946-4858-d2c78e2a8825@linux.alibaba.com>
Message-ID: <alpine.LRH.2.02.2103030430080.29593@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210302190552.715551440@debian-a64.vm> <3e8b3b2e-f1f4-e946-4858-d2c78e2a8825@linux.alibaba.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Wed, 3 Mar 2021, JeffleXu wrote:

> 
> 
> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
> > Don't clear REQ_HIPRI for bio-based drivers. Device mapper will need to
> > see this flag in order to support polling.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  block/blk-core.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > Index: linux-2.6/block/blk-core.c
> > ===================================================================
> > --- linux-2.6.orig/block/blk-core.c	2021-03-02 10:43:28.000000000 +0100
> > +++ linux-2.6/block/blk-core.c	2021-03-02 10:53:50.000000000 +0100
> 
> I notice that the diff header indicates that the code base is from
> linux-2.6. Or it's just the name of your directory, while the code base
> is for the latest upstream 5.12?

It's just the name of the git repository. The patch is against 5.12-rc1.

> 
> > @@ -836,7 +836,7 @@ static noinline_for_stack bool submit_bi
> >  		}
> >  	}
> >  
> > -	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags))
> > +	if (!test_bit(QUEUE_FLAG_POLL, &q->queue_flags) && !bdev->bd_disk->fops->submit_bio)
> >  		bio->bi_opf &= ~REQ_HIPRI;
> >  
> >  	switch (bio_op(bio)) {
> > 
> > --
> 
> What if dm device is built upon mq devices that are not capable of
> polling, i.e., mq devices without QUEUE_FLAG_POLL set? Then this dm
> device shall not support polling.

We will check if the underlying queue has QUEUE_FLAG_POLL in __map_bio - 
see this piece of code:

        case DM_MAPIO_REMAPPED:
                /* the bio has been remapped so dispatch it */
                trace_block_bio_remap(clone, bio_dev(io->orig_bio), sector);
                if (clone->bi_opf & REQ_HIPRI &&
                    test_bit(QUEUE_FLAG_POLL, &clone->bi_bdev->bd_disk->queue->queue_flags)) {
                        ci->poll_queue = clone->bi_bdev->bd_disk->queue;
                        ci->poll_cookie = submit_bio_noacct_mq_direct(clone);
                } else {
                        ci->poll_cookie = BLK_QC_T_NONE;
                        submit_bio_noacct(clone);
                }
                break;

Mikulas

