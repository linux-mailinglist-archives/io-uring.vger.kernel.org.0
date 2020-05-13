Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 633C01D1661
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 15:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726061AbgEMNsj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 09:48:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387802AbgEMNsi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 09:48:38 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BEF9C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 06:48:38 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id v4so13234916qte.3
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 06:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lBOqRGgNr9ZQdjq38+327F9TAjeFjFTKbtSYjfSGnSc=;
        b=X2FRZOypO2/bJZUkMx0lX+3DOETCb28VJGqEk0vS80MTsBHMS8C3fjOdQbL0XdYZrq
         1GDoMmZQuPFye+kNceWmLoyoy5Vbn268SsjJC+vpnxhBjEVg+lN9gyThp4IjalOMLtGT
         C7/PAbGq4QES1FGCtXJu/eKIQBJ8wrORlrRTcLOveUvwKLPR+WR24ZSzjc+/VpCFjNIx
         xIdFMRgzI04OachtF31kjvs0oQd3ypI/wCSQoEQWNiNmKMlREL8Rl5lmQh99E1BeNtno
         SzeFdlolk4jL92XOxmInh07rxQD7rfysMfi82AKeS6JfzJkGrGBgJNWQScBwwG3f9P6K
         58HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lBOqRGgNr9ZQdjq38+327F9TAjeFjFTKbtSYjfSGnSc=;
        b=i5P8kLPoD9SlJajBkFmXm5Ds7yCcrzofdY67aGuAO1Zu2p14hBWx+wBwt+yMIkjiUc
         NMLjhhW8L5OIZ72p1HgtYMESTjNo9VPJJfuY0Jtcf5AnOr/aKwKTUVfskiHPAgYyz8Hf
         ybZM81lputUXFbn9N1II6yp3xn82gKfT0qbPHYtztJOZuRbMYO+NSZ+/2VUKi8KHriGN
         wNP/nr+2NgtY1tFNhNvDem+wERyt+TLHUN5DIW6L3X3YUTMjLoKqE6urgtU91qB4p+t7
         7Mr9WAJH7wSTEYrMPkUSpaSep4baH1DYoPVah5VZV3X2FFTCE+fl+5JENIk0rVCfuLkY
         /CBA==
X-Gm-Message-State: AOAM533hH5Yt8V+b6zPcq23KUgScAukcsiLCGwzNUQAsMJ2IO7ZYuEiS
        LzMywkk2whjE5/4hhFgBWFtYmdNGRuTddke031Lr2T0=
X-Google-Smtp-Source: ABdhPJxqBNBGO+qqVUSRSR4fWNryo4Ei90xZxeRTJ8phPb+r/S3cDoVyuBbT3uWTfdc9h51OhhtT3D/9rgeoSQUS3JQ=
X-Received: by 2002:aed:3c0d:: with SMTP id t13mr2462607qte.137.1589377717579;
 Wed, 13 May 2020 06:48:37 -0700 (PDT)
MIME-Version: 1.0
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com> <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com> <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
 <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com>
In-Reply-To: <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 13 May 2020 16:48:03 +0300
Message-ID: <CADPKF+d2cczCuMJCxufVwCiZp0+GZrP0ujLQcEusBNFXL+aijQ@mail.gmail.com>
Subject: Re: Any performance gains from using per thread(thread local) urings?
To:     Mark Papadakis <markuspapadakis@icloud.com>
Cc:     "H. de Vries" <hdevries@fastmail.com>,
        io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Yep, I want for all states to be uncoupled from threads - its more
about moving unique state from one thread(core) to another for
processing, only SQ+CQ are shared between cores-bound threads.

> I am personally very much against sharing state between threads unless th=
ere a really good reason for it.

Yeah, I understand, but for max performance we should start to think
about states as independent from threads entities or whats the reason
to use uring for max performance at first place - we could as well
stuck to very poor Apache model(unbound number of threads with coupled
states).

On Wed, May 13, 2020 at 4:27 PM Mark Papadakis
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
