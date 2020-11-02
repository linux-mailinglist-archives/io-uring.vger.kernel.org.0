Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E5FCA2A2FCC
	for <lists+io-uring@lfdr.de>; Mon,  2 Nov 2020 17:28:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726868AbgKBQ24 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Nov 2020 11:28:56 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:53916 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726795AbgKBQ24 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Nov 2020 11:28:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604334535;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ZPIZCN+l/z1LBcTIqXH+625Dr2hdY3RdIvanAI2iRP8=;
        b=VGMV8ZPwbvLZySmMxXbdAo5UJb0ojXDVA0pk3flNsIOXn0ujwODsaLlZIbx4JdKb3NGIAS
        9aeWI4HgwWLlo32WS/jw+fUUlt18qQPgFtpcSWJQ2K/gqrRo4QLgL2NVOGKebXKmMID35D
        +TQSmx3EEPxiXIibo1eTN1DNe4MJEIo=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-16-8pqwr9pZPbKG7B4yFYPvVw-1; Mon, 02 Nov 2020 11:28:53 -0500
X-MC-Unique: 8pqwr9pZPbKG7B4yFYPvVw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6D182FD0D;
        Mon,  2 Nov 2020 16:28:51 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8A8AA55766;
        Mon,  2 Nov 2020 16:28:48 +0000 (UTC)
Date:   Mon, 2 Nov 2020 10:28:23 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, linux-block@vger.kernel.org, dm-devel@redhat.com,
        joseph.qi@linux.alibaba.com, xiaoguang.wang@linux.alibaba.com,
        haoxu@linux.alibaba.com, io-uring@vger.kernel.org
Subject: Re: [RFC 0/3] Add support of iopoll for dm device
Message-ID: <20201102152822.GA20466@redhat.com>
References: <20201020065420.124885-1-jefflexu@linux.alibaba.com>
 <20201021203906.GA10896@redhat.com>
 <da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
 <20201026185334.GA8463@redhat.com>
 <33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sun, Nov 01 2020 at 10:14pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> On 10/27/20 2:53 AM, Mike Snitzer wrote:
> >What you detailed there isn't properly modeling what it needs to.
> >A given dm_target_io could result in quite a few bios (e.g. for
> >dm-striped we clone each bio for each of N stripes).  So the fan-out,
> >especially if then stacked on N layers of stacked devices, to all the
> >various hctx at the lowest layers is like herding cats.
> >
> >But the recursion in block core's submit_bio path makes that challenging
> >to say the least.  So much so that any solution related to enabling
> >proper bio-based IO polling is going to need a pretty significant
> >investment in fixing block core (storing __submit_bio()'s cookie during
> >recursion, possibly storing to driver provided memory location,
> >e.g. DM initialized bio->submit_cookie pointer to a blk_qc_t within a DM
> >clone bio's per-bio-data).
> >
> >SO __submit_bio_noacct would become:
> >
> >    retp = &ret;
> >    if (bio->submit_cookie)
> >           retp = bio->submit_cookie;
> >    *retp = __submit_bio(bio);
> 
> Sorry for the late reply. Exactly I missed this point before. IF you
> have not started working on this, I'd like to try to implement this as
> an RFC.

I did start on this line of development but it needs quite a bit more
work.  Even the pseudo code I provided above isn't useful in the context
of DM clone bios that have their own per-bio-data to assist with this
implementation.  Because the __submit_bio_noacct() recursive call
drivers/md/dm.c:__split_and_process_bio() makes is supplying the
original bio (modified to only point to remaining work).

But sure, I'm not opposed to you carrying this line of work forward.  I
can always lend a hand if you need help later or if you need to hand it
off to me.

> >I think you probably just got caught out by the recursive nature of the bio
> >submission path -- makes creating a graph of submitted bios and their
> >associated per-bio-data and generated cookies a mess to track (again,
> >like herding cats).
> >
> >Could also be you didn't quite understand the DM code's various
> >structures.
> >
> >In any case, the block core changes needed to make bio-based IO polling
> >work is the main limiting factor right now.
>
> Yes the logic is kind of subtle and maybe what I'm concerned here is
> really should be concerned at the coding phase.

Definitely, lots of little details and associations.

Mike

