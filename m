Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 284AC5A5D70
	for <lists+io-uring@lfdr.de>; Tue, 30 Aug 2022 09:55:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbiH3HzH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Aug 2022 03:55:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230132AbiH3HzG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Aug 2022 03:55:06 -0400
Received: from out0.migadu.com (out0.migadu.com [94.23.1.103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 570101275F
        for <io-uring@vger.kernel.org>; Tue, 30 Aug 2022 00:55:04 -0700 (PDT)
Message-ID: <195044cd-9c4f-1201-b329-e6e1de0262b1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1661846102;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=22O9/+WGhXrq4qCm0CfLoZL8yqsv/Bw5eIETdNw9BA8=;
        b=g4JXbatI9Rohp0weBXu/J9lG+mIKRd+tCAB2ZibkLoDJBYHY4cmXpjUw2mq3rg/rkDnWQG
        RObN+1vfVohFA0760xO9FLVFCI5sU54UDdgi9YxwNESspKD2z5+uESBhYwjuXW1daV06o+
        617FXAEkK1FUx8oz4RPiIYp1dren7Yk=
Date:   Tue, 30 Aug 2022 15:54:52 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next v3 4/7] io_uring: add IORING_SETUP_DEFER_TASKRUN
Content-Language: en-US
To:     Dylan Yudaken <dylany@fb.com>, "axboe@kernel.dk" <axboe@kernel.dk>,
        "asml.silence@gmail.com" <asml.silence@gmail.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     Kernel Team <Kernel-team@fb.com>
References: <20220819121946.676065-1-dylany@fb.com>
 <20220819121946.676065-5-dylany@fb.com>
 <d3ad2512-ab06-1a56-6394-0dc4a62f0028@gmail.com>
 <370dd3d4-1f54-279c-3d6a-8c9f8473a80a@linux.dev>
 <c708e882393f3e9ae0e90f368d941868325f1cf1.camel@fb.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <c708e882393f3e9ae0e90f368d941868325f1cf1.camel@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/30/22 15:23, Dylan Yudaken wrote:
> On Mon, 2022-08-29 at 14:32 +0800, Hao Xu wrote:
>>>> @@ -3289,17 +3409,29 @@ static __cold int
>>>> io_uring_create(unsigned
>>>> entries, struct io_uring_params *p,
>>>>        if (ctx->flags & IORING_SETUP_SQPOLL) {
>>>>            /* IPI related flags don't make sense with SQPOLL */
>>>>            if (ctx->flags & (IORING_SETUP_COOP_TASKRUN |
>>>> -                  IORING_SETUP_TASKRUN_FLAG))
>>>> +                  IORING_SETUP_TASKRUN_FLAG |
>>>> +                  IORING_SETUP_DEFER_TASKRUN))
>>>
>>> Sounds like we should also fail if SQPOLL is set, especially with
>>> the task check on the waiting side.
>>
>> sqpoll as a natural single issuer case, shouldn't we support this
>> feature for it? And surely, in that case, don't do local task work
>> check
>> in cqring wait time and be careful in other places like
>> io_uring_register
> 
> I think there is definitely scope for that - but it's less obvious how
> to do it.
> i.e. in it's current form DEFER_TASKRUN requires the GETEVENTS to be
> submitted on the same task as the initial submission, but with SQPOLL
> the submission task is a kernel thread so would have to have some
> difference in the API.

Yea, just like what I said, in sqpoll mode, we shouldn't do the tw
handle in the io_uring_enter.

> 
> As an idea for a later patch set - perhaps the semantics should be to
> keep task work local but only run it once submissions have been
> processed for a ctx. I suspect that will require some care to ensure
> the wakeup flag is set correctly and that it cleans up properly.
> 

Yea, it should be a separate follow-up patchset, currently there is a
io_run_task_work() after submitted sqes for all ctxes and before going
to sleep, that may be a good place for it. I haven't think about it in
detail, but there should be a viable way.

> Dylan
> 

