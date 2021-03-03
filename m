Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2560E32C5AB
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 02:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350237AbhCDAYC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 3 Mar 2021 19:24:02 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21111 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239520AbhCCK0h (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 3 Mar 2021 05:26:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614767110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=hNTEj3ex8wv2ADmkIQmf2LExgG6syL3c0c0xrAzVRSE=;
        b=MoIyD1DcHkoVsne2OeUC3uJhsGfnXNspvK2a9Fhay0w7ZgaEAc0S3WpUfttSwUij6lL9IN
        4LTbBGoiFpWCJDB4r0XcmvZGzw+g4wrBKxo7dQwy3Z5iFcp77rKRZ5r4iwoOQRV9Jshbc0
        XThdP++VrYqWhD5zVkWeQNtytTOqrfs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-gIIU8uXZNsWohUsuiuqsZw-1; Wed, 03 Mar 2021 05:09:24 -0500
X-MC-Unique: gIIU8uXZNsWohUsuiuqsZw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E6CFD801976;
        Wed,  3 Mar 2021 10:09:22 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A946810013DB;
        Wed,  3 Mar 2021 10:09:19 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 123A9JHU002022;
        Wed, 3 Mar 2021 05:09:19 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 123A9Jip002018;
        Wed, 3 Mar 2021 05:09:19 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Wed, 3 Mar 2021 05:09:18 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     JeffleXu <jefflexu@linux.alibaba.com>
cc:     Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
In-Reply-To: <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
Message-ID: <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210302190555.201228400@debian-a64.vm> <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
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
> 
> > Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
> > cookie.
> > 
> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> > 
> > ---
> >  drivers/md/dm.c |    5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > Index: linux-2.6/drivers/md/dm.c
> > ===================================================================
> > --- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
> > +++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
> > @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
> >  		}
> >  	}
> >  
> > +	if (ci.poll_cookie != BLK_QC_T_NONE) {
> > +		while (atomic_read(&ci.io->io_count) > 1 &&
> > +		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
> > +	}
> > +
> >  	/* drop the extra reference count */
> >  	dec_pending(ci.io, errno_to_blk_status(error));
> >  }
> 
> It seems that the general idea of your design is to
> 1) submit *one* split bio
> 2) blk_poll(), waiting the previously submitted split bio complets

No, I submit all the bios and poll for the last one.

> and then submit next split bio, repeating the above process. I'm afraid
> the performance may be an issue here, since the batch every time
> blk_poll() reaps may decrease.

Could you benchmark it?

> Besides, the submitting routine and polling routine is bound together
> here, i.e., polling is always synchronous.

__split_and_process_bio calls __split_and_process_non_flush in a loop and 
__split_and_process_non_flush records the poll cookie in ci.poll_cookie. 
When we processed all the bios, we poll for the last cookie here:

        if (ci.poll_cookie != BLK_QC_T_NONE) {
                while (atomic_read(&ci.io->io_count) > 1 &&
                       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
        }


Mikulas

