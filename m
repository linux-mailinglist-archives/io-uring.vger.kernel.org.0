Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C028A1D1737
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 16:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388395AbgEMOMY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 10:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733142AbgEMOMX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 10:12:23 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24ED7C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 07:12:22 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id i68so14240703qtb.5
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 07:12:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kgpAkOKuV73O3J+83ga1OU8HKDQTilNC290qDKJ18/0=;
        b=fnyeloSaRFHfEjszW6BWoT41GR5GWkKm3lVsYBVqtw1P2jtqFtRr6tkYsIqpisGvdX
         D6G84cxEbopJwH6uIoVxOQqhdJDBZLXuTKJCgt7LPp42B37G3Aa+BoP7zA4wdSgtIZsD
         o9TxeYZqXcycYIgrCoVuqYxmA3v4rQIHvIvZZqJAL9dPqYTrwKGThgdPaA1AUXOTrDEK
         cloCPj3+DqpnttLMZoX4Nr5eljaztgU94HUNrblQX+IOqm7gvQ2mLzPFBGbwZCX/Cz5N
         IAfnNW4TbLSKMqnmB4eoYBf+Iudvfu5r6gRYxGHkoLdRoyjvZbQkk5Y24BeNHu+2FSHe
         Ljqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kgpAkOKuV73O3J+83ga1OU8HKDQTilNC290qDKJ18/0=;
        b=NJGUi8NeaOW0TIKau+1c2dZho1Fz3Icu9hb3UomPKdzB3yXzealXXHSXwdDr1NZh7D
         KCRS1Nc6V22LHXBoaWYSdMqp0aCc163QWqJnijbqmRVAQLA7oIhRB9UM97ef+3l6RBPv
         1g5/h2fIS9KjSPyNwarOGVuBt+rUa7I8ppGNhj5YPESOQzzNUkfudlYh1nDObCAFB0jW
         wPjkrd9PcmkKOrR4sI5csQWhYe62Hu0dPKae3fQgOh5Lfo95rjSaaM+PjqIND2WMRypN
         G0eoIinCASGVpGbCWGjZb7OXrL5nb1u53qOQfFDTWZNlu1Xq25OHFs4Jl9hjptYq4A3q
         /GAg==
X-Gm-Message-State: AGi0PuZviYNpSIlHxm+lwGFPZIJc2GGkqKFmr1EMVBPEwFHzLB4lXTfR
        yFN+FWqj0NFJL/fBlJxS7mXRiwAUjCeRj/if1F2+bu4LhHnvOw==
X-Google-Smtp-Source: APiQypJhz7OOHbowkJnR2F/ztvLQN8WDiI6e2pUfZ3mWcv+o38da9cS3UbpswFbjJQQ2zcHppwIBPFJn0uIaMPvxYLk=
X-Received: by 2002:ac8:2c44:: with SMTP id e4mr28951941qta.13.1589379141197;
 Wed, 13 May 2020 07:12:21 -0700 (PDT)
MIME-Version: 1.0
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com> <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com> <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
 <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com>
In-Reply-To: <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com>
From:   Sergiy Yevtushenko <sergiy.yevtushenko@gmail.com>
Date:   Wed, 13 May 2020 16:12:08 +0200
Message-ID: <CAO5MNusGPbxXw77g4Yf0hSGj2WZepZgOANWf3KunZhR8H06apw@mail.gmail.com>
Subject: Re: Any performance gains from using per thread(thread local) urings?
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     Dmitry Sychov <dmitry.sychov@gmail.com>,
        "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Completely agree. Sharing state should be avoided as much as possible.
Returning to original question: I believe that uring-per-thread scheme
is better regardless from how queue is managed inside the kernel.
- If there is only one queue inside the kernel, then it's more
efficient to perform multiplexing/demultiplexing requests in kernel
space
- If there are several queues inside the kernel, then user space code
better matches kernel-space code.
- If kernel implementation will change from single to multiple queues,
user space is already prepared for this change.


On Wed, May 13, 2020 at 3:30 PM Mark Papadakis
<markuspapadakis@icloud.com> wrote:
>
>
>
> > On 13 May 2020, at 4:15 PM, Dmitry Sychov <dmitry.sychov@gmail.com> wro=
te:
> >
> > Hey Mark,
> >
> > Or we could share one SQ and one CQ between multiple threads(bound by
> > the max number of CPU cores) for direct read/write access using very
> > light mutex to sync.
> >
> > This also solves threads starvation issue  - thread A submits the job
> > into shared SQ while thread B both collects and _processes_ the result
> > from the shared CQ instead of waiting on his own unique CQ for next
> > completion event.
> >
>
>
> Well, if the SQ submitted by A and its matching CQ is consumed by B, and =
A will need access to that CQ because it is tightly coupled to state it own=
s exclusively(for example), or other reasons, then you=E2=80=99d still need=
 to move that CQ from B back to A, or share it somehow, which seems expensi=
ve-is.
>
> It depends on what kind of roles your threads have though; I am personall=
y very much against sharing state between threads unless there a really goo=
d reason for it.
>
>
>
>
>
>
> > On Wed, May 13, 2020 at 2:56 PM Mark Papadakis
> > <markuspapadakis@icloud.com> wrote:
> >>
> >> For what it=E2=80=99s worth, I am (also) using using multiple =E2=80=
=9Creactor=E2=80=9D (i.e event driven) cores, each associated with one OS t=
hread, and each reactor core manages its own io_uring context/queues.
> >>
> >> Even if scheduling all SQEs through a single io_uring SQ =E2=80=94 by =
e.g collecting all such SQEs in every OS thread and then somehow =E2=80=9Cm=
oving=E2=80=9D them to the one OS thread that manages the SQ so that it can=
 enqueue them all -- is very cheap, you =E2=80=98d still need to drain the =
CQ from that thread and presumably process those CQEs in a single OS thread=
, which will definitely be more work than having each reactor/OS thread deq=
ueue CQEs for SQEs that itself submitted.
> >> You could have a single OS thread just for I/O and all other threads c=
ould do something else but you=E2=80=99d presumably need to serialize acces=
s/share state between them and the one OS thread for I/O which maybe a scal=
ability bottleneck.
> >>
> >> ( if you are curious, you can read about it here https://medium.com/@m=
arkpapadakis/building-high-performance-services-in-2020-e2dea272f6f6 )
> >>
> >> If you experiment with the various possible designs though, I=E2=80=99=
d love it if you were to share your findings.
> >>
> >> =E2=80=94
> >> @markpapapdakis
> >>
> >>
> >>> On 13 May 2020, at 2:01 PM, Dmitry Sychov <dmitry.sychov@gmail.com> w=
rote:
> >>>
> >>> Hi Hielke,
> >>>
> >>>> If you want max performance, what you generally will see in non-bloc=
king servers is one event loop per core/thread.
> >>>> This means one ring per core/thread. Of course there is no simple an=
swer to this.
> >>>> See how thread-based servers work vs non-blocking servers. E.g. Apac=
he vs Nginx or Tomcat vs Netty.
> >>>
> >>> I think a lot depends on the internal uring implementation. To what
> >>> degree the kernel is able to handle multiple urings independently,
> >>> without much congestion points(like updates of the same memory
> >>> locations from multiple threads), thus taking advantage of one ring
> >>> per CPU core.
> >>>
> >>> For example, if the tasks from multiple rings are later combined into
> >>> single input kernel queue (effectively forming a congestion point) I
> >>> see
> >>> no reason to use exclusive ring per core in user space.
> >>>
> >>> [BTW in Windows IOCP is always one input+output queue for all(active)=
 threads].
> >>>
> >>> Also we could pop out multiple completion events from a single CQ at
> >>> once to spread the handling to cores-bound threads .
> >>>
> >>> I thought about one uring per core at first, but now I'am not sure -
> >>> maybe the kernel devs have something to add to the discussion?
> >>>
> >>> P.S. uring is the main reason I'am switching from windows to linux de=
v
> >>> for client-sever app so I want to extract the max performance possibl=
e
> >>> out of this new exciting uring stuff. :)
> >>>
> >>> Thanks, Dmitry
> >>
>
