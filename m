Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB78632D63D
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 16:16:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbhCDPNZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 10:13:25 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:56110 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232259AbhCDPNR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 10:13:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614870711;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3TYaCt+56CSLmJuxUkX3Yt9N0VOzmswmJsOmJdaECmc=;
        b=fnnAHbCaCDQygpmrTwMLV1h/dY5TnsLxUEJCEQtowf4sCNFci5F63dGkXfqsqhVz3MeGVP
        1B5tGrS85rhThVDBjz5a5clfEpwgARMpaqYkUTzY9xBo3I5+l55L1ZtRubovvh1xnJeJzd
        cJK/c5kaRY/DYH/KtuBo9Fbg/iI+/Zg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-W86Ima2NObSwuHs8S6E2Gg-1; Thu, 04 Mar 2021 10:11:47 -0500
X-MC-Unique: W86Ima2NObSwuHs8S6E2Gg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4506664AE9;
        Thu,  4 Mar 2021 15:11:46 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 81FAA19809;
        Thu,  4 Mar 2021 15:11:42 +0000 (UTC)
Date:   Thu, 4 Mar 2021 10:11:41 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     Jeff Moyer <jmoyer@redhat.com>
Cc:     Mikulas Patocka <mpatocka@redhat.com>,
        JeffleXu <jefflexu@linux.alibaba.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de,
        Jonathan Brassow <jbrassow@redhat.com>
Subject: Re: [PATCH 4/4] dm: support I/O polling
Message-ID: <20210304151141.GB14551@redhat.com>
References: <20210302190555.201228400@debian-a64.vm>
 <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
 <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
 <x49o8fzklnx.fsf@segfault.boston.devel.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <x49o8fzklnx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Mar 04 2021 at 10:01am -0500,
Jeff Moyer <jmoyer@redhat.com> wrote:

> Hi, Mikulas,
> 
> Mikulas Patocka <mpatocka@redhat.com> writes:
> 
> > On Wed, 3 Mar 2021, JeffleXu wrote:
> >
> >> 
> >> 
> >> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
> >> 
> >> > Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
> >> > cookie.
> >> > 
> >> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
> >> > 
> >> > ---
> >> >  drivers/md/dm.c |    5 +++++
> >> >  1 file changed, 5 insertions(+)
> >> > 
> >> > Index: linux-2.6/drivers/md/dm.c
> >> > ===================================================================
> >> > --- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
> >> > +++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
> >> > @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
> >> >  		}
> >> >  	}
> >> >  
> >> > +	if (ci.poll_cookie != BLK_QC_T_NONE) {
> >> > +		while (atomic_read(&ci.io->io_count) > 1 &&
> >> > +		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
> >> > +	}
> >> > +
> >> >  	/* drop the extra reference count */
> >> >  	dec_pending(ci.io, errno_to_blk_status(error));
> >> >  }
> >> 
> >> It seems that the general idea of your design is to
> >> 1) submit *one* split bio
> >> 2) blk_poll(), waiting the previously submitted split bio complets
> >
> > No, I submit all the bios and poll for the last one.
> 
> What happens if the last bio completes first?  It looks like you will
> call blk_poll with a cookie that already completed, and I'm pretty sure
> that's invalid.

In addition, I'm concerned this approach to have DM internalize IO
polling is a non-starter.

I just don't think this approach adheres to the io_uring + IO polling
interface.. it never returns a cookie to upper layers... so there is
really no opportunity for standard io_uring + IO polling interface to
work is there?

But Heinz and Mikulas are about to kick off some fio io_uring + hipri=1
(io polling) testing of Jeffle's latest v5 patchset:
https://patchwork.kernel.org/project/dm-devel/list/?series=442075

compared to Mikulas' patchset:
https://patchwork.kernel.org/project/dm-devel/list/?series=440719

We should have definitive answers soon enough, just using Jeffle's fio
config (with hipri=1 for IO polling) that was documented here:
https://listman.redhat.com/archives/dm-devel/2020-October/msg00129.html

Mike

