Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DFEA362489
	for <lists+io-uring@lfdr.de>; Fri, 16 Apr 2021 17:55:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236107AbhDPPyL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Apr 2021 11:54:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235676AbhDPPyH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Apr 2021 11:54:07 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E59C061574
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 08:53:42 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id a4so27184412wrr.2
        for <io-uring@vger.kernel.org>; Fri, 16 Apr 2021 08:53:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r1J7YVOpdf6Slh4B5gllP/Suj03cOuvwna5aiPIJWaE=;
        b=vRUVq6AQnaCBfD8YWGNAl/dvsqG4zQbZ3DYql9x5JgEtRzl/o9R86+VnUWcioQ3HgK
         VFbb1JG9AlIfF7CDJG+ccEMdwuw9sX5Em1UbX0FiACD3D50dWCpsMSDILazkSEKXAIwp
         KBICt4A2G+ciY9kZ0REW2AePrPj6wX/gfSSdMjUqJ1FGDDOQPc6wwuOaFIsoCucjvge6
         AcIcPmrZH9AeDDDxgVZLnjPvcs7QT3+YptI9OPuHjx6xmc+FRM8cHBijM53H6qLM9xNo
         mKY9xROHDezzQz6vb0U9PhIQMAQRqD8CVYbPUcgnH0L+PFh8Lqcp8++xa5cBXq4VFTMv
         tt7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=r1J7YVOpdf6Slh4B5gllP/Suj03cOuvwna5aiPIJWaE=;
        b=bzzqsFKDQIH7hAXzflSPJcoR8UvfxA5Ybu+MU+6wzOKTqAwQZyBqtYTMqmiibgegUu
         TIKZevrsbGGor+kyvEEt5CeVRnT6VG8LGhJlLZwVF9f0lR+VRI1C/7O4vmC+Prrbo2DQ
         O6izVulMTVlhhXTm1YiDw8nscgTLYkqsisVh3wxJ6WZeGujsDxgspWVjchdNh3H0SG5h
         BeC7grwJcwcLBMvkXjer+PmdfyYeJz7EyvCYDVC/z0mke5aV5W9V6aY2ZR11u4d7cclK
         MYg5278DnNYVEouwC1P1TBGzJXIXYRUxarhzqy8wzhqiXfr1pu2IVr2z4pPqWYFEH0he
         VUtQ==
X-Gm-Message-State: AOAM533GhXigkAeMe0bwStKeXA0KEzWcYiCxlGntnnfAsbgn6Xbx0KRQ
        HKXQV0ozqD9B2vm5Js4dUuhlLGQQmyEayA==
X-Google-Smtp-Source: ABdhPJzGeiSyLjMSFL7hyKHq6Y2800gVFp/uBywD2attLSPZXCDflDEfYyxRW+owOjcHyg+ddqSoPw==
X-Received: by 2002:a5d:4850:: with SMTP id n16mr9878817wrs.294.1618588421369;
        Fri, 16 Apr 2021 08:53:41 -0700 (PDT)
Received: from [192.168.8.191] ([148.252.132.77])
        by smtp.gmail.com with ESMTPSA id p18sm10799144wrs.68.2021.04.16.08.53.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Apr 2021 08:53:41 -0700 (PDT)
To:     Christian Dietrich <christian.dietrich@tuhh.de>,
        io-uring <io-uring@vger.kernel.org>
Cc:     Horst Schirmeier <horst.schirmeier@tu-dortmund.de>,
        "Franz-B. Tuneke" <franz-bernhard.tuneke@tu-dortmund.de>
References: <s7bsg4slmn3.fsf@dokucode.de>
 <9b3a8815-9a47-7895-0f4d-820609c15e9b@gmail.com>
 <s7btuo6wi7l.fsf@dokucode.de>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [RFC] Programming model for io_uring + eBPF
Message-ID: <4a553a51-50ff-e986-acf0-da9e266d97cd@gmail.com>
Date:   Fri, 16 Apr 2021 16:49:29 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <s7btuo6wi7l.fsf@dokucode.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 16/04/2021 13:02, Christian Dietrich wrote:
> Hello,
> 
> we [1] are operating-system researchers from Germany and noticed the LWN
> article about the combination of io_uring and eBPF programs. We think
> that high-performance system-call interfaces in combination with
> programability are the perfect substrate for system-call clustering.
> Therefore, we had some intense discussions how the combination of eBPF
> and io_uring could look like, and we would like to present our ideas
> here. In a nutshell, our goal is to give applications the possibility to
> perform complex I/O operations, or even their whole application logic,
> with less kernel-userspace transitions.

Hi Christian, Horst, Franz-Bernhard,

It's nice to hear from you again. Sounds good, we need to have this
discussion to refine interfaces. The model makes much sense, but let
me outline some details and how it matches up from the kernel and
implementation perspective

> 
> First, we want to present our idea what the execution model should look
> like in order to give the user program the possibility to program its
> I/O behavior, before we give a few coarse examples how this execution
> model can be used to structure complex I/O operations.
> 
> Execution model
> ================
> 
> Think of the execution model as a list of short high-level statements
> about the capabilities that the io_uring+eBPF interface should provide.
> For each point, in-detail design decisions will be necessary to
> integrate it well with the kernel.
> 
> 1. Program model
>     1. **Loading**: An eBPF program, which is a collection of functions,
>        can be attached to an uring. Each uring has at most one loaded
>        eBPF program

An ebpf program is basically a single entry point (i.e. function), but
there is some flexibility on reusing them, iirc even dynamically, not
link-time only. So, from the io_uring/bpf perspective, you load a bunch
of bpf programs (i.e. separate functions) ...

>     2. **Invocation**: Individual functions in that eBPF program can be
>        called.
>     3. These eBPF programs have some kind of global state that remains
>        valid across invocations.

... where the state is provided from the userspace in a form of bpf
map/array. So, it's not necessarily restricted by a single state, but
you can have many per io_uring.

Hence, if userspace provides a single piece of state, that should be as
you described. 

> 
> 2. Invocation model
>     1. An invocation to any function in the loaded eBPF program can
>        be queued as an SQE.
>     2. If an invocation SQE is part of an SQE link chain, it is
>        (as usual) executed after the preceeding I/O operation has
>        finished.

Right, just like any other linked request

>     3. All invocations on the same uring are serialized in their
>        execution -- even if the SQEs are part of different link
>        chains that are otherwise executed in parallel.

Don't think it's a good idea to limit the kernel to it, but we
may try to find a userspace solution, or do it optionally.

>     4. Invocations have run-to-completion semantics.
> 
> 3. Access to previous SQEs/CQEs (in a link chain)
>     1. In a link chain, the invocation can access the data of
>        (**all** or **the** -- subject to debate and application-scenario
>        requirements) previous SQEs and CQEs.
>     2. All SQEs get a flag that indicates that no CQE is emitted to
>        userspace. However, the CQE is always generated and can be
>        consumed by following invocation-SQEs.

There is my last concept, was thinking about because feeding CQE of
only last linked request seems very limited to me.

- let's allow to register multiple completion queues (CQs), for
simplicity extra ones are limited to BPF programs and not exported to
the userspace, may be lifted in the future

- BPF requests are naturally allowed to reap CQEs from them and free
to choose from which exactly CQ (including from multiple).

So, that solves 2) without flags because CQEs are posted, but userspace
can write BPF in such a way that they are reaped only by a specific BPF
request/etc. and not affecting others. As well as effectively CQEs part
of 1), without burden of extra allocations for CQEs, etc.

That's flexible enough to enable users to do many interesting things,
e.g. to project it onto graph-like events synchronisation models. This
may need some other things, e.g. like allowing BPF requests to wait
for >=N entries in CQ, but not of much concern.

> 4. Data and control access within an invocation: Invocations can ...
>     1. Access preceeding SQEs and CQEs of the same link chain (see above).

It'd be a problem to allow them to access preceeding SQEs. They're never
saved in requests, and by the time of execution previous requests are
already gone. And SQE is 64B, even alloc + copy would add too much of
overhead.


>     2. Emit SQEs and CQEs to the same uring. All SQEs that are submitted
>        by one invocation follow each other directly in the submission
>        ring to enable SQE linking.

fwiw, no need to use the SQ for from BPF submissions, especially since
it may be used by the userspace in parallel and synchronises races is
painful.

>     3. Read and write the whole userspace memory of the uring-owning
>        process.

That's almost completely on BPF.
 
> We think that this execution model provides a few important design
> considerations that make programming I/O feasible to application
> developers:
> 
> With the capability to access previous SQEs (3.1) and userspace memory
> (4.3), invocations can directly manipulate the read and written results
> of previous I/O operations. There, we could also avoid to provide buffer
> allocation/deallocation mechanisms for invocations. While this might be
> a point of debate for the Linux kernel, it is definitely something we
> want to try in our academic setting.
> 
> With the serialization guarantees (2.3 and 2.4), the user has not to
> worry about synchronization within the eBPF program itself, and we
> somehow mimic the (unluckily successful) execution model of JavaScript.
> 
> With the possibility to submit linked pairs of I/O-SQE and
> invocation-SQE (4.2), an invocation can submit several parallelly
> running I/O requests. With the possibility to supress emitting CQEs to
> userspace (3.2), long chains of computation+I/O can be executed without
> disturbing userspace.
> 
> By having global state (1.3) and the serialization guarantees, complex
> synchronization (e.g. barrier) can be implemented within such eBPF
> programs.

Great job writing up requirements and use cases. Let's see how we can
improve it. My main concerns is 1) to keep it flexible, so use-cases
and ideas may bounce around, and allow multiple models to co-exists.
2) but also keep it slim enough, because wouldn't be of much use if
it's faster to go through userspace and normal submissions.

Let me know what you think

> 
> 
> # Application Examples
> 
> In order to make our imagined execution model more plastic, we want to
> give a few examples how our proposed interface could be used to program
> I/O. For this, we have drawn a pretty picture:
> 
>    https://i.imgur.com/HADDfrv.png
>    Also attached with this mail as an PDF.
>    
> 
> 
> 
> 
> 
> ## Postprocess
> 
> We submit two linked SQEs into the queue. The first one performs an I/O
> operation and does not emit a CQE. The second is an invocation that can
> access the previous SQE, the CQE, and the resulting buffer. After some
> postprocessing, it emits a CQE to the completion queue.
> 
> ## I/O -> Computation -> I/O Loops
> 
> This is an extension to the postprocess example. Instead of always
> emitting a CQE, the invocation can also decide to queue another pair of
> I/O+invocation SQEs to perform another round of postprocessed I/O.
> 
> An example for such an I/O loop could be to parse the header of some
> network protocol. The loop parses incoming data until the header is
> complete or until some unhandled corner case occurs. In these cases, the
> loop can **escalate** to the userspace by emitting an CQE.
> 
> 
> ## Fork-Join Parallelism
> 
> As an invocation can emit multiple SQEs to its io_uring, it can issue
> multiple I/O requests at once that are executed in parallel. In order to
> wait for all requests to complete, it initializes a global counter in
> its program state and links an invocation to each parallel requests that
> counts completions. The last invocation continues the io-program:
> 
> 
> int counter;
> void start_par() {
>     sqe_barrier->opcode = IORING_OP_EBPF;
>     ...
>     sqe_barrier->addr = &finish_par;
>     counter = 10;
>     for (int i=0; i<10 ;i++) {
>         sqe_io->opcode = IORING_OP_READV...
>         sqe_io->flags = ... | IOSQE_IO_LINK | IOSEQ_IO_NOCQE | ...
>         ...
>         uring_submit_sqe(seq_io);
>         uring_submit_sqe(seq_barrier)
>     }
> }
> 
> void finish_par () {
>     if (--counter > 0) return;
>     
>     // All 10 packets are completed
>     uring_submit_cqe(....)
> }
> 
> 
> The synchronization with a global variable works as all eBPF programs
> within one uring are serialized, regardless of their linking state.
> 
> # Our next steps
> 
> With Franz (Cc), we have a Master student who wants to explore this
> execution model. We will first build a prototype in userspace on basis
> of Pavel's eBPF patch series. For this prototype, we will put a proxy
> before the completion queue to mimic the linked invocation-SQEs and the
> data access to userspace. The proxy will execute normal C functions that
> adhere to the rules of eBPF as callbacks to completed I/O SQEs. With
> this prototype at hand, we can already use the execution model to
> restructure a userspace program to use the new interface, before we work
> on the necessary kernel extensions.
> 
> Besides that, we would like to discuss our envisioned execution model on
> this mailinglist. What do you think about the presented idea?
> 
> Horst & chris
> 
> [1] Christian Dietrich, https://osg.tuhh.de/People/dietrich/
>     Horst Schirmeier, https://ess.cs.tu-dortmund.de/~hsc/
> 

-- 
Pavel Begunkov
