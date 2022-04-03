Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE4A54F0A82
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 17:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359119AbiDCPHE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 11:07:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353718AbiDCPHD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 11:07:03 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A6893669A
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 08:05:10 -0700 (PDT)
Received: from [192.168.148.80] (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id 611CA7E30F;
        Sun,  3 Apr 2022 15:05:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648998309;
        bh=r1q8uNavViWj3wMi3O0yOqd0DmEHB8qJhQjM+eEoDCs=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BrRQtcZLx7MySbZ4XrLjGAukUArzNb51XoGOSzTi1beIKaxkcO675A/YGtSMoXroJ
         qJeOG2a9KSy3DxlmWi8MJAPI2Rq/SW9KobLQ4crk+jXWD5TarsWN/1lYQ5qMqUmEHN
         bowxwgJJjYAlcDOHN+QY1aNnWkBLQxb67FPtiHw0FwKFfI2GkdKe3dE7Xm6+gKtB32
         KjOxfEKQ4e4v6nRN5ng4YYo3KjK4IXSBaq8HyjUs2KMwE6XuxsAxsaLFMpQLodWFAU
         5qBigscoyZlAUlnzdQ/jl9ym6vfxfkPk7ZifDOExNsNM1v2GQDWiSJqp8Mb5S90Dci
         A7J5GglzfKlXw==
Message-ID: <b48cc4ad-275e-0aa3-6c22-6e0a48e12040@gnuweeb.org>
Date:   Sun, 3 Apr 2022 22:05:05 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH liburing v1 2/2] test/Makefile: Append `.test` to the test
 binary filename
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
References: <20220403095602.133862-1-ammarfaizi2@gnuweeb.org>
 <20220403095602.133862-3-ammarfaizi2@gnuweeb.org>
 <5eb7b378-b0cf-83ff-7796-87a33517b1a0@kernel.dk>
 <e1b1662e-f2fe-7041-7012-721ee703d41d@gnuweeb.org>
 <0f33b074-9bed-2fe2-10f6-a36b1c3f63d3@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <0f33b074-9bed-2fe2-10f6-a36b1c3f63d3@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/3/22 10:00 PM, Jens Axboe wrote:
> On 4/3/22 8:55 AM, Ammar Faizi wrote:
>> On 4/3/22 9:51 PM, Jens Axboe wrote:
>>> On 4/3/22 3:56 AM, Ammar Faizi wrote:
>>>> When adding a new test, we often forget to add the new test binary to
>>>> `.gitignore`. Append `.test` to the test binary filename, this way we
>>>> can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
>>>> test binary files.
>>>
>>> Did you build it?
>>>
>>>        CC 917257daa0fe-test.test
>>> /usr/bin/ld: /tmp/ccGrhiuN.o: in function `thread_start':
>>> /home/axboe/git/liburing/test/35fa71a030ca-test.c:52: undefined reference to `pthread_attr_setstacksize'
>>> /usr/bin/ld: /home/axboe/git/liburing/test/35fa71a030ca-test.c:55: undefined reference to `pthread_create'
>>>        CC a0908ae19763-test.test
>>> collect2: error: ld returned 1 exit status
>>> make[1]: *** [Makefile:210: 35fa71a030ca-test.test] Error 1
>>> make[1]: *** Waiting for unfinished jobs....
>>> /usr/bin/ld: /tmp/cc2nozDW.o: in function `main':
>>> /home/axboe/git/liburing/test/232c93d07b74-test.c:295: undefined reference to `pthread_create'
>>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:296: undefined reference to `pthread_create'
>>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:297: undefined reference to `pthread_join'
>>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:298: undefined reference to `pthread_join'
>>> collect2: error: ld returned 1 exit status
>>> make[1]: *** [Makefile:210: 232c93d07b74-test.test] Error 1
>>> make[1]: Leaving directory '/home/axboe/git/liburing/test'
>>>
>>> I do like the idea of not having to keep fixing that gitignore list.
>>
>> Hmm.. weird... It builds just fine from my end.
>> Can you show the full commands?
> 
> Sure, here it is:
> 
> axboe@m1 ~/gi/liburing (master)> make V=1                                    0.011s

OK, it now makes sense to me.

These pthread stuff are appended for the test binary files without "*.test" suffix.

35fa71a030ca-test: override LDFLAGS += -lpthread
232c93d07b74-test: override LDFLAGS += -lpthread
send_recv: override LDFLAGS += -lpthread
send_recvmsg: override LDFLAGS += -lpthread
poll-link: override LDFLAGS += -lpthread
accept-link: override LDFLAGS += -lpthread
submit-reuse: override LDFLAGS += -lpthread
poll-v-poll: override LDFLAGS += -lpthread
across-fork: override LDFLAGS += -lpthread
ce593a6c480a-test: override LDFLAGS += -lpthread
wakeup-hang: override LDFLAGS += -lpthread
pipe-eof: override LDFLAGS += -lpthread
timeout-new: override LDFLAGS += -lpthread
thread-exit: override LDFLAGS += -lpthread
ring-leak2: override LDFLAGS += -lpthread
poll-mshot-update: override LDFLAGS += -lpthread
exit-no-cleanup: override LDFLAGS += -lpthread
pollfree: override LDFLAGS += -lpthread
msg-ring: override LDFLAGS += -lpthread
recv-msgall: override LDFLAGS += -lpthread
recv-msgall-stream: override LDFLAGS += -lpthread

I don't know why my linker doesn't complain about that.

What about appending -lpthread to all tests and remove all of these
override stuff? Are you okay with that?

Or do you prefer to append -lpthread for only test that needs pthread?

-- 
Ammar Faizi
