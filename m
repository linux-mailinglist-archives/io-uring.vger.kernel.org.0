Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB840392C63
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 13:12:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229844AbhE0LOA convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Thu, 27 May 2021 07:14:00 -0400
Received: from mailgate.zerties.org ([144.76.28.47]:51166 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbhE0LOA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 07:14:00 -0400
Received: from a89-182-234-195.net-htp.de ([89.182.234.195] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1lmDw7-0005wU-Vt; Thu, 27 May 2021 11:12:25 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
In-Reply-To: <e11cd3e6-b1be-2098-732a-2987a5a9f842@gmail.com>
Organization: Technische =?utf-8?Q?Universit=C3=A4t?= Hamburg
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
 <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
 <s7bmttssyl4.fsf@dokucode.de>
 <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
 <s7bv985te4l.fsf@dokucode.de>
 <46229c8c-7e9d-9232-1e97-d1716dfc3056@gmail.com>
 <s7bpmy5pcc3.fsf@dokucode.de> <s7bbl9pp39g.fsf@dokucode.de>
 <c45d633e-1278-1dcb-0d59-f0886abc3e60@gmail.com>
 <s7beeec8ah0.fsf@dokucode.de>
 <fd68fd2d-3816-e326-8016-b9d5c5c429ed@gmail.com>
 <s7bv97ey87m.fsf@dokucode.de>
 <0468c1d5-9d0a-f8c0-618c-4a40b4677099@gmail.com>
 <s7bsg2hwitp.fsf@dokucode.de>
 <e11cd3e6-b1be-2098-732a-2987a5a9f842@gmail.com>
X-Commit-Hash-org: 09dc047fb2edb0ef9819debbd5e29f06b7dac1cf
X-Commit-Hash-Maildir: 1f67180946c1eb7965a659ed8196c1967dde205f
Date:   Thu, 27 May 2021 13:12:23 +0200
Message-ID: <s7b1r9sfn1k.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 89.182.234.195
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

Pavel Begunkov <asml.silence@gmail.com> [21. May 2021]:

>> The problem that I see is that eBPF in io_uring breaks this fine
>> synchronization as eBPF SQE submission and userspace SQE submission can
>> run in parallel.
>
> It definitely won't be a part of ABI, but they actually do serialise
> at the moment.

They serialize because they are executed by the same worker thread,
right?

Perhaps that is the solution to my synchronization problem. If/when
io_uring supports more than one eBPF executioners, we should make the
number of executors configurable at setup time. Thereby, the user can
implicitly manage serialization of eBPF execution.


>> But going back to my original wish: I wanted to ensure that I can
>> serialize eBPF-SQEs such that I'm sure that they do not run in parallel.
>> My idea was to use synchronization groups as a generalization of
>> SQE linking in order to make it also useful for others (not only for eBPF).
>
> So, let's dissect it a bit more, why do you need serialising as
> such? What use case you have in mind, and let's see if it's indeed
> can't be implemented efficiently with what we have.

What I want to do is to manipulate (read-calculate-update) user memory
from eBPF without the need to synchronize between eBPF invocations.

As eBPF invocations have a run-to-completion semantic, it feels bad to
use lock-based synchronization. Besides waiting for user-memory to be
swapped in, they will be usually short and plug together results and
newly emitted CQEs.

> To recap: BPFs don't share SQ with userspace at all, and may have
> separate CQs to reap events from. You may post an event and it's
> wait synchronised, so may act as a message-based synchronisation,
> see test3 in the recently posted v2 for example. I'll also be
> adding futex support (bpf + separate requests), it might
> play handy for some users.

I'm sure that it is possible to use those mechanisms for synchronizing,
but I assume that explicit synchronization (locks, passing tokens
around) is more expensive than sequenzializing requests (implicit
synchronization) before starting to execute them.

But probably, we need some benchmarks to see what performs better.

>> My reasoning being not doing this serialization in userspace is that I
>> want to use the SQPOLL mode and execute long chains of
>> IO/computation-SQEs without leaving the kernelspace.
>
> btw, "in userspace" is now more vague as it can be done by BPF
> as well. For some use cases I'd expect BPF acting as a reactor,
> e.g. on completion of previous CQEs and submitting new requests
> in response, and so keeping it entirely in kernel space until
> it have anything to tell to the userspace, e.g. by posting
> into the main CQ.

Yes, exactly that is my motivation. But I also think that it is a useful
pattern to have many eBPF callbacks pending (e.g. one for each
connection).

With one pending invocation per connection, synchronization with a fixed
number of additional CQEs might be problematic: For example, for a
per-connection barrier synchronization with the CQ-reap approach, one
needs one CQ for each connection.

>> The problem that I had when thinking about the implementation is that
>> IO_LINK semantic works in the wrong direction: Link the next SQE,
>> whenever it comes to this SQE. If it would be the other way around
>> ("Link this SQE to the previous one") it would be much easier as the
>> cost would only arise if we actually request linking. But compatibility..
>
> Stack vs queue style linking? If I understand what you mean right, that's
> because this is how SQ is parsed and so that's the most efficient way.

No, I did not want to argue about the ordering within the link chain,
but with the semantic of link flag. I though that it might have been
beneficial to let the flag indicate that the SQE should be linked to the
previous one. However, after thinking this through in more detail I now
believe that it does not make any difference for the submission path.


>> Ok, but what happens if the last SQE in an io_submit_sqes() call
>> requests linking? Is it envisioned that the first SQE that comes with
>> the next io_submit_sqes() is linked to that one?
>
> No, it doesn't leave submission boundary (e.g. a single syscall).
> In theory may be left there _not_ submitted, but don't see much
> profit in it.
>
>> If this is not supported, what happens if I use the SQPOLL mode where
>>   the poller thread can partition my submitted SQEs at an arbitrary
>>   point into multiple io_submit_sqes() calls?
>
> It's not arbitrary, submission is atomic in nature, first you fill
> SQEs in memory but they are not visible to SQPOLL in a meanwhile,
> and then you "commit" them by overwriting SQ tail pointer.
>
> Not a great exception for that is shared SQPOLL task, but it
> just waits someone to take care of the case.
>
> if (cap_entries && to_submit > 8)
> 	to_submit = 8;
>
>> If this is supported, link.head has to point to the last submitted SQE after
>>   the first io_submit_sqes()-call. Isn't then appending SQEs in the
>>   second io_submit_sqes()-call racy with the completion side. (With the
>>   same problems that I tried to solve?
>
> Exactly why it's not supported

Thank you for this detailed explanation. I now understand the design
decision with the SQE linking much better and why delayed linking of
SQEs introduces linking between completion and submission side that is
undesirable.

chris
-- 
Prof. Dr.-Ing. Christian Dietrich
Operating System Group (E-EXK4)
Technische Universität Hamburg
Am Schwarzenberg-Campus 3 (E), 4.092
21073 Hamburg

eMail:  christian.dietrich@tuhh.de
Tel:    +49 40 42878 2188
WWW:    https://osg.tuhh.de/
