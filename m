Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8FDA955FFC1
	for <lists+io-uring@lfdr.de>; Wed, 29 Jun 2022 14:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233423AbiF2MWp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jun 2022 08:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233434AbiF2MWo (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jun 2022 08:22:44 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B150C31519
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 05:22:42 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id e2so21971869edv.3
        for <io-uring@vger.kernel.org>; Wed, 29 Jun 2022 05:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=97N3MInXv71Av4RcrRufWLqrJASKkXMBF/eFEUqvIhY=;
        b=MHte/lyi+AYhzOTcxO+4lTMrcMN4yjxUC8YVcDuCGkNN7KygojXgCopO3Dx5AxB0fD
         Rqkm7SEQTpzR9JSRyYFM05QyPIHsYK+eJS0WdJdNx9kiNh8XFUzFGYUVp3kaXll9JZmE
         mOVC3jtNdSqCxxIcJB5JQS5NO5URbIJQakCQ1T+ckx04uEa/ZK71hGLAdxMr7vNHxaGK
         AP6fjbAL1ACrBys/2r2aMnDNvDPCnh/QY1wJR/XNAUpmbHg/A3cO5kOrlb514QF6po+F
         RoKWgnxb5fqO1l9PGH0BbMUu+ZM4xV9ZcnElTd4ZxmHsrgpX44Dvv0l9COMtr50ohN1e
         8XFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=97N3MInXv71Av4RcrRufWLqrJASKkXMBF/eFEUqvIhY=;
        b=OaeKuZBchDwsgIFySAZ6u3C1uG9kYTMiLrBTDmRg5nAaY/wHW6fAkjZdgkM/0OsIqt
         IWDdG9+15NUGBVfyNHUx9Z6Sh2mrHdDttqE+yJHGfX0YF01nbQHCZY/M9g7n97ob0jpa
         qaG/eXmr/bu03L91+p2/Y5Qysnptp+Jzse6/rN7wyHFkelY+dbbHhyDcF9CgSj3HldMa
         uRyAZhxxT/0Vrmx65NLCYKDJC4xezfwGSUmY9nNqhk7crzo62/7+6xe00+RPHg+8qYpO
         8L+Y78Gb3cES1x3VNuvMYWqWzkL73dYSuXQ1iNMfCwFmMMuzHZAMkdYHO8e9Z05Y/jeO
         MlGg==
X-Gm-Message-State: AJIora/YP8Ba1h808EMbHngvidjuqnguIdyi1MV3hG3txCV8+sCfETrl
        mBx2Xj6zare2/E/ykWBvQQM=
X-Google-Smtp-Source: AGRyM1tbxGMlhno6UyPK6DqTgDwz7sZ46Iabvg9tp3G4Te1S54q99qB0ucOctrTl40Ho9ZKwznzqPA==
X-Received: by 2002:a05:6402:3511:b0:437:7eec:c44c with SMTP id b17-20020a056402351100b004377eecc44cmr3958749edd.11.1656505361246;
        Wed, 29 Jun 2022 05:22:41 -0700 (PDT)
Received: from [192.168.8.198] (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id ci25-20020a170906c35900b006fe921fcb2dsm7635175ejb.49.2022.06.29.05.22.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 05:22:40 -0700 (PDT)
Message-ID: <a20e307a-6a7e-dca4-7ec6-e630fa17a0e5@gmail.com>
Date:   Wed, 29 Jun 2022 13:18:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH for-next] io_uring: let to set a range for file slot
 allocation
Content-Language: en-US
To:     Hao Xu <hao.xu@linux.dev>, io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <66ab0394e436f38437cf7c44676e1920d09687ad.1656154403.git.asml.silence@gmail.com>
 <70e38e6d-35f3-f140-9551-63e4e434bf18@linux.dev>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <70e38e6d-35f3-f140-9551-63e4e434bf18@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/27/22 08:47, Hao Xu wrote:
> On 6/25/22 18:55, Pavel Begunkov wrote:
>>  From recently io_uring provides an option to allocate a file index for
>> operation registering fixed files. However, it's utterly unusable with
>> mixed approaches when for a part of files the userspace knows better
>> where to place it, as it may race and users don't have any sane way to
>> pick a slot and hoping it will not be taken.
> 
> Exactly, with high frequency of index allocation from like multishot
> accept, it's easy that user-pick requests fails.
> By the way, just curious, I can't recall a reason that users pick a slot
> rather than letting kernel do the decision, is there any? So I guess

Can't say for the initial design, but I prefer to give away control
over such stuff to the userspace 1) to not over pollute the kernel
(not relevant anymore), 2) because it has more knowledge and can
use it more efficiently. E.g. to have O(1) memory and search time
by using in-place index based free slot list, when indexes can be
contants, and so on.


> users may use all the indexes as 'file slot allocation' range. Correct
> me if I miss something.

Yeah, can be enough, and that's what the range is set to by default.

>> Let the userspace to register a range of fixed file slots in which the
>> auto-allocation happens. The use case is splittting the fixed table in
>> two parts, where on of them is used for auto-allocation and another for
>> slot-specified operations.
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
[...]
>> @@ -24,11 +24,10 @@ static int io_file_bitmap_get(struct io_ring_ctx *ctx)
>>           if (ret != nr)
>>               return ret;
>> -        if (!table->alloc_hint)
>> +        if (table->alloc_hint == ctx->file_alloc_start)
>>               break;
>> -
>>           nr = table->alloc_hint;
>> -        table->alloc_hint = 0;
>> +        table->alloc_hint = ctx->file_alloc_start;
> 
> should we use io_reset_alloc_hint() ?

We could but I'd rather prefer not. It's used just to anything valid
within the range, while in io_file_bitmap_get() it's specifically to
wrap around.

-- 
Pavel Begunkov
