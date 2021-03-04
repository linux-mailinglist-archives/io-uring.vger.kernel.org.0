Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E8DA632D06F
	for <lists+io-uring@lfdr.de>; Thu,  4 Mar 2021 11:11:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbhCDKLL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 05:11:11 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20709 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233357AbhCDKLA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 05:11:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614852575;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gEq80ZVZMwjKodIE6ojiKHKFbahisMaPtzK8j1T5l58=;
        b=AUe0w1sOD5CPZk8qtMHUrECy5TVTlJ0zIZiondKw+wogxt1KpduE8NH9J+Al230a9/pnqd
        UrTIAqmO0sYzeMP4iCfNXuf8ZJno5kF+QbDV79H7PhvW3gRozaPB9JdX+eAXT4N7HadnQh
        8af+CUGs8TRFC+cZTEWqaJ81a/rov5A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-515-TTouH1leOkqqT0-g4BvVzw-1; Thu, 04 Mar 2021 05:09:31 -0500
X-MC-Unique: TTouH1leOkqqT0-g4BvVzw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F2EA71005D4A;
        Thu,  4 Mar 2021 10:09:29 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (file01.intranet.prod.int.rdu2.redhat.com [10.11.5.7])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 47364100E114;
        Thu,  4 Mar 2021 10:09:26 +0000 (UTC)
Received: from file01.intranet.prod.int.rdu2.redhat.com (localhost [127.0.0.1])
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4) with ESMTP id 124A9PQ9007649;
        Thu, 4 Mar 2021 05:09:25 -0500
Received: from localhost (mpatocka@localhost)
        by file01.intranet.prod.int.rdu2.redhat.com (8.14.4/8.14.4/Submit) with ESMTP id 124A9Oo8007645;
        Thu, 4 Mar 2021 05:09:25 -0500
X-Authentication-Warning: file01.intranet.prod.int.rdu2.redhat.com: mpatocka owned process doing -bs
Date:   Thu, 4 Mar 2021 05:09:24 -0500 (EST)
From:   Mikulas Patocka <mpatocka@redhat.com>
X-X-Sender: mpatocka@file01.intranet.prod.int.rdu2.redhat.com
To:     JeffleXu <jefflexu@linux.alibaba.com>
cc:     Mike Snitzer <msnitzer@redhat.com>,
        Heinz Mauelshagen <heinzm@redhat.com>, axboe@kernel.dk,
        caspar@linux.alibaba.com, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, hch@lst.de
Subject: Re: [dm-devel] [PATCH 4/4] dm: support I/O polling
In-Reply-To: <f9dd41f1-7a4c-5901-c099-dca08c4e6d65@linux.alibaba.com>
Message-ID: <alpine.LRH.2.02.2103040507040.7400@file01.intranet.prod.int.rdu2.redhat.com>
References: <20210302190555.201228400@debian-a64.vm> <33fa121a-88a8-5c27-0a43-a7efc9b5b3e3@linux.alibaba.com> <alpine.LRH.2.02.2103030505460.29593@file01.intranet.prod.int.rdu2.redhat.com> <f9dd41f1-7a4c-5901-c099-dca08c4e6d65@linux.alibaba.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Thu, 4 Mar 2021, JeffleXu wrote:

> > __split_and_process_non_flush records the poll cookie in ci.poll_cookie. 
> > When we processed all the bios, we poll for the last cookie here:
> > 
> >         if (ci.poll_cookie != BLK_QC_T_NONE) {
> >                 while (atomic_read(&ci.io->io_count) > 1 &&
> >                        blk_poll(ci.poll_queue, ci.poll_cookie, true)) ;
> >         }
> 
> So what will happen if one bio submitted to dm device crosses the device
> boundary among several target devices (e.g., dm-stripe)? Please refer
> the following call graph.
> 
> ```
> submit_bio
>   __submit_bio_noacct
>     disk->fops->submit_bio(), calling into __split_and_process_bio(),
> call __split_and_process_non_flush() once, submitting the *first* split bio
>     disk->fops->submit_bio(), calling into __split_and_process_bio(),
> call __split_and_process_non_flush() once, submitting the *second* split bio
>     ...
> ```
> 
> 
> So the loop is in __submit_bio_noacct(), rather than
> __split_and_process_bio(). Your design will send the first split bio,
> and then poll on this split bio, then send the next split bio, polling
> on this, go on and on...

No. It will send all the bios and poll for the last one.

Mikulas

