Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884C773082C
	for <lists+io-uring@lfdr.de>; Wed, 14 Jun 2023 21:25:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236328AbjFNTZp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 14 Jun 2023 15:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229889AbjFNTZo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 14 Jun 2023 15:25:44 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C63082137
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 12:25:42 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-7748ca56133so56946839f.0
        for <io-uring@vger.kernel.org>; Wed, 14 Jun 2023 12:25:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1686770742; x=1689362742;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wTh/WeBLA3L/iUB7emgcRuosHfyPFBcyQt/RUvKoISI=;
        b=KMMzj382XiuSAsAAGaB4idgy/7JCLQdW7pnNM0+Cb+Xx+Mj8+LtX11QMyFeAK4U7WU
         X3QvDzo6ayf1KA8qDS4vLzhx9EPy9lt3eYp9Z7raY6Nw8yxfGHF0SpDGNkod8cHFbuJX
         yEfyMS9/0HfUUMVRFEwW0jq89sUgToS2ksr97t3RUQJuPQ3rs3psdg44kZBbvKcOAY5a
         oX3+QDfbHej3M/hF687SuThC7uLyAMRFzZGfTOk+ZS/m6cur/g7ty7ZLz9EKZvoKDvo4
         RDigdXS/a2jBYkm/zPWZ2cdx3iFGfHUV8nTpsEwE/eQz251NpSGcFNqhpFF/OHkowImr
         Z5hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686770742; x=1689362742;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wTh/WeBLA3L/iUB7emgcRuosHfyPFBcyQt/RUvKoISI=;
        b=QR/vGjlQWgsNe2qqxy3wV5A9jrZLWa90quOtmlvxfuxMB4i3uIPiCyFy9hP0kfvBzB
         a+h6feWESwQqcMGXxj39X578/Z6yMgUKdCUXn+yx1o4VYeUXGf8HLDPjA1qeZIOB+r5S
         o1HJkgVOScOUR10hC6W6muCvsPSVttDcQkrYdkDGGymBRYn78fxJv0nR/5ZY3p6K0QSd
         NhD4vAwLBiovuLE6sdTWfSNi6ESAymVO8j+WCFfCidYNFYHOE1NknkXMZw6uTrPF/2N1
         UZxWXRyanu2QhaIi5k/b9BQ2UWwgg2xx9iOQxl5cSIKM41YAHb8syaSQY5PMDFb9TZ8K
         e1Eg==
X-Gm-Message-State: AC+VfDwtgLEGi6B/DAsfwDvnIuTvd+ypFI87xvSFs5F0RbHJO6OElmhc
        2bq8/nITlfCoMVf3eJeJbsyRaQ==
X-Google-Smtp-Source: ACHHUZ5ndQ/jsx2z03dFwLowARGWq0Gv5/4INxiHk2ToGrfA2O/oHCek9v8RYFQ6IGBKAG/qd5lStA==
X-Received: by 2002:a6b:8d4b:0:b0:777:b6a9:64ba with SMTP id p72-20020a6b8d4b000000b00777b6a964bamr12702260iod.2.1686770741904;
        Wed, 14 Jun 2023 12:25:41 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c7-20020a6bfd07000000b00760f256037dsm5452925ioi.44.2023.06.14.12.25.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jun 2023 12:25:41 -0700 (PDT)
Message-ID: <225f0de7-8dc6-8470-3e8e-f6af58ef668a@kernel.dk>
Date:   Wed, 14 Jun 2023 13:25:40 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH] io_uring/io-wq: don't clear PF_IO_WORKER on exit
Content-Language: en-US
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Zorro Lang <zlang@redhat.com>, io-uring <io-uring@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Dave Chinner <david@fromorbit.com>
References: <2392dcb4-71f4-1109-614b-4e2083c0941e@kernel.dk>
 <20230614005449.awc2ncxl5lb2eg6m@zlang-mailbox>
 <5d5ccbb1-784c-52b3-3748-2cf7b5cf01ef@kernel.dk>
 <CAHk-=wiotpcKvBWGneGjNA4eOGUsY+KTMCVsMxsGhXGCg=n=bA@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAHk-=wiotpcKvBWGneGjNA4eOGUsY+KTMCVsMxsGhXGCg=n=bA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/14/23 11:44?AM, Linus Torvalds wrote:
> On Tue, 13 Jun 2023 at 18:14, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> +       preempt_disable();
>> +       current->worker_private = NULL;
>> +       preempt_enable();
> 
> Yeah, that preempt_disable/enable cannot possibly make a difference in
> any sane situation.
> 
> If you want to make clear that it should be one single write, do it
> with WRITE_ONCE().
> 
> But realistically, that won't matter either. There's just no way a
> sane compiler can make it do anything else, and just the plain
> 
>         current->worker_private = NULL;
> 
> will be equivalent.
> 
> If there are ordering concerns, then neither preemption nor
> WRITE_ONCE() matter, but "smp_store_release()" would.
> 
> But then any readers should use "smp_load_acquire()" too.
> 
> However, in this case, I don't think any of that matters.

Right, it's all 'current' stuff, at least any users of whatever hangs
off ->worker_private is. I've cut it down and added a comment as well.

> The actual backing store is free'd with kfree_rcu(), so any ordering
> would be against the RCU grace period anyway. So the only ordering
> that matters is, I think, that you set it to NULL *before* that
> kfree_rcu() call, so that we know that "if somebody has seen a
> non-NULL worker_private, then you still have a full RCU grace period
> until it is gone".
> 
> Of course, that all still assumes that any read of worker_private
> (from outside of 'current') is inside an RCU read-locked region. Which
> isn't actually obviously true.
> 
> But at least for the case of io_wq_worker_running() and
> io_wq_worker_sleeping, the call is always just for the current task.
> So there are no ordering constraints at all. Not for preemption, not
> for SMP, not for RCU. It's all entirely thread-local.
> 
> (That may not be obvious in the source code, since
> io_wq_worker_sleeping/running gets a 'tsk' argument, but in the
> context of the scheduler, 'tsk' is always just a cached copy of
> 'current').
> 
> End result: just do it as a plain store.  And I don't understand why
> the free'ing of that data structure is RCU-delayed at all. There does
> not seem to be any non-synchronous users of the worker_private pointer
> at all. So I *think* that
> 
>         kfree_rcu(worker, rcu);
> 
> should just be
> 
>         kfree(worker);
> 
> and I wonder if that rcu-freeing was there to try to hide the bug.
> 
> But maybe I'm missing something.

It's for worker lookup, on activating a new worker for exmaple, and has
a reference associated with it too. This is unrelated to
->worker_private, that is only ever used in context of the the worker
itself. Inside those lookups we need to ensure that 'worker' doesn't go
away, hence why it's freed by rcu. So we cannot get rid of that.

-- 
Jens Axboe

