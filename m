Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD77A4D401C
	for <lists+io-uring@lfdr.de>; Thu, 10 Mar 2022 05:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239421AbiCJEEm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Mar 2022 23:04:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232620AbiCJEEl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Mar 2022 23:04:41 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F06657306D
        for <io-uring@vger.kernel.org>; Wed,  9 Mar 2022 20:03:38 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id q11so3738415pln.11
        for <io-uring@vger.kernel.org>; Wed, 09 Mar 2022 20:03:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ZPAIMXCcRQHF4wfaaECqCW7e0y+WiiPZvMaFxhJ74wE=;
        b=k2gU/avIyM8idYHm8OBBcgOW79P/E+m/X038go3IGTn7akAt6c6OSndYKgzfuiYfLx
         7Uol7JfpogNOn5E//E83uuTXcmUxbNLvPCrSnxJvuaft2lm2JKY48bdI02TyiDR42SUP
         h5xA4dJtJiJO3pvS243CdkcC44VLCgydL/9uG/177LCCmyhQc6ZnbNA1alF1sWdHK575
         rYfGiERuPxckxgC6f7i/0ldti24St2g3PK993T2s7mcCU4Z1F6Xg34NqW+HzZ3kxNd7O
         8hkXYS16slgZS4gIFIQ/a9bcFmn4lub9BSHl+wzJm8Wt+45JCaHCKnFrEs0N6O0BHOKE
         8D3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ZPAIMXCcRQHF4wfaaECqCW7e0y+WiiPZvMaFxhJ74wE=;
        b=yULN+plpsdMTzPI9H+GA01DeNFeQlESuKfTI2qTx9VYOg94CRjUXTlC3WYby9n20N3
         VoF100ZcW9dmkmyLQzX/8wWASSyoYnsdviqj6nYVO22X3ZaWc7rbGif72NkkofCLF5gC
         mqvDdhajxYqsCqb1odnBxsTC0OaWxqiudYX/C5118jc5+B6Hi3/X0aPvehaw88qqwa3P
         Sf2Tgb4H0jUMJgfJj8JO2FR8E5LTsTI8dF/WgMb/JaXNf8JnCElPj2UNFHpRp6VYtQzT
         JleqJ9cqwFqUrsimkCpjh7YR6nYOIAY14Heu5Ugcvigft47oF9xhBuvPKYxTdsQDQO9H
         Ee9w==
X-Gm-Message-State: AOAM5311HrrUAPVNaFG3bGvRdrjiN/s8OWRkOZNJC6NG7Z41JoW2KZdB
        3I9upne12SE93bcV+5eQy6AZ3E3VPWZWKyWD
X-Google-Smtp-Source: ABdhPJwvIHP9alo1dUsebod9axcgMui5d7kp9iJ7Hd5ZwdQIa2eL3ZuLOHdQ55N1M5LxSNnZhmaKKQ==
X-Received: by 2002:a17:90b:1b4c:b0:1bf:d91:e157 with SMTP id nv12-20020a17090b1b4c00b001bf0d91e157mr2950077pjb.82.1646885018382;
        Wed, 09 Mar 2022 20:03:38 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id l17-20020a637011000000b0037d5eac87e3sm3681806pgc.18.2022.03.09.20.03.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Mar 2022 20:03:37 -0800 (PST)
Message-ID: <9f8c753d-fed4-08ac-7b39-aee23b8ba04c@kernel.dk>
Date:   Wed, 9 Mar 2022 21:03:36 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: Sending CQE to a different ring
Content-Language: en-US
To:     Artyom Pavlov <newpavlov@gmail.com>, io-uring@vger.kernel.org
References: <bf044fd3-96c0-3b54-f643-c62ae333b4db@gmail.com>
 <e31e5b96-5c20-d49b-da90-db559ba44927@kernel.dk>
 <c4a02dbd-8dff-a311-ce4a-e7daffd6a22a@gmail.com>
 <478d1650-139b-f02b-bebf-7d54aa24eae2@kernel.dk>
 <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a13e9f56-0f1c-c934-9ca7-07ca8f82c6c8@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/22 8:48 PM, Artyom Pavlov wrote:
>> OK, so what you're asking is to be able to submit an sqe to ring1, but
>> have the completion show up in ring2? With the idea being that the rings
>> are setup so that you're basing this on which thread should ultimately
>> process the request when it completes, which is why you want it to
>> target another ring?
> 
> Yes, to both questions.
> 
>> 1) It's a fast path code addition to every request, we'd need to check
>>     some new field (sqe->completion_ring_fd) and then also grab a
>>     reference to that file for use at completion time.
> 
> Since migration of tasks will be relatively rare, the relevant branch
> could be marked as cold and such branch should be relatively easy for
> CPU branch predictor. So I don't think we will see a measurable
> performance regression for the common case.

It's not the branches I'm worried about, it's the growing of the request
to accomodate it, and the need to bring in another fd for this. We're
not just talking one piece of branch here, a request being tied to a
specific ring is a pretty core foundation of the internal code. It would
require massive refactoring to disconnect those two. We have a lot of
optimizations in place to handle completions efficiently as it is.

But I guess I'm still a bit confused on what this will buy is. The
request is still being executed on the first ring (and hence the thread
associated with it), with the suggested approach here the only thing
you'd gain is the completion going somewhere else. Is this purely about
the post-processing that happens when a completion is posted to a given
ring?

>> 2) Completions are protected by the completion lock, and it isn't
>>     trivial to nest these. What happens if ring1 submits an sqe with
>>     ring2 as the cqe target, and ring2 submits an sqe with ring1 as the
>>     cqe target? We can't safely nest these, as we could easily introduce
>>     deadlocks that way.
> 
> I thought a better approach will be to copy SQE from ring1 into ring2
> internal buffer and execute it as usual (IIUC kernel copies SQEs first
> before processing them). I am not familiar with internals of io-uring
> implementation, so I can not give any practical proposals.

That's certainly possible, but what does it buy us? Why not just issue
it on ring2 to begin with? The issue per ring is serialized anyway, by
an internal mutex.

>> My knee jerk reaction is that it'd be both simpler and cheaper to
>> implement this in userspace... Unless there's an elegant solution to it,
>> which I don't immediately see.
> 
> Yes, as I said in the initial post, it's certainly possible to do it
> in user-space. But I think it's a quite common problem, so it could
> warrant including a built-in solution into io-uring API. Also it could
> be a bit more efficient to do in kernel space, e.g. you would not need
> mutexes, which in the worst case may involve parking and unparking
> threads, thus stalling event loop.

I'm all for having solutions for common problems, but it has to make
sense to do so. 

liburing has some state in the ring structure which makes it hard to
share, but for the raw interface, there's really not that concern
outside of needing to ensure that you serialize access to writing the sq
ring head and sqe entry. The kernel doesn't really care, though you
don't want two threads entering the kernel for the same ring as one of
them would simply then just be blocked until the other is done.

>> The submitting task is the owner of the request, and will ultimately
>> be the one that ends up running eg task_work associated with the
>> request. It's not really a good way to shift work from one ring to
>> another, if the setup is such that the rings are tied to a thread and
>> the threads are in turn mostly tied to a CPU or group of CPUs.
> 
> I am not sure I understand your point here. In my understanding, the
> common approach for using io-uring is to keep in user_data a pointer
> to FSM (Finite State Machine) state together with pointer to a
> function used to drive FSM further after CQE is received
> (alternatively, instead of the function pointer a jump table could be
> used).
> 
> Usually, it does not matter much on which thread FSM will be driven
> since FSM state is kept on the heap. Yes, it may not be great from CPU
> cache point of view, but it's better than having unbalanced thread
> load.

OK, so it is just about the post-processing. These are key questions to
answer, because it'll help drive what the best solution is here.

How did the original thread end up with the work to begin with? Was the
workload evenly distributed at that point, but later conditions (before
it get issued) mean that the situation has now changed and we'd prefer
to execute it somewhere else?

I'll mull over this a bit...

-- 
Jens Axboe

