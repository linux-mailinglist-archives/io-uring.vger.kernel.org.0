Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE81B3706B8
	for <lists+io-uring@lfdr.de>; Sat,  1 May 2021 11:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231244AbhEAJup (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 May 2021 05:50:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbhEAJuo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 May 2021 05:50:44 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 173F5C06174A
        for <io-uring@vger.kernel.org>; Sat,  1 May 2021 02:49:55 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id s82so409046wmf.3
        for <io-uring@vger.kernel.org>; Sat, 01 May 2021 02:49:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=deTys4JQwk5Y1Ge2Zy+3Od//RAnjAvH5yzy7zxS9qo4=;
        b=UZRF0Kq62agi5rPPp7/nF1BoWEYIcj852ftDB/MgxXPIVDmusuX13uFS/XPJ6/M4Y1
         YEbg8TsD4/5K6IF3iS4onnUQD84cY9vDpr/rNGGz0wAkKowoxq+aoh+RUYM58vn0aZ+7
         Br4n9RZh36IuFLb14dIzgoOj2a7LX/EYFPQNTOLe/gcXhN7ug3/nUZHaOFUUk3DkRgQ7
         aRabJHq1qyBpZXaHrMPe6rFMFKzn7K3VOv4T7WudFAhEweaP5ls1qUxROoApVQHzz9CG
         cmweQn598XHeEfd9cU7KvTGXR+S0lYRKuXeMDgw7/C1Isyj3y4yTGIni7dR5bFXwnD04
         UsaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=deTys4JQwk5Y1Ge2Zy+3Od//RAnjAvH5yzy7zxS9qo4=;
        b=QKvqrw5uaMjiN/TsefWaYMEeWLhhvvApopoW/DGjPM+WMjcxubjEMJs6ITsorhLkmJ
         gOWH4pbeGmcs+Kz4gyWJ4E/P31GYNwU6wiTSy4gvkm/0J1e6tFYvy18Fx0cBhEcdYLue
         I7nmNQ3y8Yolk095T3s4R03OkNTlIfcvz19WMEt9gRbgpnk+ypy2wfuXQdAWNgtJY9MI
         +SlGIyHVtcCxKgMTU7CC57kjFZuIKEVRObhwLFj5piwakFyIX5PXoc2wgj5C7dIE5rc4
         lPo3OUgkX8T5NGSKMwJoP3d+3/CA1fNw6fzmZJmYk2AsaR6Pg62b2djfZb2BctUStwcU
         UgMw==
X-Gm-Message-State: AOAM531Pv7pCfbeQg1L9r/YsSHV/oxAh3ondpqMM8DFTCXXFa0kVyq3Q
        gdBcZVTd9GDaVEUT+Gmme/Y=
X-Google-Smtp-Source: ABdhPJw2O086GKLvZiLWd0Y+JyPtRqKkRUUqDarKFjbIvOfJjUUvUUebW+4nULmQYO1MXk1oGd3PdQ==
X-Received: by 2002:a7b:ce84:: with SMTP id q4mr10891980wmj.149.1619862593642;
        Sat, 01 May 2021 02:49:53 -0700 (PDT)
Received: from [192.168.8.197] ([185.69.145.138])
        by smtp.gmail.com with ESMTPSA id l25sm5207564wmi.17.2021.05.01.02.49.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 May 2021 02:49:53 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
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
Message-ID: <46229c8c-7e9d-9232-1e97-d1716dfc3056@gmail.com>
Date:   Sat, 1 May 2021 10:49:48 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <s7bv985te4l.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/29/21 2:27 PM, Christian Dietrich wrote:
> Pavel Begunkov <asml.silence@gmail.com> [23. April 2021]:
> 
>> Yeah, absolutely. I don't see much profit in registering them
>> dynamically, so for now they will be needed to be loaded and attached
>> in advance. Or can be done in a more dynamic fashion, doesn't really
>> matter.
>>
>> btw, bpf splits compilation and attach steps, adds some flexibility.
> 
> So, I'm currently working on rebasing your work onto the tag
> 'for-5.13/io_uring-2021-04-27'. So if you already have some branch on
> this, just let me know to save the work.
I'll hack the v2 up the next week + patch some bugs I see, so
I'd suggest to wait for a bit. Will post an example together, because
was using plain bpf assembly for testing.

>> Should look similar to the userspace, fill a 64B chunk of memory,
>> where the exact program is specified by an index, the same that is
>> used during attach/registration
> 
> When looking at the current implementation, when can only perform the
> attachment once and there is no "append eBPF". While this is probably OK
> for code, for eBPF maps, we will need some kind of append eBPF map.

No need to register maps, it's passed as an fd. Looks I have never
posted any example, but you can even compile fds in in bpf programs
at runtime.

fd = ...;
bpf_prog[] = { ..., READ_MAP(fd), ...};
compile_bpf(bpf_prog);

I was thinking about the opposite, to allow to optionally register
them to save on atomic ops. Not in the next patch iteration though

Regarding programs, can be updated by unregister+register (slow).
And can be made more dynamic as registered files, but don't
see much profit in doing so, but open to use cases.

>> and context fd is just another field in the SQE. On the space -- it
>> depends. Some opcodes pass more info than others, and even for those we
>> yet have 16 bytes unused. For bpf I don't expect passing much in SQE, so
>> it should be ok.
> 
> So besides an eBPF-Progam ID, we would also pass an ID for an eEBF map
> in the SQE.

Yes, at least that's how I envision it. But that's a good question
what else we want to pass. E.g. some arbitrary ids (u64), that's
forwarded to the program, it can be a pointer to somewhere or just
a piece of current state.
 
> One thought that came to my mind: Why do we have to register the eBPF
> programs and maps? We could also just pass the FDs for those objects in
> the SQE. As long as there is no other state, it could be the userspaces
> choice to either attach it or pass it every time. For other FDs we
> already support both modes, right?

It doesn't register maps (see above). For not registering/attaching in
advance -- interesting idea, I need it double check with bpf guys.

>>> - My proposed serialization promise
>>
>> It can be an optional feature, but 1) it may become a bottleneck at
>> some point, 2) users use several rings, e.g. per-thread, so they
>> might need to reimplement serialisation anyway.
> 
> If we make it possible to pass some FD to an synchronization object
> (e.g. semaphore), this might do the trick to support both modes at the interface.
> 
>>> - Exposing synchronization primitives to the eBPF program. I don't think
>>>   that we can argue for semaphores in an eBPF program.
>>
>> I remember a discussion about sleep-able bpf, we need to look what has
>> happened with it.
> 
> But surely this would hurt a lot as we would have to manage not only
> eBPF programs, but also eBPF processes. While this is surely possible, I
> don't know if it is really suitable for a high-performance interface
> like io_uring. But, don't know about the state.
> 
>>
>>> With the serialization promise, we at least avoid the need to
>>> synchronize callbacks with callbacks. However, synchronization between
>>> user space and callback is still a problem.
>>
>> Need to look up up-to-date BPF capabilities, but can also be spinlocks,
>> for both: bpf-userspace sync, and between bpf 
>> https://lwn.net/ml/netdev/20190116050830.1881316-1-ast@kernel.org/
> 
> Using Spinlocks between kernel and userspace just feels wrong, very
> wrong. But it might be an alternate route to synchronization

Right, probably not the way to go, can't exist out of try_lock()
or blocking, but it's still interesting for me to look into in general

>> With a bit of work nothing forbids to make them userspace visible,
>> just next step to the idea. In the end I want to have no difference
>> between CQs, and everyone can reap from anywhere, and it's up to
>> user to use/synchronise properly.
> 
> I like the notion of orthogonality with this route. Perhaps, we don't
> need to have user-invisible CQs but it can be enough to address the CQ
> of another uring in my SQE as the sink for the resulting CQE.

Not going to happen, cross references is always a huge headache.

The idea is to add several CQs to a single ring, regardless of BPF,
and for any request of any type use specify sqe->cq_idx, and CQE
goes there. And then BPF can benefit from it, sending its requests
to the right CQ, not necessarily to a single one.
It will be the responsibility of the userspace to make use of CQs
right, e.g. allocating CQ per BPF program and so avoiding any sync,
or do something more complex cross posting to several CQs.

 
> Downside with that idea would be that the user has to setup another 
> ring with SQ and CQ, but only the CQ is used.
> 
>> [...]
> 
>> CQ is specified by index in SQE, in each SQE. So either as you say, or
>> just specify index of the main CQ in that previous linked request in
>> the first place.
> 
> From looking at the code: This is not yet the case, or? 

Right, not yet

>>> How do I indicate at the first SQE into which CQ the result should be
>>> written?
> 
>> Yes, adds a bit of complexity, but without it you can only get last CQE,
>> 1) it's not flexible enough and shoots off different potential scenarios
>>
>> 2) not performance efficient -- overhead on running a bpf request after
>> each I/O request can be too large.
>>
>> 3) does require mandatory linking if you want to get result. Without it
>> we can submit a single BPF request and let it running multiple times,
>> e.g. waiting for on CQ, but linking would much limit options
>>
>> 4) bodgy from the implementation perspective
> 
> When taking a step back, this is nearly a io_uring_enter(minwait=N)-SQE

Think of it as a separate request type (won't be a separate, but still...)
waiting on CQ, similarly to io_uring_enter(minwait=N) but doesn't block.

> with an attached eBPF callback, or? At that point, we are nearly full
> circle.

What do you mean?

>>> Are we able to encode all of that into a single SQE that also holds an
>>> eBPF function pointer and (potenitally) an pointer to a context map?
>>
>> yes, but can be just a separate linked request...
> 
> So, let's make a little collection about the (potential) information
> that our poor SQE has to hold. Thereby, FDs should be registrable and
> addressible by an index.
> 
> - FD to eBPF program

yes (index, not fd), but as you mentioned we should check

> - FD to eBPF map

we pass fd, but not register it (not by default)

> - FD to synchronization object during the execution

can be in the context, in theory. We need to check available
synchronisation means

> - FD to foreign CQ for waiting on N CQEs

It's a generic field in SQE, so not bpf specific. And a BPF program
submitting SQEs is free to specify any CQ index in them.

e.g. pseudo-code:

my_bpf_program(ctx) {
   sqe = prep_read(ctx, ...);
   sqe->cq_idx = 1;

   sqe = prep_recv(ctx, ...);
   sqe->cq_idx = 42;
}

> 
> That are a lot of references to other object for which we would have
> to extend the registration interface.

So, it's only bpf programs that it registers.

>> Right. And it should know what it's doing anyway in most cases. All
>> more complex dispatching / state machines can be pretty well
>> implemented via context.
> 
> You convinced me that an eBPF map as a context is the more canonical way
> of doing it by achieving the same degree of flexibility.
> 
>> I believe there was something for accessing userspace memory, we
>> need to look it up.
> 
> Either way, from a researcher perspective, we can just allow it and look
> how it can performs.

-- 
Pavel Begunkov
