Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4077E3986EA
	for <lists+io-uring@lfdr.de>; Wed,  2 Jun 2021 12:49:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231952AbhFBKuo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 2 Jun 2021 06:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230321AbhFBKtu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 2 Jun 2021 06:49:50 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2929CC061763
        for <io-uring@vger.kernel.org>; Wed,  2 Jun 2021 03:48:01 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id h12-20020a05600c350cb029019fae7a26cdso1372541wmq.5
        for <io-uring@vger.kernel.org>; Wed, 02 Jun 2021 03:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=48OcPMCgzRaV4Hvf2hUEiH5aAfW3sJxFOm4K9wlET9E=;
        b=KuNzUhiWdKjqf0oZolZRhBVSn/MivnmN1yif6JYWmBn2RCMRE0zJwp9GnHz7FewA6w
         ZcKfHaVQ65xqO4KAlX9/lcgPOtpXR2U9IRD3KssDII5BX6l+UO6V+Xaf+pnuQBgqlM/K
         oTdSSRoflDEnDZIykGSB+UyivFnIfh1gLpSJktDhK9wA812Db46aqno7JvLjA9CcFLzN
         Pngdg81xy38r1DIl1UrUcg/eG8gb0PdAy2tLsNfAB+9XdZOND1Mn42SchsRTBH/hU4kN
         I8gJeYpf43+gwCP46ONuFIwoTjFm4/JMfVKlUxJzF764TdrJ0Tp9dObMgrILw684i5OG
         IZrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=48OcPMCgzRaV4Hvf2hUEiH5aAfW3sJxFOm4K9wlET9E=;
        b=LiNbr1paE2F3ieSGQat8rs9ZLEH1BSb0dn+XM0cIxpgfGk9YX1nyN8XlxfCg8/O1e2
         os7i6aDNVHHUo1J+KQLHO+JwNNwgHo8fV8WdMDeiOjg+FBB2DO5+Aqolm7lQRfiHarcd
         rLUWolUXj70DiD8mWsd6/PxcliYMiNHbf7JvDPEWzHZacwccN2T7QQ+J2ibRl5ElIJX5
         zyl6w12ErIc0ZYumQu6CsMRIo8xrh/sGyg7nUIZDhUS6Q3XPhPeScOeLeI5muKtcL//W
         ATAuaQURef8hr0NJzGkjhZnwYZ5AahjZwBnCBeSYkFy5/ITpyed6mlQ/GEwgrdWUpl7x
         JMZg==
X-Gm-Message-State: AOAM533re8YoYCQ+w+SNfw3BcobLDrtemwkodd8XvxStbiTpchZ17N3/
        Z4PQUPvw4JwLuXPsXCOtfxE=
X-Google-Smtp-Source: ABdhPJysv3XIbEYHStWFwg1Xhy/PKQoTqzcPIC4oEJl9bE+XbAsRfCDefZW2ZvxID3r4sx1DNaO/lQ==
X-Received: by 2002:a05:600c:4657:: with SMTP id n23mr4634790wmo.47.1622630879762;
        Wed, 02 Jun 2021 03:47:59 -0700 (PDT)
Received: from ?IPv6:2620:10d:c096:310::2410? ([2620:10d:c092:600::2:f0d])
        by smtp.gmail.com with ESMTPSA id v8sm7028408wrc.29.2021.06.02.03.47.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 02 Jun 2021 03:47:59 -0700 (PDT)
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
 <e11cd3e6-b1be-2098-732a-2987a5a9f842@gmail.com>
 <s7b1r9sfn1k.fsf@dokucode.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Subject: Re: [RFC] Programming model for io_uring + eBPF
Message-ID: <49df117c-dcbd-9b91-e181-e5b2757ae6aa@gmail.com>
Date:   Wed, 2 Jun 2021 11:47:50 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <s7b1r9sfn1k.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/27/21 12:12 PM, Christian Dietrich wrote:
> Pavel Begunkov <asml.silence@gmail.com> [21. May 2021]:
> 
>>> The problem that I see is that eBPF in io_uring breaks this fine
>>> synchronization as eBPF SQE submission and userspace SQE submission can
>>> run in parallel.
>>
>> It definitely won't be a part of ABI, but they actually do serialise
>> at the moment.
> 
> They serialize because they are executed by the same worker thread,
> right?

No, because all submissions are currently under ctx->uring_lock mutex
and also executed in the submitting task context (no io-wq). I hope to
get rid of the second restriction, i.e. prior upstreaming, and maybe
do something about the first one in far future if there will be a need.

> Perhaps that is the solution to my synchronization problem. If/when
> io_uring supports more than one eBPF executioners, we should make the
> number of executors configurable at setup time. Thereby, the user can
> implicitly manage serialization of eBPF execution.

I wouldn't keep it a part of ABI, but may be good enough for
experiments. So, it'll be UB and may break unless we figure
something out.

... actually it sounds like a sane idea to do lock grabbing lazy,
i.e. only if it actually submits requests. That may make sense if
you control several requests by BPF, e.g. keeping QD + batching.

>>> But going back to my original wish: I wanted to ensure that I can
>>> serialize eBPF-SQEs such that I'm sure that they do not run in parallel.
>>> My idea was to use synchronization groups as a generalization of
>>> SQE linking in order to make it also useful for others (not only for eBPF).
>>
>> So, let's dissect it a bit more, why do you need serialising as
>> such? What use case you have in mind, and let's see if it's indeed
>> can't be implemented efficiently with what we have.
> 
> What I want to do is to manipulate (read-calculate-update) user memory
> from eBPF without the need to synchronize between eBPF invocations.
> 
> As eBPF invocations have a run-to-completion semantic, it feels bad to
> use lock-based synchronization. Besides waiting for user-memory to be
> swapped in, they will be usually short and plug together results and
> newly emitted CQEs.

swapping can't be done under spinlocks, that's a reason why userspace
read/write are available only to sleepable BPF.

btw, I was thinking about adding atomic ops with userspace memory.
I can code an easy solution, but may have too much of additional
overhead. Same situation with normal load/stores being slow
mentioned below.

> 
>> To recap: BPFs don't share SQ with userspace at all, and may have
>> separate CQs to reap events from. You may post an event and it's
>> wait synchronised, so may act as a message-based synchronisation,
>> see test3 in the recently posted v2 for example. I'll also be
>> adding futex support (bpf + separate requests), it might
>> play handy for some users.
> 
> I'm sure that it is possible to use those mechanisms for synchronizing,
> but I assume that explicit synchronization (locks, passing tokens
> around) is more expensive than sequenzializing requests (implicit
> synchronization) before starting to execute them.

As you know it depends on work/synchronisation ratio, but I'm also
concerned about scalability. Consider same argument applied to
sequenzializing normal user threads (e.g. pthreads). Not quite
of the same extent but shows the idea.

> But probably, we need some benchmarks to see what performs better.

Would be great to have some in any case. Userspace read/write
may be slow. It can be solved (if a problem) but would require
work to be done on the BPF kernel side

>>> My reasoning being not doing this serialization in userspace is that I
>>> want to use the SQPOLL mode and execute long chains of
>>> IO/computation-SQEs without leaving the kernelspace.
>>
>> btw, "in userspace" is now more vague as it can be done by BPF
>> as well. For some use cases I'd expect BPF acting as a reactor,
>> e.g. on completion of previous CQEs and submitting new requests
>> in response, and so keeping it entirely in kernel space until
>> it have anything to tell to the userspace, e.g. by posting
>> into the main CQ.
> 
> Yes, exactly that is my motivation. But I also think that it is a useful
> pattern to have many eBPF callbacks pending (e.g. one for each
> connection).

Good case. One more moment is how much generality such cases need.
E.g. there are some data structures in BPF, don't remember names
but like perf buffers or perf rings.

> 
> With one pending invocation per connection, synchronization with a fixed
> number of additional CQEs might be problematic: For example, for a
> per-connection barrier synchronization with the CQ-reap approach, one
> needs one CQ for each connection.
> 
>>> The problem that I had when thinking about the implementation is that
>>> IO_LINK semantic works in the wrong direction: Link the next SQE,
>>> whenever it comes to this SQE. If it would be the other way around
>>> ("Link this SQE to the previous one") it would be much easier as the
>>> cost would only arise if we actually request linking. But compatibility..
>>
>> Stack vs queue style linking? If I understand what you mean right, that's
>> because this is how SQ is parsed and so that's the most efficient way.
> 
> No, I did not want to argue about the ordering within the link chain,
> but with the semantic of link flag. I though that it might have been
> beneficial to let the flag indicate that the SQE should be linked to the
> previous one. However, after thinking this through in more detail I now
> believe that it does not make any difference for the submission path.
> 
> 
>>> Ok, but what happens if the last SQE in an io_submit_sqes() call
>>> requests linking? Is it envisioned that the first SQE that comes with
>>> the next io_submit_sqes() is linked to that one?
>>
>> No, it doesn't leave submission boundary (e.g. a single syscall).
>> In theory may be left there _not_ submitted, but don't see much
>> profit in it.
>>
>>> If this is not supported, what happens if I use the SQPOLL mode where
>>>   the poller thread can partition my submitted SQEs at an arbitrary
>>>   point into multiple io_submit_sqes() calls?
>>
>> It's not arbitrary, submission is atomic in nature, first you fill
>> SQEs in memory but they are not visible to SQPOLL in a meanwhile,
>> and then you "commit" them by overwriting SQ tail pointer.
>>
>> Not a great exception for that is shared SQPOLL task, but it
>> just waits someone to take care of the case.
>>
>> if (cap_entries && to_submit > 8)
>> 	to_submit = 8;
>>
>>> If this is supported, link.head has to point to the last submitted SQE after
>>>   the first io_submit_sqes()-call. Isn't then appending SQEs in the
>>>   second io_submit_sqes()-call racy with the completion side. (With the
>>>   same problems that I tried to solve?
>>
>> Exactly why it's not supported
> 
> Thank you for this detailed explanation. I now understand the design
> decision with the SQE linking much better and why delayed linking of
> SQEs introduces linking between completion and submission side that is
> undesirable.

You're welcome, hope we'll get API into shape in no time

-- 
Pavel Begunkov
