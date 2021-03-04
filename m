Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 975EA32D5D4
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 16:03:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232931AbhCDPCo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 10:02:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:44398 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232976AbhCDPCe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 10:02:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614870068;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ejUN3tvqkFllhrARw3o33HWriTSZkp02yrNAR9+FPd0=;
        b=NwtiX86I7R5ItTqTzw+k47+Mr8comhnvYKAWmGL1LltJIFkwy6K+dlFFPW3GuW9wTj162G
        7PhSdliPEKO0OMCyuHUiAincdkEBHOqqLcR1NxrEq0kctcdyuqBdq7v0n96Vk2EjkQUerV
        TOPof1T0SY+Y+vGoqVBeo2Dr0r+dVdw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-181-VzNcRQMZNeS97iJomllj_Q-1; Thu, 04 Mar 2021 10:01:04 -0500
X-MC-Unique: VzNcRQMZNeS97iJomllj_Q-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id DBDA21019624;
        Thu,  4 Mar 2021 15:01:02 +0000 (UTC)
Received: from segfault.boston.devel.redhat.com (segfault.boston.devel.redhat.com [10.19.60.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 60BBB5D705;
        Thu,  4 Mar 2021 15:00:58 +0000 (UTC)
From:   Jeff Moyer <jmoyer@redhat.com>
To:     Mikulas Patocka <mpatocka@redhat.com>
Cc:     JeffleXu <jefflexu@linux.alibaba.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
References: <20210302190555.201228400@debian-a64.vm>
        <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com>
        <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
Date:   Thu, 04 Mar 2021 10:01:38 -0500
In-Reply-To: <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com>
        (Mikulas Patocka's message of "Wed, 3 Mar 2021 05:09:18 -0500 (EST)")
Message-ID: <x49o8fzklnx.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi, Mikulas,

Mikulas Patocka <mpatocka@redhat.com> writes:

> On Wed, 3 Mar 2021, JeffleXu wrote:
>
>> 
>> 
>> On 3/3/21 3:05 AM, Mikulas Patocka wrote:
>> 
>> > Support I/O polling if submit_bio_noacct_mq_direct returned non-empty
>> > cookie.
>> > 
>> > Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>> > 
>> > ---
>> >  drivers/md/dm.c |    5 +++++
>> >  1 file changed, 5 insertions(+)
>> > 
>> > Index: linux-2.6/drivers/md/dm.c
>> > ===================================================================
>> > --- linux-2.6.orig/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
>> > +++ linux-2.6/drivers/md/dm.c	2021-03-02 19:26:34.000000000 +0100
>> > @@ -1682,6 +1682,11 @@ static void __split_and_process_bio(stru
>> >  		}
>> >  	}
>> >  
>> > +	if (ci.poll_cookie != BLK_QC_T_NONE) {
>> > +		while (atomic_read(&ci.io->io_count) > 1 &&
>> > +		       blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
>> > +	}
>> > +
>> >  	/* drop the extra reference count */
>> >  	dec_pending(ci.io, errno_to_blk_status(error));
>> >  }
>> 
>> It seems that the general idea of your design is to
>> 1) submit *one* split bio
>> 2) blk_poll(), waiting the previously submitted split bio complets
>
> No, I submit all the bios and poll for the last one.

What happens if the last bio completes first?  It looks like you will
call blk_poll with a cookie that already completed, and I'm pretty sure
that's invalid.

Thanks,
Jeff

