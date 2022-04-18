Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7DC505AC5
	for <lists+io-uring@lfdr.de>; Mon, 18 Apr 2022 17:15:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239446AbiDRPS0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 18 Apr 2022 11:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345455AbiDRPRk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 18 Apr 2022 11:17:40 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42C70C1C9F
        for <io-uring@vger.kernel.org>; Mon, 18 Apr 2022 07:14:36 -0700 (PDT)
Received: from [192.168.88.87] (unknown [36.80.217.41])
        by gnuweeb.org (Postfix) with ESMTPSA id C99E37E39F;
        Mon, 18 Apr 2022 14:14:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1650291276;
        bh=Gi4eTDMir+Qy7TGvwYXPLLPx6qwuVxNEo3rk4ARftJ8=;
        h=Date:To:Cc:References:From:Subject:In-Reply-To:From;
        b=DpEmZhs3cX/zAOwg9FhVu/9ZonPLgFtqFtC17/fCGLMmih0TiyfhY5EanhcUO3iOI
         LLCYGU8w+cjskAilrYfWbvyqovBGykJlqvPODJvL4it6V74buLAzXspMsZ596iqoe3
         VaZ/CnuDsnka14PIoDYEZDgxK6ZlFNOxRowPsFIIUZNIcMOD+q5j9V3HmcB4ipM8bQ
         vnsErId/VeGzf82w2VJ7strOqWdry5yHV/CWUy6k5t7Z9m9jD1Fvc9oAjfg6idQueP
         2+qym1/oe4K0AwDvRLRvwn0uBpuwSQ4XgokiQuA8Cl2iA9FE3vRlPSC8kjQjjD+H7J
         9VD+isFIF8N8w==
Message-ID: <d861f90d-1c66-73c8-3e66-f656275dbd08@gnuweeb.org>
Date:   Mon, 18 Apr 2022 21:14:20 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
References: <20220414224001.187778-1-ammar.faizi@intel.com>
 <459a2922-55cd-aec1-f4f2-bf037844017f@kernel.dk>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: Re: [PATCH liburing 0/3] Add x86 32-bit support for the nolibc build
In-Reply-To: <459a2922-55cd-aec1-f4f2-bf037844017f@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/18/22 9:01 AM, Jens Axboe wrote:
> On 4/14/22 4:41 PM, Ammar Faizi wrote:
>> Hi,
>>
>> This series adds nolibc support for x86 32-bit. There are 3 patches in
>> this series:
>>
>> 1) Use `__NR_mmap2` instead of `__NR_mmap` for x86 32-bit.
>> 2) Provide `get_page_size()` function for x86 32-bit.
>> 3) Add x86 32-bit native syscall support.
>>
>> The most noticeable changes is the patch 3. Unlike x86-64, only
>> use native syscall from the __do_syscall macros when CONFIG_NOLIBC is
>> enabled for 32-bit build. The reason is because the libc syscall
>> wrapper can do better in 32-bit. The libc syscall wrapper can dispatch
>> the best syscall instruction that the environment is supported, there
>> are at least two variants syscall instruction for x86 32-bit, they are:
>> `int $0x80` and `sysenter`. The `int $0x80` instruction is always
>> available, but `sysenter` is not, it relies on VDSO. liburing always
>> uses `int $0x80` for syscall if it's compiled with CONFIG_NOLIBC,
>> otherwise it uses whatever the libc provides.
>>
>> Extra notes for __do_syscall6() macro:
>> On i386, the 6th argument of syscall goes in %ebp. However, both Clang
>> and GCC cannot use %ebp in the clobber list and in the "r" constraint
>> without using -fomit-frame-pointer. To make it always available for
>> any kind of compilation, the below workaround is implemented:
>>
>>    1) Push the 6-th argument.
>>    2) Push %ebp.
>>    3) Load the 6-th argument from 4(%esp) to %ebp.
>>    4) Do the syscall (int $0x80).
>>    5) Pop %ebp (restore the old value of %ebp).
>>    6) Add %esp by 4 (undo the stack pointer).
>>
>> WARNING:
>>    Don't use register variables for __do_syscall6(), there is a known
>>    GCC bug that results in an endless loop.
>>
>> BugLink: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=105032
>>
>>
>> ===== How is this tested? =====
>>
>> This has been tested on x86-64 Linux (compiled with 32-bit bin support)
>> with the following commands:
>>
>>    sudo apt-get install gcc-i686-linux-gnu g++-i686-linux-gnu -y;
>>    ./configure --cc=i686-linux-gnu-gcc --cxx=i686-linux-gnu-g++ --nolibc;
>>    sudo make -j8 runtests;
> 
> Looks reasonable to me, even with the warts. I keep threatening to do a
> 2.2 release, and I do want to do that soon, so question is if we defer
> this patchset until after that has happened?
> 
> I'm looking for a gauge of confidence on the series.

I personally love not to defer this patchset. I understand that if we
were adding something like this to the Linux kernel, it's pretty sure
that it is not acceptable time. But liburing.

Several things that you may want to consider:

1) Previously, `--nolibc` build on x86 32-bit will throw a compile
    error, "Arch doesn't support building liburing without libc".
    After this patchset, it compiles just fine.

2) This series doesn't have any effect for x86 32-bit that uses libc,
    and that is what we do by default.

3) I believe x86 32-bit users are not that many. So having this one
    earlier gives sometime to get it mature without much chaos (if
    we ever found a bug).

    Not to say it's buggy. But younger code tend to be buggier. If we
    ever hit that bug due to this patchset, some of them may fallback
    to the libc build while waiting for the next stable liburing.

But anyway, I don't think it's that urgent seeing that we don't have
visible users that are actively using nolibc x86 32-bit. So if you
prefer to defer this, please defer it. What do you think?

-- 
Ammar Faizi
