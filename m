Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A4E838B260
	for <lists+io-uring@lfdr.de>; Thu, 20 May 2021 17:01:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhETPCf convert rfc822-to-8bit (ORCPT
        <rfc822;lists+io-uring@lfdr.de>); Thu, 20 May 2021 11:02:35 -0400
Received: from mailgate.zerties.org ([144.76.28.47]:42446 "EHLO
        mailgate.zerties.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231330AbhETPCd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 May 2021 11:02:33 -0400
Received: from a89-182-234-247.net-htp.de ([89.182.234.247] helo=localhost)
        by mailgate.zerties.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.93)
        (envelope-from <stettberger@dokucode.de>)
        id 1ljkAc-0007cU-E4; Thu, 20 May 2021 15:01:08 +0000
From:   Christian Dietrich <stettberger@dokucode.de>
To:     Pavel Begunkov <asml.silence@gmail.com>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
In-Reply-To: <0468c1d5-9d0a-f8c0-618c-4a40b4677099@gmail.com>
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
X-Commit-Hash-org: d18408fc8e33b9521828b731e7d04f3eb9eaa916
X-Commit-Hash-Maildir: f5bfa57f19f3619bf48535c3e94fc2f81fd22e0a
Date:   Thu, 20 May 2021 17:01:06 +0200
Message-ID: <s7bsg2hwitp.fsf@dokucode.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-SA-Do-Not-Rej: Yes
X-SA-Exim-Connect-IP: 89.182.234.247
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

Pavel Begunkov <asml.silence@gmail.com> [20. May 2021]:

> atomics/spinlocks scale purely, can be used we would surely prefer to
> avoid them in hot paths if possible.

I understand that. Do you consider SQE-Linking part of the hot path or
is it OK if linking SQE results overhead?

> E.g., if userspace is single threaded or already finely sync
> submission/completion, the exactly same algorithm can be implemented
> without any extra synchronisation there.

The problem that I see is that eBPF in io_uring breaks this fine
synchronization as eBPF SQE submission and userspace SQE submission can
run in parallel.

But going back to my original wish: I wanted to ensure that I can
serialize eBPF-SQEs such that I'm sure that they do not run in parallel.
My idea was to use synchronization groups as a generalization of
SQE linking in order to make it also useful for others (not only for eBPF).

My reasoning being not doing this serialization in userspace is that I
want to use the SQPOLL mode and execute long chains of
IO/computation-SQEs without leaving the kernelspace.

> Not telling that the feature can't have place, just needs good
> enough justification (e.g. performance or opening new use cases)
> comparing to complexity/etc. So the simpler/less intrusive the
> better.

I hope that you find this discussion as fruitful as I do. I really enjoy
searching for an abstraction that is simple and yet powerful enough to
fulfill user requirements.

>> At submission time, we have to append requests, if there is a
>> predecessor. For this, we extend io_submit_sqe to work with multiple
>> groups:
>> 
>>    u8 sg = req->sync_group;
>>    struct io_kiocb **link_field_new =
>>        (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) ? &(req->link) : NULL;
>> 
>> retry:
>>    struct io_kiocb **link_field = ctx->sync_groups[sg]
>>    if (link_field) {
>>        // Try to append to previous SQE. However, we might run in
>>        // parallel to __io_req_find_next.
>> 
>>        // Edit the link field of the previous SQE.
>>        *link_field = req;
>
> By this time the req might already be gone (and sync_groups[] changed to
> NULL/next), and so you may get use after free. Also modifying it will
> break some cancellation bits who want it to be stable and conditionally
> sync using completion_lock.

Yes, that is right if the completion side frees requests. Is this the
case or is the SQE returned to an io_kiocb cache?

>> In essence, the sync_groups would be a lock_free queue with a dangling
>> head that is even wait-free on the completion side. The above is surely
>> not correct, but with a few strategic load_aquire and the store_release
>> it probably can be made correct.
>
> Neither those are free -- cache bouncing

The problem that I had when thinking about the implementation is that
IO_LINK semantic works in the wrong direction: Link the next SQE,
whenever it comes to this SQE. If it would be the other way around
("Link this SQE to the previous one") it would be much easier as the
cost would only arise if we actually request linking. But compatibility..

>> And while it is not free, there already should be a similar kind of
>> synchronization between submission and completion if it should be
>> possible to link SQE to SQEs that are already in flight and could
>> complete while we want to link it.
>> Otherwise, SQE linking would only work for SQEs that are submitted in
>> one go, but as io_submit_state_end() does not clear
>> state->link.head, I think this is supposed to work.
>
> Just to clarify, it submits all the collected link before returning,
> just the invariant is based on link.head, if NULL there is no link,
> if not tail is initialised.

Ok, but what happens if the last SQE in an io_submit_sqes() call
requests linking? Is it envisioned that the first SQE that comes with
the next io_submit_sqes() is linked to that one?

If this is not supported, what happens if I use the SQPOLL mode where
  the poller thread can partition my submitted SQEs at an arbitrary
  point into multiple io_submit_sqes() calls?

If this is supported, link.head has to point to the last submitted SQE after
  the first io_submit_sqes()-call. Isn't then appending SQEs in the
  second io_submit_sqes()-call racy with the completion side. (With the
  same problems that I tried to solve?

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
