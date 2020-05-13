Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 77B4F1D177B
	for <lists+io-uring@lfdr.de>; Wed, 13 May 2020 16:23:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388850AbgEMOXK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 May 2020 10:23:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388788AbgEMOXK (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 May 2020 10:23:10 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA679C061A0C
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 07:23:09 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id b6so16372075qkh.11
        for <io-uring@vger.kernel.org>; Wed, 13 May 2020 07:23:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=V/RLc20rbxqEllmYNKC8wSKErHz1ppBn5Gie9oqhi2A=;
        b=CXr1t1F4iRc64O2fJPIYMtP4zX7kljB6RlLSa+irYbIze7RSFXgXyApxA1rEOJ/i4e
         JP550t0ADeA4dcYNkmI4rVsXy4IRe/BZ9jOONslaOAQ/p8LPM7b1zPTuJPKF4Yp5SQGO
         CijZ8iqXGMKvPvMUKMFfSklt1UUGbNIwHX+fWfh5urrzRu9mLcmpaMnT6QHSNHHyxbxc
         yKH7JMaJarGj6SSwDJ6rx6J6cd+rtp7wY+zSk4senhhovZyWVqPUaYqzSbPyC32JIkDJ
         FN6KNYph0stVpGdGBlGoxS0Z4QG7L74fv/kSxOJC4Gc27zGInw/6yQqkv2wPdER1S1s0
         qD6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=V/RLc20rbxqEllmYNKC8wSKErHz1ppBn5Gie9oqhi2A=;
        b=ku7niHyyISMF1beRFxWOdQ5ux7EKyif3OLddiRPKNUgyO80U5QaMX9jQMK3z+Dwf2/
         UK+0zeDcp3ghSAlMMhu67foQbSkZap653rkzt5TpCnnWBu+kjakM4IZuUCGtR3I0xou3
         A380wQOnm4NMEr1ijGdNgVEWhNojIojuqAeSxGEUGF/EobpG6+zcOO7oWAG8rfFQcMpN
         acR7sO0SNxL8ICFPWejq/FNg35oihocFh9BaeiIiXQlNohRdc+OkwDAKvwPJ9T/BbPYc
         hUTUppBK+40Jv09h3YZqOZpoHgeJaZ06UFoWOEb6Pb7Om0Uk9P5MJLO1PdaWHgjaykir
         TBrw==
X-Gm-Message-State: AGi0PuY6vtM2FTXV5Rn3v4FzTpTDpl6woCE+y6wKg5Hsnp4Trfm1Le68
        5XqlsLRxYM8BW5jZ0mYH6NcnXResk5V+XIE2x4+8WUM+lK8m1oFN3A==
X-Google-Smtp-Source: APiQypIbLqbBs+uXng53ajzQkmx9PH5aAyEPmdEhDxm5ScrJ0A9PHc1pFfrHWNm6WYXRzhW7kOWZwtndXm5pgJFMXSM=
X-Received: by 2002:a37:a603:: with SMTP id p3mr25234579qke.133.1589379789122;
 Wed, 13 May 2020 07:23:09 -0700 (PDT)
MIME-Version: 1.0
References: <CADPKF+ene9LqKTFPUTwkdgbEe_pccZsJGjcm7cNmiq=8P_ojbA@mail.gmail.com>
 <d22e7619-3ff0-4cea-ba10-a05c2381f3b7@www.fastmail.com> <CADPKF+d1SJU9T+NFtqgRWwY3GJn1Wg06uNdSrVg_q837z_PV=A@mail.gmail.com>
 <7692E70C-A0EA-423B-883F-6BF91B0DB359@icloud.com> <CADPKF+eZCE4A2yXnQaZvq1uk3b-zR+-rwQhzA2z=v7+VsTndkQ@mail.gmail.com>
 <2F012CBD-7DB6-4E88-BFFE-63427B0DD18D@icloud.com> <CAO5MNut+nD-OqsKgae=eibWYuPim1f8-NuwqVpD87eZQnrwscA@mail.gmail.com>
In-Reply-To: <CAO5MNut+nD-OqsKgae=eibWYuPim1f8-NuwqVpD87eZQnrwscA@mail.gmail.com>
From:   Dmitry Sychov <dmitry.sychov@gmail.com>
Date:   Wed, 13 May 2020 17:22:34 +0300
Message-ID: <CADPKF+dR=uQx9Dnu83ADghgei4KxwqnfBwONvp-ou--aePq0xg@mail.gmail.com>
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

Anyone could shed some light on the inner implementation of uring please? :=
)

Specifically how well kernel scales with the increased number of user
created urings?

> If kernel implementation will change from single to multiple queues,
> user space is already prepared for this change.

Thats +1 for per-thread urings. An expectation for the kernel to
become better and better in multiple urings scaling in the future.

On Wed, May 13, 2020 at 4:52 PM Sergiy Yevtushenko
<sergiy.yevtushenko@gmail.com> wrote:
>
> Completely agree. Sharing state should be avoided as much as possible.
> Returning to original question: I believe that uring-per-thread scheme is=
 better regardless from how queue is managed inside the kernel.
> - If there is only one queue inside the kernel, then it's more efficient =
to perform multiplexing/demultiplexing requests in kernel space
> - If there are several queues inside the kernel, then user space code bet=
ter matches kernel-space code.
> - If kernel implementation will change from single to multiple queues, us=
er space is already prepared for this change.
>
>
> On Wed, May 13, 2020 at 3:30 PM Mark Papadakis <markuspapadakis@icloud.co=
m> wrote:
>>
>>
>>
>> > On 13 May 2020, at 4:15 PM, Dmitry Sychov <dmitry.sychov@gmail.com> wr=
ote:
>> >
>> > Hey Mark,
>> >
>> > Or we could share one SQ and one CQ between multiple threads(bound by
>> > the max number of CPU cores) for direct read/write access using very
>> > light mutex to sync.
>> >
>> > This also solves threads starvation issue  - thread A submits the job
>> > into shared SQ while thread B both collects and _processes_ the result
>> > from the shared CQ instead of waiting on his own unique CQ for next
>> > completion event.
>> >
>>
>>
>> Well, if the SQ submitted by A and its matching CQ is consumed by B, and=
 A will need access to that CQ because it is tightly coupled to state it ow=
ns exclusively(for example), or other reasons, then you=E2=80=99d still nee=
d to move that CQ from B back to A, or share it somehow, which seems expens=
ive-is.
>>
>> It depends on what kind of roles your threads have though; I am personal=
ly very much against sharing state between threads unless there a really go=
od reason for it.
>>
>>
>>
>>
>>
>>
>> > On Wed, May 13, 2020 at 2:56 PM Mark Papadakis
>> > <markuspapadakis@icloud.com> wrote:
>> >>
>> >> For what it=E2=80=99s worth, I am (also) using using multiple =E2=80=
=9Creactor=E2=80=9D (i.e event driven) cores, each associated with one OS t=
hread, and each reactor core manages its own io_uring context/queues.
>> >>
>> >> Even if scheduling all SQEs through a single io_uring SQ =E2=80=94 by=
 e.g collecting all such SQEs in every OS thread and then somehow =E2=80=9C=
moving=E2=80=9D them to the one OS thread that manages the SQ so that it ca=
n enqueue them all -- is very cheap, you =E2=80=98d still need to drain the=
 CQ from that thread and presumably process those CQEs in a single OS threa=
d, which will definitely be more work than having each reactor/OS thread de=
queue CQEs for SQEs that itself submitted.
>> >> You could have a single OS thread just for I/O and all other threads =
could do something else but you=E2=80=99d presumably need to serialize acce=
ss/share state between them and the one OS thread for I/O which maybe a sca=
lability bottleneck.
>> >>
>> >> ( if you are curious, you can read about it here https://medium.com/@=
markpapadakis/building-high-performance-services-in-2020-e2dea272f6f6 )
>> >>
>> >> If you experiment with the various possible designs though, I=E2=80=
=99d love it if you were to share your findings.
>> >>
>> >> =E2=80=94
>> >> @markpapapdakis
>> >>
>> >>
>> >>> On 13 May 2020, at 2:01 PM, Dmitry Sychov <dmitry.sychov@gmail.com> =
wrote:
>> >>>
>> >>> Hi Hielke,
>> >>>
>> >>>> If you want max performance, what you generally will see in non-blo=
cking servers is one event loop per core/thread.
>> >>>> This means one ring per core/thread. Of course there is no simple a=
nswer to this.
>> >>>> See how thread-based servers work vs non-blocking servers. E.g. Apa=
che vs Nginx or Tomcat vs Netty.
>> >>>
>> >>> I think a lot depends on the internal uring implementation. To what
>> >>> degree the kernel is able to handle multiple urings independently,
>> >>> without much congestion points(like updates of the same memory
>> >>> locations from multiple threads), thus taking advantage of one ring
>> >>> per CPU core.
>> >>>
>> >>> For example, if the tasks from multiple rings are later combined int=
o
>> >>> single input kernel queue (effectively forming a congestion point) I
>> >>> see
>> >>> no reason to use exclusive ring per core in user space.
>> >>>
>> >>> [BTW in Windows IOCP is always one input+output queue for all(active=
) threads].
>> >>>
>> >>> Also we could pop out multiple completion events from a single CQ at
>> >>> once to spread the handling to cores-bound threads .
>> >>>
>> >>> I thought about one uring per core at first, but now I'am not sure -
>> >>> maybe the kernel devs have something to add to the discussion?
>> >>>
>> >>> P.S. uring is the main reason I'am switching from windows to linux d=
ev
>> >>> for client-sever app so I want to extract the max performance possib=
le
>> >>> out of this new exciting uring stuff. :)
>> >>>
>> >>> Thanks, Dmitry
>> >>
>>
