Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2324F5916A1
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 23:10:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233675AbiHLVJd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 17:09:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233151AbiHLVJD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 17:09:03 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C1EB56E6
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:09:02 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id y1so1757558plb.2
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:09:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=Jwz0ra0IgsfyOkSaBYAxzVQFXGlau9hv/50WxXxTPD4=;
        b=NLnu9/l2B5eNE0YawK4fbxIpfSw/8MDPgvhNlXSmT53NxWM6O1mOlGZdvOg0Lmspm+
         tgCaMHkqSRAqGDnjvxhuSAIutOOkc/+Xafhtp9HEnlxD7B5dDC8jEDtR3CWzfT2p41ap
         GimANrR49w51ErW7klaRuQDTWKUiucuJQF4/XJJj0+LwGQ9lbGCLaU99/Vwlezk+Fc/6
         ADPR0WnFpoKdjgZQWNUuDSKv6NKwddZpdHuyZb0aX/1dkMri+Qu7P3KVFCiZtbGGZzsn
         rxSaNZI0ZmJAlDnALxUejgFC89q3tiTngMNfwkuiJRPNfxUIqkMDLBnRVSDnzyqxwpdU
         aQVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=Jwz0ra0IgsfyOkSaBYAxzVQFXGlau9hv/50WxXxTPD4=;
        b=45LqD9AqhDpRMBopcf0bLd8H2WtobVCtoj86C04pYWeKl2tzKi9PpkLAmVn52af6ce
         WyciZpqxLbDaeSF2BjwOW3rMGL7i8QgXlzHYXu4sHDZC5b9jzAPyJqxtOfqQ/1lQ1On0
         LeOaWDM1b15CCFkBkdB99OXTtIY3UMD1QqDBon8TYOeZ/9dah17yM7ifQkSOLinsH/QG
         PWprb1ONsgFt8kBYwbUBvn4nhZDt4QeN8Myw6y3lWogKo5hiF4vAsZWYZkzgvYTANQU3
         DcPdN6sprmd83NPoSKxPUvcc2QzooJ4d6QAUOSABuLKoH9Ayi+QZvRPub5YW8UBk8Fgr
         oc5w==
X-Gm-Message-State: ACgBeo0Mr1WKnH5UlFjTXLzWBEeF1OR6L/jrFz5/XX8aWVzJXBzyruea
        trCInjJo6mTklk3YLnyrom68RpNoiqTRZw==
X-Google-Smtp-Source: AA6agR5SOjtudhnh1Z9oFLUSD53s1FHaKVGnV037R1EYIGzwBHN8P/YGa98SlH2NelzPx6J3hdafzQ==
X-Received: by 2002:a17:90b:3d85:b0:1f7:6a32:3576 with SMTP id pq5-20020a17090b3d8500b001f76a323576mr15305825pjb.187.1660338541307;
        Fri, 12 Aug 2022 14:09:01 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id f8-20020a170902ce8800b001714853e503sm2252889plg.36.2022.08.12.14.09.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 14:09:00 -0700 (PDT)
Message-ID: <ca630c3c-80ad-ceff-61a9-63b253ba5dbd@kernel.dk>
Date:   Fri, 12 Aug 2022 15:08:59 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] io_uring fixes for 6.0-rc1
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <CAHk-=wioqj4HUQM_dXdVoSJtPe+z0KxNrJPg0cs_R3j-gJJxAg@mail.gmail.com>
 <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
 <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
In-Reply-To: <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/22 3:01 PM, Jens Axboe wrote:
> On 8/12/22 2:44 PM, Jens Axboe wrote:
>> On Aug 12, 2022, at 2:28 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>>
>>> ?On Fri, Aug 12, 2022 at 5:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>>
>>>> - Small series improving type safety of the sqe fields (Stefan)
>>>
>>> This doesn't work AT ALL.
>>>
>>> A basic allmodconfig build fails with tons of errors. It starts with
>>>
>>>  In function ?io_kiocb_cmd_sz_check?,
>>>      inlined from ?io_prep_rw? at io_uring/rw.c:38:21:
>>>  ././include/linux/compiler_types.h:354:45: error: call to
>>> ?__compiletime_assert_802? declared with attribute error: BUILD_BUG_ON
>>> failed: cmd_sz > sizeof(struct io_cmd_data)
>>>    354 |         _compiletime_assert(condition, msg,
>>> __compiletime_assert_, __COUNTER__)
>>>        |                                             ^
>>>  ././include/linux/compiler_types.h:335:25: note: in definition of
>>> macro ?__compiletime_assert?
>>>    335 |                         prefix ## suffix();
>>>           \
>>>        |                         ^~~~~~
>>>  ././include/linux/compiler_types.h:354:9: note: in expansion of
>>> macro ?_compiletime_assert?
>>>    354 |         _compiletime_assert(condition, msg,
>>> __compiletime_assert_, __COUNTER__)
>>>        |         ^~~~~~~~~~~~~~~~~~~
>>>  ./include/linux/build_bug.h:39:37: note: in expansion of macro
>>> ?compiletime_assert?
>>>     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>>>        |                                     ^~~~~~~~~~~~~~~~~~
>>>  ./include/linux/build_bug.h:50:9: note: in expansion of macro
>>> ?BUILD_BUG_ON_MSG?
>>>     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: "
>>> #condition)
>>>        |         ^~~~~~~~~~~~~~~~
>>>  ./include/linux/io_uring_types.h:496:9: note: in expansion of macro
>>> ?BUILD_BUG_ON?
>>>    496 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
>>>        |         ^~~~~~~~~~~~
>>>
>>> and goes downhill from there.
>>>
>>> I don't think this can have seen any testing at all.
>>
>> Wtf? I always run allmodconfig before sending and it also ran testing.
>> I?ll check shortly. Sorry about that, whatever went wrong here. 
> 
> My test box is still on the same sha from this morning, which is:
> 
> commit 2ae08b36c06ea8df73a79f6b80ff7964e006e9e3 (origin/master, origin/HEAD)
> Merge: 21f9c8a13bb2 8bb5e7f4dcd9
> Author: Linus Torvalds <torvalds@linux-foundation.org>
> Date:   Thu Aug 11 09:23:08 2022 -0700
> 
>     Merge tag 'input-for-v5.20-rc0' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input
> 
> with io_uring-6.0 (ff34d8d06a1f16b6a58fb41bfbaa475cc6c02497) and
> block-6.0 (aa0c680c3aa96a5f9f160d90dd95402ad578e2b0) pulled in, and it
> builds just fine for me:
> 
> axboe@r7525 ~/gi/build (test)> make clean                                    9.827s
>   HOSTCC  scripts/basic/fixdep
>   HOSTCC  scripts/kconfig/conf.o
>   HOSTCC  scripts/kconfig/confdata.o
>   HOSTCC  scripts/kconfig/expr.o
>   LEX     scripts/kconfig/lexer.lex.c
>   YACC    scripts/kconfig/parser.tab.[ch]
>   HOSTCC  scripts/kconfig/lexer.lex.o
>   HOSTCC  scripts/kconfig/menu.o
>   HOSTCC  scripts/kconfig/parser.tab.o
>   HOSTCC  scripts/kconfig/preprocess.o
>   HOSTCC  scripts/kconfig/symbol.o
>   HOSTCC  scripts/kconfig/util.o
>   HOSTLD  scripts/kconfig/conf
> #
> # No change to .config
> #
> axboe@r7525 ~/gi/build (test)> time make -j256 -s
> 
> ________________________________________________________
> Executed in  172.67 secs    fish           external
>    usr time  516.61 mins  396.00 micros  516.61 mins
>    sys time   44.40 mins    0.00 micros   44.40 mins
> 
> using:
> 
> axboe@r7525 ~/gi/build (test)> gcc --version
> gcc (Debian 12.1.0-7) 12.1.0
> 
> Puzzled, I'll keep poking...

I re-did an allmodconfig, and also built on arm64, and I have to say I'm
puzzled with what you are seeing. Updated to latest master as well,
nothing. Furthermore, I have the build bot send me successful build
notifications as well, not just the errors, and here's what it reported
12h ago:

tree/branch: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git io_uring-6.0
branch HEAD: ff34d8d06a1f16b6a58fb41bfbaa475cc6c02497  io_uring: add missing BUILD_BUG_ON() checks for new io_uring_sqe fields

elapsed time: 882m

configs tested: 53
configs skipped: 2

The following configs have been built successfully.
More configs may be tested in the coming days.

gcc tested configs:
um                           x86_64_defconfig
um                             i386_defconfig
i386                                defconfig
i386                          randconfig-a014
i386                          randconfig-a012
i386                          randconfig-a016
x86_64                        randconfig-a013
x86_64                        randconfig-a011
arc                  randconfig-r043-20220811
arm                                 defconfig
x86_64                        randconfig-a015
m68k                             allmodconfig
arc                              allyesconfig
i386                             allyesconfig
i386                          randconfig-a001
x86_64                          rhel-8.3-func
i386                          randconfig-a003
x86_64                              defconfig
alpha                            allyesconfig
mips                             allyesconfig
arm                              allyesconfig
x86_64                         rhel-8.3-kunit
m68k                             allyesconfig
powerpc                           allnoconfig
arm64                            allyesconfig
i386                          randconfig-a005
x86_64                               rhel-8.3
sh                               allmodconfig
x86_64                           rhel-8.3-kvm
x86_64                           allyesconfig
x86_64                    rhel-8.3-kselftests
x86_64                           rhel-8.3-syz
x86_64                        randconfig-a002
x86_64                        randconfig-a004
x86_64                        randconfig-a006
ia64                             allmodconfig
powerpc                          allmodconfig

clang tested configs:
i386                          randconfig-a011
i386                          randconfig-a013
hexagon              randconfig-r045-20220811
hexagon              randconfig-r041-20220811
x86_64                        randconfig-a012
s390                 randconfig-r044-20220811
i386                          randconfig-a015
riscv                randconfig-r042-20220811
x86_64                        randconfig-a014
x86_64                        randconfig-a016
i386                          randconfig-a002
i386                          randconfig-a006
i386                          randconfig-a004
x86_64                        randconfig-a001
x86_64                        randconfig-a003
x86_64                        randconfig-a005

building that very same sha I sent you. WTF? I assure you this thing has
been both built, and not just by me, and runtime tested as per usual.
Why it fails on your end, I really have no good clue right now.


-- 
Jens Axboe

