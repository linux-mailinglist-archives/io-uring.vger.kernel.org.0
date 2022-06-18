Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C4AC55045D
	for <lists+io-uring@lfdr.de>; Sat, 18 Jun 2022 14:08:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232912AbiFRMIR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Jun 2022 08:08:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231329AbiFRMIR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Jun 2022 08:08:17 -0400
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D7C13DD1
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:08:16 -0700 (PDT)
Received: by mail-ed1-x52a.google.com with SMTP id z7so9279112edm.13
        for <io-uring@vger.kernel.org>; Sat, 18 Jun 2022 05:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=LomvdWvqgBhsPwcw6xFc/20qQFIhXtLS6hXt3K0gAfw=;
        b=XfRTA6M6BiZmFDOi14GICJzIjbXRUCniw4aIoxkaKSv0Gg73p8hg0NTU3TR8UVijiU
         hnUHKnyFtVFD0GbuwzTy4lODOKb1nDX7fegSBEQtM4k0t5MYpWO9dJKv5MZReIid5pra
         /tJFH2jU3H/iBOshhUP/9Bsxh7U8t6ySv+kN5SNitNjDqz7oJxVmipv6Vtjo1nf0YhZp
         wQHJ+9D27eZa2WclNc5wd6wcAKtSvgxfkjeJPet4mAGqOea7MlcbKCOptrFuA/CJteeq
         h8RYaBqcCisgq4mgP9LKUAqnjLA4pOfR6ch+sunMgY69Ezx9uGuAEH7xOGWLXn/aX2sM
         KC2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=LomvdWvqgBhsPwcw6xFc/20qQFIhXtLS6hXt3K0gAfw=;
        b=lCd5BquHR3DG+caFluUAVpLmJp7Fnfzp73V3VYLv8yaJWF6sW4MRGYjV531yF2y3r4
         i91zJcGKAGglgHb1ZwYu/eVDbGN/zqYfYyqaqbMSqX0WffVTtb9uTsMlA8pz10wi2P43
         gSlza2XsPbIEKm8iALiFtVzHMLo624AA6QhVUQOnQlJN3swknMpeOswOY3VT9rXDim7m
         AnWE5oMLdZIhh0W1vxlGR/ozs7i3tnFBgVSZcKb8wiM75Qx3lZ3k94XOGOguHHczP1mD
         izpufmag093wJDAQKdDaDYrrA5O30IqQdxzQAuI2MDmplWjbxCPVgiRmmFDwMp33sbsc
         3sCw==
X-Gm-Message-State: AJIora+X5F/Vqgo1/U2Pf9yQlws/syM8bMnNdDp90NRXIdfXSfIRZXDv
        CEr6hR+WHk1m9MhAqsiw/7hnhy7tGuwIxQ==
X-Google-Smtp-Source: AGRyM1tCky+3UYwGQcNdb0qDQIOcfKaBZqaaYxGwWw1OfZzQuNMoPNMZ46IfNoCd3rHxDbiFQ/XMfg==
X-Received: by 2002:a05:6402:401f:b0:433:406a:82c2 with SMTP id d31-20020a056402401f00b00433406a82c2mr18207278eda.289.1655554094641;
        Sat, 18 Jun 2022 05:08:14 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id y11-20020a056402270b00b0042e1cbc4471sm5832934edd.3.2022.06.18.05.08.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Jun 2022 05:08:14 -0700 (PDT)
Message-ID: <36f85d32-4238-9461-72d1-38a2c3468041@gmail.com>
Date:   Sat, 18 Jun 2022 13:07:54 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH for-next v3 16/16] io_uring: mutex locked poll hashing
Content-Language: en-US
To:     Nathan Chancellor <nathan@kernel.org>
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        llvm@lists.linux.dev
References: <cover.1655371007.git.asml.silence@gmail.com>
 <1bbad9c78c454b7b92f100bbf46730a37df7194f.1655371007.git.asml.silence@gmail.com>
 <YqyfK34NJakiLiVe@dev-arch.thelio-3990X>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <YqyfK34NJakiLiVe@dev-arch.thelio-3990X>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/17/22 16:35, Nathan Chancellor wrote:
> On Thu, Jun 16, 2022 at 10:22:12AM +0100, Pavel Begunkov wrote:
>> Currently we do two extra spin lock/unlock pairs to add a poll/apoll
>> request to the cancellation hash table and remove it from there.
>>
>> On the submission side we often already hold ->uring_lock and tw
>> completion is likely to hold it as well. Add a second cancellation hash
>> table protected by ->uring_lock. In concerns for latency because of a
>> need to have the mutex locked on the completion side, use the new table
>> only in following cases:
>>
>> 1) IORING_SETUP_SINGLE_ISSUER: only one task grabs uring_lock, so there
>>     is little to no contention and so the main tw hander will almost
>>     always end up grabbing it before calling callbacks.
>>
>> 2) IORING_SETUP_SQPOLL: same as with single issuer, only one task is
>>     a major user of ->uring_lock.
>>
>> 3) apoll: we normally grab the lock on the completion side anyway to
>>     execute the request, so it's free.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> 
> <snip>
> 
>> -/*
>> - * Returns true if we found and killed one or more poll requests
>> - */
>> -__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
>> -			       bool cancel_all)
>> +static __cold bool io_poll_remove_all_table(struct task_struct *tsk,
>> +					    struct io_hash_table *table,
>> +					    bool cancel_all)
>>   {
>> -	struct io_hash_table *table = &ctx->cancel_table;
>>   	unsigned nr_buckets = 1U << table->hash_bits;
>>   	struct hlist_node *tmp;
>>   	struct io_kiocb *req;
>> @@ -557,6 +592,17 @@ __cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
>>   	return found;
>>   }
>>   
>> +/*
>> + * Returns true if we found and killed one or more poll requests
>> + */
>> +__cold bool io_poll_remove_all(struct io_ring_ctx *ctx, struct task_struct *tsk,
>> +			       bool cancel_all)
>> +	__must_hold(&ctx->uring_lock)
>> +{
>> +	return io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all) |
>> +	       io_poll_remove_all_table(tsk, &ctx->cancel_table_locked, cancel_all);
>> +}
> 
> Clang warns:
> 
>    io_uring/poll.c:602:9: error: use of bitwise '|' with boolean operands [-Werror,-Wbitwise-instead-of-logical]
>            return io_poll_remove_all_table(tsk, &ctx->cancel_table, cancel_all) |
>                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>                                                                                 ||
>    io_uring/poll.c:602:9: note: cast one or both operands to int to silence this warning
>    1 error generated.
> 
> I assume this is intentional so io_poll_remove_all_table() gets called
> twice every time? If so, would you be opposed to unrolling this a bit to
> make it clear to the compiler? Alternatively, we could change the return
> type of io_poll_remove_all_table to be an int or add a cast to int like
> the note mentioned but that is rather ugly to me. I can send a formal
> patch depending on your preference.

Thanks for the heads up. Yes, it's intentional, and I'm fine with either
version. Are you going to send a patch?


-- 
Pavel Begunkov
