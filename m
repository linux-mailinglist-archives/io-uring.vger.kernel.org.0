Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E1852AF6E4
	for <lists+io-uring@lfdr.de>; Wed, 11 Nov 2020 17:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgKKQtY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 11 Nov 2020 11:49:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgKKQtY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 11 Nov 2020 11:49:24 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15302C0613D1
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 08:49:24 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id c66so1956292pfa.4
        for <io-uring@vger.kernel.org>; Wed, 11 Nov 2020 08:49:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nametag.social; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nv7sXkq+0EpkTF5bSnWxyvHWRRb0NyynhTMh1x21i2Y=;
        b=ZZLFlSpk3qhHgvh0SoxdluxkRdIeMDEDwq2ckr5SV0v0/mJR8P6gYLqaivxRou2CtV
         RJK44hyX/Q4+/q24OlkUXGK748C1MS2ZnG8QltGbMGn/HHU6xFG1keznkVNgrqclsc/2
         lO4N7hVatxf6wosnyy9x7J4ZShIzABmnX2Ay25AeajeDaTqimNhb6ZmNejlzqKNIxYyT
         O4/23WyKSPGR3T0CPMTntrWHlSETb273Kc64XoAwGhjftS/MFivfTBREocA0s7Yhl23J
         xTnf9NAc3eLCqgQ9jlon9QIw8FriZb83GyxM6YFBbNoEz9+bdhnf+CUj4SNdN4TMrkGD
         UYIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nv7sXkq+0EpkTF5bSnWxyvHWRRb0NyynhTMh1x21i2Y=;
        b=jh0ClE6SyD0AQnjzBzd49ukGd3nNn+j7kWWFd5QT62X3+Q1tXl8p/FZ2CCFnUMClar
         miwDMKTDUUdZJDhVys/+xApaO/dS4+wZtgEncXKdgav9TTXYL8KAGKO/3xy+CjAGZmOD
         PS5FopYlWSGCGwC0fnOAl+OIcNmirG51O3PpUsTfhV8VZcrnFKMi74lb4j2xpbRAXdUm
         hTR6nR9Uh8yEd0PVkSrj+XWLGPXK3vaUaXj+Q5si/VlDNGa008g+hsO6kV3TOT/+x4Hz
         4B3iCsnaIm4oPM1zQ/1uK6gK1ngtF+NNTgI3jFvxbOVT1mDm1RpkwCjGIUKs+Za6RBu6
         A02Q==
X-Gm-Message-State: AOAM533KSfXmINfjL+P30qJxxDQBcROzO5MrZRZqC+FxIdc8GA3mITaW
        F1q6hJCwiLroJJZC0C2UXOUnpYzukJ3ap4AZMjcj6w==
X-Google-Smtp-Source: ABdhPJy5q/JR+cVE5lG7ZGWcZ2h5Asnu21LU/J5UhPSqJU+HZkCXyi04dz9fk1upniNJBfflv6gOUTegbbBmvopZJYQ=
X-Received: by 2002:a65:4945:: with SMTP id q5mr21252875pgs.83.1605113363433;
 Wed, 11 Nov 2020 08:49:23 -0800 (PST)
MIME-Version: 1.0
References: <CAM1kxwgKGMz9UcvpFr1239kmdvmKPuzAyBEwKi_rxDog1MshRQ@mail.gmail.com>
 <acc66238-0d27-cd22-dac4-928777a8efbc@gmail.com> <CAM1kxwjSyLb9ijs0=RZUA06E20qjwBnAZygwM3ckh10WozExag@mail.gmail.com>
 <3913bbb5-50ec-6ad9-13c9-d49a8b7f7e89@gmail.com>
In-Reply-To: <3913bbb5-50ec-6ad9-13c9-d49a8b7f7e89@gmail.com>
From:   Victor Stewart <v@nametag.social>
Date:   Wed, 11 Nov 2020 16:49:12 +0000
Message-ID: <CAM1kxwhdCoH7ZAmnaaDTohg3TUSWL264juamO1or_3m-JFnRyg@mail.gmail.com>
Subject: Re: io_uring-only sendmsg + recvmsg zerocopy
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     io-uring <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Nov 11, 2020 at 1:00 AM Pavel Begunkov <asml.silence@gmail.com> wro=
te:
>
> On 11/11/2020 00:07, Victor Stewart wrote:
> > On Tue, Nov 10, 2020 at 11:26 PM Pavel Begunkov <asml.silence@gmail.com=
> wrote:
> >>> we'd be looking at approx +100% throughput each on the send and recv
> >>> paths (per TCP_ZEROCOPY_RECEIVE benchmarks).>
> >>> these would be io_uring only operations given the sendmsg completion
> >>> logic described below. want to get some conscious that this design
> >>> could/would be acceptable for merging before I begin writing the code=
.
> >>>
> >>> the problem with zerocopy send is the asynchronous ACK from the NIC
> >>> confirming transmission. and you can=E2=80=99t just block on a syscal=
l til
> >>> then. MSG_ZEROCOPY tackled this by putting the ACK on the
> >>> MSG_ERRQUEUE. but that logic is very disjointed and requires a double
> >>> completion (once from sendmsg once the send is enqueued, and again
> >>> once the NIC ACKs the transmission), and requires costly userspace
> >>> bookkeeping.
> >>>
> >>> so what i propose instead is to exploit the asynchrony of io_uring.
> >>>
> >>> you=E2=80=99d submit the IORING_OP_SENDMSG_ZEROCOPY operation, and th=
en
> >>> sometime later receive the completion event on the ring=E2=80=99s com=
pletion
> >>> queue (either failure or success once ACK-ed by the NIC). 1 unified
> >>> completion flow.
> >>
> >> I though about it after your other email. It makes sense for message
> >> oriented protocols but may not for streams. That's because a user
> >> may want to call
> >>
> >> send();
> >> send();
> >>
> >> And expect right ordering, and that where waiting for ACK may add a lo=
t
> >> of latency, so returning from the call here is a notification that "it=
's
> >> accounted, you may send more and order will be preserved".
> >>
> >> And since ACKs may came a long after, you may put a lot of code and st=
uff
> >> between send()s and still suffer latency (and so potentially throughpu=
t
> >> drop).
> >>
> >> As for me, for an optional feature sounds sensible, and should work we=
ll
> >> for some use cases. But for others it may be good to have 2 of
> >> notifications (1. ready to next send(), 2. ready to recycle buf).
> >> E.g. 2 CQEs, that wouldn't work without a bit of io_uring patching.
> >>
> >
> > we could make it datagram only, like check the socket was created with
>
> no need, streams can also benefit from it.
>
> > SOCK_DGRAM and fail otherwise... if it requires too much io_uring
> > changes / possible regression to accomodate a 2 cqe mode.
>
> May be easier to do via two requests with the second receiving
> errors (yeah, msg_control again).
>
> >>> we can somehow tag the socket as registered to io_uring, then when th=
e
> >>
> >> I'd rather tag a request
> >
> > as long as the NIC is able to find / callback the ring about
> > transmission ACK, whatever the path of least resistance is is best.
> >
> >>
> >>> NIC ACKs, instead of finding the socket's error queue and putting the
> >>> completion there like MSG_ZEROCOPY, the kernel would find the io_urin=
g
> >>> instance the socket is registered to and call into an io_uring
> >>> sendmsg_zerocopy_completion function. Then the cqe would get pushed
> >>> onto the completion queue.>
> >>> the "recvmsg zerocopy" is straight forward enough. mimicking
> >>> TCP_ZEROCOPY_RECEIVE, i'll go into specifics next time.
> >>
> >> Receive side is inherently messed up. IIRC, TCP_ZEROCOPY_RECEIVE just
> >> maps skbuffs into userspace, and in general unless there is a better
> >> suited protocol (e.g. infiniband with richier src/dst tagging) or a ve=
ry
> >> very smart NIC, "true zerocopy" is not possible without breaking
> >> multiplexing.
> >>
> >> For registered buffers you still need to copy skbuff, at least because
> >> of security implications.
> >
> > we can actually just force those buffers to be mmap-ed, and then when
> > packets arrive use vm_insert_pin or remap_pfn_range to change the
> > physical pages backing the virtual memory pages submmited for reading
> > via msg_iov. so it's transparent to userspace but still zerocopy.
> > (might require the user to notify io_uring when reading is
> > completed... but no matter).
>
> Yes, with io_uring zerocopy-recv may be done better than
> TCP_ZEROCOPY_RECEIVE but
> 1) it's still a remap. Yes, zerocopy, but not ideal
> 2) won't work with registered buffers, which is basically a set
> of pinned pages that have a userspace mapping. After such remap
> that mapping wouldn't be in sync and that gets messy.

well unless we can alleviate all copies, then there isn=E2=80=99t any point
because it isn=E2=80=99t zerocopy.

so in my server, i have a ceiling on the number of clients,
preallocate them, and mmap anonymous noreserve read + write buffers
for each.

so say, 150,000 clients x (2MB * 2). which is 585GB. way more than the
physical memory of my machine. (and have 10 instance of it per
machine, so ~6TB lol). but at any one time probably 0.01% of that
memory is in usage. and i just MADV_COLD the pages after consumption.

this provides a persistent =E2=80=9Cvmem contiguous=E2=80=9D stream buffer =
per client.
which has a litany of benefits. but if we persistently pin pages, this
ceases to work, because pin pages require persistent physical memory
backing pages.

But on the send side, if you don=E2=80=99t pin persistently, you=E2=80=99d =
have to pin
on demand, which costs more than it=E2=80=99s worth for sends less than ~10=
KB.
And I guess there=E2=80=99s no way to avoid pinning and maintain kernel
integrity. Maybe we could erase those userspace -> physical page
mappings, then recreate them once the operation completes, but 1) that
would require page aligned sends so that you could keep writing and
sending while you waited for completions and 2) beyond being
nonstandard and possibly unsafe, who says that would even cost less
than pinning, definitely costs something. Might cost more because
you=E2=80=99d have to get locks to the page table?

So essentially on the send side the only way to zerocopy for free is
to persistently pin (and give up my per client stream buffers).

On the receive side actually the only way to realistically do zerocopy
is to somehow pin a NIC RX queue to a process, and then persistently
map the queue into the process=E2=80=99s memory as read only. That=E2=80=99=
s a
security absurdly in the general case, but it could be root only
usage. Then you=E2=80=99d recvmsg with a NULL msg_iov[0].iov_base, and have
the packet buffer location and length written in. Might require driver
buy-in, so might be impractical, but unsure.

Otherwise the only option is an even worse nightmare how
TCP_ZEROCOPY_RECEIVE works, and ridiculously impractical for general
purpose=E2=80=A6

=E2=80=9CMapping of memory into a process's address space is done on a
per-page granularity; there is no way to map a fraction of a page. So
inbound network data must be both page-aligned and page-sized when it
ends up in the receive buffer, or it will not be possible to map it
into user space. Alignment can be a bit tricky because the packets
coming out of the interface start with the protocol headers, not the
data the receiving process is interested in. It is the data that must
be aligned, not the headers. Achieving this alignment is possible, but
it requires cooperation from the network interface

It is also necessary to ensure that the data arrives in chunks that
are a multiple of the system's page size, or partial pages of data
will result. That can be done by setting the maximum transfer unit
(MTU) size properly on the interface. That, in turn, can require
knowledge of exactly what the incoming packets will look like; in a
test program posted with the patch set, Dumazet sets the MTU to
61,512. That turns out to be space for fifteen 4096-byte pages of
data, plus 40 bytes for the IPv6 header and 32 bytes for the TCP
header.=E2=80=9D

https://lwn.net/Articles/752188/

Either receive case also makes my persistent per client stream buffer
zerocopy impossible lol.

in short, zerocopy sendmsg with persistently pinned buffers is
definitely possible and we should do that. (I'll just make it work on
my end).

recvmsg i'll have to do more research into the practicality of what I
proposed above.

>
> >>> the other big concern is the lifecycle of the persistent memory
> >>> buffers in the case of nefarious actors. but since we already have
> >>> buffer registration for O_DIRECT, I assume those mechanics already
> >>
> >> just buffer registration, not specifically for O_DIRECT
> >>
> >>> address those issues and can just be repurposed?
> >>
> >> Depending on how long it could stuck in the net stack, we might need
> >> to be able to cancel those requests. That may be a problem.
> >
> > I spoke about this idea with Willem the other day and he mentioned...
> >
> > "As long as the mappings aren't unwound on process exit. But then you
>
> The pages won't be unpinned until all/related requests are gone, but
> for that on exit io_uring waits for them to complete. That's one of the
> reasons why either requests should be cancellable or short-lived and
> somewhat predictably time-bound.
>
> > open up to malicious applications that purposely register ranges and
> > then exit. The basics are straightforward to implement, but it's not
> > that easy to arrive at something robust."
> >
> >>
> >>>
> >>> and so with those persistent memory buffers, you'd only pay the cost
> >>> of pinning the memory into the kernel once upon registration, before
> >>> you even start your server listening... thus "free". versus pinning
> >>> per sendmsg like with MSG_ZEROCOPY... thus "true zerocopy".
> --
> Pavel Begunkov
