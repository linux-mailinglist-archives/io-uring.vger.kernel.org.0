Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BA2A4F0A73
	for <lists+io-uring@lfdr.de>; Sun,  3 Apr 2022 16:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233193AbiDCO5q (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Apr 2022 10:57:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiDCO5o (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Apr 2022 10:57:44 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D94C111158
        for <io-uring@vger.kernel.org>; Sun,  3 Apr 2022 07:55:50 -0700 (PDT)
Received: from [192.168.148.80] (unknown [182.2.43.220])
        by gnuweeb.org (Postfix) with ESMTPSA id DB4847E342;
        Sun,  3 Apr 2022 14:55:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648997750;
        bh=zYbrk0yYzr5C7JeDM3tY8hNv8/pVZpZdFMR2yZ531TE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=oeT3kwhujgeCtYo2ANe4cgWjQjPsGjCsApbYjSYR59Ebghr9ThjqP3K91AxQozPzW
         ErPleB7mzU/pDR6dZmFXy9TTxChonn0UFc5bXfpX7l4iMKXNdgMufiK5pX8Wrag2O2
         b1fdL4IzWTziuho7lm6iUYQTmM+2fttskAYqsTbuICebgPvzE+k0d3bMUr5QRPYHvW
         soxASiBg+yQBHPhZyE0qTq1IX50c5va2YBUlM4JJgV3sKLCGlF7J2t0wJDDpdQlzx+
         k/KRFmIk4lJ0TvRjsez7FrfA04mKdogITGDTt7JcNp+aVu4rhPwscoq5ubLVIrN0FD
         eosw4q/0cmTQA==
Message-ID: <e1b1662e-f2fe-7041-7012-721ee703d41d@gnuweeb.org>
Date:   Sun, 3 Apr 2022 21:55:46 +0700
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
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <5eb7b378-b0cf-83ff-7796-87a33517b1a0@kernel.dk>
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

On 4/3/22 9:51 PM, Jens Axboe wrote:
> On 4/3/22 3:56 AM, Ammar Faizi wrote:
>> When adding a new test, we often forget to add the new test binary to
>> `.gitignore`. Append `.test` to the test binary filename, this way we
>> can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
>> test binary files.
> 
> Did you build it?
> 
>       CC 917257daa0fe-test.test
> /usr/bin/ld: /tmp/ccGrhiuN.o: in function `thread_start':
> /home/axboe/git/liburing/test/35fa71a030ca-test.c:52: undefined reference to `pthread_attr_setstacksize'
> /usr/bin/ld: /home/axboe/git/liburing/test/35fa71a030ca-test.c:55: undefined reference to `pthread_create'
>       CC a0908ae19763-test.test
> collect2: error: ld returned 1 exit status
> make[1]: *** [Makefile:210: 35fa71a030ca-test.test] Error 1
> make[1]: *** Waiting for unfinished jobs....
> /usr/bin/ld: /tmp/cc2nozDW.o: in function `main':
> /home/axboe/git/liburing/test/232c93d07b74-test.c:295: undefined reference to `pthread_create'
> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:296: undefined reference to `pthread_create'
> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:297: undefined reference to `pthread_join'
> /usr/bin/ld: /home/axboe/git/liburing/test/232c93d07b74-test.c:298: undefined reference to `pthread_join'
> collect2: error: ld returned 1 exit status
> make[1]: *** [Makefile:210: 232c93d07b74-test.test] Error 1
> make[1]: Leaving directory '/home/axboe/git/liburing/test'
> 
> I do like the idea of not having to keep fixing that gitignore list.

Hmm.. weird... It builds just fine from my end.
Can you show the full commands?

This is mine:
-----------------------------------------
ammarfaizi2@integral2:~/app/liburing$ make clean
make[1]: Entering directory '/home/ammarfaizi2/app/liburing/src'
make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/src'
make[1]: Entering directory '/home/ammarfaizi2/app/liburing/test'
make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/test'
make[1]: Entering directory '/home/ammarfaizi2/app/liburing/examples'
make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/examples'
ammarfaizi2@integral2:~/app/liburing$ git log -n 2
commit 9c6343ae79a63dbddc9baf404fe6a9e07ac6fb3b (HEAD -> for-jens5)
Author: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Sun Apr 3 16:35:30 2022 +0700

     test/Makefile: Append `.test` to the test binary filename
     
     When adding a new test, we often forget to add the new test binary to
     `.gitignore`. Append `.test` to the test binary filename, this way we
     can use a wildcard matching "test/*.test" in `.gitignore` to ignore all
     test binary files.
     
     Goals:
       - Make the .gitignore simpler.
       - Avoid the burden of adding a new test to .gitignore.
     
     Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>

commit 2f72d1261e30c514ed9426c7c7a6187d15e4f75d
Author: Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Sun Apr 3 16:44:26 2022 +0700

     src/int_flags.h: Add missing SPDX-License-Identifier
     
     Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
ammarfaizi2@integral2:~/app/liburing$ taskset -c 0-7 make -j8
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
make[1]: Entering directory '/home/ammarfaizi2/app/liburing/src'
      CC setup.ol
      CC queue.ol
      CC register.ol
      CC syscall.ol
      CC setup.os
      CC queue.os
      CC register.os
      CC syscall.os
      AR liburing.a
ar: creating liburing.a
      CC liburing.so.2.2
  RANLIB liburing.a
make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/src'
make[1]: Entering directory '/home/ammarfaizi2/app/liburing/test'
      CC helpers.o
      CC ../src/syscall.o
      CC 35fa71a030ca-test.test
      CC 232c93d07b74-test.test
      CC 500f9fbadef8-test.test
      CC 7ad0e4b2f83c-test.test
      CC 8a9973408177-test.test
      CC 917257daa0fe-test.test
      CC a0908ae19763-test.test
      CC a4c0b3decb33-test.test
      CC accept.test
      CC accept-link.test
      CC accept-reuse.test
      CC accept-test.test
      CC across-fork.test
      CC b19062a56726-test.test
      CC b5837bd5311d-test.test
      CC ce593a6c480a-test.test
      CC close-opath.test
      CC connect.test
      CC cq-full.test
      CC cq-overflow.test
      CC cq-peek-batch.test
      CC cq-ready.test
      CC cq-size.test
      CC d4ae271dfaae-test.test
      CC d77a67ed5f27-test.test
      CC defer.test
      CC double-poll-crash.test
      CC drop-submit.test
      CC eeed8b54e0df-test.test
      CC empty-eownerdead.test
      CC eventfd.test
      CC eventfd-disable.test
      CC eventfd-reg.test
      CC eventfd-ring.test
      CC exec-target.test
      CC exit-no-cleanup.test
      CC fadvise.test
      CC fallocate.test
      CC fc2a85cb02ef-test.test
      CC file-register.test
      CC files-exit-hang-poll.test
      CC files-exit-hang-timeout.test
      CC file-update.test
      CC file-verify.test
      CC fixed-buf-iter.test
      CC fixed-link.test
      CC fixed-reuse.test
      CC fpos.test
      CC fsync.test
      CC hardlink.test
      CC io-cancel.test
      CC iopoll.test
      CC io_uring_enter.test
      CC io_uring_register.test
      CC io_uring_setup.test
      CC lfs-openat.test
      CC lfs-openat-write.test
      CC link.test
      CC link_drain.test
      CC link-timeout.test
      CC madvise.test
      CC mkdir.test
      CC msg-ring.test
      CC multicqes_drain.test
      CC nop-all-sizes.test
      CC nop.test
      CC openat2.test
      CC open-close.test
      CC open-direct-link.test
      CC personality.test
      CC pipe-eof.test
      CC pipe-reuse.test
      CC poll.test
      CC poll-cancel.test
      CC poll-cancel-ton.test
      CC poll-link.test
      CC poll-many.test
      CC poll-mshot-update.test
      CC poll-ring.test
      CC poll-v-poll.test
      CC pollfree.test
      CC probe.test
      CC read-write.test
      CC recv-msgall.test
      CC recv-msgall-stream.test
      CC register-restrictions.test
      CC rename.test
      CC ring-leak2.test
      CC ring-leak.test
      CC rsrc_tags.test
      CC rw_merge_test.test
      CC self.test
      CC sendmsg_fs_cve.test
      CC send_recv.test
      CC send_recvmsg.test
      CC shared-wq.test
      CC short-read.test
      CC shutdown.test
      CC sigfd-deadlock.test
      CC socket-rw.test
      CC socket-rw-eagain.test
      CC socket-rw-offset.test
      CC splice.test
      CC sq-full.test
      CXX sq-full-cpp.test
      CC sqpoll-cancel-hang.test
      CC sqpoll-disable-exit.test
      CC sq-poll-dup.test
      CC sqpoll-exit-hang.test
      CC sq-poll-kthread.test
      CC sq-poll-share.test
      CC sqpoll-sleep.test
      CC sq-space_left.test
      CC stdout.test
      CC submit-link-fail.test
      CC submit-reuse.test
      CC symlink.test
      CC teardowns.test
      CC thread-exit.test
      CC timeout.test
      CC timeout-new.test
      CC timeout-overflow.test
      CC tty-write-dpoll.test
      CC unlink.test
      CC wakeup-hang.test
      CC skip-cqe.test
      CC statx.test
make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/test'
make[1]: Entering directory '/home/ammarfaizi2/app/liburing/examples'
      CC io_uring-cp
      CC io_uring-test
      CC ucontext-cp
      CC link-cp
make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/examples'
ammarfaizi2@integral2:~/app/liburing$

-- 
Ammar Faizi
