Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68C9F5504D3
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 14:47:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233879AbiFRMr5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 08:47:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234359AbiFRMr4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 08:47:56 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6209C14025
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:47:53 -0700 (PDT)
Message-ID: <db6d5ce5-5445-d095-8000-3000461a37e7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655556471;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Gl3oKrOQpgMgZNQXalG8ZB811Iqan9PYLXL6zl2ppgg=;
        b=xhJLbP3H2B99EqmcvDzU4+DWtIreSGkQ9xYwZIgEeg7TAtNwvC8Vpqlr7c6QpUuvAld6zS
        leGj7VDWepHg23EfQBgDaYADT1als4TYyuglZoDvQt+WVoeaxDqsIRDULzS7Th5GT2JGgG
        wi99s2Ul16kQAvzIfJszB5j098bPYC4=
Date:   Sat, 18 Jun 2022 20:47:29 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/2] io_uring: add support for passing fixed file
 descriptors
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
References: <20220617134504.368706-1-axboe@kernel.dk>
 <20220617134504.368706-3-axboe@kernel.dk>
 <37a2034d-6cc1-ccf7-53d3-a334e54c3779@linux.dev>
 <0890d4f2-1f9e-9aa3-c98c-9e415f0dc5d7@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <0890d4f2-1f9e-9aa3-c98c-9e415f0dc5d7@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/18/22 19:34, Jens Axboe wrote:
> On 6/18/22 5:02 AM, Hao Xu wrote:
>> On 6/17/22 21:45, Jens Axboe wrote:
>>> With IORING_OP_MSG_RING, one ring can send a message to another ring.
>>> Extend that support to also allow sending a fixed file descriptor to
>>> that ring, enabling one ring to pass a registered descriptor to another
>>> one.
>>>
>>> Arguments are extended to pass in:
>>>
>>> sqe->addr3    fixed file slot in source ring
>>> sqe->file_index    fixed file slot in destination ring
>>>
>>> IORING_OP_MSG_RING is extended to take a command argument in sqe->addr.
>>> If set to zero (or IORING_MSG_DATA), it sends just a message like before.
>>> If set to IORING_MSG_SEND_FD, a fixed file descriptor is sent according
>>> to the above arguments.
>>>
>>> Undecided:
>>>      - Should we post a cqe with the send, or require that the sender
>>>        just link a separate IORING_OP_MSG_RING? This makes error
>>>        handling easier, as we cannot easily retract the installed
>>>        file descriptor if the target CQ ring is full. Right now we do
>>>        fill a CQE. If the request completes with -EOVERFLOW, then the
>>>        sender must re-send a CQE if the target must get notified.
>>
>> Hi Jens,
>> Since we are have open/accept direct feature, this may be useful. But I
>> just can't think of a real case that people use two rings and need to do
>> operations to same fd.
> 
> The two cases that people bring up as missing for direct descriptors
> that you can currently do with a real fd is:
> 
> 1) Server needs to be shutdown or restarted, pass file descriptors to
>     another onei
> 
> 2) Backend is split, and one accepts connections, while others then get
>     the fd passed and handle the actual connection.
> 
> Both of those are classic SCM_RIGHTS use cases, and it's not possible to
> support them with direct descriptors today.

I see, thanks for detail explanation.

> 
>> Assume there are real cases, then filling a cqe is necessary since users
>> need to first make sure the desired fd is registered before doing
>> something to it.
> 
> Right, my quesion here was really whether it should be bundled with the
> IORING_MSG_SEND_FD operation, or whether the issuer of that should also
> be responsible for then posting a "normal" IORING_OP_MSG_SEND to the
> target ring to notify it if the fact that an fd has been sent to it.
> 
> If the operation is split like the latter, then it makes the error
> handling a bit easier as we eliminate one failing part of the existing
> MSG_SEND_FD.
> 
> You could then also pass a number of descriptors and then post a single
> OP_MSG_SEND with some data that tells you which descriptors were passed.
> 
> For the basic use case of just passing a single descriptor, what the
> code currently does is probably the sanest approach - send the fd, post
> a cqe.
> 
>> A downside is users have to take care to do fd delivery especially
>> when slot resource is in short supply in target_ctx.
>>
>>                  ctx                            target_ctx
>>      msg1(fd1 to target slot x)
>>
>>      msg2(fd2 to target slot x)
>>
>>                                               get cqe of msg1
>>                                    do something to fd1 by access slot x
>>
>>
>> the msg2 is issued not at the right time. In short not only ctx needs to
>> fill a cqe to target_ctx to inform that the file has been registered
>> but also the target_ctx has to tell ctx that "my slot x is free now
>> for you to deliver fd". So I guess users are inclined to allocate a
>> big fixed table and deliver fds to target_ctx in different slots,
>> Which is ok but anyway a limitation.
> 
> I suspect the common use case would be to use the alloc feature, since
> the sender generally has no way of knowing which slots are free on the
> target ring.

I mean the sender may not easily know which value to set for
msg->dst_fd not about the alloc feature.

> 
>>> +static int io_double_lock_ctx(struct io_ring_ctx *ctx,
>>> +                  struct io_ring_ctx *octx,
>>> +                  unsigned int issue_flags)
>>> +{
>>> +    /*
>>> +     * To ensure proper ordering between the two ctxs, we can only
>>> +     * attempt a trylock on the target. If that fails and we already have
>>> +     * the source ctx lock, punt to io-wq.
>>> +     */
>>> +    if (!(issue_flags & IO_URING_F_UNLOCKED)) {
>>> +        if (!mutex_trylock(&octx->uring_lock))
>>> +            return -EAGAIN;
>>> +        return 0;
>>> +    }
>>> +
>>> +    /* Always grab smallest value ctx first. */
>>> +    if (ctx < octx) {
>>> +        mutex_lock(&ctx->uring_lock);
>>> +        mutex_lock(&octx->uring_lock);
>>> +    } else if (ctx > octx) {
>>
>>
>> Would a simple else work?
>> if (a < b) {
>>    lock(a); lock(b);
>> } else {
>>    lock(b);lock(a);
>> }
>>
>> since a doesn't equal b
> 
> Yes that'd be fine, I think I added the a == b pre-check a bit later in
> the process. I'll change this to an else instead.
> 

