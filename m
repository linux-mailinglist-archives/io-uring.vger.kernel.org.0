Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E30A3233858
	for <lists+io-uring@lfdr.de>; Thu, 30 Jul 2020 20:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728499AbgG3SZ6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Jul 2020 14:25:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726343AbgG3SZ5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Jul 2020 14:25:57 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC6DC061574;
        Thu, 30 Jul 2020 11:25:57 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id g8so6545517wmk.3;
        Thu, 30 Jul 2020 11:25:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=FesOhcVTz5uG9NwCWw9U4Tl+VO0cc6CvMGdsLU0fVOY=;
        b=JSLUD6Ggz+bKsJ08SAUqsI/PGM0PQ5tm8TwxKS0m32kPlmM2hfVN8I1DmwETfrQgE5
         hkFMQKWfHP10tNs0IPsZsKrO4ajDGvgv042jX1WUNEa9fzY8hHQwyWt/pKF7J+KCaC+I
         kO0kHenqIW7df6AyF5QWaKCdKsL3eFpOrdNp7aiq+lLnvbDPiAVbzKNGFxs6cRAuqLSb
         kOgpUfoti3O7VSMwbUTLanZBvxSd13lLlFijXtdaAATGPCWZ8Opg0qwHVrkMOkKya49f
         L97IxPrtoUBOLBJGlTZ5QGM3ZFPgFuCVFA0gAO0sUCkiicOywj4PMvjr6KOYnJdYOxwM
         99Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=FesOhcVTz5uG9NwCWw9U4Tl+VO0cc6CvMGdsLU0fVOY=;
        b=NQJiHsF5UsPpXBim9OyEaRB5AK88HVh+4ybgWX0ozb3BglZguhZDiQVHbI45xYo4QH
         V8CTRfNsKdBLFYJhwY6K9nczC79VaXs7yq0tSZGxobCJ8iS8HwKpUHaR39bg0iM4BKK1
         wDGn4LNHpmImiSc2HttV/dvNUNh6rhXZag524IN+BElaNiG7f72CDP2M7k+RzhqDRcL+
         owdeBU5lLC6z6KjrE3fZBQw8cjyKAmvdAtLsYByf3p65x124R6avAvv3JnfP+mOQwNQv
         F6yOm+70tHWhgd0DtGIuM9XFas5HOMdHbwiENM1a4MkRVgu/mWcKYWeohM2tYRBNBqj9
         ASRA==
X-Gm-Message-State: AOAM533WBFCIjcYKutEloDOmBPLNUq4ZMa2GjRzuq3ld8nTcdWN0TUum
        mpiR5B86rZfFnfEjJI0nQCsR6wTKvNFg6fK7UGWkJitSKdBynA==
X-Google-Smtp-Source: ABdhPJzGfjfyZ+YhqPFgnYDYU8ZyzGJxinC1q0eHjJxy1v/AjsWIhh689HPUV5YOFKUyBkPVwiV6BeyPJpkR15WINoI=
X-Received: by 2002:a05:600c:21cd:: with SMTP id x13mr464368wmj.155.1596133555893;
 Thu, 30 Jul 2020 11:25:55 -0700 (PDT)
MIME-Version: 1.0
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com> <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
 <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
 <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk> <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
 <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk> <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com>
 <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk> <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com> <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
In-Reply-To: <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Thu, 30 Jul 2020 23:55:28 +0530
Message-ID: <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, Matthew Wilcox <willy@infradead.org>,
        Christoph Hellwig <hch@infradead.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-api@vger.kernel.org,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Thu, Jul 30, 2020 at 11:24 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 7/30/20 11:51 AM, Kanchan Joshi wrote:
> > On Thu, Jul 30, 2020 at 11:10 PM Pavel Begunkov <asml.silence@gmail.com=
> wrote:
> >>
> >> On 30/07/2020 20:16, Jens Axboe wrote:
> >>> On 7/30/20 10:26 AM, Pavel Begunkov wrote:
> >>>> On 30/07/2020 19:13, Jens Axboe wrote:
> >>>>> On 7/30/20 10:08 AM, Pavel Begunkov wrote:
> >>>>>> On 27/07/2020 23:34, Jens Axboe wrote:
> >>>>>>> On 7/27/20 1:16 PM, Kanchan Joshi wrote:
> >>>>>>>> On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> wr=
ote:
> >>>>>>>>>
> >>>>>>>>> On 7/24/20 9:49 AM, Kanchan Joshi wrote:
> >>>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >>>>>>>>>> index 7809ab2..6510cf5 100644
> >>>>>>>>>> --- a/fs/io_uring.c
> >>>>>>>>>> +++ b/fs/io_uring.c
> >>>>>>>>>> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(stru=
ct io_kiocb *req, long res, long cflags)
> >>>>>>>>>>       cqe =3D io_get_cqring(ctx);
> >>>>>>>>>>       if (likely(cqe)) {
> >>>>>>>>>>               WRITE_ONCE(cqe->user_data, req->user_data);
> >>>>>>>>>> -             WRITE_ONCE(cqe->res, res);
> >>>>>>>>>> -             WRITE_ONCE(cqe->flags, cflags);
> >>>>>>>>>> +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) {
> >>>>>>>>>> +                     if (likely(res > 0))
> >>>>>>>>>> +                             WRITE_ONCE(cqe->res64, req->rw.a=
ppend_offset);
> >>>>>>>>>> +                     else
> >>>>>>>>>> +                             WRITE_ONCE(cqe->res64, res);
> >>>>>>>>>> +             } else {
> >>>>>>>>>> +                     WRITE_ONCE(cqe->res, res);
> >>>>>>>>>> +                     WRITE_ONCE(cqe->flags, cflags);
> >>>>>>>>>> +             }
> >>>>>>>>>
> >>>>>>>>> This would be nice to keep out of the fast path, if possible.
> >>>>>>>>
> >>>>>>>> I was thinking of keeping a function-pointer (in io_kiocb) durin=
g
> >>>>>>>> submission. That would have avoided this check......but argument=
 count
> >>>>>>>> differs, so it did not add up.
> >>>>>>>
> >>>>>>> But that'd grow the io_kiocb just for this use case, which is arg=
uably
> >>>>>>> even worse. Unless you can keep it in the per-request private dat=
a,
> >>>>>>> but there's no more room there for the regular read/write side.
> >>>>>>>
> >>>>>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linu=
x/io_uring.h
> >>>>>>>>>> index 92c2269..2580d93 100644
> >>>>>>>>>> --- a/include/uapi/linux/io_uring.h
> >>>>>>>>>> +++ b/include/uapi/linux/io_uring.h
> >>>>>>>>>> @@ -156,8 +156,13 @@ enum {
> >>>>>>>>>>   */
> >>>>>>>>>>  struct io_uring_cqe {
> >>>>>>>>>>       __u64   user_data;      /* sqe->data submission passed b=
ack */
> >>>>>>>>>> -     __s32   res;            /* result code for this event */
> >>>>>>>>>> -     __u32   flags;
> >>>>>>>>>> +     union {
> >>>>>>>>>> +             struct {
> >>>>>>>>>> +                     __s32   res;    /* result code for this =
event */
> >>>>>>>>>> +                     __u32   flags;
> >>>>>>>>>> +             };
> >>>>>>>>>> +             __s64   res64;  /* appending offset for zone app=
end */
> >>>>>>>>>> +     };
> >>>>>>>>>>  };
> >>>>>>>>>
> >>>>>>>>> Is this a compatible change, both for now but also going forwar=
d? You
> >>>>>>>>> could randomly have IORING_CQE_F_BUFFER set, or any other futur=
e flags.
> >>>>>>>>
> >>>>>>>> Sorry, I didn't quite understand the concern. CQE_F_BUFFER is no=
t
> >>>>>>>> used/set for write currently, so it looked compatible at this po=
int.
> >>>>>>>
> >>>>>>> Not worried about that, since we won't ever use that for writes. =
But it
> >>>>>>> is a potential headache down the line for other flags, if they ap=
ply to
> >>>>>>> normal writes.
> >>>>>>>
> >>>>>>>> Yes, no room for future flags for this operation.
> >>>>>>>> Do you see any other way to enable this support in io-uring?
> >>>>>>>
> >>>>>>> Honestly I think the only viable option is as we discussed previo=
usly,
> >>>>>>> pass in a pointer to a 64-bit type where we can copy the addition=
al
> >>>>>>> completion information to.
> >>>>>>
> >>>>>> TBH, I hate the idea of such overhead/latency at times when SSDs c=
an
> >>>>>> serve writes in less than 10ms. Any chance you measured how long d=
oes it
> >>>>>
> >>>>> 10us? :-)
> >>>>
> >>>> Hah, 10us indeed :)
> >>>>
> >>>>>
> >>>>>> take to drag through task_work?
> >>>>>
> >>>>> A 64-bit value copy is really not a lot of overhead... But yes, we'=
d
> >>>>> need to push the completion through task_work at that point, as we =
can't
> >>>>> do it from the completion side. That's not a lot of overhead, and m=
ost
> >>>>> notably, it's overhead that only affects this particular type.
> >>>>>
> >>>>> That's not a bad starting point, and something that can always be
> >>>>> optimized later if need be. But I seriously doubt it'd be anything =
to
> >>>>> worry about.
> >>>>
> >>>> I probably need to look myself how it's really scheduled, but if you=
 don't
> >>>> mind, here is a quick question: if we do work_add(task) when the tas=
k is
> >>>> running in the userspace, wouldn't the work execution wait until the=
 next
> >>>> syscall/allotted time ends up?
> >>>
> >>> It'll get the task to enter the kernel, just like signal delivery. Th=
e only
> >>> tricky part is really if we have a dependency waiting in the kernel, =
like
> >>> the recent eventfd fix.
> >>
> >> I see, thanks for sorting this out!
> >
> > Few more doubts about this (please mark me wrong if that is the case):
> >
> > - Task-work makes me feel like N completions waiting to be served by
> > single task.
> > Currently completions keep arriving and CQEs would be updated with
> > result, but the user-space (submitter task) would not be poked.
> >
> > - Completion-code will set the task-work. But post that it cannot go
> > immediately to its regular business of picking cqe and updating
> > res/flags, as we cannot afford user-space to see the cqe before the
> > pointer update. So it seems completion-code needs to spawn another
> > work which will allocate/update cqe after waiting for pointer-update
> > from task-work?
>
> The task work would post the completion CQE for the request after
> writing the offset.

Got it, thank you for making it simple.
Overall if I try to put the tradeoffs of moving to indirect-offset
(compared to current scheme)=E2=80=93

Upside:
- cqe res/flags would be intact, avoids future-headaches as you mentioned
- short-write cases do not have to be failed in lower-layers (as
cqe->res is there to report bytes-copied)

Downside:
- We may not be able to use RWF_APPEND, and need exposing a new
type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this
sounds outrageous, but is it OK to have uring-only flag which can be
combined with RWF_APPEND?
-  Expensive compared to sending results in cqe itself. But I agree
that this may not be major, and only for one type of write.


--=20
Joshi
