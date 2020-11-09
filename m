Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A922D2AC36F
	for <lists+io-uring@lfdr.de>; Mon,  9 Nov 2020 19:15:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729336AbgKISPo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Nov 2020 13:15:44 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:25946 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729119AbgKISPo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Nov 2020 13:15:44 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604945743;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PmOXsFY7PPboBbH/YirsDQDsybj2DbsHq557r+8r2gU=;
        b=FtcsVr68bZhdmbUH3xQ9IF1ty0uyLUv8uHRRMy2txS/+KOTHZIc61Bx8j3S0vRD6BoOIwy
        Qbziujtdbok1QNkMdbmgAC7Nxq8PmIeE0HoS0/qrmQ8QnzKc6uFuvgsPP1m9Oujs2qN9W+
        24O01obOqa5mRKMav2jsD7ptrqQ/7ek=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-318-EfkJDmYXOOewkjA8waxW6g-1; Mon, 09 Nov 2020 13:15:37 -0500
X-MC-Unique: EfkJDmYXOOewkjA8waxW6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8162C80477A;
        Mon,  9 Nov 2020 18:15:36 +0000 (UTC)
Received: from localhost (unknown [10.18.25.174])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 750467513A;
        Mon,  9 Nov 2020 18:15:29 +0000 (UTC)
Date:   Mon, 9 Nov 2020 13:15:28 -0500
From:   Mike Snitzer <snitzer@redhat.com>
To:     JeffleXu <jefflexu@linux.alibaba.com>
Cc:     axboe@kernel.dk, xiaoguang.wang@linux.alibaba.com,
        linux-block@vger.kernel.org, joseph.qi@linux.alibaba.com,
        dm-devel@redhat.com, haoxu@linux.alibaba.com,
        io-uring@vger.kernel.org
Subject: Re: [RFC 0/3] Add support of iopoll for dm device
Message-ID: <20201109181528.GA8599@redhat.com>
References: <20201021203906.GA10896@redhat.com>
 <da936cfa-93a8-d6ec-bd88-c0fad6c67c8b@linux.alibaba.com>
 <20201026185334.GA8463@redhat.com>
 <33c32cd1-5116-9a42-7fe2-b2a383f1c7a0@linux.alibaba.com>
 <20201102152822.GA20466@redhat.com>
 <f165f38a-91d1-79aa-829d-a9cc69a5eee6@linux.alibaba.com>
 <20201104150847.GB32761@redhat.com>
 <2c5dab21-8125-fcdf-078e-00a158c57f43@linux.alibaba.com>
 <20201106174526.GA13292@redhat.com>
 <23c73ad7-23e3-3172-8f0e-3c15e0fa5a87@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <23c73ad7-23e3-3172-8f0e-3c15e0fa5a87@linux.alibaba.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Sat, Nov 07 2020 at  8:09pm -0500,
JeffleXu <jefflexu@linux.alibaba.com> wrote:

> 
> On 11/7/20 1:45 AM, Mike Snitzer wrote:
> >On Thu, Nov 05 2020 at  9:51pm -0500,
> >JeffleXu <jefflexu@linux.alibaba.com> wrote:
> >
> >>blk-mq.c: blk_mq_submit_bio
> >>
> >>     if (bio->orig)
> >>
> >>         init blk_poll_data and insert it into bio->orig's @cookies list
> >>
> >>```
> >If you feel that is doable: certainly give it a shot.
> 
> Make sense.
> 
> >But it is not clear to me how you intend to translate from cookie passed
> >in to ->blk_poll hook (returned from submit_bio) to the saved off
> >bio->orig.
> >
> >What is your cookie strategy in this non-recursive implementation?  What
> >will you be returning?  Where will you be storing it?
> 
> Actually I think it's a common issue to design the cookie returned
> by submit_bio() whenever it's implemented in a recursive or
> non-recursive way. After all you need to translate the returned cookie
> to the original bio even if it's implemented in a recursive way as you
> described.

Yes.

> Or how could you walk through the bio graph when the returned cookie
> is only 'unsigned int' type?

You could store a pointer (to orig bio, or per-bio-data stored in split
clone, or whatever makes sense for how you're associating poll data with
split bios) in 'unsigned int' type but that's very clumsy -- as I
discovered when trying to do that ;)

> How about this:
> 
> 
> ```
> 
> typedef uintptr_t blk_qc_t;
> 
> ```
> 
> 
> or something like union
> 
> ```
> 
> typedef union {
> 
>     unsigned int cookie;
> 
>     struct bio *orig; // the original bio of submit_bio()
> 
> } blk_qc_t;
> 
> ```
> When serving for blk-mq, the integer part of blk_qc_t is used and it
> stores the valid cookie, while it stores a pointer to the original bio
> when serving bio-based device.

Union looks ideal, but maybe make it a void *?  Initial implementation
may store bio pointer but it _could_ evolve to be 'struct blk_poll_data
*' or whatever.  But not a big deal either way.

> By the way, would you mind sharing your plan and progress on this
> work, I mean, supporting iopoll for dm device. To be honest, I don't
> want to re-invent the wheel as you have started on this work, but I do
> want to participate in somehow. Please let me know if there's something
> I could do here.

I thought I said as much before but: I really don't have anything
meaningful to share.  My early exploration was more rough pseudo code
that served to try to get my arms around the scope of the design
problem.

Please feel free to own all aspects of this work.

I will gladly help analyze/test/refine your approach once you reach the
point of sharing RFC patches.

Thanks,
Mike

