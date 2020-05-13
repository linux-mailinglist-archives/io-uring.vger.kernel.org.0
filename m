Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 713EC1D179F
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 16:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388753AbgEMOby (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 10:31:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728345AbgEMOby (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 10:31:54 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB7F2C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 07:31:52 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id n14so17501515qke.8
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 07:31:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9W9QX8uSlEIM9qv3LBbvEqJJOqp4wl6zUKonHdYYAx4=;
        b=nxT920WSuY60DPC6H/Sg1VfklDjO1OTLbFpAzahEHeiGveo5/BlP5iaQF0eHpz8FDG
         jD8FZcLTkRA5WamyhRC7DOlazb1zpqannfdHlJjokB2RLdl3RaIA9hx2GVUfK2df7o5J
         4hmatGAE6zGIcJSBS5GYZoZR29N60CY9+uebU7cD1rYaHMSvgHMagvoH6UW/5nDBOXbl
         iC58q1JpK4st9zV8FIHi40jA+dHL0rHu4xwyS9CSuFy1kJTVXqAXJa7C8Ic+Q9sbLxDa
         URHY3wEw4il8AMiolYw7O0bYaK5aemLn1wq7dKfDbqPECwLmhgeM02uG9vaeCZuS3/XZ
         cKjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9W9QX8uSlEIM9qv3LBbvEqJJOqp4wl6zUKonHdYYAx4=;
        b=HUlbs+Sp/sfgKsQqRsElBYX5lwIHA7XL3wu4CWo/T+cWVK3ON/vFBXdZ9QaFX34WR7
         nKk4ZcKAFlA2QxF7aJu0zM5kDUkCIvUNb/lVv6qyZXDRe2tglGeLZnAm0c32XH768Jo5
         9XfV8p6T78jN57x6xH70YZnjxHdt10CQKF+oymwLPrLfp/HI71bQpKB+9pCTJKIHy0TM
         apHy3q6Ug79zycm1RkYlTL6Ni3u3bM12lLUhllSTfyxQl3RJcAy6J3oB2cYWpVromGcm
         JP/MUZpwvW26Swp6RKKlgIi4g1bzXaXHjHKWfA9zGoG4JvMei+Aerc5VdVhSDM7kbjG+
         Ulcg==
X-Gm-Message-State: AGi0PubgrXB1OUacBJWw4yt+5DhguNgiozuzezIWaMO5q0NivnuMDVZx
        S2+ld0bj9K4tUklWr3dQ5g06dvTXSbx6PxjEFHO8osQ=
X-Google-Smtp-Source: APiQypL4eYpVaTbp9uuUahooyp3b3xTPOdM43eEpjPIiB3C6ozvt90gAqtCm0shDZTGkdZldrN90Uedz3ThtE0LR3Q4=
X-Received: by 2002:a37:4e11:: with SMTP id c17mr15891409qkb.25.1589380311777;
 Wed, 13 May 2020 07:31:51 -0700 (PDT)
MIME-Version: 1.0
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com> <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com> <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
 <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com> <CAO5MNut+nD-OqsKgae=eibWYuPim1f8-NuwqVpD87eZQnrwscA@mail.gmail.com>
 <CADPKF+dR=uQx9Dnu83ADghgei4KxwqnfBwONvp-ou--aePq0xg@mail.gmail.com>
In-Reply-To: <CADPKF+dR=uQx9Dnu83ADghgei4KxwqnfBwONvp-ou--aePq0xg@mail.gmail.com>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 13 May 2020 17:31:17 +0300
Message-ID: <CADPKF+fW3Yj28PAWBqUO8s9ztkU9sRzTLsLXeh0qgUhE8oWzDg@mail.gmail.com>
Subject: Re: Any performance gains from using per thread(thread local) urings?
To:     Sergiy Yevtushenko <sergiy.yevtushenko@gmail.com>
Cc:     Mark Papadakis <markuspapadakis@icloud.com>,
        "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

> Sharing state should be avoided as much as possible.

Its more about freely moving state between threads (like using
io_uring_cqe::user_data), not sharing...

On Wed, May 13, 2020 at 5:22 PM Dmitry Sychov <dmitry.sychov@gmail.com> wro=
te:
>
> Anyone could shed some light on the inner implementation of uring please?=
 :)
>
> Specifically how well kernel scales with the increased number of user
> created urings?
>
> > If kernel implementation will change from single to multiple queues,
> > user space is already prepared for this change.
>
> Thats +1 for per-thread urings. An expectation for the kernel to
> become better and better in multiple urings scaling in the future.
>
> On Wed, May 13, 2020 at 4:52 PM Sergiy Yevtushenko
> <sergiy.yevtushenko@gmail.com> wrote:
> >
> > Completely agree. Sharing state should be avoided as much as possible.
> > Returning to original question: I believe that uring-per-thread scheme =
is better regardless from how queue is managed inside the kernel.
> > - If there is only one queue inside the kernel, then it's more efficien=
t to perform multiplexing/demultiplexing requests in kernel space
> > - If there are several queues inside the kernel, then user space code b=
etter matches kernel-space code.
> > - If kernel implementation will change from single to multiple queues, =
user space is already prepared for this change.
> >
> >
> > On Wed, May 13, 2020 at 3:30 PM Mark Papadakis <markuspapadakis@icloud.=
com> wrote:
> >>
> >>
> >>
> >> > On 13 May 2020, at 4:15 PM, Dmitry Sychov <dmitry.sychov@gmail.com> =
wrote:
> >> >
> >> > Hey Mark,
> >> >
> >> > Or we could share one SQ and one CQ between multiple threads(bound b=
y
> >> > the max number of CPU cores) for direct read/write access using very
> >> > light mutex to sync.
> >> >
> >> > This also solves threads starvation issue  - thread A submits the jo=
b
> >> > into shared SQ while thread B both collects and _processes_ the resu=
lt
> >> > from the shared CQ instead of waiting on his own unique CQ for next
> >> > completion event.
> >> >
> >>
> >>
> >> Well, if the SQ submitted by A and its matching CQ is consumed by B, a=
nd A will need access to that CQ because it is tightly coupled to state it =
owns exclusively(for example), or other reasons, then you=E2=80=99d still n=
eed to move that CQ from B back to A, or share it somehow, which seems expe=
nsive-is.
> >>
> >> It depends on what kind of roles your threads have though; I am person=
ally very much against sharing state between threads unless there a really =
good reason for it.
> >>
> >>
> >>
> >>
> >>
> >>
> >> > On Wed, May 13, 2020 at 2:56 PM Mark Papadakis
> >> > <markuspapadakis@icloud.com> wrote:
> >> >>
> >> >> For what it=E2=80=99s worth, I am (also) using using multiple =E2=
=80=9Creactor=E2=80=9D (i.e event driven) cores, each associated with one O=
S thread, and each reactor core manages its own io_uring context/queues.
> >> >>
> >> >> Even if scheduling all SQEs through a single io_uring SQ =E2=80=94 =
by e.g collecting all such SQEs in every OS thread and then somehow =E2=80=
=9Cmoving=E2=80=9D them to the one OS thread that manages the SQ so that it=
 can enqueue them all -- is very cheap, you =E2=80=98d still need to drain =
the CQ from that thread and presumably process those CQEs in a single OS th=
read, which will definitely be more work than having each reactor/OS thread=
 dequeue CQEs for SQEs that itself submitted.
> >> >> You could have a single OS thread just for I/O and all other thread=
s could do something else but you=E2=80=99d presumably need to serialize ac=
cess/share state between them and the one OS thread for I/O which maybe a s=
calability bottleneck.
> >> >>
> >> >> ( if you are curious, you can read about it here https://medium.com=
/@markpapadakis/building-high-performance-services-in-2020-e2dea272f6f6 )
> >> >>
> >> >> If you experiment with the various possible designs though, I=E2=80=
=99d love it if you were to share your findings.
> >> >>
> >> >> =E2=80=94
> >> >> @markpapapdakis
> >> >>
> >> >>
> >> >>> On 13 May 2020, at 2:01 PM, Dmitry Sychov <dmitry.sychov@gmail.com=
> wrote:
> >> >>>
> >> >>> Hi Hielke,
> >> >>>
> >> >>>> If you want max performance, what you generally will see in non-b=
locking servers is one event loop per core/thread.
> >> >>>> This means one ring per core/thread. Of course there is no simple=
 answer to this.
> >> >>>> See how thread-based servers work vs non-blocking servers. E.g. A=
pache vs Nginx or Tomcat vs Netty.
> >> >>>
> >> >>> I think a lot depends on the internal uring implementation. To wha=
t
> >> >>> degree the kernel is able to handle multiple urings independently,
> >> >>> without much congestion points(like updates of the same memory
> >> >>> locations from multiple threads), thus taking advantage of one rin=
g
> >> >>> per CPU core.
> >> >>>
> >> >>> For example, if the tasks from multiple rings are later combined i=
nto
> >> >>> single input kernel queue (effectively forming a congestion point)=
 I
> >> >>> see
> >> >>> no reason to use exclusive ring per core in user space.
> >> >>>
> >> >>> [BTW in Windows IOCP is always one input+output queue for all(acti=
ve) threads].
> >> >>>
> >> >>> Also we could pop out multiple completion events from a single CQ =
at
> >> >>> once to spread the handling to cores-bound threads .
> >> >>>
> >> >>> I thought about one uring per core at first, but now I'am not sure=
 -
> >> >>> maybe the kernel devs have something to add to the discussion?
> >> >>>
> >> >>> P.S. uring is the main reason I'am switching from windows to linux=
 dev
> >> >>> for client-sever app so I want to extract the max performance poss=
ible
> >> >>> out of this new exciting uring stuff. :)
> >> >>>
> >> >>> Thanks, Dmitry
> >> >>
> >>
