Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2292D75439B
	for <lists+io-uring@lfdr.de>; Fri, 14 Jul 2023 22:14:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236012AbjGNUOu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 14 Jul 2023 16:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233193AbjGNUOt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 14 Jul 2023 16:14:49 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7F630E3
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 13:14:48 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id e9e14a558f8ab-346434c7793so1724805ab.0
        for <io-uring@vger.kernel.org>; Fri, 14 Jul 2023 13:14:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689365687; x=1691957687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tFNh9MsRVDfaCjAas0TYiHd8ifY1+GVeMaznPoC7JfU=;
        b=f73tb2lx82DoNRk6qD5fcyH9VMlOvBxqjASY0rXobOgoHm+O9ftySYNAQ7AidDqhVa
         e0NTPQ0CNSbFx0j+E+zxm9juodR5cVoKaZBjAjpx80N5KfTKonsZysXceKMvN3BA83hF
         Xhu0xiJOxUKGOY7KVitvP9crtFV9qiyDul9fcznIDojlD7HsvEn5zvZjq0dsh6s8LMZf
         ncqmbZh/zscVJUGjQ8+fBdzzywHzWGQODQkh7cl46Dpmj3ZDo5LkaXY2aVf4hM5tcRmG
         d94cK1MOwaQSynYuUTAXhigiFOu0/iC4zKasGJzPqrM4nEWJwjSJ9bRDjTMlm2gUzZ/G
         pQcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689365687; x=1691957687;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tFNh9MsRVDfaCjAas0TYiHd8ifY1+GVeMaznPoC7JfU=;
        b=AtUmG7/KubEB8JvQkmkkasrYQryiHpX7QmZdgu+rCVTQoDcQFun9zcZf7XvlDwLOp9
         nRu2WKyWcrQppJt+YomRO6bhFMseq3mJqCb/v1BI3z9jcMj64vaIlHBtBPKQSsAyc3lZ
         yCQRMRP9a1cjksnqCi5a5XafyweaXIbeqoj8Dmb12hxUcGSPy76lYXhS7S8Dca/pd53w
         NDe1v/Tuu6iIkeAlBPEa7JMA7u8VkyR4WNcXCGrC51UZEAeLSwm9dzlEZcvWW9eJ1G14
         H2DXZMJ7eKFAYWjTRy8+BLppqROKa0gzBteJZ6Vsemk2jxGFkKuOtaLk4A4CNuPXrM1U
         907A==
X-Gm-Message-State: ABy/qLa52MCEJ6vlvXEa/SUD/gEVpqnu9eA8raWeGdW6aSaFEnXy8lXv
        ChWnGHl3oG9VEIVF+KWDqY6ICDtgb4Hi6IrBHuU=
X-Google-Smtp-Source: APBJJlF4KlZ5aDRW6O3/Vlts0tKYFwIqnqYvn3wX0CeC66eNpfpDQ1DWNs7VWAitVWvtQNo+DqsgCA==
X-Received: by 2002:a05:6602:4a07:b0:780:cde6:3e22 with SMTP id eh7-20020a0566024a0700b00780cde63e22mr204487iob.0.1689365687541;
        Fri, 14 Jul 2023 13:14:47 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d18-20020a6b4f12000000b00786ea00bdb5sm2882046iob.2.2023.07.14.13.14.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 14 Jul 2023 13:14:46 -0700 (PDT)
Message-ID: <ca82bd8b-5868-8fbb-6701-061220a1ff97@kernel.dk>
Date:   Fri, 14 Jul 2023 14:14:45 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5/5] io_uring: add IORING_OP_WAITID support
Content-Language: en-US
To:     Arnd Bergmann <arnd@arndb.de>,
        Christian Brauner <brauner@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230711204352.214086-1-axboe@kernel.dk>
 <20230711204352.214086-6-axboe@kernel.dk>
 <8431d207-5e52-4f8c-a12d-276836174bad@app.fastmail.com>
 <048cfbce-5238-2580-2d53-2ca740e72d79@kernel.dk>
 <bbc5f3cf-99f8-0695-1367-979301c64ecb@kernel.dk>
 <20230714-grummeln-sitzgelegenheit-1157c2feac71@brauner>
 <d53ed71a-3f57-4c5e-9117-82535aae7855@app.fastmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d53ed71a-3f57-4c5e-9117-82535aae7855@app.fastmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/14/23 12:33?PM, Arnd Bergmann wrote:
> On Fri, Jul 14, 2023, at 17:47, Christian Brauner wrote:
>> On Tue, Jul 11, 2023 at 04:18:13PM -0600, Jens Axboe wrote:
>>> On 7/11/23 3:22?PM, Jens Axboe wrote:
>>>> On 7/11/23 3:11?PM, Arnd Bergmann wrote:
> 
>>>>> Does this require argument conversion for compat tasks?
>>>>>
>>>>> Even without the rusage argument, I think the siginfo
>>>>> remains incompatible with 32-bit tasks, unfortunately.
>>>>
>>>> Hmm yes good point, if compat_siginfo and siginfo are different, then it
>>>> does need handling for that. Would be a trivial addition, I'll make that
>>>> change. Thanks Arnd!
>>>
>>> Should be fixed in the current version:
>>>
>>> https://git.kernel.dk/cgit/linux/commit/?h=io_uring-waitid&id=08f3dc9b7cedbd20c0f215f25c9a7814c6c601cc
>>
>> In kernel/signal.c in pidfd_send_signal() we have
>> copy_siginfo_from_user_any() it seems that a similar version
>> copy_siginfo_to_user_any() might be something to consider. We do have
>> copy_siginfo_to_user32() and copy_siginfo_to_user(). But I may lack
>> context why this wouldn't work here.
> 
> We could add a copy_siginfo_to_user_any(), but I think open-coding
> it is easier here, since the in_compat_syscall() check does not
> work inside of the io_uring kernel thread, it has to be
> "if (req->ctx->compat)" in order to match the wordsize of the task
> that started the request.

Yeah, unifying this stuff did cross my mind when adding another one.
Which I think could still be done, you'd just need to pass in a 'compat'
parameter similar to how it's done for iovec importing.

But if it's ok with everybody I'd rather do that as a cleanup post this.

> Using copy_siginfo_to_user32() and copy_siginfo_to_user() is
> probably a good idea though, it's often faster and less
> error-prone than writing each member separately.

I was just pattern matching on the other use cases. I'll take a look at
the siginfo copy helpers, thanks!

-- 
Jens Axboe

