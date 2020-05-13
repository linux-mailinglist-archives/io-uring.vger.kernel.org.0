Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 493361D1F00
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 21:24:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390263AbgEMTYT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 15:24:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTYT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 15:24:19 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFFBBC061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 12:24:18 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id j2so779622qtr.12
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 12:24:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ZOfTY8R/u4rTnoEIrszPd7HIwzUpo5eTVkwRymhLJn4=;
        b=th0zMIQK8wvorrRRqzi+cFq6oAaSh9jZG1pJlJf2HsPZNq2ODIS25EuDElkMHl/Orq
         DFvh9xI+r4soWNaWFcI/p/p8P2aF/GhU039mv/Sb1qbS9njzES7aHZ89E2djxKyb3WZj
         gs6Nd4cbROZcdUXZU/fwb1YxHW6fHiZgRaL7l6/Jo5ONuurg4FdQLZab5Q2mfD6KJQYW
         72ZqLE/cQ7zaHW8tdsUr9XIXRQpOxqe9b1D19S+kts9vbKu+gdpx1G+ze9DBEOiQfqop
         +H/oNY59w9mH5giFY3qFehnx+/Qse32bV/j4U/aBXl5fIzqRmEkT9DGaik2HCOoeCv6s
         FvaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ZOfTY8R/u4rTnoEIrszPd7HIwzUpo5eTVkwRymhLJn4=;
        b=MaipDO+dDozjql9VZ5XqeM754Q4iaNWN7ToTaZbS8PnbmlnGpT5y4AxY/LkmBXRfKd
         kq9bUdPSbqa81tAMWewdC35paCAn8WssHG/QMQsv5mH623yMRq3RQG6/LUyfM09XzCB8
         23Hx67TPpREjyQPGLco59YbsEUxNX6YrWcIgHVj1LffTiPUC/Yi8bMJndHEHbLKlDyVR
         GjH1r6tEISxiTmouY7k28DH9tOjr7gLQkS9Tv5ps7xiKngW3FwTpU/KaZ7XhJqERH7cm
         EDAlsUEKR4QvFtVqozBNAGNRO/rMRMVAP0rcHIC103ypIeG6TYnxmSfTIfZ2lesP8+3B
         oLjw==
X-Gm-Message-State: AOAM530Ig3CPNK4/PzlyIHU+cJM1mZ1idiY/Bkr57nQn+J+dspdEVqiM
        duWUyeyWDl7UBwPt2cXdRNfn4x+m3CneYePavxh7KxE=
X-Google-Smtp-Source: ABdhPJyYBIK9kR4S2btytPsMaEq+lN03dVr0e1hm5VHT4FqPxr2PuAp5Xvvgv5VuCZr69sJdAbKbJfsOsi9pHr6y45I=
X-Received: by 2002:ac8:7b81:: with SMTP id p1mr701688qtu.305.1589397857984;
 Wed, 13 May 2020 12:24:17 -0700 (PDT)
MIME-Version: 1.0
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com> <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com> <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
 <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com> <CAO5MNut+nD-OqsKgae=eibWYuPim1f8-NuwqVpD87eZQnrwscA@mail.gmail.com>
 <CADPKF+dR=uQx9Dnu83ADghgei4KxwqnfBwONvp-ou--aePq0xg@mail.gmail.com> <c66f786b-999b-de45-ce18-f6a2df0e7d8c@gmail.com>
In-Reply-To: <c66f786b-999b-de45-ce18-f6a2df0e7d8c@gmail.com>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 13 May 2020 22:23:43 +0300
Message-ID: <CADPKF+fGMYHDMdtWzuujyUqwBGJounsn3RsxgVVGaPDeLj_3TQ@mail.gmail.com>
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

> E.g. 100+ cores hammering on a spinlock/mutex protecting an SQ wouldn't d=
o any good.

Its possible to mitigate the hammering by using proxy buffer - instead
of spinning, the particular thread
could add the next entry into the buffer through XADD instead, and
another thread currently holding an exclusive
lock could in turn check this buffer and batch-submit all pending
entries to SQ before leasing SQ mutex.

> will be offloaded to an internal thread pool (aka io-wq), which is per io=
_uring by default, but can be shared if specified.

Well, thats sounds like mumbo jumbo to me, does this mean that the
kernel holds and internal pool of threads to
perform uring tasks independent to the number of user urings?

If there are multiple kernel work flows bound to corresponding uring
setups the issue with threads starvation could exist if they do not
actively steal from each other SQs.

And starvation costs could be greater than allowing for multiple
threads to dig into one uring queue, even under the exclusive lock.

> And there a lot of details, probably worth of a separate write-up.

I've reread io_uring.pdf and there are not much tech details on the
inner implementation of uring to try to apply best practices and to
avoid noob questions like mine.



On Wed, May 13, 2020 at 7:03 PM Pavel Begunkov <asml.silence@gmail.com> wro=
te:
>
> On 13/05/2020 17:22, Dmitry Sychov wrote:
> > Anyone could shed some light on the inner implementation of uring pleas=
e? :)
>
> It really depends on the workload, hardware, etc.
>
> io_uring instances are intended to be independent, and each have one CQ a=
nd SQ.
> The main user's concern should be synchronisation (in userspace) on CQ+SQ=
. E.g.
> 100+ cores hammering on a spinlock/mutex protecting an SQ wouldn't do any=
 good.
>
> Everything that can't be inline completed\submitted during io_urng_enter(=
), will
> be offloaded to an internal thread pool (aka io-wq), which is per io_urin=
g by
> default, but can be shared if specified. There are pros and cons, but I'd
> recommend first to share a single io-wq, and then experiment and tune.
>
> Also, in-kernel submission is not instantaneous and done by only thread a=
t any
> moment. Single io_uring may bottleneck you there or add high latency in s=
ome cases.
>
> And there a lot of details, probably worth of a separate write-up.
>
> >
> > Specifically how well kernel scales with the increased number of user
> > created urings?
>
> Should scale well, especially for rw. Just don't overthrow the kernel wit=
h
> threads from dozens of io-wqs.
>
> >
> >> If kernel implementation will change from single to multiple queues,
> >> user space is already prepared for this change.
> >
> > Thats +1 for per-thread urings. An expectation for the kernel to
> > become better and better in multiple urings scaling in the future.
> >
> > On Wed, May 13, 2020 at 4:52 PM Sergiy Yevtushenko
> > <sergiy.yevtushenko@gmail.com> wrote:
> >>
> >> Completely agree. Sharing state should be avoided as much as possible.
> >> Returning to original question: I believe that uring-per-thread scheme=
 is better regardless from how queue is managed inside the kernel.
> >> - If there is only one queue inside the kernel, then it's more efficie=
nt to perform multiplexing/demultiplexing requests in kernel space
> >> - If there are several queues inside the kernel, then user space code =
better matches kernel-space code.
> >> - If kernel implementation will change from single to multiple queues,=
 user space is already prepared for this change.
> >>
> >>
> >> On Wed, May 13, 2020 at 3:30 PM Mark Papadakis <markuspapadakis@icloud=
.com> wrote:
> >>>
> >>>
> >>>
> >>>> On 13 May 2020, at 4:15 PM, Dmitry Sychov <dmitry.sychov@gmail.com> =
wrote:
> >>>>
> >>>> Hey Mark,
> >>>>
> >>>> Or we could share one SQ and one CQ between multiple threads(bound b=
y
> >>>> the max number of CPU cores) for direct read/write access using very
> >>>> light mutex to sync.
> >>>>
> >>>> This also solves threads starvation issue  - thread A submits the jo=
b
> >>>> into shared SQ while thread B both collects and _processes_ the resu=
lt
> >>>> from the shared CQ instead of waiting on his own unique CQ for next
> >>>> completion event.
> >>>>
> >>>
> >>>
> >>> Well, if the SQ submitted by A and its matching CQ is consumed by B, =
and A will need access to that CQ because it is tightly coupled to state it=
 owns exclusively(for example), or other reasons, then you=E2=80=99d still =
need to move that CQ from B back to A, or share it somehow, which seems exp=
ensive-is.
> >>>
> >>> It depends on what kind of roles your threads have though; I am perso=
nally very much against sharing state between threads unless there a really=
 good reason for it.
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>
> >>>> On Wed, May 13, 2020 at 2:56 PM Mark Papadakis
> >>>> <markuspapadakis@icloud.com> wrote:
> >>>>>
> >>>>> For what it=E2=80=99s worth, I am (also) using using multiple =E2=
=80=9Creactor=E2=80=9D (i.e event driven) cores, each associated with one O=
S thread, and each reactor core manages its own io_uring context/queues.
> >>>>>
> >>>>> Even if scheduling all SQEs through a single io_uring SQ =E2=80=94 =
by e.g collecting all such SQEs in every OS thread and then somehow =E2=80=
=9Cmoving=E2=80=9D them to the one OS thread that manages the SQ so that it=
 can enqueue them all -- is very cheap, you =E2=80=98d still need to drain =
the CQ from that thread and presumably process those CQEs in a single OS th=
read, which will definitely be more work than having each reactor/OS thread=
 dequeue CQEs for SQEs that itself submitted.
> >>>>> You could have a single OS thread just for I/O and all other thread=
s could do something else but you=E2=80=99d presumably need to serialize ac=
cess/share state between them and the one OS thread for I/O which maybe a s=
calability bottleneck.
> >>>>>
> >>>>> ( if you are curious, you can read about it here https://medium.com=
/@markpapadakis/building-high-performance-services-in-2020-e2dea272f6f6 )
> >>>>>
> >>>>> If you experiment with the various possible designs though, I=E2=80=
=99d love it if you were to share your findings.
> >>>>>
> >>>>> =E2=80=94
> >>>>> @markpapapdakis
> >>>>>
> >>>>>
> >>>>>> On 13 May 2020, at 2:01 PM, Dmitry Sychov <dmitry.sychov@gmail.com=
> wrote:
> >>>>>>
> >>>>>> Hi Hielke,
> >>>>>>
> >>>>>>> If you want max performance, what you generally will see in non-b=
locking servers is one event loop per core/thread.
> >>>>>>> This means one ring per core/thread. Of course there is no simple=
 answer to this.
> >>>>>>> See how thread-based servers work vs non-blocking servers. E.g. A=
pache vs Nginx or Tomcat vs Netty.
> >>>>>>
> >>>>>> I think a lot depends on the internal uring implementation. To wha=
t
> >>>>>> degree the kernel is able to handle multiple urings independently,
> >>>>>> without much congestion points(like updates of the same memory
> >>>>>> locations from multiple threads), thus taking advantage of one rin=
g
> >>>>>> per CPU core.
> >>>>>>
> >>>>>> For example, if the tasks from multiple rings are later combined i=
nto
> >>>>>> single input kernel queue (effectively forming a congestion point)=
 I
> >>>>>> see
> >>>>>> no reason to use exclusive ring per core in user space.
> >>>>>>
> >>>>>> [BTW in Windows IOCP is always one input+output queue for all(acti=
ve) threads].
> >>>>>>
> >>>>>> Also we could pop out multiple completion events from a single CQ =
at
> >>>>>> once to spread the handling to cores-bound threads .
> >>>>>>
> >>>>>> I thought about one uring per core at first, but now I'am not sure=
 -
> >>>>>> maybe the kernel devs have something to add to the discussion?
> >>>>>>
> >>>>>> P.S. uring is the main reason I'am switching from windows to linux=
 dev
> >>>>>> for client-sever app so I want to extract the max performance poss=
ible
> >>>>>> out of this new exciting uring stuff. :)
> >>>>>>
> >>>>>> Thanks, Dmitry
> >>>>>
> >>>
>
> --
> Pavel Begunkov
