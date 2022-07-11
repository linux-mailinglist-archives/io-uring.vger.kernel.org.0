Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB3D256FD04
	for <lists+io-uring@lfdr.de>; Mon, 11 Jul 2022 11:50:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbiGKJtv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 11 Jul 2022 05:49:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233815AbiGKJtS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 11 Jul 2022 05:49:18 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18569AC058
        for <io-uring@vger.kernel.org>; Mon, 11 Jul 2022 02:24:05 -0700 (PDT)
Received: from [192.168.88.254] (unknown [36.81.65.188])
        by gnuweeb.org (Postfix) with ESMTPSA id 39AF47E24B;
        Mon, 11 Jul 2022 09:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1657531444;
        bh=ajvO0ZUqObfgCQT9WhOjP3JgTDd+tJDCG3E5yZ1wnlY=;
        h=Date:To:Cc:From:Subject:From;
        b=REEEBFcPkFEqy5FZYC8Pd8pkc5hP38fNlr/BmMWvLvOEjcfYslo/DxMjuw77X0G3c
         mhbS1MxRKsEDVkHBmvcQnr17Xhsn4hSU59EAIVE9vF8+xvgRoGmwfNzyA9ALifYl3U
         1n8mXEqcSx9NzTeQSRC4L6iwilA36kGV0i69iRnJzpOxYfEioVrT4i5sJ7DMyqohP6
         DswL6lpiVApPZBdwUwQLIPQwMxOEhwFBb5Q90W5wsY1+tHm5z5Mov+8mQsrqHpDmCZ
         fAc2iazO6FCTPlet7197LslUgQZKeRBLwk7FmL1GpjaTw5z5wJPIarm7+mVY/MSiCh
         J5k+Gy9K6z10g==
Message-ID: <45d0409e-e112-a0e9-7007-9db34d53a43f@gnuweeb.org>
Date:   Mon, 11 Jul 2022 16:23:56 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Hao Xu <howeyxu@tencent.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Fernanda Ma'rouf <fernandafmr12@gnuweeb.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [RFC liburing for-2.3] Kill src/syscall.c
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


Hi Jens,

I haven't written any patch, but I want to get your comments first.
If you think it's a good idea, I will wire up a patch.

## Background story:

Since we support nolibc, the file src/syscall.c is no longer used by
any liburing internal functions. It's only used by `test/`.

Other architectures that still depend on libc are now using:

     src/generic/syscall.h

*not*:

     src/syscall.c

I should have killed src/syscall.c and fixed the tests earlier when
adding nolibc support, unfortunately, I didn't. I was mistaken that
if we killed src/syscall.c, it might break user. But no, no user uses
it.

We don't actually intend to export __sys_io_uring* functions to user.
This situation is reflected in liburing.map and liburing.h which don't
have those functions.

## Proposal:

Let's just kill src/syscall.c and use __sys_io_uring* or
____sys_io_uring* only.


## Two choices:

1. Keep using ____sys_io_uring* functions and delete __sys_io_uring*
    functions.

2. Back to use __sys_io_uring* functions and delete ____sys_io_uring*.

Both choices need to fix tests. I can do that. I personally like the
second choice since we don't have many underscores.

What do you think?

-- 
Ammar Faizi

