Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C7CA5448F0
	for <lists+io-uring@lfdr.de>; Thu,  9 Jun 2022 12:32:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233822AbiFIKcr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Jun 2022 06:32:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232096AbiFIKcq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Jun 2022 06:32:46 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390DD20FC5D
        for <io-uring@vger.kernel.org>; Thu,  9 Jun 2022 03:32:43 -0700 (PDT)
Message-ID: <e4f72c36-b56a-5760-1e42-bf16304b1bd7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1654770762;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=caccuPqgaKQE+fd/7ToWXy24CRKeO5pZmAXO05WNW70=;
        b=E0gosfbtxUJdSwukc6QoFTX4wOYCV3zKjMWlN6ny2ajymUB+6bXrNTz943K1YLqz9PpGHK
        CtjiUOdEvXWHT88UtMcmS9tyl0Gd6Lhpx0T2K6bWWTR5MpMxvtlr2vGT1/IXBWL1sFZeqm
        VOudYjwVxVXVvKocQBYFf1fFM1q03iE=
Date:   Thu, 9 Jun 2022 18:32:33 +0800
MIME-Version: 1.0
Subject: Re: Possible bug for ring-mapped provided buffer
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Cc:     Pavel Begunkov <asml.silence@gmail.com>
References: <1884ea45-07df-303a-c22c-319a2394b20f@linux.dev>
 <7c563209-7b33-4cc8-86d9-fecfef68c274@kernel.dk>
 <ed5b8a0a-d312-1181-c6b4-95fd126ea9e9@linux.dev>
 <8ec6116d-39cd-ed6c-3477-9165d1a27128@kernel.dk>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <8ec6116d-39cd-ed6c-3477-9165d1a27128@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/9/22 18:19, Jens Axboe wrote:
> On 6/9/22 4:14 AM, Hao Xu wrote:
>> On 6/9/22 18:06, Jens Axboe wrote:
>>> On 6/9/22 1:53 AM, Hao Xu wrote:
>>>> Hi all,
>>>> I haven't done tests to demonstrate it. It is for partial io case, we
>>>> don't consume/release the buffer before arm_poll in ring-mapped mode.
>>>> But seems we should? Otherwise ring head isn't moved and other requests
>>>> may take that buffer. What do I miss?
>>>
>>> On vacation this week, so can't take a look at the code. But the
>>> principle is precisely not to consume the buffer if we arm poll, because
>>> then the next one can grab it instead. We don't want to consume a buffer
>>> over poll, as that defeats the purpose of a provided buffer. It should
>>> be grabbed and consumed only if we can use it right now.
>>>
>>> Hence the way it should work is that we DON'T consume the buffer in this
>>> case, and that someone else can just use it. At the same time, we should
>>> ensure that we grab a NEW buffer for this case, whenever the poll
>>
>> If we grab a new buffer for it, then we have to copy the data since we
>> have done partial io...this also defeats the purpose of this feature.
> 
> For partial IO, we never drop the buffer. See the logic in
> io_kbuf_recycle(). It should be as follows:

Yea, in io_kbuf_recycle(), if it's partial io, we just return. For
legacy mode, this means we keep the buffer. For ring-mapped mode, this
means we then release the uring_lock without moving the ring->head,
and then other requests may take that buffer which is in use..
And next time we do (for example) recv(), we lost the data which we got
at the previous time.
Do I miss something?

> 
> - If PARTIAL_IO is set, then hang on to the buffer. You can't consume a
>    partial buffer anyway.
> 
> - If no IO has been done and it's a ring provided buffer, just hang on
>    to the bgid and clear the fact that we grabbed a buffer. That's all
>    you need to do in this case, someone else may grab it and we'll grab a
>    new one for this request whenever it's time to do so.
> 
>> What the legacy provided buffer mode do in this case is just
>> keep/consume that buffer. So I'd think we should keep the consistency.
>> But yes, there may be a better way.
> 
> The legacy mode has to do that, as it always has to grab the buffer. We
> don't need to do that in the ring case, it's an efficiency thing as
> well. If we do need to arm poll, we don't have to do anything but ensure
> that we grab a new one next time. Consuming it would be the wrong thing
> to do in that case, as it defeats the purpose of a provided buffer. You
> may as well just pass in a buffer at that point.
> 

