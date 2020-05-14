Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A473D1D2E66
	for <lists+io-uring@lfdr.de>; Thu, 14 May 2020 13:35:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726050AbgENLfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 14 May 2020 07:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbgENLfr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 14 May 2020 07:35:47 -0400
Received: from mail-qv1-xf29.google.com (mail-qv1-xf29.google.com [IPv6:2607:f8b0:4864:20::f29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 553BDC061A0C
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 04:35:47 -0700 (PDT)
Received: by mail-qv1-xf29.google.com with SMTP id g20so1462545qvb.9
        for <io-uring@vger.kernel.org>; Thu, 14 May 2020 04:35:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=/zElGm2zfL/kwgR8uLI36cmipyNAnQaRgwqOApvAPT0=;
        b=Yl/V2FMFpX4quZBshyLTLa8m+wD7iYY52BLGCY8vBIybY3uHnVajeXTl+lBhGxchak
         Kqh29QplIllcm1HMXjw981Aj8F5O0gH+m4h82kBr437p4nLST0QsZFZDkkKQf1pxrcXE
         3MbL2j5Y/1nU273OcRxFkJmHAtV/ZG3Hnn64xN5czd4JfouXEd6uXVwpFTr2SbSSheLf
         F/OnWVuxD2FbI0nM3MCuwOAvkmj6uCu8Dw8mkGA2dTxp39S/g8PtpKlz65nhgXEVctkj
         V2I97B7A/zk2h39NdQhO78tmj4WQjhBKT1dQmxkXEXIwt868DCFck0yN6kyVJ3va2Rg5
         3r/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=/zElGm2zfL/kwgR8uLI36cmipyNAnQaRgwqOApvAPT0=;
        b=PVuuoR1gZjP1PpIpHDddqEeEW+Tl2dKZC8FHUPs8j275puY8zoSFIqoWE1kPTi/UWv
         RgISkG1a82bkiwVkYiB9Q1EUnSRNYWmc2X+8Ia544/lZHkDcEsnwzKWctvIZqcwIlhBT
         bljBv2xmTmP959a+a4sMr7WTOsxdqeqi1fmJ8RAnMsxQ2+/Lqsglkaa4eFC2fEEEsDB9
         URHJrS+bIfa1BY/rPFY2Chj15ewFb8LoGml93hum4ZpYZhKdLAPn3MrAckTKCUC2XE5o
         2Jg+sIiE3vUJUPwQ9hfYyFX8nFskmrUXNYfdCcnZoVE5Q2d0WFxfz4C2TYL5h2FXWkfw
         kSrA==
X-Gm-Message-State: AOAM531mMgoFVtTSm7YLkR8ioSt3qbU0V6kDasqT4zonza7MkW6ujRBp
        ZUzdGpRRcUHP9NqXleAJUDIf1iB32AIw59GcEgiK7AI=
X-Google-Smtp-Source: ABdhPJxPA497SMlJ9w46wXlyuDbKe6m4a+6bmLMsYjoXYgUtJnr9QhRxVhA6WiW97/3Ac4AKUJuKs0xZP3zluZsj+W8=
X-Received: by 2002:a05:6214:1334:: with SMTP id c20mr4316610qvv.183.1589456146371;
 Thu, 14 May 2020 04:35:46 -0700 (PDT)
MIME-Version: 1.0
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com> <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com> <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
 <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com> <CAO5MNut+nD-OqsKgae=eibWYuPim1f8-NuwqVpD87eZQnrwscA@mail.gmail.com>
 <CADPKF+dR=uQx9Dnu83ADghgei4KxwqnfBwONvp-ou--aePq0xg@mail.gmail.com>
 <c66f786b-999b-de45-ce18-f6a2df0e7d8c@gmail.com> <CADPKF+fGMYHDMdtWzuujyUqwBGJounsn3RsxgVVGaPDeLj_3TQ@mail.gmail.com>
 <ed95db2a-246b-f968-38eb-b9394b95938a@gmail.com>
In-Reply-To: <ed95db2a-246b-f968-38eb-b9394b95938a@gmail.com>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Thu, 14 May 2020 14:35:12 +0300
Message-ID: <CADPKF+ed9hqL=2Pgjo4mn6QBjO4Z3UzPm9J_zPaVBLrJkzu+_Q@mail.gmail.com>
Subject: Re: Any performance gains from using per thread(thread local) urings?
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Sergiy Yevtushenko <sergiy.yevtushenko@gmail.com>,
        Mark Papadakis <markuspapadakis@icloud.com>,
        "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> If I parsed the question correctly, again, it creates a separate
> thread pool per each new io_uring, if wasn't specified otherwise.

Aha, got it - finally found IORING_SETUP_ATTACH_WQ flag desc :)

Whats the default number of threads in a pool? Is it fixed or depends
on the number of system CPU cores?

> Not sure what kind of starvation you meant, but feel free to rephrase you=
r
> questions if any of them weren't understood well.

Starvation problem arises when for example one uring becomes
overloaded with pending tasks while another is already empty
and the only way to mitigate the stall is to have all worker flows to
check all other urings(steal jobs from each other)... or to use one
shared uring at first place.

With the increasing number of urings the cost of checking other queues
increases leading to suppressed scaling.

Same thing happens on consumer side. If I'am using states decoupled
from threads and submit(move) them(states) to random urings from a
uring pool I have
to check all other CQs for completed work if the CQ currently
associated with my CPU thread is empty.

> FWIW, atomics/wait-free will fail to scale good enough after some point.

Yep... in general shared between multiple cores memory updates
suppress scalability up to zero gains after like first hundred of cpu
threads.

There was a paper somewhere that even having a one shared counter
between 100+ threads already blocks the scaling completely further
and wait-free containers are almost the same sources for mem bouncing
as write shared data...

On Thu, May 14, 2020 at 1:08 PM Pavel Begunkov <asml.silence@gmail.com> wro=
te:
>
> On 13/05/2020 22:23, Dmitry Sychov wrote:
> >> E.g. 100+ cores hammering on a spinlock/mutex protecting an SQ wouldn'=
t do any good.
> >
> > Its possible to mitigate the hammering by using proxy buffer - instead
> > of spinning, the particular thread
> > could add the next entry into the buffer through XADD instead, and
> > another thread currently holding an exclusive
> > lock could in turn check this buffer and batch-submit all pending
> > entries to SQ before leasing SQ mutex.
>
> Sure there are many ways, but I think my point is clear.
> FWIW, atomics/wait-free will fail to scale good enough after some point.
>
> >> will be offloaded to an internal thread pool (aka io-wq), which is per=
 io_uring by default, but can be shared if specified.
> >
> > Well, thats sounds like mumbo jumbo to me, does this mean that the
> > kernel holds and internal pool of threads to
> > perform uring tasks independent to the number of user urings?
>
> If I parsed the question correctly, again, it creates a separate thread p=
ool per
> each new io_uring, if wasn't specified otherwise.
>
> >
> > If there are multiple kernel work flows bound to corresponding uring
> > setups the issue with threads starvation could exist if they do not
> > actively steal from each other SQs.
> The threads can go to sleep or be dynamically created/destroyed.
>
> Not sure what kind of starvation you meant, but feel free to rephrase you=
r
> questions if any of them weren't understood well.
>
> > And starvation costs could be greater than allowing for multiple
> > threads to dig into one uring queue, even under the exclusive lock.
> Thread pools can be shared.
>
> >
> >> And there a lot of details, probably worth of a separate write-up.
> >
> > I've reread io_uring.pdf and there are not much tech details on the
> > inner implementation of uring to try to apply best practices and to
> > avoid noob questions like mine.
> >
> >
> >
> > On Wed, May 13, 2020 at 7:03 PM Pavel Begunkov <asml.silence@gmail.com>=
 wrote:
> >>
> >> On 13/05/2020 17:22, Dmitry Sychov wrote:
> >>> Anyone could shed some light on the inner implementation of uring ple=
ase? :)
> >>
> >> It really depends on the workload, hardware, etc.
> >>
> >> io_uring instances are intended to be independent, and each have one C=
Q and SQ.
> >> The main user's concern should be synchronisation (in userspace) on CQ=
+SQ. E.g.
> >> 100+ cores hammering on a spinlock/mutex protecting an SQ wouldn't do =
any good.
> >>
> >> Everything that can't be inline completed\submitted during io_urng_ent=
er(), will
> >> be offloaded to an internal thread pool (aka io-wq), which is per io_u=
ring by
> >> default, but can be shared if specified. There are pros and cons, but =
I'd
> >> recommend first to share a single io-wq, and then experiment and tune.
> >>
> >> Also, in-kernel submission is not instantaneous and done by only threa=
d at any
> >> moment. Single io_uring may bottleneck you there or add high latency i=
n some cases.
> >>
> >> And there a lot of details, probably worth of a separate write-up.
> >>
> >>>
> >>> Specifically how well kernel scales with the increased number of user
> >>> created urings?
> >>
> >> Should scale well, especially for rw. Just don't overthrow the kernel =
with
> >> threads from dozens of io-wqs.
> >>
> >>>
> >>>> If kernel implementation will change from single to multiple queues,
> >>>> user space is already prepared for this change.
> >>>
> >>> Thats +1 for per-thread urings. An expectation for the kernel to
> >>> become better and better in multiple urings scaling in the future.
> >>>
> >>> On Wed, May 13, 2020 at 4:52 PM Sergiy Yevtushenko
> >>> <sergiy.yevtushenko@gmail.com> wrote:
> >>>>
> >>>> Completely agree. Sharing state should be avoided as much as possibl=
e.
> >>>> Returning to original question: I believe that uring-per-thread sche=
me is better regardless from how queue is managed inside the kernel.
> >>>> - If there is only one queue inside the kernel, then it's more effic=
ient to perform multiplexing/demultiplexing requests in kernel space
> >>>> - If there are several queues inside the kernel, then user space cod=
e better matches kernel-space code.
> >>>> - If kernel implementation will change from single to multiple queue=
s, user space is already prepared for this change.
> >>>>
> >>>>
> >>>> On Wed, May 13, 2020 at 3:30 PM Mark Papadakis <markuspapadakis@iclo=
ud.com> wrote:
> >>>>>
> >>>>>
> >>>>>
> >>>>>> On 13 May 2020, at 4:15 PM, Dmitry Sychov <dmitry.sychov@gmail.com=
> wrote:
> >>>>>>
> >>>>>> Hey Mark,
> >>>>>>
> >>>>>> Or we could share one SQ and one CQ between multiple threads(bound=
 by
> >>>>>> the max number of CPU cores) for direct read/write access using ve=
ry
> >>>>>> light mutex to sync.
> >>>>>>
> >>>>>> This also solves threads starvation issue  - thread A submits the =
job
> >>>>>> into shared SQ while thread B both collects and _processes_ the re=
sult
> >>>>>> from the shared CQ instead of waiting on his own unique CQ for nex=
t
> >>>>>> completion event.
> >>>>>>
> >>>>>
> >>>>>
> >>>>> Well, if the SQ submitted by A and its matching CQ is consumed by B=
, and A will need access to that CQ because it is tightly coupled to state =
it owns exclusively(for example), or other reasons, then you=E2=80=99d stil=
l need to move that CQ from B back to A, or share it somehow, which seems e=
xpensive-is.
> >>>>>
> >>>>> It depends on what kind of roles your threads have though; I am per=
sonally very much against sharing state between threads unless there a real=
ly good reason for it.
> >>>>>
> >>>>>
> >>>>>
> >>>>>
> >>>>>
> >>>>>
> >>>>>> On Wed, May 13, 2020 at 2:56 PM Mark Papadakis
> >>>>>> <markuspapadakis@icloud.com> wrote:
> >>>>>>>
> >>>>>>> For what it=E2=80=99s worth, I am (also) using using multiple =E2=
=80=9Creactor=E2=80=9D (i.e event driven) cores, each associated with one O=
S thread, and each reactor core manages its own io_uring context/queues.
> >>>>>>>
> >>>>>>> Even if scheduling all SQEs through a single io_uring SQ =E2=80=
=94 by e.g collecting all such SQEs in every OS thread and then somehow =E2=
=80=9Cmoving=E2=80=9D them to the one OS thread that manages the SQ so that=
 it can enqueue them all -- is very cheap, you =E2=80=98d still need to dra=
in the CQ from that thread and presumably process those CQEs in a single OS=
 thread, which will definitely be more work than having each reactor/OS thr=
ead dequeue CQEs for SQEs that itself submitted.
> >>>>>>> You could have a single OS thread just for I/O and all other thre=
ads could do something else but you=E2=80=99d presumably need to serialize =
access/share state between them and the one OS thread for I/O which maybe a=
 scalability bottleneck.
> >>>>>>>
> >>>>>>> ( if you are curious, you can read about it here https://medium.c=
om/@markpapadakis/building-high-performance-services-in-2020-e2dea272f6f6 )
> >>>>>>>
> >>>>>>> If you experiment with the various possible designs though, I=E2=
=80=99d love it if you were to share your findings.
> >>>>>>>
> >>>>>>> =E2=80=94
> >>>>>>> @markpapapdakis
> >>>>>>>
> >>>>>>>
> >>>>>>>> On 13 May 2020, at 2:01 PM, Dmitry Sychov <dmitry.sychov@gmail.c=
om> wrote:
> >>>>>>>>
> >>>>>>>> Hi Hielke,
> >>>>>>>>
> >>>>>>>>> If you want max performance, what you generally will see in non=
-blocking servers is one event loop per core/thread.
> >>>>>>>>> This means one ring per core/thread. Of course there is no simp=
le answer to this.
> >>>>>>>>> See how thread-based servers work vs non-blocking servers. E.g.=
 Apache vs Nginx or Tomcat vs Netty.
> >>>>>>>>
> >>>>>>>> I think a lot depends on the internal uring implementation. To w=
hat
> >>>>>>>> degree the kernel is able to handle multiple urings independentl=
y,
> >>>>>>>> without much congestion points(like updates of the same memory
> >>>>>>>> locations from multiple threads), thus taking advantage of one r=
ing
> >>>>>>>> per CPU core.
> >>>>>>>>
> >>>>>>>> For example, if the tasks from multiple rings are later combined=
 into
> >>>>>>>> single input kernel queue (effectively forming a congestion poin=
t) I
> >>>>>>>> see
> >>>>>>>> no reason to use exclusive ring per core in user space.
> >>>>>>>>
> >>>>>>>> [BTW in Windows IOCP is always one input+output queue for all(ac=
tive) threads].
> >>>>>>>>
> >>>>>>>> Also we could pop out multiple completion events from a single C=
Q at
> >>>>>>>> once to spread the handling to cores-bound threads .
> >>>>>>>>
> >>>>>>>> I thought about one uring per core at first, but now I'am not su=
re -
> >>>>>>>> maybe the kernel devs have something to add to the discussion?
> >>>>>>>>
> >>>>>>>> P.S. uring is the main reason I'am switching from windows to lin=
ux dev
> >>>>>>>> for client-sever app so I want to extract the max performance po=
ssible
> >>>>>>>> out of this new exciting uring stuff. :)
> >>>>>>>>
> >>>>>>>> Thanks, Dmitry
> >>>>>>>
> >>>>>
> >>
> >> --
> >> Pavel Begunkov
>
> --
> Pavel Begunkov
