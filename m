Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA8FD38C4D0
	for <lists+io-uring@lfdr.de>; Fri, 21 May 2021 12:28:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234282AbhEUKaB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 May 2021 06:30:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234285AbhEUK3O (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 May 2021 06:29:14 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1229CC061352
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 03:27:32 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id d11so20518526wrw.8
        for <io-uring@vger.kernel.org>; Fri, 21 May 2021 03:27:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DBilce2lusVwzAf17UhFRU/LKmThktICF0Pe3pl1F00=;
        b=lASPRd6Yp983n1GYbkRGyYdwGmakdfF25PS5oZUp6KakggCYY2GQ7WhPY5cZTIGzAJ
         EYdEcw4FDUFq8gzHB5FvJH5vT8IxeCtdCxsLYHZ7186CWsZhbvSAuUjMpWrm1BQSuUQp
         SXXV0zWB988Ufr9gaKDoZbjFug358Zw7bi2Va8yQdRmaf8Zl7owajZAUnNuUC9q7ayvq
         kAARL43i2a662vq6de/cmJVcnR502bja+i3J8Pj4Tqj8dyXnntTzipQeXtlZexZ5s3P2
         WRem46ybR5DecC4agGj9/4oHEgUQsCPURTZkZ84jlfGjlrwsEaRcrlhc7pUzLcsKwdZ6
         GtfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DBilce2lusVwzAf17UhFRU/LKmThktICF0Pe3pl1F00=;
        b=HHI32KlQdkR6y4R+E73rfHi2Fg7VYXK0hqIlEBf5IU6jHXhQv+rXH/DEr9BTHsOjvj
         DbX5UcnbKsWdD6z/KutGzOK5RNvCgBNQq+U1auF+7+EhTYXZ4ZopCzXNJk1Y+BDlPePJ
         UJ+o62NWCzwaDfHUZaU7tAIM0Da46q5vDEyDCxDlC/TmwvrJOiHlX5EdHGwsUmbi+5pf
         dyeDIqFXTWbEFoCVefR5BdNvuGHYuLQjN9X0Y/AUHOhEYj5XtxQ2R4KbQFjBjQ4W7BzD
         X8J2ZrUHjVy0Z8mCZlDTrvfR3Mn13/7UCMKa8RfbKjbe7KXBqOSmydKWZ688n2cw3yKv
         DgVA==
X-Gm-Message-State: AOAM530WEyLGOHQQflAy59PG5sCdAlqtD9YXXhiBFNVcWo59bichdGeF
        U2iIqY0F4bnhgzQfH/wmoXk=
X-Google-Smtp-Source: ABdhPJx7F9fezk/RFo4x7+cUUV396R8R+1kZHd/vnSZ4qOuS8BCsfp/qd7xK9tbpTVjcoQBURbH/WA==
X-Received: by 2002:a5d:6291:: with SMTP id k17mr9163687wru.247.1621592850600;
        Fri, 21 May 2021 03:27:30 -0700 (PDT)
Received: from [192.168.8.197] ([85.255.236.182])
        by smtp.gmail.com with ESMTPSA id o21sm1550652wrf.91.2021.05.21.03.27.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 May 2021 03:27:30 -0700 (PDT)
To:     Christian Dietrich <stettberger@dokucode.de>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC] Programming model for io_uring + eBPF
Message-ID: <e11cd3e6-b1be-2098-732a-2987a5a9f842@gmail.com>
Date:   Fri, 21 May 2021 11:27:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <s7bsg2hwitp.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/20/21 4:01 PM, Christian Dietrich wrote:
> Pavel Begunkov <asml.silence@gmail.com> [20. May 2021]:
> 
>> atomics/spinlocks scale purely, can be used we would surely prefer to
>> avoid them in hot paths if possible.
> 
> I understand that. Do you consider SQE-Linking part of the hot path or
> is it OK if linking SQE results overhead?
> 
>> E.g., if userspace is single threaded or already finely sync
>> submission/completion, the exactly same algorithm can be implemented
>> without any extra synchronisation there.
> 
> The problem that I see is that eBPF in io_uring breaks this fine
> synchronization as eBPF SQE submission and userspace SQE submission can
> run in parallel.

It definitely won't be a part of ABI, but they actually do serialise
at the moment. But even if not, there are way doing that sync-less
not ctx-wide, but per submitter.

> But going back to my original wish: I wanted to ensure that I can
> serialize eBPF-SQEs such that I'm sure that they do not run in parallel.
> My idea was to use synchronization groups as a generalization of
> SQE linking in order to make it also useful for others (not only for eBPF).

So, let's dissect it a bit more, why do you need serialising as
such? What use case you have in mind, and let's see if it's indeed
can't be implemented efficiently with what we have.

To recap: BPFs don't share SQ with userspace at all, and may have
separate CQs to reap events from. You may post an event and it's
wait synchronised, so may act as a message-based synchronisation,
see test3 in the recently posted v2 for example. I'll also be
adding futex support (bpf + separate requests), it might
play handy for some users.

> My reasoning being not doing this serialization in userspace is that I
> want to use the SQPOLL mode and execute long chains of
> IO/computation-SQEs without leaving the kernelspace.

btw, "in userspace" is now more vague as it can be done by BPF
as well. For some use cases I'd expect BPF acting as a reactor,
e.g. on completion of previous CQEs and submitting new requests
in response, and so keeping it entirely in kernel space until
it have anything to tell to the userspace, e.g. by posting
into the main CQ. 

>> Not telling that the feature can't have place, just needs good
>> enough justification (e.g. performance or opening new use cases)
>> comparing to complexity/etc. So the simpler/less intrusive the
>> better.
> 
> I hope that you find this discussion as fruitful as I do. I really enjoy
> searching for an abstraction that is simple and yet powerful enough to
> fulfill user requirements.

It is, I just have my doubts that it's the most flexible/performant
option. Would be easier to reason with specific use cases in mind,
so we may see if it can't be done in a better way

>>> At submission time, we have to append requests, if there is a
>>> predecessor. For this, we extend io_submit_sqe to work with multiple
>>> groups:
>>>
>>>    u8 sg = req->sync_group;
>>>    struct io_kiocb **link_field_new =
>>>        (req->flags & (REQ_F_LINK | REQ_F_HARDLINK)) ? &(req->link) : NULL;
>>>
>>> retry:
>>>    struct io_kiocb **link_field = ctx->sync_groups[sg]
>>>    if (link_field) {
>>>        // Try to append to previous SQE. However, we might run in
>>>        // parallel to __io_req_find_next.
>>>
>>>        // Edit the link field of the previous SQE.
>>>        *link_field = req;
>>
>> By this time the req might already be gone (and sync_groups[] changed to
>> NULL/next), and so you may get use after free. Also modifying it will
>> break some cancellation bits who want it to be stable and conditionally
>> sync using completion_lock.
> 
> Yes, that is right if the completion side frees requests. Is this the
> case or is the SQE returned to an io_kiocb cache?

Might be freed. Caching them is a recent feature and doesn't cover
all the cases, at least for now.

>>> In essence, the sync_groups would be a lock_free queue with a dangling
>>> head that is even wait-free on the completion side. The above is surely
>>> not correct, but with a few strategic load_aquire and the store_release
>>> it probably can be made correct.
>>
>> Neither those are free -- cache bouncing
> 
> The problem that I had when thinking about the implementation is that
> IO_LINK semantic works in the wrong direction: Link the next SQE,
> whenever it comes to this SQE. If it would be the other way around
> ("Link this SQE to the previous one") it would be much easier as the
> cost would only arise if we actually request linking. But compatibility..

Stack vs queue style linking? If I understand what you mean right, that's
because this is how SQ is parsed and so that's the most efficient way.

>>> And while it is not free, there already should be a similar kind of
>>> synchronization between submission and completion if it should be
>>> possible to link SQE to SQEs that are already in flight and could
>>> complete while we want to link it.
>>> Otherwise, SQE linking would only work for SQEs that are submitted in
>>> one go, but as io_submit_state_end() does not clear
>>> state->link.head, I think this is supposed to work.
>>
>> Just to clarify, it submits all the collected link before returning,
>> just the invariant is based on link.head, if NULL there is no link,
>> if not tail is initialised.
> 
> Ok, but what happens if the last SQE in an io_submit_sqes() call
> requests linking? Is it envisioned that the first SQE that comes with
> the next io_submit_sqes() is linked to that one?

No, it doesn't leave submission boundary (e.g. a single syscall).
In theory may be left there _not_ submitted, but don't see much
profit in it.

> If this is not supported, what happens if I use the SQPOLL mode where
>   the poller thread can partition my submitted SQEs at an arbitrary
>   point into multiple io_submit_sqes() calls?

It's not arbitrary, submission is atomic in nature, first you fill
SQEs in memory but they are not visible to SQPOLL in a meanwhile,
and then you "commit" them by overwriting SQ tail pointer.

Not a great exception for that is shared SQPOLL task, but it
just waits someone to take care of the case.

if (cap_entries && to_submit > 8)
	to_submit = 8;
 
> If this is supported, link.head has to point to the last submitted SQE after
>   the first io_submit_sqes()-call. Isn't then appending SQEs in the
>   second io_submit_sqes()-call racy with the completion side. (With the
>   same problems that I tried to solve?

Exactly why it's not supported

-- 
Pavel Begunkov
