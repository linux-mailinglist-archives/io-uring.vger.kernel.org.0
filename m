Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2068373BD2
	for <lists+io-uring@lfdr.de>; Wed,  5 May 2021 14:57:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232981AbhEEM6u convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Wed, 5 May 2021 08:58:50 -0400
Received: from mailgate.zerties.org ([144.76.28.47]:59544 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbhEEM6t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 08:58:49 -0400
Received: from [130.75.33.67] (helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1leH65-0004dU-7X; Wed, 05 May 2021 12:57:50 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
In-Reply-To: <46229c8c-7e9d-9232-1e97-d1716dfc3056@gmail.com>
Organization: Technische =?utf-8?Q?Universit=C3=A4t?= Hamburg
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
 <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
 <s7bmttssyl4.fsf@dokucode.de>
 <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
 <s7bv985te4l.fsf@dokucode.de>
 <46229c8c-7e9d-9232-1e97-d1716dfc3056@gmail.com>
X-Commit-Hash-org: 6d4641337834dfde749b899ec805359d074f9152
X-Commit-Hash-Maildir: 17bb32204bb02047dc6f0f754ffd7868c982f554
Date:   Wed, 05 May 2021 14:57:48 +0200
Message-ID: <s7bpmy5pcc3.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 130.75.33.67
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

Pavel Begunkov <asml.silence@gmail.com> [01. May 2021]:

> No need to register maps, it's passed as an fd. Looks I have never
> posted any example, but you can even compile fds in in bpf programs
> at runtime.
>
> fd = ...;
> bpf_prog[] = { ..., READ_MAP(fd), ...};
> compile_bpf(bpf_prog);
>
> I was thinking about the opposite, to allow to optionally register
> them to save on atomic ops. Not in the next patch iteration though

That was exactly my idea:  make it possible to register them
optionally.

I also think that registering the eBPF program FD could be made
optionally, since this would be similar to other FD references that are
submitted to io_uring.

> Yes, at least that's how I envision it. But that's a good question
> what else we want to pass. E.g. some arbitrary ids (u64), that's
> forwarded to the program, it can be a pointer to somewhere or just
> a piece of current state.

So, we will have the regular user_data attribute there. So why add
another potential argument to the program, besides passing an eBPF map?

>> One thought that came to my mind: Why do we have to register the eBPF
>> programs and maps? We could also just pass the FDs for those objects in
>> the SQE. As long as there is no other state, it could be the userspaces
>> choice to either attach it or pass it every time. For other FDs we
>> already support both modes, right?
>
> It doesn't register maps (see above). For not registering/attaching in
> advance -- interesting idea, I need it double check with bpf guys.

My feeling would be the following: In any case, at submission we have to
resolve the SQE references to a 'bpf_prog *', if this is done via a
registered program in io_ring_ctx or via calling 'bpf_prog_get_type' is
only a matter of the frontend.

The only difference would be the reference couting. For registered
bpf_progs, we can increment the refcounter only once. For unregistered,
we would have to increment it for every SQE. Don't know if the added
flexibility is worth the effort.

>> If we make it possible to pass some FD to an synchronization object
>> (e.g. semaphore), this might do the trick to support both modes at the interface.

I was thinking further about this. And, really I could not come up with
a proper user-space visible 'object' that we can grab with an FD to
attach this semantic to as futexes come in form of a piece of memory.

So perhaps, we would do something like

    // alloc 3 groups
    io_uring_register(fd, REGISTER_SYNCHRONIZATION_GROUPS, 3);

    // submit a synchronized SQE
    sqe->flags |= IOSQE_SYNCHRONIZE;
    sqe->synchronize_group = 1;     // could probably be restricted to uint8_t.

When looking at this, this could generally be a nice feature to have
with SQEs, or? Hereby, the user could insert all of his SQEs and they
would run sequentially. In contrast to SQE linking, the order of SQEs
would not be determined, which might be beneficial at some point.

>> - FD to synchronization object during the execution
>
> can be in the context, in theory. We need to check available
> synchronisation means

In the context you mean: there could be a pointer to user-memory and the
bpf program calls futex_wait?

> The idea is to add several CQs to a single ring, regardless of BPF,
> and for any request of any type use specify sqe->cq_idx, and CQE
> goes there. And then BPF can benefit from it, sending its requests
> to the right CQ, not necessarily to a single one.
> It will be the responsibility of the userspace to make use of CQs
> right, e.g. allocating CQ per BPF program and so avoiding any sync,
> or do something more complex cross posting to several CQs.

Would this be done at creation time or by registering them? I think that
creation time would be sufficient and it would ease the housekeeping. In
that case, we could get away with making all CQs equal in size and only
read out the number of the additional CQs from the io_uring_params.

When adding a sqe->cq_idx: Do we have to introduce an IOSQE_SELET_OTHER
flag to not break userspace for backwards compatibility or is it
sufficient to assume that the user has zeroed the SQE beforehand?

However, I like the idea of making it a generic field of SQEs.

>> When taking a step back, this is nearly a io_uring_enter(minwait=N)-SQE
>
> Think of it as a separate request type (won't be a separate, but still...)
> waiting on CQ, similarly to io_uring_enter(minwait=N) but doesn't block.
>
>> with an attached eBPF callback, or? At that point, we are nearly full
>> circle.
>
> What do you mean?

I was just joking: With a minwait=N-like field in the eBPF-SQE, we can
mimic the behavior of io_uring_enter(minwait=N) but with an SQE. On the
result of that eBPF-SQE we can now actually wait with io_uring_enter(..)

chris
-- 
Prof. Dr.-Ing. Christian Dietrich
Operating System Group (E-EXK4)
Technische Universität Hamburg
Am Schwarzenberg-Campus 3 (E)
21073 Hamburg

eMail:  christian.dietrich@tuhh.de
Tel:    +49 40 42878 2188
WWW:    https://osg.tuhh.de/
