Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D22F9154A44
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 18:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727479AbgBFRdz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 12:33:55 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57201 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726990AbgBFRdz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 12:33:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581010433;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BklOOZtpEbXR2lfLsVN/Nzs8K2IHl/5W7tD5xZRKzIw=;
        b=fCyqbDTD/T5hSfkDtrAEZC1uLCzzJ1YGwiR/kfuYPy+dzgGfznVbW2dsRTxHP+yzxNQSwV
        IcagDAzaZGd80KHiMXlyUhhSSP0JzDcXh0bFJCtyHFliasz/r9Ss19YOISnktovOfXLLlN
        Lqat+iSpMXoILSQ3393HLh393fd4v6I=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-377-ax0HIhwfOJOVFTUXq1Cpgw-1; Thu, 06 Feb 2020 12:33:52 -0500
X-MC-Unique: ax0HIhwfOJOVFTUXq1Cpgw-1
Received: by mail-wr1-f69.google.com with SMTP id s13so3829259wrb.21
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 09:33:51 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BklOOZtpEbXR2lfLsVN/Nzs8K2IHl/5W7tD5xZRKzIw=;
        b=eIamBWGUn7oYEy+EU6b7mv67DhCimzOfoDVwSzd1BZDtwdOozOxrtyB6VRpxnaCq37
         BT0JqWNPkX1kSUcHIxN/jhps57Ob9mdQRISvi97UfDwMKfeIOW+OobHdY6bBqEubW6x/
         OR1LjVv+1ym6pJab+co0xuAOgTCwvPRFylYQElv/MxVYmBXNQ2lVka1EA/AcNNP9HNkE
         3EBlVUgtlHsBwxBqzdyl42vPFFin3SsNtXYFqZEs6OEHUVwdkJJJ7mx5DE0NTUHIt4JM
         dDZkl6WoaCqkfFqO86l65lJEHmipgjCOunz3dju6rWbwgL3FKmrWMF9/h80/WXYrOmep
         X6MQ==
X-Gm-Message-State: APjAAAUc78oBGxM0WxlbEBlbzBjO/kuq97KM1kzL1/4/0rULPr3zKfN8
        hXogsA4UPBhdRf6Wo28s70tN8AbWOZbzE7MmUYFV7i/W2HJxlknMm+QkaXNNM/sjXjYaux9I8JO
        L4u/aia85W78hWksaoMY=
X-Received: by 2002:a1c:7915:: with SMTP id l21mr5504744wme.112.1581010431052;
        Thu, 06 Feb 2020 09:33:51 -0800 (PST)
X-Google-Smtp-Source: APXvYqz/LgvjhDqPglzyKZz65I/FvXOuZVvP6MOg0sTKNxQjVoAU4NrjaJmmLB1IwT7DfEihNiQf7w==
X-Received: by 2002:a1c:7915:: with SMTP id l21mr5504712wme.112.1581010430684;
        Thu, 06 Feb 2020 09:33:50 -0800 (PST)
Received: from steredhat (host209-4-dynamic.27-79-r.retail.telecomitalia.it. [79.27.4.209])
        by smtp.gmail.com with ESMTPSA id z133sm263777wmb.7.2020.02.06.09.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 09:33:50 -0800 (PST)
Date:   Thu, 6 Feb 2020 18:33:48 +0100
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH liburing v2 0/1] test: add epoll test case
Message-ID: <CAGxU2F6qvW28=ULNUi-UHethus2bO6VXYX127HOcH_KPToZC-w@mail.gmail.com>
References: <20200131142943.120459-1-sgarzare@redhat.com>
 <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org



On Fri, Jan 31, 2020 at 4:39 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 1/31/20 7:29 AM, Stefano Garzarella wrote:
> > Hi Jens,
> > this is a v2 of the epoll test.
> >
> > v1 -> v2:
> >     - if IORING_FEAT_NODROP is not available, avoid to overflow the CQ
> >     - add 2 new tests to test epoll with IORING_FEAT_NODROP
> >     - cleanups
> >
> > There are 4 sub-tests:
> >     1. test_epoll
> >     2. test_epoll_sqpoll
> >     3. test_epoll_nodrop
> >     4. test_epoll_sqpoll_nodrop
> >
> > In the first 2 tests, I try to avoid to queue more requests than we have room
> > for in the CQ ring. These work fine, I have no faults.
>
> Thanks!
>
> > In the tests 3 and 4, if IORING_FEAT_NODROP is supported, I try to submit as
> > much as I can until I get a -EBUSY, but they often fail in this way:
> > the submitter manages to submit everything, the receiver receives all the
> > submitted bytes, but the cleaner loses completion events (I also tried to put a
> > timeout to epoll_wait() in the cleaner to be sure that it is not related to the
> > patch that I send some weeks ago, but the situation doesn't change, it's like
> > there is still overflow in the CQ).
> >
> > Next week I'll try to investigate better which is the problem.
>
> Does it change if you have an io_uring_enter() with GETEVENTS set? I wonder if
> you just pruned the CQ ring but didn't flush the internal side.

If I do io_uring_enter() with GETEVENTS set and wait_nr = 0 it solves
the issue, I think because we call io_cqring_events() that flushes the
overflow list.

At this point, should we call io_cqring_events() (that flushes the
overflow list) in io_uring_poll()?
I mean something like this:

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 77f22c3da30f..2769451af89a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6301,7 +6301,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
        if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
            ctx->rings->sq_ring_entries)
                mask |= EPOLLOUT | EPOLLWRNORM;
-       if (READ_ONCE(ctx->rings->cq.head) != ctx->cached_cq_tail)
+       if (!io_cqring_events(ctx, false))
                mask |= EPOLLIN | EPOLLRDNORM;

        return mask;

Thanks,
Stefano

