Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE3CB36EB55
	for <lists+io-uring@lfdr.de>; Thu, 29 Apr 2021 15:27:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235944AbhD2N2M convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Thu, 29 Apr 2021 09:28:12 -0400
Received: from mailgate.zerties.org ([144.76.28.47]:37760 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237302AbhD2N2M (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Apr 2021 09:28:12 -0400
Received: from a89-182-232-8.net-htp.de ([89.182.232.8] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1lc6hO-0001vq-Ne; Thu, 29 Apr 2021 13:27:24 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
In-Reply-To: <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
Organization: Technische =?utf-8?Q?Universit=C3=A4t?= Hamburg
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
 <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
 <s7bmttssyl4.fsf@dokucode.de>
 <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
X-Commit-Hash-org: 43cc44e3fdb1c3837853682a65069e9bc0757e24
X-Commit-Hash-Maildir: fb91d5079a3bcc193f2005b0c3d9d38911866475
Date:   Thu, 29 Apr 2021 15:27:22 +0200
Message-ID: <s7bv985te4l.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 89.182.232.8
X-SA-Exim-Mail-From: stettberger@dokucode.de
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mailgate.zerties.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED shortcircuit=no autolearn=ham autolearn_force=no
        version=3.4.4
Subject: Re: [RFC] Programming model for io_uring + eBPF
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Pavel Begunkov <asml.silence@gmail.com> [23. April 2021]:

> Yeah, absolutely. I don't see much profit in registering them
> dynamically, so for now they will be needed to be loaded and attached
> in advance. Or can be done in a more dynamic fashion, doesn't really
> matter.
>
> btw, bpf splits compilation and attach steps, adds some flexibility.

So, I'm currently working on rebasing your work onto the tag
'for-5.13/io_uring-2021-04-27'. So if you already have some branch on
this, just let me know to save the work.

> Should look similar to the userspace, fill a 64B chunk of memory,
> where the exact program is specified by an index, the same that is
> used during attach/registration

When looking at the current implementation, when can only perform the
attachment once and there is no "append eBPF". While this is probably OK
for code, for eBPF maps, we will need some kind of append eBPF map.

> and context fd is just another field in the SQE. On the space -- it
> depends. Some opcodes pass more info than others, and even for those we
> yet have 16 bytes unused. For bpf I don't expect passing much in SQE, so
> it should be ok.

So besides an eBPF-Progam ID, we would also pass an ID for an eEBF map
in the SQE.

One thought that came to my mind: Why do we have to register the eBPF
programs and maps? We could also just pass the FDs for those objects in
the SQE. As long as there is no other state, it could be the userspaces
choice to either attach it or pass it every time. For other FDs we
already support both modes, right?

>> - My proposed serialization promise
>
> It can be an optional feature, but 1) it may become a bottleneck at
> some point, 2) users use several rings, e.g. per-thread, so they
> might need to reimplement serialisation anyway.

If we make it possible to pass some FD to an synchronization object
(e.g. semaphore), this might do the trick to support both modes at the interface.

>> - Exposing synchronization primitives to the eBPF program. I don't think
>>   that we can argue for semaphores in an eBPF program.
>
> I remember a discussion about sleep-able bpf, we need to look what has
> happened with it.

But surely this would hurt a lot as we would have to manage not only
eBPF programs, but also eBPF processes. While this is surely possible, I
don't know if it is really suitable for a high-performance interface
like io_uring. But, don't know about the state.

>
>> With the serialization promise, we at least avoid the need to
>> synchronize callbacks with callbacks. However, synchronization between
>> user space and callback is still a problem.
>
> Need to look up up-to-date BPF capabilities, but can also be spinlocks,
> for both: bpf-userspace sync, and between bpf 
> https://lwn.net/ml/netdev/20190116050830.1881316-1-ast@kernel.org/

Using Spinlocks between kernel and userspace just feels wrong, very
wrong. But it might be an alternate route to synchronization

> With a bit of work nothing forbids to make them userspace visible,
> just next step to the idea. In the end I want to have no difference
> between CQs, and everyone can reap from anywhere, and it's up to
> user to use/synchronise properly.

I like the notion of orthogonality with this route. Perhaps, we don't
need to have user-invisible CQs but it can be enough to address the CQ
of another uring in my SQE as the sink for the resulting CQE.

Downside with that idea would be that the user has to setup another 
ring with SQ and CQ, but only the CQ is used.

> [...]

> CQ is specified by index in SQE, in each SQE. So either as you say, or
> just specify index of the main CQ in that previous linked request in
> the first place.

From looking at the code: This is not yet the case, or? 

>> How do I indicate at the first SQE into which CQ the result should be
>> written?

> Yes, adds a bit of complexity, but without it you can only get last CQE,
> 1) it's not flexible enough and shoots off different potential scenarios
>
> 2) not performance efficient -- overhead on running a bpf request after
> each I/O request can be too large.
>
> 3) does require mandatory linking if you want to get result. Without it
> we can submit a single BPF request and let it running multiple times,
> e.g. waiting for on CQ, but linking would much limit options
>
> 4) bodgy from the implementation perspective

When taking a step back, this is nearly a io_uring_enter(minwait=N)-SQE
with an attached eBPF callback, or? At that point, we are nearly full
circle.

>> Are we able to encode all of that into a single SQE that also holds an
>> eBPF function pointer and (potenitally) an pointer to a context map?
>
> yes, but can be just a separate linked request...

So, let's make a little collection about the (potential) information
that our poor SQE has to hold. Thereby, FDs should be registrable and
addressible by an index.

- FD to eBPF program
- FD to eBPF map
- FD to synchronization object during the execution
- FD to foreign CQ for waiting on N CQEs

That are a lot of references to other object for which we would have
to extend the registration interface.

> Right. And it should know what it's doing anyway in most cases. All
> more complex dispatching / state machines can be pretty well
> implemented via context.

You convinced me that an eBPF map as a context is the more canonical way
of doing it by achieving the same degree of flexibility.

> I believe there was something for accessing userspace memory, we
> need to look it up.

Either way, from a researcher perspective, we can just allow it and look
how it can performs.

chris
-- 
Dr.-Ing. Christian Dietrich
Operating System Group (E-EXK4)
Technische Universität Hamburg
Am Schwarzenberg-Campus 3 (E)
21073 Hamburg

eMail:  christian.dietrich@tuhh.de
Tel:    +49 40 42878 2188
WWW:    https://osg.tuhh.de/
