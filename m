Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADC555051A
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 15:29:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbiFRN1q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 09:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiFRN1p (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 09:27:45 -0400
Received: from out1.migadu.com (out1.migadu.com [IPv6:2001:41d0:2:863f::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2E7765E1
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 06:27:43 -0700 (PDT)
Message-ID: <eccc3da8-225f-e7fa-f85f-b559658f6273@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1655558862;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dosDyX3Lj15kCqqBFoaCCTrp68lu/IPzPrzVFpeXPuI=;
        b=CQlpeITGOSJmr5INgKd4dmqWm2CLiHSDFXFDy3Rsr9IbT47ePy8FCDgaBpfe4uF5KtpWuz
        Vfa59WSZlUb9O2b5RF+xKs9lpnY9alPHebkWEz5qPHuaGCDSS5SJqoEXjTK0Zlyqnrxqwy
        lg2qiRpIXZ5ml2WBF/A0dfM1XRD7r4Q=
Date:   Sat, 18 Jun 2022 21:27:28 +0800
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
 <db6d5ce5-5445-d095-8000-3000461a37e7@linux.dev>
 <3eb8c4d5-5e55-2918-01ee-091fa635e950@kernel.dk>
 <337a2a6a-1237-0485-2ca5-745ca6d27696@linux.dev>
 <eb9c10c7-683b-5bfe-ddfe-e1899d8506dd@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <eb9c10c7-683b-5bfe-ddfe-e1899d8506dd@kernel.dk>
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

On 6/18/22 21:16, Jens Axboe wrote:
> On 6/18/22 7:09 AM, Hao Xu wrote:
>> On 6/18/22 20:50, Jens Axboe wrote:
>>> On 6/18/22 6:47 AM, Hao Xu wrote:
>>>> On 6/18/22 19:34, Jens Axboe wrote:
>>>>> On 6/18/22 5:02 AM, Hao Xu wrote:
>>>>>> On 6/17/22 21:45, Jens Axboe wrote:
>>>>>>> With IORING_OP_MSG_RING, one ring can send a message to another ring.
>>>>>>> Extend that support to also allow sending a fixed file descriptor to
>>>>>>> that ring, enabling one ring to pass a registered descriptor to another
>>>>>>> one.
>>>>>>>
>>>>>>> Arguments are extended to pass in:
>>>>>>>
>>>>>>> sqe->addr3    fixed file slot in source ring
>>>>>>> sqe->file_index    fixed file slot in destination ring
>>>>>>>
>>>>>>> IORING_OP_MSG_RING is extended to take a command argument in sqe->addr.
>>>>>>> If set to zero (or IORING_MSG_DATA), it sends just a message like before.
>>>>>>> If set to IORING_MSG_SEND_FD, a fixed file descriptor is sent according
>>>>>>> to the above arguments.
>>>>>>>
>>>>>>> Undecided:
>>>>>>>        - Should we post a cqe with the send, or require that the sender
>>>>>>>          just link a separate IORING_OP_MSG_RING? This makes error
>>>>>>>          handling easier, as we cannot easily retract the installed
>>>>>>>          file descriptor if the target CQ ring is full. Right now we do
>>>>>>>          fill a CQE. If the request completes with -EOVERFLOW, then the
>>>>>>>          sender must re-send a CQE if the target must get notified.
>>>>>>
>>>>>> Hi Jens,
>>>>>> Since we are have open/accept direct feature, this may be useful. But I
>>>>>> just can't think of a real case that people use two rings and need to do
>>>>>> operations to same fd.
>>>>>
>>>>> The two cases that people bring up as missing for direct descriptors
>>>>> that you can currently do with a real fd is:
>>>>>
>>>>> 1) Server needs to be shutdown or restarted, pass file descriptors to
>>>>>       another onei
>>>>>
>>>>> 2) Backend is split, and one accepts connections, while others then get
>>>>>       the fd passed and handle the actual connection.
>>>>>
>>>>> Both of those are classic SCM_RIGHTS use cases, and it's not possible to
>>>>> support them with direct descriptors today.
>>>>
>>>> I see, thanks for detail explanation.
>>>
>>> I should put that in the commit message in fact. Will do so.
>>>
>>>>>> Assume there are real cases, then filling a cqe is necessary since users
>>>>>> need to first make sure the desired fd is registered before doing
>>>>>> something to it.
>>>>>
>>>>> Right, my quesion here was really whether it should be bundled with the
>>>>> IORING_MSG_SEND_FD operation, or whether the issuer of that should also
>>>>> be responsible for then posting a "normal" IORING_OP_MSG_SEND to the
>>>>> target ring to notify it if the fact that an fd has been sent to it.
>>>>>
>>>>> If the operation is split like the latter, then it makes the error
>>>>> handling a bit easier as we eliminate one failing part of the existing
>>>>> MSG_SEND_FD.
>>>>>
>>>>> You could then also pass a number of descriptors and then post a single
>>>>> OP_MSG_SEND with some data that tells you which descriptors were passed.
>>
>> [1]
>>
>>>>>
>>>>> For the basic use case of just passing a single descriptor, what the
>>>>> code currently does is probably the sanest approach - send the fd, post
>>>>> a cqe.
>>
>> I think it's fine to keep it like this, since we can achieve [1] by a
>> GROUP_DELIVER flag and set cqe_skip flag for send msg request when it
>> turns out [1] is indeed necessary.
> 
> The expected use case is probably CQE_SKIP for using this, as the sender
> doesn't care about being notified about a successful send. But for the
> target CQE, we'd then need to either have CQE_SKIP implying that we
> should skip CQE delivery there too, or we'd need to add an

Yea, that's what I meant, CQE_SKIP for the target_ctx cqe.

> IORING_OP_MSG_RING flag for that. I think the latter is the cleaner
> approach, and it would indeed then allow both use cases. If you're
> sending a bunch of fds and would prefer to notify with a single
> OP_MSG_RING when they are done, then you'd set that OP_MSG_RING flag
> that says "don't post a CQE to the target".
> 
> Hence my proposal would be to keep the CQE delivery by default as it
> stands in the patch, and add a flag for controlling whether or not
> OP_MSG_RING with MSG_SEND posts a CQE to the target ring or not.
> 
> Agree?
> 

Sounds good.

