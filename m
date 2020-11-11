Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2962AE4E1
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 01:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732023AbgKKAZV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Nov 2020 19:25:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgKKAZV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Nov 2020 19:25:21 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52527C0613D1
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 16:25:20 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id f20so340806ejz.4
        for <io-uring@vger.kernel.org>; Tue, 10 Nov 2020 16:25:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=xHreNgpHOhRixsnVNAFW0iSTa9ttyX9Vvw1T79xdT+c=;
        b=K6gC7cy4EKNupFBUgR+nLbCGd98EtoaZL7CTx5UlxqGNpPoVzUfJ9uQ61/+kj3RCE5
         plmzXhpsa75HHM3TvN16KqMNoAvb15+OkATE4ZyGqasTrQb3PJirpNz7IqY0CG6oQ6/v
         D/Smg71WrIF3A4u4zIflh8dmQsvEH5V3zzciOuZ2Qfa2gaPvJC+zprcp1tFSGiIRQlcQ
         pyzZzuD6ZHnOLfHqvv3WyDYjsbgNK3HSxEVmrSbVYr7B+6oBn0YHAijVSHB7GAsOTXEE
         p/LN7OcvUYKVgwl61RxLRz+ppsBKZre86aY7snNOtLrDMdYm/xWsML/cTt1wrN1/2s5w
         RLzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=xHreNgpHOhRixsnVNAFW0iSTa9ttyX9Vvw1T79xdT+c=;
        b=r2qd63URgKkGtoEvytAyYOAI0dtnf/df/RMyQBD7CnHRLYcByARFFWiDDmh4k5A1mB
         Kyle/vorDBKRvqHekQoTIjCr0VM1MJryo/+QX4AizoZS6EqvWT243QhctqlrhDteVo8o
         oftXOMBokp3k4M5C/x/br39VHJDTa2nHjJXOAfAvawKw88dvqqFvJEKK4MujxroRdF2f
         IXbREbPvgg2+ojX5mlWVOde9vy7QuW7ndtrkjnF9yUlyLLOHzooz9ujAN9yKxVcgOD8s
         QFLYfAyKPV5abPEzEHydGJUVDktAF08cs25tUUq3gN5TU7o6bAHM1zlSgI+ARJWhFaPi
         OMcQ==
X-Gm-Message-State: AOAM531z0yTV6H15yteFr3DtvRMqRBjFYnTYt5eU0FV0ZxF2K9K6OaCT
        JNU8SogZIcEtFZSzN+xIUGWyvDy8WJxh59R6GAv5XQ==
X-Google-Smtp-Source: ABdhPJz8qybO1KgnlfabRcXTBJPvejAdrKzYdURSdRA4RAgfIKPy/a7eYsx0cc+JLNXn5vNpQ+95G2cyCOuAULPrxpo=
X-Received: by 2002:a17:906:7cc6:: with SMTP id h6mr4102165ejp.161.1605054318348;
 Tue, 10 Nov 2020 16:25:18 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwgKGMz9UcvpFr1239kmdvmKPuzAyBEwKi_rxDog1MshRQ@mail.gmail.com>
 <acc66238-0d27-cd22-dac4-928777a8efbc@gmail.com> <CAM1kxwjSyLb9ijs0=RZUA06E20qjwBnAZygwM3ckh10WozExag@mail.gmail.com>
In-Reply-To: <CAM1kxwjSyLb9ijs0=RZUA06E20qjwBnAZygwM3ckh10WozExag@mail.gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 11 Nov 2020 00:25:07 +0000
Message-ID: <CAM1kxwjwF=5f0cxWQL8m8bcFDd96YwM=PzxeBwuW1fySFfGP0A@mail.gmail.com>
Subject: Fwd: io_uring-only sendmsg + recvmsg zerocopy
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

forgot to reply-all on this lol.

also FYI

https://www.spinics.net/lists/netdev/msg698969.html

On Tue, Nov 10, 2020 at 11:26 PM Pavel Begunkov <asml.silence@gmail.com> wr=
ote:
>
> On 10/11/2020 21:31, Victor Stewart wrote:
> > here=E2=80=99s the design i=E2=80=99m flirting with for "recvmsg and se=
ndmsg zerocopy"
> > with persistent buffers patch.
>
> Ok, first we need make it to work with registered buffers. I had patches
> for that but need to rebase+refresh it, I'll send it out this week then.
>
> Zerocopy would still go through some pinning,
> e.g. skb_zerocopy_iter_*() -> iov_iter_get_pages()
>                 -> get_page() -> atomic_inc()
> but it's lighter for bvec and can be optimised later if needed.
>
> And that leaves hooking up into struct ubuf_info with callbacks
> for zerocopy.

okay!

>
> >
> > we'd be looking at approx +100% throughput each on the send and recv
> > paths (per TCP_ZEROCOPY_RECEIVE benchmarks).>
> > these would be io_uring only operations given the sendmsg completion
> > logic described below. want to get some conscious that this design
> > could/would be acceptable for merging before I begin writing the code.
> >
> > the problem with zerocopy send is the asynchronous ACK from the NIC
> > confirming transmission. and you can=E2=80=99t just block on a syscall =
til
> > then. MSG_ZEROCOPY tackled this by putting the ACK on the
> > MSG_ERRQUEUE. but that logic is very disjointed and requires a double
> > completion (once from sendmsg once the send is enqueued, and again
> > once the NIC ACKs the transmission), and requires costly userspace
> > bookkeeping.
> >
> > so what i propose instead is to exploit the asynchrony of io_uring.
> >
> > you=E2=80=99d submit the IORING_OP_SENDMSG_ZEROCOPY operation, and then
> > sometime later receive the completion event on the ring=E2=80=99s compl=
etion
> > queue (either failure or success once ACK-ed by the NIC). 1 unified
> > completion flow.
>
> I though about it after your other email. It makes sense for message
> oriented protocols but may not for streams. That's because a user
> may want to call
>
> send();
> send();
>
> And expect right ordering, and that where waiting for ACK may add a lot
> of latency, so returning from the call here is a notification that "it's
> accounted, you may send more and order will be preserved".
>
> And since ACKs may came a long after, you may put a lot of code and stuff
> between send()s and still suffer latency (and so potentially throughput
> drop).
>
> As for me, for an optional feature sounds sensible, and should work well
> for some use cases. But for others it may be good to have 2 of
> notifications (1. ready to next send(), 2. ready to recycle buf).
> E.g. 2 CQEs, that wouldn't work without a bit of io_uring patching.
>

we could make it datagram only, like check the socket was created with
SOCK_DGRAM and fail otherwise... if it requires too much io_uring
changes / possible regression to accomodate a 2 cqe mode.

> >
> > we can somehow tag the socket as registered to io_uring, then when the
>
> I'd rather tag a request

as long as the NIC is able to find / callback the ring about
transmission ACK, whatever the path of least resistance is is best.

>
> > NIC ACKs, instead of finding the socket's error queue and putting the
> > completion there like MSG_ZEROCOPY, the kernel would find the io_uring
> > instance the socket is registered to and call into an io_uring
> > sendmsg_zerocopy_completion function. Then the cqe would get pushed
> > onto the completion queue.>
> > the "recvmsg zerocopy" is straight forward enough. mimicking
> > TCP_ZEROCOPY_RECEIVE, i'll go into specifics next time.
>
> Receive side is inherently messed up. IIRC, TCP_ZEROCOPY_RECEIVE just
> maps skbuffs into userspace, and in general unless there is a better
> suited protocol (e.g. infiniband with richier src/dst tagging) or a very
> very smart NIC, "true zerocopy" is not possible without breaking
> multiplexing.
>
> For registered buffers you still need to copy skbuff, at least because
> of security implications.

we can actually just force those buffers to be mmap-ed, and then when
packets arrive use vm_insert_pin or remap_pfn_range to change the
physical pages backing the virtual memory pages submmited for reading
via msg_iov. so it's transparent to userspace but still zerocopy.
(might require the user to notify io_uring when reading is
completed... but no matter).


>
> >
> > the other big concern is the lifecycle of the persistent memory
> > buffers in the case of nefarious actors. but since we already have
> > buffer registration for O_DIRECT, I assume those mechanics already
>
> just buffer registration, not specifically for O_DIRECT
>
> > address those issues and can just be repurposed?
>
> Depending on how long it could stuck in the net stack, we might need
> to be able to cancel those requests. That may be a problem.

I spoke about this idea with Willem the other day and he mentioned...

"As long as the mappings aren't unwound on process exit. But then you
open up to malicious applications that purposely register ranges and
then exit. The basics are straightforward to implement, but it's not
that easy to arrive at something robust."

>
> >
> > and so with those persistent memory buffers, you'd only pay the cost
> > of pinning the memory into the kernel once upon registration, before
> > you even start your server listening... thus "free". versus pinning
> > per sendmsg like with MSG_ZEROCOPY... thus "true zerocopy".
> >
>
> --
> Pavel Begunkov
