Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB35369641
	for <lists+io-uring@lfdr.de>; Fri, 23 Apr 2021 17:34:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237082AbhDWPfX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Apr 2021 11:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231748AbhDWPfX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Apr 2021 11:35:23 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 561A3C061574
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 08:34:46 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id x7so48779753wrw.10
        for <io-uring@vger.kernel.org>; Fri, 23 Apr 2021 08:34:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ntak25gWDrjH/OLErVgckVp/iX3bQ4MAaMhcw0lpovI=;
        b=E56c8m9m7Ljdel56xR9QwVs9PzPC2VV6IZz79ikDeJ4zOrC27d3sKY6WYpiOAN0nKg
         sARhbpjR97poaSDI3OaK+6GkWef0Yf6SU08QNY2X8XzNq9Q365RqPgM5fSdbaxeYwHoa
         D/CKQcwIEECPpBdt9zR1z8UcCuzGeMnaTqtxiUo5+uw9G2NG7c1aUcLpeYk1UFP9sqVa
         guvAyTNfJEKFtefo7iAoLEwjgg08NR9MlZCn3gR3oWRYSeRoWWJHy0isqu/fVrhimxfI
         YUpAWWLjO60bnEO8NI0mxbY9iMToTts3yq4R2y1DF9tonUXserf+ZmAJ2NH5bVg2jQSl
         EkvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ntak25gWDrjH/OLErVgckVp/iX3bQ4MAaMhcw0lpovI=;
        b=qHy+Tkb0bjPXaV/d+2bUM80nGER3dzUjqWE0FaUX4aOcaPBMp5M0FM1X6xA0KNbyvK
         sBzwveGaahgfZsSEG19UKHZvKQXakJOuHqV5CaP2ZiWzDUeYxY0cK/2tb1xJWpPB99WV
         rCLqJlsh/V975chPBdvF5HLjAqdj+cYGusK3CTU5hDhupFR4B870nANC5DRsKVfwpWGd
         0xJNZIRKx1Xr7D0lTqDBLji/k2dXYy2fSikXs0e3VBOzcwIheQCqBSTtQcYjFosQTLsX
         YGZwNKFOFdWYd1562kpB6rVnGb4wuJwt0FBRAJyw/Y9eJ33Y2AEE4Q1/edN8s8p7nrKy
         GKcw==
X-Gm-Message-State: AOAM531KuTIxsUjJqnEZG4PJymlnHk9bdFwPzWHiKCGFnf69IVX3PjfI
        cpoZaO893+Z6cmNTKYEaK4E=
X-Google-Smtp-Source: ABdhPJxGLiKVYVPgykzTYEqsJ2JVlqkrNQCazUVSnCNoVCzYuFlprCAcYNafB0Iw8KWZoPNvpMEW1Q==
X-Received: by 2002:adf:b608:: with SMTP id f8mr5688330wre.338.1619192084929;
        Fri, 23 Apr 2021 08:34:44 -0700 (PDT)
Received: from [192.168.8.197] ([148.252.128.225])
        by smtp.gmail.com with ESMTPSA id h9sm8408491wmb.35.2021.04.23.08.34.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Apr 2021 08:34:44 -0700 (PDT)
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
From:   Pavel Begunkov <asml.silence@gmail.com>
Message-ID: <f1e5d6cf-08a9-9110-071f-e89b09837e37@gmail.com>
Date:   Fri, 23 Apr 2021 16:34:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <s7bmttssyl4.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/20/21 5:35 PM, Christian Dietrich wrote:
> Hi Pavel,
> 
> thank you for your insights on the potential kernel integration.
> Hopefully this mail also lands on the mailinglist, because somehow my
> last mail was eaten by VGER although I'm a subscriber on that list.
> Let's see where this mail ends up.
> 
> Pavel Begunkov <asml.silence@gmail.com> [16. April 2021]:
> 
>>> 1. Program model
>>>     1. **Loading**: An eBPF program, which is a collection of functions,
>>>        can be attached to an uring. Each uring has at most one loaded
>>>        eBPF program
>>
>> An ebpf program is basically a single entry point (i.e. function), but
>> there is some flexibility on reusing them, iirc even dynamically, not
>> link-time only. So, from the io_uring/bpf perspective, you load a bunch
>> of bpf programs (i.e. separate functions) ...
> 
> From a intentional perspective, there is not much difference between N
> programs with one entry function each and one program with N entry
> functions. As a user of our new interface I want to have the possibility
> to preattach multiple eBPF functions to a uring in order to shadow the
> latency for loading (and potentially) jitting the eBPF program.

Yeah, absolutely. I don't see much profit in registering them
dynamically, so for now they will be needed to be loaded and attached
in advance. Or can be done in a more dynamic fashion, doesn't really
matter.

btw, bpf splits compilation and attach steps, adds some flexibility.


> My intention with wanting only a single program was to make it easier to
> emit SQEs that reference anot	unction. In an ideal world, the
> eBPF function only uses a `sqe.callback = &other_func' in its body.

Should look similar to the userspace, fill a 64B chunk of memory,
where the exact program is specified by an index, the same that is
used during attach/registration

> 
>>>     2. **Invocation**: Individual functions in that eBPF program can be
>>>        called.
>>>     3. These eBPF programs have some kind of global state that remains
>>>        valid across invocations.
>>
>> ... where the state is provided from the userspace in a form of bpf
>> map/array. So, it's not necessarily restricted by a single state, but
>> you can have many per io_uring.
>>
>> Hence, if userspace provides a single piece of state, that should be as
>> you described.
> 
> That should be fine as long as we do not have to transport the eBPF
> function pointer and the state pointer in every eBPF-SQE. As I heard,
> the space in an SQE is quite limited :-) Therefore, I designed an
> implicit method to pass state between invocations into the our model.

and context fd is just another field in the SQE. On the space -- it
depends. Some opcodes pass more info than others, and even for those we
yet have 16 bytes unused. For bpf I don't expect passing much in SQE, so
it should be ok.

>>>     3. All invocations on the same uring are serialized in their
>>>        execution -- even if the SQEs are part of different link
>>>        chains that are otherwise executed in parallel.
>>
>> Don't think it's a good idea to limit the kernel to it, but we
>> may try to find a userspace solution, or do it optionally.
> 
> I think this is a curcial point for the execution model as otherwise SQE
> executions have synchronize to with each other. I think it is consensus
> that these callback should have read and write access to different
> buffers, which provokes the question of data races. I see several
> solutions here:
> 
> - My proposed serialization promise

It can be an optional feature, but 1) it may become a bottleneck at
some point, 2) users use several rings, e.g. per-thread, so they
might need to reimplement serialisation anyway.

> 
> - Giving atomicity guarantees for the invocation of different eBPF
>   helper functions (e.g. write buffer to user memory). However, what
>   should I do if I want to perform a composed operation in an atomar
>   fashin? Surely, we do not want to have transactions.

Surely not in the kernel ;)

> 
> - Exposing synchronization primitives to the eBPF program. I don't think
>   that we can argue for semaphores in an eBPF program.

I remember a discussion about sleep-able bpf, we need to look what has
happened with it.

> With the serialization promise, we at least avoid the need to
> synchronize callbacks with callbacks. However, synchronization between
> user space and callback is still a problem.

Need to look up up-to-date BPF capabilities, but can also be spinlocks,
for both: bpf-userspace sync, and between bpf 
https://lwn.net/ml/netdev/20190116050830.1881316-1-ast@kernel.org/

Either just cancel bpf requests, and resubmit them.

> 
> In order to make this serialization promise less strict, we could hide
> it behind an SQE flag. Thereby, many callbacks can execute in parallel,
> while some are guaranteed to execute in sequence.
> 
>>> 3. Access to previous SQEs/CQEs (in a link chain)
>>>     1. In a link chain, the invocation can access the data of
>>>        (**all** or **the** -- subject to debate and application-scenario
>>>        requirements) previous SQEs and CQEs.
>>>     2. All SQEs get a flag that indicates that no CQE is emitted to
>>>        userspace. However, the CQE is always generated and can be
>>>        consumed by following invocation-SQEs.
>>
>> There is my last concept, was thinking about because feeding CQE of
>> only last linked request seems very limited to me.
>>
>> - let's allow to register multiple completion queues (CQs), for
>> simplicity extra ones are limited to BPF programs and not exported to
>> the userspace, may be lifted in the future
>>
>> - BPF requests are naturally allowed to reap CQEs from them and free
>> to choose from which exactly CQ (including from multiple).
>>
>> So, that solves 2) without flags because CQEs are posted, but userspace
>> can write BPF in such a way that they are reaped only by a specific BPF
>> request/etc. and not affecting others. As well as effectively CQEs part
>> of 1), without burden of extra allocations for CQEs, etc.
> 
> Ok, let me summarize that to know if I've understand it correctly.
> Instead of having one completion queue for a submission queue, there are
> now the user-exposed completion queue and (N-1) in-kernel completion

With a bit of work nothing forbids to make them userspace visible,
just next step to the idea. In the end I want to have no difference
between CQs, and everyone can reap from anywhere, and it's up to
user to use/synchronise properly.

> queues. On these queues, only eBPF programs can reap CQEs. If an eBPF
> wants to forward the CQE of the previous linked SQE, it reaps it from
> that queue and write it to the user-visible queue.

CQ is specified by index in SQE, in each SQE. So either as you say, or
just specify index of the main CQ in that previous linked request in
the first place.

> 
> How do I indicate at the first SQE into which CQ the result should be
> written?
> 
> On the first sight, this looks much more complex to me than using a flag
> to supress the emitting of CQEs.

Yes, adds a bit of complexity, but without it you can only get last CQE,
1) it's not flexible enough and shoots off different potential scenarios

2) not performance efficient -- overhead on running a bpf request after
each I/O request can be too large.

3) does require mandatory linking if you want to get result. Without it
we can submit a single BPF request and let it running multiple times,
e.g. waiting for on CQ, but linking would much limit options

4) bodgy from the implementation perspective

Just imagine that you will be able to synchronise between BPF programs
just by writing to the right CQ. Or can keep constant queue depth with
a single BPF program, and many more ideas flying around.

>> That's flexible enough to enable users to do many interesting things,
>> e.g. to project it onto graph-like events synchronisation models. This
>> may need some other things, e.g. like allowing BPF requests to wait
>> for >=N entries in CQ, but not of much concern.
> 
> In your mentioned scenario, I would submit an unlinked eBPF-SQE that
> says: exeucte this SQE only if that CQ has more than n entries.
> But wouldn't that introduce a whole new signaling and waiting that sits
> beside the SQE linking mechanism?

Should work just like CQ waiting, don't see any problem with it.

> Are we able to encode all of that into a single SQE that also holds an
> eBPF function pointer and (potenitally) an pointer to a context map?

yes, but can be just a separate linked request...

>>> 4. Data and control access within an invocation: Invocations can ...
>>>     1. Access preceeding SQEs and CQEs of the same link chain (see above).
>>
>> It'd be a problem to allow them to access preceeding SQEs. They're never
>> saved in requests, and by the time of execution previous requests are
>> already gone. And SQE is 64B, even alloc + copy would add too much of
>> overhead.
> 
> My rational behind this point was to have the arguments to the
> preceeding request at hand to have both, request and uring, specific
> state as arguments. But perhaps all of this can be done in userspace
> (and might even be more flexible) by supplying the correct eBPF map.

Right. And it should know what it's doing anyway in most cases. All
more complex dispatching / state machines can be pretty well
implemented via context.

> 
>>>     2. Emit SQEs and CQEs to the same uring. All SQEs that are submitted
>>>        by one invocation follow each other directly in the submission
>>>        ring to enable SQE linking.
>>
>> fwiw, no need to use the SQ for from BPF submissions, especially since
>> it may be used by the userspace in parallel and synchronises races is
>> painful.
> 
> Sure, we only have to have a possibility so create linked requests. They
> never have to fly through the SQ. Only on an intentional level it should
> be the same. And by mimicing the user-level interface, without backing
> it by the same implementation, it would be more familiar for the
> user-space developer.
> 
>>>     3. Read and write the whole userspace memory of the uring-owning
>>>        process.
>>
>> That's almost completely on BPF.
> 
> But probably, people have stark opinions on that, or? I mean, as far as
> i grasped the situation, people are quite skeptical on the capabilities
> of eBPF programs and fear the hell of an endless chain of vulnerabilities.

Capabilities are vast already, and there are restrictions because of
security reasons, and it's there not without a reason, so io_uring
won't try to circumvent bpf policies on that. If it's allowed, great,
if not, need to wait while a solution is figured out (if ever).

I believe there was something for accessing userspace memory, we
need to look it up.
 
>> Great job writing up requirements and use cases. Let's see how we can
>> improve it. My main concerns is 1) to keep it flexible, so use-cases
>> and ideas may bounce around, and allow multiple models to co-exists.
>> 2) but also keep it slim enough, because wouldn't be of much use if
>> it's faster to go through userspace and normal submissions.
> 
> I completely agree with your here. I would add another point to our
> bucket list of goals:
> 
>    3) it should be comprehensible for the user-space dev and follow the
>    principle of the least surprise.
> 
> I tried to accomplish this, by reproducing the user-space interface at
> the eBPF level. In the end it would be nice, if a user space program,
> toghether with the help of a few #defines and a little bit of
> make-magic, decide for each SQE-callback whether it should be executed
> in user- or in kernel space.

sounds interesting!

-- 
Pavel Begunkov
