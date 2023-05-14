Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 977DC701B45
	for <lists+io-uring@lfdr.de>; Sun, 14 May 2023 04:59:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbjENC7J (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 13 May 2023 22:59:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjENC7I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 13 May 2023 22:59:08 -0400
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D045213E
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 19:59:07 -0700 (PDT)
Received: by mail-pl1-x629.google.com with SMTP id d9443c01a7336-1aaf0bc8a07so22203735ad.0
        for <io-uring@vger.kernel.org>; Sat, 13 May 2023 19:59:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684033147; x=1686625147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bEz/GDZryWPwdLiBye9UG8FSH96Dq5ETY+tUulxp6TM=;
        b=3BFaA4VFKi0KwSM7jC+CaKAqVgO+ejoqKAIRgUaDXWvOtpa15Fqixxisy46Te0EImO
         JCNj3pNFMeyZYY+CuNzEwuqf6Y4o40ZLrWRWrRe4TxqEJt54jOMnHFbpdLiXAkj2dsEz
         g6ZqiMibYa1EiyS5SpmoP5BXwPr61N4rwxyC3GCQS1uNGQjxUsh3Hk9woFSu+is0Ex3f
         dhCLWCAD24k4CJW6mTIXnzPGmpz1zPRoVCsRkkX+prgFN9GpwjZsTwjj8+2NC9wtral3
         l2V+ddcKe4T23JkmURSHREPvUJjErY5PNEeSm22yQPOW1uE+Y7uauRNpQ3Y4AJHYx9aS
         lSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684033147; x=1686625147;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bEz/GDZryWPwdLiBye9UG8FSH96Dq5ETY+tUulxp6TM=;
        b=F3VErREI4ae3R8DlSPJPH36Fffnbo2YfMmfkPbjfGFPfCrm8O52+Ag+bMPY9BB0Sya
         Y431Rm5fRuobZv0gUDX4E/lGYKpl8rzYN2j1yR6EGMYNbqpRsz1pF9ki3zf5rmWrYWl1
         zURo9tSVfky4y3TvzwoJWIQPIUJcX+ATtlQlSu8KWiJ/S1fKnGBRzByX0rPdli3X/6th
         f5nzMUFC2MBGvMnmEa3gEwXa7spKjpaMGJ87GgCFzhr8CaHcf57rx1arQYErUbHO0sCe
         ef/jPw68MFLxXB/wKcfk7gDRqUkZebZS1gxDdakrW3cIgz6qmw2nKVMt4AhvZirCHomE
         giHA==
X-Gm-Message-State: AC+VfDz2PFuXR4PbnLfBFxt5EIXNqHGNPZ11wTd+ByyPS89s9xPnm9oH
        vI2Tpdc8hTAxUykR9UyyhFtst1+dlOn8V8YhX0c=
X-Google-Smtp-Source: ACHHUZ6TI6FvXrlKwGPmqlIAtfZks5LUU1Y0J6j6cwzSrR1kmq0Ydwtr5xF5j8rBrLY/7WZhBeh5eQ==
X-Received: by 2002:a17:902:c950:b0:1ac:775b:3e0a with SMTP id i16-20020a170902c95000b001ac775b3e0amr26452335pla.5.1684033146808;
        Sat, 13 May 2023 19:59:06 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id je6-20020a170903264600b001aaf2e7b06csm10544436plb.132.2023.05.13.19.59.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 13 May 2023 19:59:06 -0700 (PDT)
Message-ID: <9a3ccab4-f173-ec53-7730-ebace868793d@kernel.dk>
Date:   Sat, 13 May 2023 20:59:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 2/4] io_uring: return error pointer from io_mem_alloc()
Content-Language: en-US
To:     Dmitry Kadashev <dkadashev@gmail.com>
Cc:     io-uring@vger.kernel.org
References: <20230513141643.1037620-1-axboe@kernel.dk>
 <20230513141643.1037620-3-axboe@kernel.dk>
 <CAOKbgA5U_o2igDLfsbmd7NSCSxtNXA=GV+1k3H-F5VF2szb-uQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAOKbgA5U_o2igDLfsbmd7NSCSxtNXA=GV+1k3H-F5VF2szb-uQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/13/23 8:54?PM, Dmitry Kadashev wrote:
> Hi Jens,
> 
> On Sat, May 13, 2023 at 9:19?PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> In preparation for having more than one time of ring allocator, make the
>> existing one return valid/error-pointer rather than just NULL.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
>> ---
>>  io_uring/io_uring.c | 18 ++++++++++++------
>>  1 file changed, 12 insertions(+), 6 deletions(-)
>>
>> diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
>> index 3695c5e6fbf0..6266a870c89f 100644
>> --- a/io_uring/io_uring.c
>> +++ b/io_uring/io_uring.c
>> @@ -2712,8 +2712,12 @@ static void io_mem_free(void *ptr)
>>  static void *io_mem_alloc(size_t size)
>>  {
>>         gfp_t gfp = GFP_KERNEL_ACCOUNT | __GFP_ZERO | __GFP_NOWARN | __GFP_COMP;
>> +       void *ret;
>>
>> -       return (void *) __get_free_pages(gfp, get_order(size));
>> +       ret = (void *) __get_free_pages(gfp, get_order(size));
>> +       if (ret)
>> +               return ret;
>> +       return ERR_PTR(-ENOMEM);
>>  }
>>
>>  static unsigned long rings_size(struct io_ring_ctx *ctx, unsigned int sq_entries,
>> @@ -3673,6 +3677,7 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>  {
>>         struct io_rings *rings;
>>         size_t size, sq_array_offset;
>> +       void *ptr;
>>
>>         /* make sure these are sane, as we already accounted them */
>>         ctx->sq_entries = p->sq_entries;
>> @@ -3683,8 +3688,8 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>                 return -EOVERFLOW;
>>
>>         rings = io_mem_alloc(size);
>> -       if (!rings)
>> -               return -ENOMEM;
>> +       if (IS_ERR(rings))
>> +               return PTR_ERR(rings);
>>
>>         ctx->rings = rings;
>>         ctx->sq_array = (u32 *)((char *)rings + sq_array_offset);
>> @@ -3703,13 +3708,14 @@ static __cold int io_allocate_scq_urings(struct io_ring_ctx *ctx,
>>                 return -EOVERFLOW;
>>         }
>>
>> -       ctx->sq_sqes = io_mem_alloc(size);
>> -       if (!ctx->sq_sqes) {
>> +       ptr = io_mem_alloc(size);
>> +       if (IS_ERR(ptr)) {
>>                 io_mem_free(ctx->rings);
>>                 ctx->rings = NULL;
>> -               return -ENOMEM;
>> +               return PTR_ERR(ptr);
>>         }
>>
>> +       ctx->sq_sqes = io_mem_alloc(size);
> 
> Should be 'ptr' rather than 'io_mem_alloc(size)' here.

Indeed, good catch. Patch 4 does correct that so the final result is
correct, must've happened during a split rebase a while back. I'll fix
up patch 2 and 4 so that it's correct after patch 2 as well.

-- 
Jens Axboe

