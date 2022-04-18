Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA9C0505BC1
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 17:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345837AbiDRPtb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 11:49:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345796AbiDRPtW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 11:49:22 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EB533D1D6
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 08:24:00 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id d4so8717567iln.6
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 08:24:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=8Iqyww9DEAjB3MOyihAAT+JyYCPpbthvKoltZeSNRvY=;
        b=nMGP++WlkRp99/ZjYg8u+sOuqyVU1QHCB0jlQzUD9THnztmbZpLnmVLti2V/OlV10p
         sxeUE+l3dDxxK/AnBxpMmTMf5hKWC2yWqnSpKmKO7Q7di1vHGurnQ23+U73Iacw1O7M8
         pGNdG6GCwLTxl8yhUSDpP4kiP+luwNLv+LsaAUxBN3EkRzNk3T7fzRc5KxFdUlEa0TN3
         cCypOF25q2kDEd7kNyV3Yz/QP6ptQyf//L4k/DCW+PmKBmap8BT6EBqS0i54UBeG1gvi
         0yya9i0ERbJJ5DwdAejx0us4M283u1aMRCeN6lItyo6JaBPEw2h8nZ/HpOqJcmCU1bQg
         9L6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=8Iqyww9DEAjB3MOyihAAT+JyYCPpbthvKoltZeSNRvY=;
        b=ZvDcBnQHOqIwrS6WgBsYkMXBqMd4dLn209KPJR7sHjadSpsKJCghZenYyFO3dbiVfr
         SPdCaZ4XPqjdXZCTRptJ4BL7eIvE1cmuAoQ2A1w2x/51sT1agRb/dYrw7O1h+/t3LmwH
         dqUVWnttRM3dQNqYtasO6NqCOuJafePWiph7D792sr+KbgG9xLJRxa7vVI2UO/NKh8j8
         QAxLk2BqIekysaKHXOPbS2nWXN0dcXMjPfGmC1bskzTJip4eGcukq02qt/teiyzklySX
         X6CggwscMaYTWCsPsHOiH6QVJA18fKTuMq2s+rm3mU5fE9rvSTrvKFLjX802LsSyBvRS
         Mztw==
X-Gm-Message-State: AOAM531f8CzsfDJwNJGYST3HLpyL3qS/QomMsnPfZTd5VzrtN6vRss7T
        5OedtvGjx3H6WVUahhnQJiR9/Q==
X-Google-Smtp-Source: ABdhPJzc3MYBXf0nS9rSsOhkX2uF3P8CgB4ABhopWCSjnRflFnucUE7kG8V469ZIv6jQI+rgjRFrFA==
X-Received: by 2002:a92:ca06:0:b0:2cc:3a47:e5d with SMTP id j6-20020a92ca06000000b002cc3a470e5dmr909372ils.115.1650295439766;
        Mon, 18 Apr 2022 08:23:59 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id p66-20020a6bbf45000000b006499925f1f1sm8483460iof.19.2022.04.18.08.23.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Apr 2022 08:23:58 -0700 (PDT)
Message-ID: <f11ffb5a-7a08-13a9-6f0a-f14f2937bf15@kernel.dk>
Date:   Mon, 18 Apr 2022 09:23:57 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH liburing 0/3] Add x86 32-bit support for the nolibc build
Content-Language: en-US
To:     Ammar Faizi <ammarfaizi2@gnuweeb.org>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
References: <20220414224001.187778-1-ammar.faizi@intel.com>
 <459a2922-55cd-aec1-f4f2-bf037844017f@kernel.dk>
 <d861f90d-1c66-73c8-3e66-f656275dbd08@gnuweeb.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <d861f90d-1c66-73c8-3e66-f656275dbd08@gnuweeb.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/22 8:14 AM, Ammar Faizi wrote:
> On 4/18/22 9:01 AM, Jens Axboe wrote:
>> On 4/14/22 4:41 PM, Ammar Faizi wrote:
>>> Hi,
>>>
>>> This series adds nolibc support for x86 32-bit. There are 3 patches in
>>> this series:
>>>
>>> 1) Use `__NR_mmap2` instead of `__NR_mmap` for x86 32-bit.
>>> 2) Provide `get_page_size()` function for x86 32-bit.
>>> 3) Add x86 32-bit native syscall support.
>>>
>>> The most noticeable changes is the patch 3. Unlike x86-64, only
>>> use native syscall from the __do_syscall macros when CONFIG_NOLIBC is
>>> enabled for 32-bit build. The reason is because the libc syscall
>>> wrapper can do better in 32-bit. The libc syscall wrapper can dispatch
>>> the best syscall instruction that the environment is supported, there
>>> are at least two variants syscall instruction for x86 32-bit, they are:
>>> `int $0x80` and `sysenter`. The `int $0x80` instruction is always
>>> available, but `sysenter` is not, it relies on VDSO. liburing always
>>> uses `int $0x80` for syscall if it's compiled with CONFIG_NOLIBC,
>>> otherwise it uses whatever the libc provides.
>>>
>>> Extra notes for __do_syscall6() macro:
>>> On i386, the 6th argument of syscall goes in %ebp. However, both Clang
>>> and GCC cannot use %ebp in the clobber list and in the "r" constraint
>>> without using -fomit-frame-pointer. To make it always available for
>>> any kind of compilation, the below workaround is implemented:
>>>
>>>    1) Push the 6-th argument.
>>>    2) Push %ebp.
>>>    3) Load the 6-th argument from 4(%esp) to %ebp.
>>>    4) Do the syscall (int $0x80).
>>>    5) Pop %ebp (restore the old value of %ebp).
>>>    6) Add %esp by 4 (undo the stack pointer).
>>>
>>> WARNING:
>>>    Don't use register variables for __do_syscall6(), there is a known
>>>    GCC bug that results in an endless loop.
>>>
>>> BugLink: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105032
>>>
>>>
>>> ===== How is this tested? =====
>>>
>>> This has been tested on x86-64 Linux (compiled with 32-bit bin support)
>>> with the following commands:
>>>
>>>    sudo apt-get install gcc-i686-linux-gnu g++-i686-linux-gnu -y;
>>>    ./configure --cc=i686-linux-gnu-gcc --cxx=i686-linux-gnu-g++ --nolibc;
>>>    sudo make -j8 runtests;
>>
>> Looks reasonable to me, even with the warts. I keep threatening to do a
>> 2.2 release, and I do want to do that soon, so question is if we defer
>> this patchset until after that has happened?
>>
>> I'm looking for a gauge of confidence on the series.
> 
> I personally love not to defer this patchset. I understand that if we
> were adding something like this to the Linux kernel, it's pretty sure
> that it is not acceptable time. But liburing.
> 
> Several things that you may want to consider:
> 
> 1) Previously, `--nolibc` build on x86 32-bit will throw a compile
>    error, "Arch doesn't support building liburing without libc".
>    After this patchset, it compiles just fine.
> 
> 2) This series doesn't have any effect for x86 32-bit that uses libc,
>    and that is what we do by default.
> 
> 3) I believe x86 32-bit users are not that many. So having this one
>    earlier gives sometime to get it mature without much chaos (if
>    we ever found a bug).
> 
>    Not to say it's buggy. But younger code tend to be buggier. If we
>    ever hit that bug due to this patchset, some of them may fallback
>    to the libc build while waiting for the next stable liburing.
> 
> But anyway, I don't think it's that urgent seeing that we don't have
> visible users that are actively using nolibc x86 32-bit. So if you
> prefer to defer this, please defer it. What do you think?

All good points, let's just get it done.

-- 
Jens Axboe

