Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 552D159168C
	for <lists+io-uring@lfdr.de>; Fri, 12 Aug 2022 23:02:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233653AbiHLVCC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Aug 2022 17:02:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232950AbiHLVCB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Aug 2022 17:02:01 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD7CEB2D99
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:01:59 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id 13so1709286plo.12
        for <io-uring@vger.kernel.org>; Fri, 12 Aug 2022 14:01:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc;
        bh=/dGi23gztXinQFG82CdStVX1Ptv58Il6HYvpfMqCA8Y=;
        b=WzKW48014zCmiwQ3+d2geiEmgHhd1C0DtjiTb91amdtoTZuHzxzAHhzs2aevfmUcXN
         ml3liKAt1ZgXu8XFLG6mWXB5Mspq5x0lHoBLETup5/lBVPwj+9sQqBEeSh4Ay1pTnlkO
         bKKl0R+CshF4nelqcPh7O4jK7BwjoEXtlZ+eb9y9+UF6eXdQRnoEllgnVcOmO1XP8PIZ
         B4EEhUsXDm5ni1Kbk22Z50YCaj0Xrqcd9MWwkPWyfqbjNVpX6AEZ8e4pmu4fhPZvnstS
         A5MIAk0xHtbuVbfuaoBwdSUL8UHg6TQTAjbxDvTMXSzhX6RR8RG4wCW2kBDn0aT1eRKH
         OyKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=/dGi23gztXinQFG82CdStVX1Ptv58Il6HYvpfMqCA8Y=;
        b=7QcLhFYG5lIJ+LEdrDk8gRx0xcOVv4J/HCy/1LGv4cEmAP0pQbo+3Nr7gk3U/ozI+U
         gz+ZTPCqV7IQa9D1ZBYUez5nizbm87wzDnxQ8DrHuIGP4QF8wVQteo0rnO9olxidBbra
         E9iwTUE6FA86wvlrVbElcV9pm3yFgEiqE80Q7geXEcNXDA/rBL1rjgrfp7kAS73RtS/z
         MkH51v+DsgniErvBuZccvc6rY40PBnzKUdaFubGR43JKpzANBHO8jj0xu2s7FDFSLFWl
         zaZ+xGEMbb+odaAfkhkBh9UhlykX466hPYZ0W/W3ooHjGY1qUWF7anPYWI65UOsacSrI
         wxgw==
X-Gm-Message-State: ACgBeo2P2GrCCmfIsqcnjTe4ek5XYgA3i40tzWfdC7cDfoJbJ3lVL91e
        rvoXlr4PHhooFcEea5vzyRVnpWI1l6trSg==
X-Google-Smtp-Source: AA6agR6MujfVhvR/MYbgN7vBrQMLYsdaroVmEYhqqdiW6hG+kYNd7/HaagZfYfhA+MvMa0zFHXuVCg==
X-Received: by 2002:a17:902:7c94:b0:170:aed6:7e6c with SMTP id y20-20020a1709027c9400b00170aed67e6cmr5584534pll.10.1660338119278;
        Fri, 12 Aug 2022 14:01:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902784a00b0015ee60ef65bsm2166081pln.260.2022.08.12.14.01.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Aug 2022 14:01:58 -0700 (PDT)
Message-ID: <6458eb59-554a-121b-d605-0b9755232818@kernel.dk>
Date:   Fri, 12 Aug 2022 15:01:57 -0600
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
In-Reply-To: <D92A7993-60C6-438C-AFA9-FA511646153C@kernel.dk>
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

On 8/12/22 2:44 PM, Jens Axboe wrote:
> On Aug 12, 2022, at 2:28 PM, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> ?On Fri, Aug 12, 2022 at 5:46 AM Jens Axboe <axboe@kernel.dk> wrote:
>>>
>>> - Small series improving type safety of the sqe fields (Stefan)
>>
>> This doesn't work AT ALL.
>>
>> A basic allmodconfig build fails with tons of errors. It starts with
>>
>>  In function ?io_kiocb_cmd_sz_check?,
>>      inlined from ?io_prep_rw? at io_uring/rw.c:38:21:
>>  ././include/linux/compiler_types.h:354:45: error: call to
>> ?__compiletime_assert_802? declared with attribute error: BUILD_BUG_ON
>> failed: cmd_sz > sizeof(struct io_cmd_data)
>>    354 |         _compiletime_assert(condition, msg,
>> __compiletime_assert_, __COUNTER__)
>>        |                                             ^
>>  ././include/linux/compiler_types.h:335:25: note: in definition of
>> macro ?__compiletime_assert?
>>    335 |                         prefix ## suffix();
>>           \
>>        |                         ^~~~~~
>>  ././include/linux/compiler_types.h:354:9: note: in expansion of
>> macro ?_compiletime_assert?
>>    354 |         _compiletime_assert(condition, msg,
>> __compiletime_assert_, __COUNTER__)
>>        |         ^~~~~~~~~~~~~~~~~~~
>>  ./include/linux/build_bug.h:39:37: note: in expansion of macro
>> ?compiletime_assert?
>>     39 | #define BUILD_BUG_ON_MSG(cond, msg) compiletime_assert(!(cond), msg)
>>        |                                     ^~~~~~~~~~~~~~~~~~
>>  ./include/linux/build_bug.h:50:9: note: in expansion of macro
>> ?BUILD_BUG_ON_MSG?
>>     50 |         BUILD_BUG_ON_MSG(condition, "BUILD_BUG_ON failed: "
>> #condition)
>>        |         ^~~~~~~~~~~~~~~~
>>  ./include/linux/io_uring_types.h:496:9: note: in expansion of macro
>> ?BUILD_BUG_ON?
>>    496 |         BUILD_BUG_ON(cmd_sz > sizeof(struct io_cmd_data));
>>        |         ^~~~~~~~~~~~
>>
>> and goes downhill from there.
>>
>> I don't think this can have seen any testing at all.
> 
> Wtf? I always run allmodconfig before sending and it also ran testing.
> I?ll check shortly. Sorry about that, whatever went wrong here. 

My test box is still on the same sha from this morning, which is:

commit 2ae08b36c06ea8df73a79f6b80ff7964e006e9e3 (origin/master, origin/HEAD)
Merge: 21f9c8a13bb2 8bb5e7f4dcd9
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu Aug 11 09:23:08 2022 -0700

    Merge tag 'input-for-v5.20-rc0' of git://git.kernel.org/pub/scm/linux/kernel/git/dtor/input

with io_uring-6.0 (ff34d8d06a1f16b6a58fb41bfbaa475cc6c02497) and
block-6.0 (aa0c680c3aa96a5f9f160d90dd95402ad578e2b0) pulled in, and it
builds just fine for me:

axboe@r7525 ~/gi/build (test)> make clean                                    9.827s
  HOSTCC  scripts/basic/fixdep
  HOSTCC  scripts/kconfig/conf.o
  HOSTCC  scripts/kconfig/confdata.o
  HOSTCC  scripts/kconfig/expr.o
  LEX     scripts/kconfig/lexer.lex.c
  YACC    scripts/kconfig/parser.tab.[ch]
  HOSTCC  scripts/kconfig/lexer.lex.o
  HOSTCC  scripts/kconfig/menu.o
  HOSTCC  scripts/kconfig/parser.tab.o
  HOSTCC  scripts/kconfig/preprocess.o
  HOSTCC  scripts/kconfig/symbol.o
  HOSTCC  scripts/kconfig/util.o
  HOSTLD  scripts/kconfig/conf
#
# No change to .config
#
axboe@r7525 ~/gi/build (test)> time make -j256 -s

________________________________________________________
Executed in  172.67 secs    fish           external
   usr time  516.61 mins  396.00 micros  516.61 mins
   sys time   44.40 mins    0.00 micros   44.40 mins

using:

axboe@r7525 ~/gi/build (test)> gcc --version
gcc (Debian 12.1.0-7) 12.1.0

Puzzled, I'll keep poking...

-- 
Jens Axboe

