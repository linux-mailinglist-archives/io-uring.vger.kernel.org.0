Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6490154CB6
	for <lists+io-uring@lfdr.de>; Thu,  6 Feb 2020 21:12:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727526AbgBFUMV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 6 Feb 2020 15:12:21 -0500
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:42021 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727474AbgBFUMT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 6 Feb 2020 15:12:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581019938;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=dc03bS7vb6AnFmrkfHvUVYpca8hGe8BfMxylHA6Yclg=;
        b=QIbaUe4KWx5IbtVqdyE6a/Y/KKopeVBu6UtbKBsuNlCRwcVgHxylzJXZmvLbfWQTQjF84s
        pQLfC/sg+1d0rwr9TXOGkwTBfP3vlWLwyD5XCK5sUeDMKYErhY6byj+n1Wa4CkIDjYRdzI
        LzriANJ7PsSDG/hV84xS1EAnO6jNdmw=
Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com
 [209.85.210.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-156-ck_DEuNtMS2GI_MrK2hl2g-1; Thu, 06 Feb 2020 15:12:16 -0500
X-MC-Unique: ck_DEuNtMS2GI_MrK2hl2g-1
Received: by mail-ot1-f71.google.com with SMTP id 39so3845744otr.21
        for <io-uring@vger.kernel.org>; Thu, 06 Feb 2020 12:12:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dc03bS7vb6AnFmrkfHvUVYpca8hGe8BfMxylHA6Yclg=;
        b=FfPnVCFtk91/ACrtuCZZYK0ZQXTCcUY3a6FdHjnYXUgH1FnBo1B94V6rwV2EvUd6qB
         SLONEVo4dNziNytMVGmI01vQFmiSZvHsEXdSHJEjgTn2O1QT3s7tqvfER122gttC2pXY
         opgz8XTjmVNjDcWRBP+4cgJlVSDxe09IVpUlos8EasvrP/mhF3orrvGyIYhGDEoITSc9
         CM+uaMQSCpkIPntfEo2s8AvhP13YIH6+oQcLtVSbVeHelCW46jR8Ma+V5kmUyVtN2yXT
         9CWciLLfD3Ev82wN/7pfXLsb/6C1K1twYaLOlxl+5Pzb9AOtF3+As4NVdHUlxK+yPa8S
         +Eew==
X-Gm-Message-State: APjAAAV9zWrzqnGsBPFUkRzod8Z6CKR28x6dXZtA4MfSWP78ZC6h0/hd
        2ILuGX5nPBC5yWfBrMsvQ7miWb2DCaWZdmcmSVqpgdRBl17QfDVOVypPl+YTrXmJOpaQkpObKvD
        /Md0wvvT9FPR0to+z0Fg73kd1KOS9vhiobLs=
X-Received: by 2002:aca:c1c2:: with SMTP id r185mr8574800oif.19.1581019935464;
        Thu, 06 Feb 2020 12:12:15 -0800 (PST)
X-Google-Smtp-Source: APXvYqwCE4YGrcrqxJ3vc8/5E1V7khl8YoaBsmxia7QqkAOBDVH5AS1SxI2KJDEm+KAx0o3nST9WGdr5QNqKAlbLYKM=
X-Received: by 2002:aca:c1c2:: with SMTP id r185mr8574790oif.19.1581019935179;
 Thu, 06 Feb 2020 12:12:15 -0800 (PST)
MIME-Version: 1.0
References: <20200131142943.120459-1-sgarzare@redhat.com> <ebc2efdb-4e7f-0db9-ef04-c02aac0b08b1@kernel.dk>
 <CAGxU2F6qvW28=ULNUi-UHethus2bO6VXYX127HOcH_KPToZC-w@mail.gmail.com>
 <ec04cb8f-01e8-6289-2fd4-6dec8a8e2c02@kernel.dk> <548cb67b-bb43-c22a-f3c6-e707e2c07c13@kernel.dk>
In-Reply-To: <548cb67b-bb43-c22a-f3c6-e707e2c07c13@kernel.dk>
From:   Stefano Garzarella <sgarzare@redhat.com>
Date:   Thu, 6 Feb 2020 21:12:03 +0100
Message-ID: <CAGxU2F7MWwvLw7dgGSoY0uFeZVe6JbYcvhmKRMfTpzVBwho3yg@mail.gmail.com>
Subject: Re: [PATCH liburing v2 0/1] test: add epoll test case
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Feb 6, 2020 at 8:51 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 2/6/20 12:15 PM, Jens Axboe wrote:
> > On 2/6/20 10:33 AM, Stefano Garzarella wrote:
> >>
> >>
> >> On Fri, Jan 31, 2020 at 4:39 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>
> >>> On 1/31/20 7:29 AM, Stefano Garzarella wrote:
> >>>> Hi Jens,
> >>>> this is a v2 of the epoll test.
> >>>>
> >>>> v1 -> v2:
> >>>>     - if IORING_FEAT_NODROP is not available, avoid to overflow the CQ
> >>>>     - add 2 new tests to test epoll with IORING_FEAT_NODROP
> >>>>     - cleanups
> >>>>
> >>>> There are 4 sub-tests:
> >>>>     1. test_epoll
> >>>>     2. test_epoll_sqpoll
> >>>>     3. test_epoll_nodrop
> >>>>     4. test_epoll_sqpoll_nodrop
> >>>>
> >>>> In the first 2 tests, I try to avoid to queue more requests than we have room
> >>>> for in the CQ ring. These work fine, I have no faults.
> >>>
> >>> Thanks!
> >>>
> >>>> In the tests 3 and 4, if IORING_FEAT_NODROP is supported, I try to submit as
> >>>> much as I can until I get a -EBUSY, but they often fail in this way:
> >>>> the submitter manages to submit everything, the receiver receives all the
> >>>> submitted bytes, but the cleaner loses completion events (I also tried to put a
> >>>> timeout to epoll_wait() in the cleaner to be sure that it is not related to the
> >>>> patch that I send some weeks ago, but the situation doesn't change, it's like
> >>>> there is still overflow in the CQ).
> >>>>
> >>>> Next week I'll try to investigate better which is the problem.
> >>>
> >>> Does it change if you have an io_uring_enter() with GETEVENTS set? I wonder if
> >>> you just pruned the CQ ring but didn't flush the internal side.
> >>
> >> If I do io_uring_enter() with GETEVENTS set and wait_nr = 0 it solves
> >> the issue, I think because we call io_cqring_events() that flushes the
> >> overflow list.
> >>
> >> At this point, should we call io_cqring_events() (that flushes the
> >> overflow list) in io_uring_poll()?
> >> I mean something like this:
> >>
> >> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >> index 77f22c3da30f..2769451af89a 100644
> >> --- a/fs/io_uring.c
> >> +++ b/fs/io_uring.c
> >> @@ -6301,7 +6301,7 @@ static __poll_t io_uring_poll(struct file *file, poll_table *wait)
> >>         if (READ_ONCE(ctx->rings->sq.tail) - ctx->cached_sq_head !=
> >>             ctx->rings->sq_ring_entries)
> >>                 mask |= EPOLLOUT | EPOLLWRNORM;
> >> -       if (READ_ONCE(ctx->rings->cq.head) != ctx->cached_cq_tail)
> >> +       if (!io_cqring_events(ctx, false))
> >>                 mask |= EPOLLIN | EPOLLRDNORM;
> >>
> >>         return mask;
> >
> > That's not a bad idea, would just have to verify that it is indeed safe
> > to always call the flushing variant from there.
>
> Double checked, and it should be fine. We may be invoked with
> ctx->uring_lock held, but that's fine.
>

Maybe yes, I'll check better and I'll send a patch :-)

Thanks,
Stefano

