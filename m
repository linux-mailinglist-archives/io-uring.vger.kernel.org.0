Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4A682337F2
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 19:52:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730294AbgG3RwJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 13:52:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgG3RwI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 13:52:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84026C061574;
        Thu, 30 Jul 2020 10:52:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id b6so25699160wrs.11;
        Thu, 30 Jul 2020 10:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=oFuoJe+oEM0Uix08KBFqSo1gG3LqQuw86Sd2WBM74e0=;
        b=i0BLDjoGkJhuUfxsPGOpOigySMxG/d6pKPpgr4SXJ0YHky7k6FibRrRixeLBM6fbvE
         QAmCdw6Xgs2E2c6z1D4WoiMScPD3zs/jDurWMDfwjC4f+CqyUsgbllJKkhhNdzgloJxR
         weMUvr6iIsNC++Kjfk28dHHS9oWRS91Fyz/dKJPudurj8Aroy2Vl0JMCeb5bFHkv3xxg
         IEYGKL01+JZ1Pzovt5rCQ8a2WJcngWDh9TdIPupO+vqIOYuAKwWLhdP3XXKVo6vn+tY4
         iekL+Ow/AtUyJL5gDe+fMkWXwKI/t/gNLewVjMvBwBQh1/5PJwGMmQTyKtiSOPnxZerD
         khPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=oFuoJe+oEM0Uix08KBFqSo1gG3LqQuw86Sd2WBM74e0=;
        b=QP1UCRRe4BYoTmPOfXIHiWP5cglJqlZRHCmII8RXsP386Om2swz8AgDAPvyN//EQbT
         xt/nYXCMk/B//AtJYCjObxFvAaa3hv2gbhWJ5xRFgJ3OznSFbPr6qk6Xi2PkJraYGdNL
         4THngo7VBwgi20B4eKwMjzvYv/JRDnOXioYauVDwNES1z2i0vRmIif5jGVUbOIcKHl6N
         XpIHGialPXyKKLTMZaNaajEDFZh3Moi4/vdqyXaNiGexGYSuSYMgjG9pAmiX5ufR7v5Q
         oJTKeHjjPIK6pmlGfy8JJkERWcRbKOOOR2wb7My1TFD30FTaCpnyO1wZL3KOZleWJ1/Z
         09Bw==
X-Gm-Message-State: AOAM531Sy+dkt/QO/xaQ5NsNoleZciLUbKIFXgnMEH9WxDuxJRmwnBUr
        lukAI8us1WC7PWubo55FFiSZLiwDs8ojx07sgNbthdHsjq4gng==
X-Google-Smtp-Source: ABdhPJxJJqwMHNYpift7oCWRcfUAjrSrb08yLuNE7q/QFrRpEhtUmhuSoC/nJO9RctnF5KT/QXq4R9WLe30T+dmce2E=
X-Received: by 2002:adf:ea4f:: with SMTP id j15mr35138244wrn.253.1596131526928;
 Thu, 30 Jul 2020 10:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com> <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
 <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
 <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk> <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
 <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk> <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com>
 <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk> <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
In-Reply-To: <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 30 Jul 2020 23:21:40 +0530
Message-ID: <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Kanchan Joshi <joshi.k@samsung.com>,
        viro@zeniv.linux.org.uk, bcrl@kvack.org,
        Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-api@vger.kernel.org,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 30, 2020 at 11:10 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> On 30/07/2020 20:16, Jens Axboe wrote:
> > On 7/30/20 10:26 AM, Pavel Begunkov wrote:
> >> On 30/07/2020 19:13, Jens Axboe wrote:
> >>> On 7/30/20 10:08 AM, Pavel Begunkov wrote:
> >>>> On 27/07/2020 23:34, Jens Axboe wrote:
> >>>>> On 7/27/20 1:16 PM, Kanchan Joshi wrote:
> >>>>>> On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>>>>>>
> >>>>>>> On 7/24/20 9:49 AM, Kanchan Joshi wrote:
> >>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >>>>>>>> index 7809ab2..6510cf5 100644
> >>>>>>>> --- a/fs/io_uring.c
> >>>>>>>> +++ b/fs/io_uring.c
> >>>>>>>> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res, long cflags)
> >>>>>>>>       cqe = io_get_cqring(ctx);
> >>>>>>>>       if (likely(cqe)) {
> >>>>>>>>               WRITE_ONCE(cqe->user_data, req->user_data);
> >>>>>>>> -             WRITE_ONCE(cqe->res, res);
> >>>>>>>> -             WRITE_ONCE(cqe->flags, cflags);
> >>>>>>>> +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
> >>>>>>>> +                     if (likely(res > 0))
> >>>>>>>> +                             WRITE_ONCE(cqe->res64, req->rw.append_offset);
> >>>>>>>> +                     else
> >>>>>>>> +                             WRITE_ONCE(cqe->res64, res);
> >>>>>>>> +             } else {
> >>>>>>>> +                     WRITE_ONCE(cqe->res, res);
> >>>>>>>> +                     WRITE_ONCE(cqe->flags, cflags);
> >>>>>>>> +             }
> >>>>>>>
> >>>>>>> This would be nice to keep out of the fast path, if possible.
> >>>>>>
> >>>>>> I was thinking of keeping a function-pointer (in io_kiocb) during
> >>>>>> submission. That would have avoided this check......but argument count
> >>>>>> differs, so it did not add up.
> >>>>>
> >>>>> But that'd grow the io_kiocb just for this use case, which is arguably
> >>>>> even worse. Unless you can keep it in the per-request private data,
> >>>>> but there's no more room there for the regular read/write side.
> >>>>>
> >>>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
> >>>>>>>> index 92c2269..2580d93 100644
> >>>>>>>> --- a/include/uapi/linux/io_uring.h
> >>>>>>>> +++ b/include/uapi/linux/io_uring.h
> >>>>>>>> @@ -156,8 +156,13 @@ enum {
> >>>>>>>>   */
> >>>>>>>>  struct io_uring_cqe {
> >>>>>>>>       __u64   user_data;      /* sqe->data submission passed back */
> >>>>>>>> -     __s32   res;            /* result code for this event */
> >>>>>>>> -     __u32   flags;
> >>>>>>>> +     union {
> >>>>>>>> +             struct {
> >>>>>>>> +                     __s32   res;    /* result code for this event */
> >>>>>>>> +                     __u32   flags;
> >>>>>>>> +             };
> >>>>>>>> +             __s64   res64;  /* appending offset for zone append */
> >>>>>>>> +     };
> >>>>>>>>  };
> >>>>>>>
> >>>>>>> Is this a compatible change, both for now but also going forward? You
> >>>>>>> could randomly have IORING_CQE_F_BUFFER set, or any other future flags.
> >>>>>>
> >>>>>> Sorry, I didn't quite understand the concern. CQE_F_BUFFER is not
> >>>>>> used/set for write currently, so it looked compatible at this point.
> >>>>>
> >>>>> Not worried about that, since we won't ever use that for writes. But it
> >>>>> is a potential headache down the line for other flags, if they apply to
> >>>>> normal writes.
> >>>>>
> >>>>>> Yes, no room for future flags for this operation.
> >>>>>> Do you see any other way to enable this support in io-uring?
> >>>>>
> >>>>> Honestly I think the only viable option is as we discussed previously,
> >>>>> pass in a pointer to a 64-bit type where we can copy the additional
> >>>>> completion information to.
> >>>>
> >>>> TBH, I hate the idea of such overhead/latency at times when SSDs can
> >>>> serve writes in less than 10ms. Any chance you measured how long does it
> >>>
> >>> 10us? :-)
> >>
> >> Hah, 10us indeed :)
> >>
> >>>
> >>>> take to drag through task_work?
> >>>
> >>> A 64-bit value copy is really not a lot of overhead... But yes, we'd
> >>> need to push the completion through task_work at that point, as we can't
> >>> do it from the completion side. That's not a lot of overhead, and most
> >>> notably, it's overhead that only affects this particular type.
> >>>
> >>> That's not a bad starting point, and something that can always be
> >>> optimized later if need be. But I seriously doubt it'd be anything to
> >>> worry about.
> >>
> >> I probably need to look myself how it's really scheduled, but if you don't
> >> mind, here is a quick question: if we do work_add(task) when the task is
> >> running in the userspace, wouldn't the work execution wait until the next
> >> syscall/allotted time ends up?
> >
> > It'll get the task to enter the kernel, just like signal delivery. The only
> > tricky part is really if we have a dependency waiting in the kernel, like
> > the recent eventfd fix.
>
> I see, thanks for sorting this out!

Few more doubts about this (please mark me wrong if that is the case):

- Task-work makes me feel like N completions waiting to be served by
single task.
Currently completions keep arriving and CQEs would be updated with
result, but the user-space (submitter task) would not be poked.

- Completion-code will set the task-work. But post that it cannot go
immediately to its regular business of picking cqe and updating
res/flags, as we cannot afford user-space to see the cqe before the
pointer update. So it seems completion-code needs to spawn another
work which will allocate/update cqe after waiting for pointer-update
from task-work?


-- 
Joshi
