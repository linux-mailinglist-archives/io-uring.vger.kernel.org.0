Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57A754F0A77
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 17:01:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358200AbiDCPCz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 11:02:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353718AbiDCPCz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 11:02:55 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4230E31372
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 08:01:01 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id d15so887249pll.10
        for <io-uring@vger.kernel.org>; Sun, 03 Apr 2022 08:01:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=78t5jB+URxRJvWeVp7bawvkn5jW/ehLW3Xd2mtnl2qo=;
        b=qT1wvYs5WYIx0yWOoEmdtiC+WKdIR4UJ9XRGmFMgUGQLQJTpO+UsOJbAqwZLD9ighf
         GNdcC32pODe88yLrm5D/kCcqrgVcseCvrLvGlfM8fSvapocKvOkmRc8U6eQg5s5kFnI/
         oqlqpAiTDESoxcAXyWQQQgg1s0uoAF6RPsDtBoTLkhvfRhMjJBH25YiT7Us1n4Xh6Jw2
         TAhG2MEPCwlZfkYm1C8de5vqf1ou851du53n7k5kuSBR0tvJCVZOSpYXMgRwaoqUhc5N
         sK2Oj791bzyd7nPVmqGDxJrhrGpUvj/6XDcIOcY/hWvqEwJZ/01fEjaSb1/sJEgQlQ3z
         hs6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=78t5jB+URxRJvWeVp7bawvkn5jW/ehLW3Xd2mtnl2qo=;
        b=GPzKzRPM/gcQyZAiHnl/EHP4F2AyOzUzLE7N3+xWtuC67XWltWPWtQgx8qYK8FRclm
         jDU7UXZz/zvj6Er4ZEU4s3VEed3vcBkScwwemgUey3q4Q58qDFaBxIlqdjJ57iiErnBi
         rP9cvp4zMmDxsFfpEAUGFW1UWxy1GDhrS5HDpMDYlBhmuuFd5CVCnKbCTiv+GVjZOeS5
         iOD+YYTg+cQ7J8p6z5TcA/ZUFXlaguOd9aVisRXrH5T7rXV7oGP06SFE1dHg3oTpTiiF
         bb3q/cpK13/ZMxl1vb1EM/iNW6Ad/tgsBckJJ7gB3cZgUPMl1B7gB4/bNDi6NcsD6bCm
         i+BA==
X-Gm-Message-State: AOAM531drv3yhCZhfo0/thfrqbKZ64ilZF7cXrvxtS1jQVEc1HXA1M3g
        /e56LIzD1cVcveyfdn0dwTPd6g==
X-Google-Smtp-Source: ABdhPJyu8U4NaHFSN795BdwB3oHedNXtn8AMf0QcHNKiIZXDYykac3nz9Wne38oHusOLj/+LWHmZcA==
X-Received: by 2002:a17:902:cf05:b0:156:8445:ce0f with SMTP id i5-20020a170902cf0500b001568445ce0fmr5970441plg.99.1648998060529;
        Sun, 03 Apr 2022 08:01:00 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id c4-20020a17090a4d0400b001ca5cf3271csm4696366pjg.14.2022.04.03.08.00.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 03 Apr 2022 08:01:00 -0700 (PDT)
Message-ID: <0f33b074-9bed-2fe2-10f6-a36b1c3f63d3@kernel.dk>
Date:   Sun, 3 Apr 2022 09:00:59 -0600
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
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <e1b1662e-f2fe-7041-7012-721ee703d41d@gnuweeb.org>
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

On 4/3/22 8:55 AM, Ammar Faizi wrote:
> On 4/3/22 9:51 PM, Jens Axboe wrote:
>> On 4/3/22 3:56 AM, Ammar Faizi wrote:
>>> When adding a new test, we often forget to add the new test binary to
>>> `.gitignore`. Append `.test` to the test binary filename, this way we
>>> can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
>>> test binary files.
>>
>> Did you build it?
>>
>>       CC 917257daa0fe-test.test
>> /usr/bin/ld: /tmp/ccGrhiuN.o: in function `thread_start':
>> /home/axboe/git/liburing/test/35fa71a030ca-test.c:52: undefined reference to `pthread_attr_setstacksize'
>> /usr/bin/ld: /home/axboe/git/liburing/test/35fa71a030ca-test.c:55: undefined reference to `pthread_create'
>>       CC a0908ae19763-test.test
>> collect2: error: ld returned 1 exit status
>> make[1]: *** [Makefile:210: 35fa71a030ca-test.test] Error 1
>> make[1]: *** Waiting for unfinished jobs....
>> /usr/bin/ld: /tmp/cc2nozDW.o: in function `main':
>> /home/axboe/git/liburing/test/232c93d07b74-test.c:295: undefined reference to `pthread_create'
>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:296: undefined reference to `pthread_create'
>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:297: undefined reference to `pthread_join'
>> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:298: undefined reference to `pthread_join'
>> collect2: error: ld returned 1 exit status
>> make[1]: *** [Makefile:210: 232c93d07b74-test.test] Error 1
>> make[1]: Leaving directory '/home/axboe/git/liburing/test'
>>
>> I do like the idea of not having to keep fixing that gitignore list.
> 
> Hmm.. weird... It builds just fine from my end.
> Can you show the full commands?

Sure, here it is:

axboe@m1 ~/gi/liburing (master)> make V=1                                    0.011s
Running configure ...
prefix                        /usr
includedir                    /usr/include
libdir                        /usr/lib
libdevdir                     /usr/lib
relativelibdir                
mandir                        /usr/man
datadir                       /usr/share
stringop_overflow             yes
array_bounds                  yes
__kernel_rwf_t                yes
__kernel_timespec             yes
open_how                      yes
statx                         yes
glibc_statx                   yes
C++                           yes
has_ucontext                  yes
has_memfd_create              yes
liburing_nolibc               no
CC                            gcc
CXX                           g++
make[1]: Entering directory '/home/axboe/git/liburing/src'
gcc -D_GNU_SOURCE -Iinclude/ -include ../config-host.h -MT "setup.ol" -MMD -MP -MF "setup.ol.d" -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -c -o setup.ol setup.c
gcc -D_GNU_SOURCE -Iinclude/ -include ../config-host.h -MT "queue.ol" -MMD -MP -MF "queue.ol.d" -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -c -o queue.ol queue.c
gcc -D_GNU_SOURCE -Iinclude/ -include ../config-host.h -MT "register.ol" -MMD -MP -MF "register.ol.d" -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -c -o register.ol register.c
gcc -D_GNU_SOURCE -Iinclude/ -include ../config-host.h -MT "syscall.ol" -MMD -MP -MF "syscall.ol.d" -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -c -o syscall.ol syscall.c
ar r liburing.a setup.ol queue.ol register.ol syscall.ol
ar: creating liburing.a
ranlib liburing.a
gcc -D_GNU_SOURCE -Iinclude/ -include ../config-host.h -MT "setup.os" -MMD -MP -MF "setup.os.d" -fPIC -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -c -o setup.os setup.c
gcc -D_GNU_SOURCE -Iinclude/ -include ../config-host.h -MT "queue.os" -MMD -MP -MF "queue.os.d" -fPIC -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -c -o queue.os queue.c
gcc -D_GNU_SOURCE -Iinclude/ -include ../config-host.h -MT "register.os" -MMD -MP -MF "register.os.d" -fPIC -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -c -o register.os register.c
gcc -D_GNU_SOURCE -Iinclude/ -include ../config-host.h -MT "syscall.os" -MMD -MP -MF "syscall.os.d" -fPIC -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -c -o syscall.os syscall.c
gcc -fPIC -g -O2 -Wall -Wextra -fno-stack-protector -Wno-unused-parameter -Wno-sign-compare -DLIBURING_INTERNAL -shared -Wl,--version-script=liburing.map -Wl,-soname=liburing.so.2 -o liburing.so.2.2 setup.os queue.os register.os syscall.os 
make[1]: Leaving directory '/home/axboe/git/liburing/src'
make[1]: Entering directory '/home/axboe/git/liburing/test'
gcc -D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ -I../src/include/ -include ../config-host.h -g -O2 -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -Wstringop-overflow=0 -Warray-bounds=0 -DLIBURING_BUILD_TEST -o helpers.o -c helpers.c
gcc -D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ -I../src/include/ -include ../config-host.h -g -O2 -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -Wstringop-overflow=0 -Warray-bounds=0 -DLIBURING_BUILD_TEST -o ../src/syscall.o -c ../src/syscall.c
gcc -D_GNU_SOURCE -D__SANE_USERSPACE_TYPES__ -I../src/include/ -include ../config-host.h -g -O2 -Wall -Wextra -Wno-unused-parameter -Wno-sign-compare -Wstringop-overflow=0 -Warray-bounds=0 -DLIBURING_BUILD_TEST -o 232c93d07b74-test.test 232c93d07b74-test.c helpers.o ../src/syscall.o -L../src/ -luring
/usr/bin/ld: /tmp/cchfKQEY.o: in function `main':
/home/axboe/git/liburing/test/232c93d07b74-test.c:295: undefined reference to `pthread_create'
/usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:296: undefined reference to `pthread_create'
/usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:297: undefined reference to `pthread_join'
/usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:298: undefined reference to `pthread_join'
collect2: error: ld returned 1 exit status
make[1]: *** [Makefile:210: 232c93d07b74-test.test] Error 1
make[1]: Leaving directory '/home/axboe/git/liburing/test'
make: *** [Makefile:11: all] Error 2

-- 
Jens Axboe

