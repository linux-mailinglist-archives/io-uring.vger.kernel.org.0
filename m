Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 690CC3767B6
	for <lists+io-uring@lfdr.de>; Fri,  7 May 2021 17:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231675AbhEGPLW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 7 May 2021 11:11:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230118AbhEGPLV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 7 May 2021 11:11:21 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF114C061574
        for <io-uring@vger.kernel.org>; Fri,  7 May 2021 08:10:21 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id n2so9677093wrm.0
        for <io-uring@vger.kernel.org>; Fri, 07 May 2021 08:10:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=4Wi7/V2DTcwe5b25dfNba2ouaoJaw77Zfp9HP9qM45g=;
        b=ZkM+pXccgF3F+mqgTx98kaEfMOyBrfn8A59mVe2CRLl5FV12ws3pyS5KQKxd9CLrkL
         a0blhS3qqrFi9eaTdkTHMkW6/CmwuxDwwWSAXNFOseZg8HT37JbRoqnAisaeLkfmFVYs
         QdOnU5rGpOr95OsF11bFhH3mneWf0U562x2f43MdlPC+Kaw424GChiaQTTtRWCtKB+yZ
         Aa1pfmF/iQIoCsgoQexFBZFtwtmwBymnNzCFh1AgPmg+oDvgSAMntpr6/TPlximDhREr
         gAGmV2+NCfH08/gChOVkgm/5qH+zmNfeLvODYVb2L2YEHp/TetX8ezPakpM4CeeA6l31
         4qmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=4Wi7/V2DTcwe5b25dfNba2ouaoJaw77Zfp9HP9qM45g=;
        b=stcsNxuj4FFf2/KECls3OiQbRNZ/2JSCoLaVuNoHV5Ht0ziZwjWjVI6YKaXYEnpp6W
         nyrYdtpS+rWR/A9Ld5/VrBwljMNsr6GwxHfuuRsW0vZC5vX3m/jNQv0I27XVaZFNgE/i
         OD7+C2SESmt6ZQqtTMcZRW3fPveWddmeounG1HfQ0iBD8dZ5HHqCDB0WMlL07afhatjS
         yN1GTz/xRnfLFIQBu07LNces3BKJpRnhEFBIG7epHvjCWPQa+Lpnq5un7RGy5lF/YF2i
         1uD1HKbO/UYCgFi028SavntrO37qeH0bZL/v1YuXrvTj/SxiSXNBwNrnuN8+7t2jprBI
         /D/Q==
X-Gm-Message-State: AOAM531U8+DGXJBPKe+bO/Db/rq3FZchOAK6Tg2p7jNM4MVlIGbFk1Pp
        4nat3SRHAtIEz02miq3VMbp+yItO3rw=
X-Google-Smtp-Source: ABdhPJyQhDC5+Gu/aluj/WkrkgpgEy+BiCRIfYiks4ykECLDISXXkgZ14RW9lDhTDIOdE+ENEaladQ==
X-Received: by 2002:a5d:4cce:: with SMTP id c14mr13528994wrt.29.1620400220411;
        Fri, 07 May 2021 08:10:20 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.132.80])
        by smtp.gmail.com with ESMTPSA id l66sm7149430wmf.20.2021.05.07.08.10.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 08:10:19 -0700 (PDT)
Subject: Re: [RFC] Programming model for io_uring + eBPF
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
 <s7bpmy5pcc3.fsf@dokucode.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <3e857fef-224d-47be-f2e9-7bf0c3f9a91e@gmail.com>
Date:   Fri, 7 May 2021 16:10:14 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <s7bpmy5pcc3.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/21 1:57 PM, Christian Dietrich wrote:
> Pavel Begunkov <asml.silence@gmail.com> [01. May 2021]:
> 
>> No need to register maps, it's passed as an fd. Looks I have never
>> posted any example, but you can even compile fds in in bpf programs
>> at runtime.
>>
>> fd = ...;
>> bpf_prog[] = { ..., READ_MAP(fd), ...};
>> compile_bpf(bpf_prog);
>>
>> I was thinking about the opposite, to allow to optionally register
>> them to save on atomic ops. Not in the next patch iteration though
> 
> That was exactly my idea:  make it possible to register them
> optionally.
> 
> I also think that registering the eBPF program FD could be made
> optionally, since this would be similar to other FD references that are
> submitted to io_uring.

To wrap it, map registration wasn't required nor possible from
the beginning, but can be interesting to allow it optionally. And
the opposite for programs.
 
>> Yes, at least that's how I envision it. But that's a good question
>> what else we want to pass. E.g. some arbitrary ids (u64), that's
>> forwarded to the program, it can be a pointer to somewhere or just
>> a piece of current state.
> 
> So, we will have the regular user_data attribute there. So why add
> another potential argument to the program, besides passing an eBPF map?

It may be more flexible or performant, I'm not eager adding more to
it, but we'll see if it's good enough as is once we write some larger
bpf programs.

>>> One thought that came to my mind: Why do we have to register the eBPF
>>> programs and maps? We could also just pass the FDs for those objects in
>>> the SQE. As long as there is no other state, it could be the userspaces
>>> choice to either attach it or pass it every time. For other FDs we
>>> already support both modes, right?
>>
>> It doesn't register maps (see above). For not registering/attaching in
>> advance -- interesting idea, I need it double check with bpf guys.
> 
> My feeling would be the following: In any case, at submission we have to
> resolve the SQE references to a 'bpf_prog *', if this is done via a
> registered program in io_ring_ctx or via calling 'bpf_prog_get_type' is
> only a matter of the frontend.

Yes, I took on this point.

> The only difference would be the reference couting. For registered
> bpf_progs, we can increment the refcounter only once. For unregistered,
> we would have to increment it for every SQE. Don't know if the added
> flexibility is worth the effort.
> 
>>> If we make it possible to pass some FD to an synchronization object
>>> (e.g. semaphore), this might do the trick to support both modes at the interface.
> 
> I was thinking further about this. And, really I could not come up with
> a proper user-space visible 'object' that we can grab with an FD to
> attach this semantic to as futexes come in form of a piece of memory.

Right, not like, but exactly futexes. There is an interest in having
futex requests, so need to write it up.

> So perhaps, we would do something like
> 
>     // alloc 3 groups
>     io_uring_register(fd, REGISTER_SYNCHRONIZATION_GROUPS, 3);
> 
>     // submit a synchronized SQE
>     sqe->flags |= IOSQE_SYNCHRONIZE;
>     sqe->synchronize_group = 1;     // could probably be restricted to uint8_t.
> 
> When looking at this, this could generally be a nice feature to have
> with SQEs, or? Hereby, the user could insert all of his SQEs and they
> would run sequentially. In contrast to SQE linking, the order of SQEs
> would not be determined, which might be beneficial at some point.

It will be in the common path hurting performance for those not using
it, and with no clear benefit that can't be implemented in userspace.
And io_uring is thin enough for all those extra ifs to affect end
performance.

Let's consider if we run out of userspace options.
 
>>> - FD to synchronization object during the execution
>>
>> can be in the context, in theory. We need to check available
>> synchronisation means
> 
> In the context you mean: there could be a pointer to user-memory and the
> bpf program calls futex_wait?
> 
>> The idea is to add several CQs to a single ring, regardless of BPF,
>> and for any request of any type use specify sqe->cq_idx, and CQE
>> goes there. And then BPF can benefit from it, sending its requests
>> to the right CQ, not necessarily to a single one.
>> It will be the responsibility of the userspace to make use of CQs
>> right, e.g. allocating CQ per BPF program and so avoiding any sync,
>> or do something more complex cross posting to several CQs.
> 
> Would this be done at creation time or by registering them? I think that
> creation time would be sufficient and it would ease the housekeeping. In
> that case, we could get away with making all CQs equal in size and only
> read out the number of the additional CQs from the io_uring_params.

At creation time. Don't see a reason to move it to post creation, and
see a small optimisation weighting for it.

> 
> When adding a sqe->cq_idx: Do we have to introduce an IOSQE_SELET_OTHER
> flag to not break userspace for backwards compatibility or is it
> sufficient to assume that the user has zeroed the SQE beforehand?

Fine by me assuming zeros.

> However, I like the idea of making it a generic field of SQEs.
> 
>>> When taking a step back, this is nearly a io_uring_enter(minwait=N)-SQE
>>
>> Think of it as a separate request type (won't be a separate, but still...)
>> waiting on CQ, similarly to io_uring_enter(minwait=N) but doesn't block.
>>
>>> with an attached eBPF callback, or? At that point, we are nearly full
>>> circle.
>>
>> What do you mean?
> 
> I was just joking: With a minwait=N-like field in the eBPF-SQE, we can
> mimic the behavior of io_uring_enter(minwait=N) but with an SQE. On the
> result of that eBPF-SQE we can now actually wait with io_uring_enter(..)

-- 
Pavel Begunkov
