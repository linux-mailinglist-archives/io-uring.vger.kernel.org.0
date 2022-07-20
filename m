Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4E96F57C0CE
	for <lists+io-uring@lfdr.de>; Thu, 21 Jul 2022 01:22:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiGTXV7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Jul 2022 19:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231918AbiGTXVx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Jul 2022 19:21:53 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCD007437C;
        Wed, 20 Jul 2022 16:21:39 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.97.11])
        by gnuweeb.org (Postfix) with ESMTPSA id 3A88E7E317;
        Wed, 20 Jul 2022 23:21:37 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658359299;
        bh=sWVuj0qahdrEIm9D7naDXpYUsd8yvFnG5YezMfbrd3o=;
        h=Date:To:Cc:From:Subject:From;
        b=MPIgyDhTtlMgL1qNNvrv3TDLMsr4mkC22n6kgjosRKJiSYLIBpBpaA3vDDkHzHCQ2
         BbtrHTDAqaKceBctn16MImETeNTKrTpAFmOwb6w9pgOPae/kWu3aEK6wkdjyj8zhdD
         4jkgGlYmqtv8Mv8c5wleMQjjC2zveLTYNio1HQLUrTzlfXiY35lKhC9aRVj4IBKvij
         EebDKiKjzDuw8bNrTcXaDc91J9I81Xh+9QctTNmarMXUovF9B/8onlK94WY7PJtNFe
         3mlqyzh9lQV/N5WqHtFX6zambFENs4mTqqkI7qlO7GTPHvPrTogjke3jFL9EklTQqZ
         F+6Q0uJ1PDJ9w==
Message-ID: <2709ed98-6459-70ea-50d4-f24b7278fb24@gnuweeb.org>
Date:   Thu, 21 Jul 2022 06:21:24 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Pavel Begunkov <asml.silence@gmail.com>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Linux 5.19-rc7 liburing test `poll-mshot-overflow.t` and
 `read-write.t` fail
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello Jens,

Kernel version:

   commit ff6992735ade75aae3e35d16b17da1008d753d28
   Author: Linus Torvalds <torvalds@linux-foundation.org>
   Date:   Sun Jul 17 13:30:22 2022 -0700

       Linux 5.19-rc7

liburing version:

   commit 4e6eec8bdea906fe5341c97aef96986d605004e9 (HEAD, origin/master, origin/HEAD)
   Author: Dylan Yudaken <dylany@fb.com>
   Date:   Mon Jul 18 06:34:29 2022 -0700

       fix io_uring_recvmsg_cmsg_nexthdr logic
       
       io_uring_recvmsg_cmsg_nexthdr was using the payload to delineate the end
       of the cmsg list, but really it needs to use whatever was returned by the
       kernel.
       
       Reported-and-tested-by: Jens Axboe <axboe@kernel.dk>
       Fixes: 874406f7fb09 ("add multishot recvmsg API")
       Signed-off-by: Dylan Yudaken <dylany@fb.com>
       Link: https://lore.kernel.org/r/20220718133429.726628-1-dylany@fb.com
       Signed-off-by: Jens Axboe <axboe@kernel.dk>

Two liburing tests fail:

   Tests failed:  <poll-mshot-overflow.t> <read-write.t>
   make[1]: *** [Makefile:237: runtests] Error 1
   make[1]: Leaving directory '/home/ammarfaizi2/app/liburing/test'
   make: *** [Makefile:21: runtests] Error 2


   ammarfaizi2@integral2:~/app/liburing$ uname -a
   Linux integral2 5.19.0-rc7-2022-07-18 #1 SMP PREEMPT_DYNAMIC Mon Jul 18 15:42:27 WIB 2022 x86_64 x86_64 x86_64 GNU/Linux
   ammarfaizi2@integral2:~/app/liburing$ test/read-write.t
   cqe res -22, wanted 8192
   test_buf_select vec failed
   ammarfaizi2@integral2:~/app/liburing$ test/poll-mshot-overflow.t
   signalled no more!
   ammarfaizi2@integral2:~/app/liburing$

JFYI, -22 is -EINVAL.

read-write.t call trace when calling fprintf(..., "cqe res %d, wanted %d\n", ...):

   #0  ___fprintf_chk (./debug/fprintf_chk.c:25)
   #1  fprintf (/usr/include/x86_64-linux-gnu/bits/stdio2.h:105)
   #2  __test_io (read-write.c:181)
   #3  test_buf_select (read-write.c:577)
   #4  main (read-write.c:849)

poll-mshot-overflow.t call trace should be trivial.

-- 
Ammar Faizi

