Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98044365D7C
	for <lists+io-uring@lfdr.de>; Tue, 20 Apr 2021 18:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbhDTQg3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 20 Apr 2021 12:36:29 -0400
Received: from mailgate.zerties.org ([144.76.28.47]:33406 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbhDTQg2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 20 Apr 2021 12:36:28 -0400
Received: from a89-183-232-99.net-htp.de ([89.183.232.99] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1lYtLs-0005Tg-82; Tue, 20 Apr 2021 16:35:53 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
In-Reply-To: <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
 <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
Date:   Tue, 20 Apr 2021 18:35:51 +0200
Message-ID: <s7bmttssyl4.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 89.183.232.99
X-SA-Exim-Mail-From: stettberger@dokucode.de
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mailgate.zerties.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.4 required=4.0 tests=ALL_TRUSTED,BAYES_00,
        GREYLIST_ISWHITE shortcircuit=no autolearn=ham autolearn_force=no
        version=3.4.4
Subject: Re: [RFC] Programming model for io_uring + eBPF
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hi Pavel,

thank you for your insights on the potential kernel integration.
Hopefully this mail also lands on the mailinglist, because somehow my
last mail was eaten by VGER although I'm a subscriber on that list.
Let's see where this mail ends up.

Pavel Begunkov <asml.silence@gmail.com> [16. April 2021]:

>> 1. Program model
>>     1. **Loading**: An eBPF program, which is a collection of functions,
>>        can be attached to an uring. Each uring has at most one loaded
>>        eBPF program
>
> An ebpf program is basically a single entry point (i.e. function), but
> there is some flexibility on reusing them, iirc even dynamically, not
> link-time only. So, from the io_uring/bpf perspective, you load a bunch
> of bpf programs (i.e. separate functions) ...

From a intentional perspective, there is not much difference between N
programs with one entry function each and one program with N entry
functions. As a user of our new interface I want to have the possibility
to preattach multiple eBPF functions to a uring in order to shadow the
latency for loading (and potentially) jitting the eBPF program.

My intention with wanting only a single program was to make it easier to
emit SQEs that reference another eBPF function. In an ideal world, the
eBPF function only uses a `sqe.callback = &other_func' in its body.

>>     2. **Invocation**: Individual functions in that eBPF program can be
>>        called.
>>     3. These eBPF programs have some kind of global state that remains
>>        valid across invocations.
>
> ... where the state is provided from the userspace in a form of bpf
> map/array. So, it's not necessarily restricted by a single state, but
> you can have many per io_uring.
>
> Hence, if userspace provides a single piece of state, that should be as
> you described.

That should be fine as long as we do not have to transport the eBPF
function pointer and the state pointer in every eBPF-SQE. As I heard,
the space in an SQE is quite limited :-) Therefore, I designed an
implicit method to pass state between invocations into the our model.

>>     3. All invocations on the same uring are serialized in their
>>        execution -- even if the SQEs are part of different link
>>        chains that are otherwise executed in parallel.
>
> Don't think it's a good idea to limit the kernel to it, but we
> may try to find a userspace solution, or do it optionally.

I think this is a curcial point for the execution model as otherwise SQE
executions have synchronize to with each other. I think it is consensus
that these callback should have read and write access to different
buffers, which provokes the question of data races. I see several
solutions here:

- My proposed serialization promise

- Giving atomicity guarantees for the invocation of different eBPF
  helper functions (e.g. write buffer to user memory). However, what
  should I do if I want to perform a composed operation in an atomar
  fashin? Surely, we do not want to have transactions.

- Exposing synchronization primitives to the eBPF program. I don't think
  that we can argue for semaphores in an eBPF program.

With the serialization promise, we at least avoid the need to
synchronize callbacks with callbacks. However, synchronization between
user space and callback is still a problem.

In order to make this serialization promise less strict, we could hide
it behind an SQE flag. Thereby, many callbacks can execute in parallel,
while some are guaranteed to execute in sequence.

>> 3. Access to previous SQEs/CQEs (in a link chain)
>>     1. In a link chain, the invocation can access the data of
>>        (**all** or **the** -- subject to debate and application-scenario
>>        requirements) previous SQEs and CQEs.
>>     2. All SQEs get a flag that indicates that no CQE is emitted to
>>        userspace. However, the CQE is always generated and can be
>>        consumed by following invocation-SQEs.
>
> There is my last concept, was thinking about because feeding CQE of
> only last linked request seems very limited to me.
>
> - let's allow to register multiple completion queues (CQs), for
> simplicity extra ones are limited to BPF programs and not exported to
> the userspace, may be lifted in the future
>
> - BPF requests are naturally allowed to reap CQEs from them and free
> to choose from which exactly CQ (including from multiple).
>
> So, that solves 2) without flags because CQEs are posted, but userspace
> can write BPF in such a way that they are reaped only by a specific BPF
> request/etc. and not affecting others. As well as effectively CQEs part
> of 1), without burden of extra allocations for CQEs, etc.

Ok, let me summarize that to know if I've understand it correctly.
Instead of having one completion queue for a submission queue, there are
now the user-exposed completion queue and (N-1) in-kernel completion
queues. On these queues, only eBPF programs can reap CQEs. If an eBPF
wants to forward the CQE of the previous linked SQE, it reaps it from
that queue and write it to the user-visible queue.

How do I indicate at the first SQE into which CQ the result should be
written?

On the first sight, this looks much more complex to me than using a flag
to supress the emitting of CQEs.

> That's flexible enough to enable users to do many interesting things,
> e.g. to project it onto graph-like events synchronisation models. This
> may need some other things, e.g. like allowing BPF requests to wait
> for >=N entries in CQ, but not of much concern.

In your mentioned scenario, I would submit an unlinked eBPF-SQE that
says: exeucte this SQE only if that CQ has more than n entries.
But wouldn't that introduce a whole new signaling and waiting that sits
beside the SQE linking mechanism?
Are we able to encode all of that into a single SQE that also holds an
eBPF function pointer and (potenitally) an pointer to a context map?

>> 4. Data and control access within an invocation: Invocations can ...
>>     1. Access preceeding SQEs and CQEs of the same link chain (see above).
>
> It'd be a problem to allow them to access preceeding SQEs. They're never
> saved in requests, and by the time of execution previous requests are
> already gone. And SQE is 64B, even alloc + copy would add too much of
> overhead.

My rational behind this point was to have the arguments to the
preceeding request at hand to have both, request and uring, specific
state as arguments. But perhaps all of this can be done in userspace
(and might even be more flexible) by supplying the correct eBPF map.

>>     2. Emit SQEs and CQEs to the same uring. All SQEs that are submitted
>>        by one invocation follow each other directly in the submission
>>        ring to enable SQE linking.
>
> fwiw, no need to use the SQ for from BPF submissions, especially since
> it may be used by the userspace in parallel and synchronises races is
> painful.

Sure, we only have to have a possibility so create linked requests. They
never have to fly through the SQ. Only on an intentional level it should
be the same. And by mimicing the user-level interface, without backing
it by the same implementation, it would be more familiar for the
user-space developer.

>>     3. Read and write the whole userspace memory of the uring-owning
>>        process.
>
> That's almost completely on BPF.

But probably, people have stark opinions on that, or? I mean, as far as
i grasped the situation, people are quite skeptical on the capabilities
of eBPF programs and fear the hell of an endless chain of vulnerabilities.


> Great job writing up requirements and use cases. Let's see how we can
> improve it. My main concerns is 1) to keep it flexible, so use-cases
> and ideas may bounce around, and allow multiple models to co-exists.
> 2) but also keep it slim enough, because wouldn't be of much use if
> it's faster to go through userspace and normal submissions.

I completely agree with your here. I would add another point to our
bucket list of goals:

   3) it should be comprehensible for the user-space dev and follow the
   principle of the least surprise.

I tried to accomplish this, by reproducing the user-space interface at
the eBPF level. In the end it would be nice, if a user space program,
toghether with the help of a few #defines and a little bit of
make-magic, decide for each SQE-callback whether it should be executed
in user- or in kernel space.

chris

-- 
Christian Dietrich
