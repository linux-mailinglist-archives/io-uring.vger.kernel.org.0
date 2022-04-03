Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C91724F0A87
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 17:07:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238158AbiDCPIy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 11:08:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234584AbiDCPIx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 11:08:53 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3427366AE
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 08:06:59 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id o10so335875ple.7
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 08:06:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=FX7QNsp0biKzV8aC5OzTBLm4hvgNEiVozcPGEOt/SZI=;
        b=HzVkX0R+rICptCONDbN9DjpsPs6mTJ58sRXqvdcaoEWRBOGfC7Zpw0rrxgBY5zuA78
         GMvPO0woKWf9HxYNgsODLs/Ge7jlKDZ7L74rUeJz0+zyfFf12yBgt4sQv24KYwFKiqcs
         vGxDb6yFVmcm/1WdF6PP2igowrhCjgMfTqUn4Ab7PPQRKwJGNujtTVc1HabiwKLWTayd
         fxqPek+kLIme9CIVdYeEqECKzGqBSXlHMBIBskK+yupVJvkbxN1lS62KqRRd6/PTkBt9
         RGc8o16UkM5/RNqRD5Qdqb6f2maRBtV1ynyVvBQxF6W6w2sS/e7whtccfAqXk5bC64cM
         O1LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=FX7QNsp0biKzV8aC5OzTBLm4hvgNEiVozcPGEOt/SZI=;
        b=gjKu7jruGWrJXTk17X3oiqEaGZrg3H52BtNId9UYEg0Vx90TPrmeNFIIiyDurPXNLi
         5blgXsh8Iwa1oX/M84ym+iC17dR5abPHRNr93zcJVdjJwJCM4ikiyy/wc+Rt4Hj1lUxB
         w5AyMzlafYH8prIlTp1tgQhLXQaVbNPeDsW3zJqeikGp6QuJJYx5r7/nvHCXtxw6+P7c
         gABxdJ7ay6p/6NZgH8xygg5hErU3+iXpurlZlVkvPYs0jyNiPc6s/rJcxWmgOcHqsiW/
         oDXlZNsMqcBROzs6sEAoDS2L1Gj2NUfptIybpoY9gvqBj9G5UnzJt3SgoYxZRJ7Xwqpj
         FQ9w==
X-Gm-Message-State: AOAM5339k+Q172oXaqPc2qiX6R9v+OU2cHcI1akMrKHzZ7AT6fvss8UQ
        lGQbFMF7glG3C25iYrwCTvCFgK5TcAtgZA==
X-Google-Smtp-Source: ABdhPJyP7wB1C9Xjmt2emW51j45D2ZpRpcke2nT5I2o9tayUtZf33DgJnmUkpLeNy88La73qjcUXew==
X-Received: by 2002:a17:90a:8595:b0:1bb:fbfd:bfbf with SMTP id m21-20020a17090a859500b001bbfbfdbfbfmr21738970pjn.125.1648998419108;
        Sun, 03 Apr 2022 08:06:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c4-20020a17090a4d0400b001ca5cf3271csm4705418pjg.14.2022.04.03.08.06.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 08:06:58 -0700 (PDT)
Message-ID: <5f923e0c-9b0e-fac8-12ed-957f16c2d5ca@kernel.dk>
Date:   Sun, 3 Apr 2022 09:06:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH liburing v1 2/2] test/Makefile: Append `.test` to the test
 binary filename
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220403095602.133862-1-ammarfaizi2@gnuweeb.org>
 <20220403095602.133862-3-ammarfaizi2@gnuweeb.org>
 <5eb7b378-b0cf-83ff-7796-87a33517b1a0@kernel.dk>
 <e1b1662e-f2fe-7041-7012-721ee703d41d@gnuweeb.org>
 <0f33b074-9bed-2fe2-10f6-a36b1c3f63d3@kernel.dk>
 <b48cc4ad-275e-0aa3-6c22-6e0a48e12040@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <b48cc4ad-275e-0aa3-6c22-6e0a48e12040@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/22 9:05 AM, Ammar Faizi wrote:
> On 4/3/22 10:00 PM, Jens Axboe wrote:
>> On 4/3/22 8:55 AM, Ammar Faizi wrote:
>>> On 4/3/22 9:51 PM, Jens Axboe wrote:
>>>> On 4/3/22 3:56 AM, Ammar Faizi wrote:
>>>>> When adding a new test, we often forget to add the new test binary to
>>>>> `.gitignore`. Append `.test` to the test binary filename, this way we
>>>>> can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
>>>>> test binary files.
>>>>
>>>> Did you build it?
>>>>
>>>>        CC 917257daa0fe-test.test
>>>> /usr/bin/ld: /tmp/ccGrhiuN.o: in function `thread_start':
>>>> /home/axboe/git/liburing/test/35fa71a030ca-test.c:52: undefined reference to `pthread_attr_setstacksize'
>>>> /usr/bin/ld: /home/axboe/git/liburing/test/35fa71a030ca-test.c:55: undefined reference to `pthread_create'
>>>>        CC a0908ae19763-test.test
>>>> collect2: error: ld returned 1 exit status
>>>> make[1]: *** [Makefile:210: 35fa71a030ca-test.test] Error 1
>>>> make[1]: *** Waiting for unfinished jobs....
>>>> /usr/bin/ld: /tmp/cc2nozDW.o: in function `main':
>>>> /home/axboe/git/liburing/test/232c93d07b74-test.c:295: undefined reference to `pthread_create'
>>>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:296: undefined reference to `pthread_create'
>>>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:297: undefined reference to `pthread_join'
>>>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:298: undefined reference to `pthread_join'
>>>> collect2: error: ld returned 1 exit status
>>>> make[1]: *** [Makefile:210: 232c93d07b74-test.test] Error 1
>>>> make[1]: Leaving directory '/home/axboe/git/liburing/test'
>>>>
>>>> I do like the idea of not having to keep fixing that gitignore list.
>>>
>>> Hmm.. weird... It builds just fine from my end.
>>> Can you show the full commands?
>>
>> Sure, here it is:
>>
>> axboe@m1 ~/gi/liburing (master)> make V=1                                    0.011s
> 
> OK, it now makes sense to me.
> 
> These pthread stuff are appended for the test binary files without "*.test" suffix.
> 
> 35fa71a030ca-test: override LDFLAGS += -lpthread
> 232c93d07b74-test: override LDFLAGS += -lpthread
> send_recv: override LDFLAGS += -lpthread
> send_recvmsg: override LDFLAGS += -lpthread
> poll-link: override LDFLAGS += -lpthread
> accept-link: override LDFLAGS += -lpthread
> submit-reuse: override LDFLAGS += -lpthread
> poll-v-poll: override LDFLAGS += -lpthread
> across-fork: override LDFLAGS += -lpthread
> ce593a6c480a-test: override LDFLAGS += -lpthread
> wakeup-hang: override LDFLAGS += -lpthread
> pipe-eof: override LDFLAGS += -lpthread
> timeout-new: override LDFLAGS += -lpthread
> thread-exit: override LDFLAGS += -lpthread
> ring-leak2: override LDFLAGS += -lpthread
> poll-mshot-update: override LDFLAGS += -lpthread
> exit-no-cleanup: override LDFLAGS += -lpthread
> pollfree: override LDFLAGS += -lpthread
> msg-ring: override LDFLAGS += -lpthread
> recv-msgall: override LDFLAGS += -lpthread
> recv-msgall-stream: override LDFLAGS += -lpthread
> 
> I don't know why my linker doesn't complain about that.
> 
> What about appending -lpthread to all tests and remove all of these
> override stuff? Are you okay with that?
> 
> Or do you prefer to append -lpthread for only test that needs pthread?

Nah I think that's fine, also saves some hassle when you add a new test
that does use pthread.

-- 
Jens Axboe

