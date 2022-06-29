Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB02055FFDE
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 14:29:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiF2M3T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 08:29:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230523AbiF2M3S (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 08:29:18 -0400
Received: from out1.migadu.com (out1.migadu.com [91.121.223.63])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D717921BD
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 05:29:17 -0700 (PDT)
Message-ID: <53f823a3-6878-9249-5f6c-f049e4d2b0df@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1656505755;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Px3bUjd9M16ez9pGvm8mQvkeI2ZWPX/0Vbufv3XcwVA=;
        b=IdZOCg77BmDLdPd3FcNXiYX8TPVmxar0hCQROgsyMjqFwGHSC7ErdKriyX4fa0QVn6dDkT
        XGai+xnVOON8v0UpK5ctjNpfRGvPsDcBFfnIAydjxOW4QQeF4w3Yq9cY0ZoBRBsj8rOKfU
        BCc6IZwrT4plTuX3Ktorw9EX92sJY5M=
Date:   Wed, 29 Jun 2022 20:29:09 +0800
MIME-Version: 1.0
Subject: Re: [PATCH for-next] io_uring: let to set a range for file slot
 allocation
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
 <70e38e6d-35f3-f140-9551-63e4e434bf18@linux.dev>
 <a20e307a-6a7e-dca4-7ec6-e630fa17a0e5@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Hao Xu <hao.xu@linux.dev>
In-Reply-To: <a20e307a-6a7e-dca4-7ec6-e630fa17a0e5@gmail.com>
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

On 6/29/22 20:18, Pavel Begunkov wrote:
> On 6/27/22 08:47, Hao Xu wrote:
>> On 6/25/22 18:55, Pavel Begunkov wrote:
>>>  From recently io_uring provides an option to allocate a file index for
>>> operation registering fixed files. However, it's utterly unusable with
>>> mixed approaches when for a part of files the userspace knows better
>>> where to place it, as it may race and users don't have any sane way to
>>> pick a slot and hoping it will not be taken.
>>
>> Exactly, with high frequency of index allocation from like multishot
>> accept, it's easy that user-pick requests fails.
>> By the way, just curious, I can't recall a reason that users pick a slot
>> rather than letting kernel do the decision, is there any? So I guess
> 
> Can't say for the initial design, but I prefer to give away control
> over such stuff to the userspace 1) to not over pollute the kernel
> (not relevant anymore), 2) because it has more knowledge and can
> use it more efficiently. E.g. to have O(1) memory and search time
> by using in-place index based free slot list, when indexes can be
> contants, and so on.
> 

Yea, I knew. Leave it alone to userspace makes biggest flexibility.

> 
>> users may use all the indexes as 'file slot allocation' range. Correct
>> me if I miss something.
> 
> Yeah, can be enough, and that's what the range is set to by default.
> 
>>> Let the userspace to register a range of fixed file slots in which the
>>> auto-allocation happens. The use case is splittting the fixed table in
>>> two parts, where on of them is used for auto-allocation and another for
>>> slot-specified operations.
>>>
>>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>>> ---
> [...]
>>> @@ -24,11 +24,10 @@ static int io_file_bitmap_get(struct io_ring_ctx 
>>> *ctx)
>>>           if (ret != nr)
>>>               return ret;
>>> -        if (!table->alloc_hint)
>>> +        if (table->alloc_hint == ctx->file_alloc_start)
>>>               break;
>>> -
>>>           nr = table->alloc_hint;
>>> -        table->alloc_hint = 0;
>>> +        table->alloc_hint = ctx->file_alloc_start;
>>
>> should we use io_reset_alloc_hint() ?
> 
> We could but I'd rather prefer not. It's used just to anything valid
> within the range, while in io_file_bitmap_get() it's specifically to
> wrap around.
> 

