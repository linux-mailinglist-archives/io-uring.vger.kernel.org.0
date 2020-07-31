Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3552F233FBB
	for <lists+io-uring@lfdr.de>; Fri, 31 Jul 2020 09:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731518AbgGaHI5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 31 Jul 2020 03:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731367AbgGaHI4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 31 Jul 2020 03:08:56 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67F39C061574;
        Fri, 31 Jul 2020 00:08:56 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id q76so7057533wme.4;
        Fri, 31 Jul 2020 00:08:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Hgf0ZyaqGaOKn5USuc2ZOpRRDGLtIAC8Tr9KyFjHJwE=;
        b=qzgH58pV3DMb/4Ewr9Yr9X7E9skTZcUoQ60AdF1bBwanjaUFIBvXKfVmPAPCtCTqKl
         471rJMY99JixEck+lNFPL25W4b28DVGdzLlyvQ0nWgA72T0RLsuQtQrAhpLIadB6bt9/
         HPFpavfv5pOk86v5hsqCrNEwAuux02YtDtbc5YozL/9mSEZxEsJ3VYKjwapPkByD7bIH
         EijXJuGlF+s9lz+5MsvcdX4xW1MFOOXQdo8QSowupkEAf0x+z26Lsk39oVp75zXfXDDD
         qTPSCyt/hqW+WPAkT/WO1u0pe4Js4Qx15pZVAOYswYdAPIx4EBlDVDB38p3Ol+r6NIyj
         G2jg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Hgf0ZyaqGaOKn5USuc2ZOpRRDGLtIAC8Tr9KyFjHJwE=;
        b=FL8aT8o479SfFlfledkRrube5NY4IsRvghqYhPFIgyTczvRXMTnePquUq6eZGs1eoO
         Lshdl1kG2GOyeWXLQg0ccuBmn6mJrYSorgoGSH5xBLe9oKBYP8qP0OvpInljwdoIaXu+
         rKKe7JOBiZl3bwIh9vEiwb84BBgRDnqDi1GpmwrOtmur4cs/sH3Gncn/sYU5l4K4ysxB
         EIDr0ku8KAWRRiTWilxN+/lqgKCp7etoTcfShSc0ikYzRkmCN8pTH5ukc6T1OrFSgkW5
         4Gi2B1v9aSPM9AigYjhzgcukyFAVwmuzGkW1udS6ngNf9O9CpidUTEWWsX7dxhisxwMZ
         Hmvg==
X-Gm-Message-State: AOAM533Pr5L7874l5K3nm4ea/KwhAdmaV6AG2x8i0lGFDqjBT5fgblLj
        UumlY5S+avT8lWGpjQzXSfG8eBd7V1zGxEajmLc=
X-Google-Smtp-Source: ABdhPJz6NYUTdZqrjqLEtWANyrKKrQxMtZMwnfn6c7g699kvaunkKDuMMoMBV+R78TbbJwNOByEF+TB9vGjWZxsTlkk=
X-Received: by 2002:a1c:32c3:: with SMTP id y186mr2494080wmy.15.1596179334716;
 Fri, 31 Jul 2020 00:08:54 -0700 (PDT)
MIME-Version: 1.0
References: <1595605762-17010-1-git-send-email-joshi.k@samsung.com>
 <CGME20200724155350epcas5p3b8f1d59eda7f8fbb38c828f692d42fd6@epcas5p3.samsung.com>
 <1595605762-17010-7-git-send-email-joshi.k@samsung.com> <f5416bd4-93b3-4d14-3266-bdbc4ae1990b@kernel.dk>
 <CA+1E3rJAa3E2Ti0fvvQTzARP797qge619m4aYLjXeR3wxdFwWw@mail.gmail.com>
 <b0b7159d-ed10-08ad-b6c7-b85d45f60d16@kernel.dk> <e871eef2-8a93-fdbc-b762-2923526a2db4@gmail.com>
 <80d27717-080a-1ced-50d5-a3a06cf06cd3@kernel.dk> <da4baa8c-76b0-7255-365c-d8b58e322fd0@gmail.com>
 <65a7e9a6-aede-31ce-705c-b7f94f079112@kernel.dk> <d4f9a5d3-1df2-1060-94fa-f77441a89299@gmail.com>
 <CA+1E3rJ3SoLU9aYcugAQgJnSPnJtcCwjZdMREXS3FTmXgy3yow@mail.gmail.com>
 <f030a338-cd52-2e83-e1da-bdbca910d49e@kernel.dk> <CA+1E3rKxZk2CatTuPcQq5d14vXL9_9LVb2_+AfR2m9xn2WTZdg@mail.gmail.com>
 <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
In-Reply-To: <MWHPR04MB3758DC08EA17780E498E9EC0E74E0@MWHPR04MB3758.namprd04.prod.outlook.com>
From:   Kanchan Joshi <joshiiitr@gmail.com>
Date:   Fri, 31 Jul 2020 12:38:27 +0530
Message-ID: <CA+1E3rJ5j6MeG3O5Xa7unWLMRz6BacvLVN8xpeEz6AVyJWT55Q@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] io_uring: add support for zone-append
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Kanchan Joshi <joshi.k@samsung.com>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "bcrl@kvack.org" <bcrl@kvack.org>,
        Matthew Wilcox <willy@infradead.org>,
        "hch@infradead.org" <hch@infradead.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-aio@kvack.org" <linux-aio@kvack.org>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>,
        SelvaKumar S <selvakuma.s1@samsung.com>,
        Nitesh Shetty <nj.shetty@samsung.com>,
        Javier Gonzalez <javier.gonz@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Jul 31, 2020 at 12:12 PM Damien Le Moal <Damien.LeMoal@wdc.com> wro=
te:
>
> On 2020/07/31 3:26, Kanchan Joshi wrote:
> > On Thu, Jul 30, 2020 at 11:24 PM Jens Axboe <axboe@kernel.dk> wrote:
> >>
> >> On 7/30/20 11:51 AM, Kanchan Joshi wrote:
> >>> On Thu, Jul 30, 2020 at 11:10 PM Pavel Begunkov <asml.silence@gmail.c=
om> wrote:
> >>>>
> >>>> On 30/07/2020 20:16, Jens Axboe wrote:
> >>>>> On 7/30/20 10:26 AM, Pavel Begunkov wrote:
> >>>>>> On 30/07/2020 19:13, Jens Axboe wrote:
> >>>>>>> On 7/30/20 10:08 AM, Pavel Begunkov wrote:
> >>>>>>>> On 27/07/2020 23:34, Jens Axboe wrote:
> >>>>>>>>> On 7/27/20 1:16 PM, Kanchan Joshi wrote:
> >>>>>>>>>> On Fri, Jul 24, 2020 at 10:00 PM Jens Axboe <axboe@kernel.dk> =
wrote:
> >>>>>>>>>>>
> >>>>>>>>>>> On 7/24/20 9:49 AM, Kanchan Joshi wrote:
> >>>>>>>>>>>> diff --git a/fs/io_uring.c b/fs/io_uring.c
> >>>>>>>>>>>> index 7809ab2..6510cf5 100644
> >>>>>>>>>>>> --- a/fs/io_uring.c
> >>>>>>>>>>>> +++ b/fs/io_uring.c
> >>>>>>>>>>>> @@ -1284,8 +1301,15 @@ static void __io_cqring_fill_event(st=
ruct io_kiocb *req, long res, long cflags)
> >>>>>>>>>>>>       cqe =3D io_get_cqring(ctx);
> >>>>>>>>>>>>       if (likely(cqe)) {
> >>>>>>>>>>>>               WRITE_ONCE(cqe->user_data, req->user_data);
> >>>>>>>>>>>> -             WRITE_ONCE(cqe->res, res);
> >>>>>>>>>>>> -             WRITE_ONCE(cqe->flags, cflags);
> >>>>>>>>>>>> +             if (unlikely(req->flags & REQ_F_ZONE_APPEND)) =
{
> >>>>>>>>>>>> +                     if (likely(res > 0))
> >>>>>>>>>>>> +                             WRITE_ONCE(cqe->res64, req->rw=
.append_offset);
> >>>>>>>>>>>> +                     else
> >>>>>>>>>>>> +                             WRITE_ONCE(cqe->res64, res);
> >>>>>>>>>>>> +             } else {
> >>>>>>>>>>>> +                     WRITE_ONCE(cqe->res, res);
> >>>>>>>>>>>> +                     WRITE_ONCE(cqe->flags, cflags);
> >>>>>>>>>>>> +             }
> >>>>>>>>>>>
> >>>>>>>>>>> This would be nice to keep out of the fast path, if possible.
> >>>>>>>>>>
> >>>>>>>>>> I was thinking of keeping a function-pointer (in io_kiocb) dur=
ing
> >>>>>>>>>> submission. That would have avoided this check......but argume=
nt count
> >>>>>>>>>> differs, so it did not add up.
> >>>>>>>>>
> >>>>>>>>> But that'd grow the io_kiocb just for this use case, which is a=
rguably
> >>>>>>>>> even worse. Unless you can keep it in the per-request private d=
ata,
> >>>>>>>>> but there's no more room there for the regular read/write side.
> >>>>>>>>>
> >>>>>>>>>>>> diff --git a/include/uapi/linux/io_uring.h b/include/uapi/li=
nux/io_uring.h
> >>>>>>>>>>>> index 92c2269..2580d93 100644
> >>>>>>>>>>>> --- a/include/uapi/linux/io_uring.h
> >>>>>>>>>>>> +++ b/include/uapi/linux/io_uring.h
> >>>>>>>>>>>> @@ -156,8 +156,13 @@ enum {
> >>>>>>>>>>>>   */
> >>>>>>>>>>>>  struct io_uring_cqe {
> >>>>>>>>>>>>       __u64   user_data;      /* sqe->data submission passed=
 back */
> >>>>>>>>>>>> -     __s32   res;            /* result code for this event =
*/
> >>>>>>>>>>>> -     __u32   flags;
> >>>>>>>>>>>> +     union {
> >>>>>>>>>>>> +             struct {
> >>>>>>>>>>>> +                     __s32   res;    /* result code for thi=
s event */
> >>>>>>>>>>>> +                     __u32   flags;
> >>>>>>>>>>>> +             };
> >>>>>>>>>>>> +             __s64   res64;  /* appending offset for zone a=
ppend */
> >>>>>>>>>>>> +     };
> >>>>>>>>>>>>  };
> >>>>>>>>>>>
> >>>>>>>>>>> Is this a compatible change, both for now but also going forw=
ard? You
> >>>>>>>>>>> could randomly have IORING_CQE_F_BUFFER set, or any other fut=
ure flags.
> >>>>>>>>>>
> >>>>>>>>>> Sorry, I didn't quite understand the concern. CQE_F_BUFFER is =
not
> >>>>>>>>>> used/set for write currently, so it looked compatible at this =
point.
> >>>>>>>>>
> >>>>>>>>> Not worried about that, since we won't ever use that for writes=
. But it
> >>>>>>>>> is a potential headache down the line for other flags, if they =
apply to
> >>>>>>>>> normal writes.
> >>>>>>>>>
> >>>>>>>>>> Yes, no room for future flags for this operation.
> >>>>>>>>>> Do you see any other way to enable this support in io-uring?
> >>>>>>>>>
> >>>>>>>>> Honestly I think the only viable option is as we discussed prev=
iously,
> >>>>>>>>> pass in a pointer to a 64-bit type where we can copy the additi=
onal
> >>>>>>>>> completion information to.
> >>>>>>>>
> >>>>>>>> TBH, I hate the idea of such overhead/latency at times when SSDs=
 can
> >>>>>>>> serve writes in less than 10ms. Any chance you measured how long=
 does it
> >>>>>>>
> >>>>>>> 10us? :-)
> >>>>>>
> >>>>>> Hah, 10us indeed :)
> >>>>>>
> >>>>>>>
> >>>>>>>> take to drag through task_work?
> >>>>>>>
> >>>>>>> A 64-bit value copy is really not a lot of overhead... But yes, w=
e'd
> >>>>>>> need to push the completion through task_work at that point, as w=
e can't
> >>>>>>> do it from the completion side. That's not a lot of overhead, and=
 most
> >>>>>>> notably, it's overhead that only affects this particular type.
> >>>>>>>
> >>>>>>> That's not a bad starting point, and something that can always be
> >>>>>>> optimized later if need be. But I seriously doubt it'd be anythin=
g to
> >>>>>>> worry about.
> >>>>>>
> >>>>>> I probably need to look myself how it's really scheduled, but if y=
ou don't
> >>>>>> mind, here is a quick question: if we do work_add(task) when the t=
ask is
> >>>>>> running in the userspace, wouldn't the work execution wait until t=
he next
> >>>>>> syscall/allotted time ends up?
> >>>>>
> >>>>> It'll get the task to enter the kernel, just like signal delivery. =
The only
> >>>>> tricky part is really if we have a dependency waiting in the kernel=
, like
> >>>>> the recent eventfd fix.
> >>>>
> >>>> I see, thanks for sorting this out!
> >>>
> >>> Few more doubts about this (please mark me wrong if that is the case)=
:
> >>>
> >>> - Task-work makes me feel like N completions waiting to be served by
> >>> single task.
> >>> Currently completions keep arriving and CQEs would be updated with
> >>> result, but the user-space (submitter task) would not be poked.
> >>>
> >>> - Completion-code will set the task-work. But post that it cannot go
> >>> immediately to its regular business of picking cqe and updating
> >>> res/flags, as we cannot afford user-space to see the cqe before the
> >>> pointer update. So it seems completion-code needs to spawn another
> >>> work which will allocate/update cqe after waiting for pointer-update
> >>> from task-work?
> >>
> >> The task work would post the completion CQE for the request after
> >> writing the offset.
> >
> > Got it, thank you for making it simple.
> > Overall if I try to put the tradeoffs of moving to indirect-offset
> > (compared to current scheme)=E2=80=93
> >
> > Upside:
> > - cqe res/flags would be intact, avoids future-headaches as you mention=
ed
> > - short-write cases do not have to be failed in lower-layers (as
> > cqe->res is there to report bytes-copied)
>
> I personally think it is a super bad idea to allow short asynchronous app=
end
> writes. The interface should allow the async zone append write to proceed=
 only
> and only if it can be stuffed entirely into a single BIO which necessaril=
ly will
> be a single request on the device side. Otherwise, the application would =
have no
> guarantees as to where a split may happen, and since this is zone append,=
 the
> next async append will not leave any hole to complete a previous short wr=
ite.
> This will wreak the structure of the application data.
>
> For the sync case, this is fine. The application can just issue a new app=
end
> write with the remaining unwritten data from the previous append write. B=
ut in
> the async case, if one write =3D=3D one data record (e.g. a key-value tup=
le for an
> SSTable in an LSM tree), then allowing a short write will destroy the rec=
ord:
> the partial write will be garbage data that will need garbage collection.=
..

There are cases when short-write is fine, isn't it? For example I can
serve only 8K write (either because of space, or because of those file
limits), but application sent 12K.....iov_iter_gets truncated to 8K
and the write is successful. At least that's what O_APPEND and
RWF_APPEND behaves currently.
But in the current scheme there is no way to report number-of-bytes
copied in io-uring, so I had to fail such short-write in lower-layer
(which does not know whether it is talking to io_uring or aio).
Failing such short-write is perhaps fine for zone-appened, but is it
fine for generic file-append?

> > Downside:
> > - We may not be able to use RWF_APPEND, and need exposing a new
> > type/flag (RWF_INDIRECT_OFFSET etc.) user-space. Not sure if this
> > sounds outrageous, but is it OK to have uring-only flag which can be
> > combined with RWF_APPEND?
>
> Why ? Where is the problem ? O_APPEND/RWF_APPEND is currently meaningless=
 for
> raw block device accesses. We could certainly define a meaning for these =
in the
> context of zoned block devices.
But application using O_APPEND/RWF_APPEND does not pass a pointer to
be updated by kernel.
While in kernel we would expect that, and may start writing something
which is not a pointer.

> I already commented on the need for first defining an interface (flags et=
c) and
> its semantic (e.g. do we allow short zone append or not ? What happens fo=
r
> regular files ? etc). Did you read my comment ? We really need to first a=
gree on
> something to clarify what needs to be done.

I read and was planning to respond, sorry. But it seemed important to
get the clarity on the uring-interface, as this seems to decide how
this whole thing looks like (to application and to lower layers as
well).

> > -  Expensive compared to sending results in cqe itself. But I agree
> > that this may not be major, and only for one type of write.
> >
> >
>
>
> --
> Damien Le Moal
> Western Digital Research



--=20
Joshi
