Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA894550446
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 13:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbiFRLev (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 07:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiFRLet (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 07:34:49 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4058019F9E
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 04:34:48 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id f65so6153115pgc.7
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 04:34:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=p7DlaTDQdX68h8t9O4Dawod7203zHP/7ftXOdNgV1I8=;
        b=mboMO4AOtOJTwoBWYAyXqbQ5AFPvcUh37KH1nZ7pzatwBqMrZT0rTLvWRdRU4RI8mI
         3fQJDcH3ZN3hqO5Q5fKlox9LQpM1h8mzoYCd8kLPbFPOJg/5tXMMlPwaIz390RrAC6YS
         AhIRISB3Guz3geVTTrNfzeMvyEamVDZ7OebsuOja6in6sUrSxbJpu0q9rboRspFq4vkR
         TU19Jo0HbZIC6KhbJupFb+So4jKNoiBmIFaYjGyrbjFo5qS8RZfIrCR+KqYbBwuq3mzw
         jhufwEEdXXOyD04PJHrRR2SwtolPNhjj1VBN9cuZhiVNUEhyjCrIkwaU8jKqKX7g7A1i
         2r1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=p7DlaTDQdX68h8t9O4Dawod7203zHP/7ftXOdNgV1I8=;
        b=XJyr/xYtFcBXjPuC6eJtRMcaAmyi9YK1EMdzYGRdLelKouFDFdG11PdSp0waqFGiR4
         b17tqfiBm1GaTtS9lr6eot+doue3DLMTeC0zfyRzinhUZ64xJIi66aX0Zjb7SGpcxDjA
         6bf2T3W7S/Jo78CBlZQ82v9y8zkRVSx0tYjEE9zkOX2qHCLbBrTh85N9FZPZfAAAPjcW
         S/cQcY+9WePlw6hW2b7ct5k53Q2xonUU9DEzytyF4Tx2U3tWHiZkqd+lT4ai/REGiGnH
         CpHL7r79Zqqj67gEgW6mLW9BsIq0IuM9NGGSJcp+xna9ChBZSZ0sZwbppJuV1jCb1YQ5
         4l4w==
X-Gm-Message-State: AJIora9wyhTh+dxpZg0uDqTSMkMoMgLsMEQNBTkzfC66/PeEey+QQFS4
        UuZBmNQmqYQQwWZH7Mcl0bR7Ng==
X-Google-Smtp-Source: AGRyM1uRc5OLi3LU0dhh/crT/onV3Rsx6KqP4v2HlC/qZGQia4seuod5GBlVN9wAXEG02aNKtXRXvQ==
X-Received: by 2002:a05:6a00:889:b0:510:91e6:6463 with SMTP id q9-20020a056a00088900b0051091e66463mr14888628pfj.58.1655552087526;
        Sat, 18 Jun 2022 04:34:47 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j10-20020a170902758a00b001641a5d5786sm1364719pll.114.2022.06.18.04.34.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jun 2022 04:34:46 -0700 (PDT)
Message-ID: <0890d4f2-1f9e-9aa3-c98c-9e415f0dc5d7@kernel.dk>
Date:   Sat, 18 Jun 2022 05:34:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 2/2] io_uring: add support for passing fixed file
 descriptors
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220617134504.368706-1-axboe@kernel.dk>
 <20220617134504.368706-3-axboe@kernel.dk>
 <37a2034d-6cc1-ccf7-53d3-a334e54c3779@linux.dev>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <37a2034d-6cc1-ccf7-53d3-a334e54c3779@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/22 5:02 AM, Hao Xu wrote:
> On 6/17/22 21:45, Jens Axboe wrote:
>> With IORING_OP_MSG_RING, one ring can send a message to another ring.
>> Extend that support to also allow sending a fixed file descriptor to
>> that ring, enabling one ring to pass a registered descriptor to another
>> one.
>>
>> Arguments are extended to pass in:
>>
>> sqe->addr3    fixed file slot in source ring
>> sqe->file_index    fixed file slot in destination ring
>>
>> IORING_OP_MSG_RING is extended to take a command argument in sqe->addr.
>> If set to zero (or IORING_MSG_DATA), it sends just a message like before.
>> If set to IORING_MSG_SEND_FD, a fixed file descriptor is sent according
>> to the above arguments.
>>
>> Undecided:
>>     - Should we post a cqe with the send, or require that the sender
>>       just link a separate IORING_OP_MSG_RING? This makes error
>>       handling easier, as we cannot easily retract the installed
>>       file descriptor if the target CQ ring is full. Right now we do
>>       fill a CQE. If the request completes with -EOVERFLOW, then the
>>       sender must re-send a CQE if the target must get notified.
> 
> Hi Jens,
> Since we are have open/accept direct feature, this may be useful. But I
> just can't think of a real case that people use two rings and need to do
> operations to same fd.

The two cases that people bring up as missing for direct descriptors
that you can currently do with a real fd is:

1) Server needs to be shutdown or restarted, pass file descriptors to
   another onei

2) Backend is split, and one accepts connections, while others then get
   the fd passed and handle the actual connection.

Both of those are classic SCM_RIGHTS use cases, and it's not possible to
support them with direct descriptors today.

> Assume there are real cases, then filling a cqe is necessary since users
> need to first make sure the desired fd is registered before doing
> something to it.

Right, my quesion here was really whether it should be bundled with the
IORING_MSG_SEND_FD operation, or whether the issuer of that should also
be responsible for then posting a "normal" IORING_OP_MSG_SEND to the
target ring to notify it if the fact that an fd has been sent to it.

If the operation is split like the latter, then it makes the error
handling a bit easier as we eliminate one failing part of the existing
MSG_SEND_FD.

You could then also pass a number of descriptors and then post a single
OP_MSG_SEND with some data that tells you which descriptors were passed.

For the basic use case of just passing a single descriptor, what the
code currently does is probably the sanest approach - send the fd, post
a cqe.

> A downside is users have to take care to do fd delivery especially
> when slot resource is in short supply in target_ctx.
> 
>                 ctx                            target_ctx
>     msg1(fd1 to target slot x)
> 
>     msg2(fd2 to target slot x)
> 
>                                              get cqe of msg1
>                                   do something to fd1 by access slot x
> 
> 
> the msg2 is issued not at the right time. In short not only ctx needs to
> fill a cqe to target_ctx to inform that the file has been registered
> but also the target_ctx has to tell ctx that "my slot x is free now
> for you to deliver fd". So I guess users are inclined to allocate a
> big fixed table and deliver fds to target_ctx in different slots,
> Which is ok but anyway a limitation.

I suspect the common use case would be to use the alloc feature, since
the sender generally has no way of knowing which slots are free on the
target ring.

>> +static int io_double_lock_ctx(struct io_ring_ctx *ctx,
>> +                  struct io_ring_ctx *octx,
>> +                  unsigned int issue_flags)
>> +{
>> +    /*
>> +     * To ensure proper ordering between the two ctxs, we can only
>> +     * attempt a trylock on the target. If that fails and we already have
>> +     * the source ctx lock, punt to io-wq.
>> +     */
>> +    if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>> +        if (!mutex_trylock(&octx->uring_lock))
>> +            return -EAGAIN;
>> +        return 0;
>> +    }
>> +
>> +    /* Always grab smallest value ctx first. */
>> +    if (ctx < octx) {
>> +        mutex_lock(&ctx->uring_lock);
>> +        mutex_lock(&octx->uring_lock);
>> +    } else if (ctx > octx) {
> 
> 
> Would a simple else work?
> if (a < b) {
>   lock(a); lock(b);
> } else {
>   lock(b);lock(a);
> }
> 
> since a doesn't equal b

Yes that'd be fine, I think I added the a == b pre-check a bit later in
the process. I'll change this to an else instead.

-- 
Jens Axboe

