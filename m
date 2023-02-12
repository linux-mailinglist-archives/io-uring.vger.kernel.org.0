Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7036769379C
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 14:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229551AbjBLNfc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 08:35:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBLNfb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 08:35:31 -0500
Received: from mail-pl1-x634.google.com (mail-pl1-x634.google.com [IPv6:2607:f8b0:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F4413D61
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 05:35:03 -0800 (PST)
Received: by mail-pl1-x634.google.com with SMTP id v23so11081799plo.1
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 05:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wYbL+BDte6q8tCYmOYRXu9pa1omQH3YD7sLUPhpL9W4=;
        b=E9lE8QF4dBVBUSBu9B5jIwnBQzZKHn6P+Aan3I6UYfF9oLaibP7qAgFqt6HWHSO0j1
         rPi05qt4S+ZoEP6xrQb51FzNoWgo7zqpTYcPHI/PR6XkDaT7330l4CAmMK20z5RWSsqs
         AE2/nMooLsVJ6lLzk2Z+JJOSzvh4ApICW8NiqBjeMztWCfVx08pmaTc1xBZa2KTF8dZg
         Mn/Uy2GelpbSyrUot+eJAQnYuNtNeoFY5gatde3gDNmLpcVHGHwP4WTb8n8vPOTEvND8
         KDbbvP8nl8jMueC1f9KToxjB5XltRgMu2/dC68IEc1tpY++pRu3yzIRUe8sZRlYeZ+W0
         9HlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wYbL+BDte6q8tCYmOYRXu9pa1omQH3YD7sLUPhpL9W4=;
        b=mfF3hZ7PUTpvcLX2XhPyGONvMt8J8H4iXwixwR+hn/p/LQoGS5KACMraz0uPUncqfO
         PcvNFsVKk0KOR2SlRyvXV5eEYlZqHo8LoUIqxSsgLPs5YkO5XGIm3b1Lku6E+QfrqyDu
         Lry+XiXZbeL8+3uC4CyDkMYmWyFMDH/YtEdjutGtSO8KSMd7j/Tm6e1oMBk73eZ+VaIZ
         aDFk2dNQA3tLAW8Weh8xfafX5RoeaOpgNJS0NqZ368AHPQK82zuLTwjKL9smcevwpBhU
         E7iHI4EUzs7+YKBek9QA5scShlBCnuirZQSx8mjlbHu6S4YR+d8O8XDOuMawziwmz/7O
         h7NA==
X-Gm-Message-State: AO0yUKVq1j8RT5Wavlu4eceIkQj1jDfJjw2B55ATJjLC9fFSJ71j83AH
        T6KcY1vosctz1BlQpmFQ2HCcIw==
X-Google-Smtp-Source: AK7set+NmLHnC2LgXUoh0RS6cQbv8g5jbXxxQfajv8H/rBA49mRAuUCuSknnNnIrWD3AjYS4uYzYTQ==
X-Received: by 2002:a17:903:230c:b0:193:1203:6e3f with SMTP id d12-20020a170903230c00b0019312036e3fmr23051066plh.3.1676208902753;
        Sun, 12 Feb 2023 05:35:02 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p16-20020a1709028a9000b00196807b5189sm6343431plo.292.2023.02.12.05.35.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 05:35:02 -0800 (PST)
Message-ID: <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
Date:   Sun, 12 Feb 2023 06:35:01 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc (32-bit userspace and 64-bit kernel)
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <216beccc-8ce7-82a2-80ba-1befa7b3bc91@gmx.de>
 <159bfaee-cba0-7fba-2116-2af1a529603c@kernel.dk>
 <c1581c21-631d-94dd-1c0d-822fb9f19cd1@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <c1581c21-631d-94dd-1c0d-822fb9f19cd1@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/23 6:28?AM, Helge Deller wrote:
> On 2/12/23 14:16, Jens Axboe wrote:
>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>> Hi all,
>>>
>>> We see io-uring failures on the parisc architecture with this testcase:
>>> https://github.com/axboe/liburing/blob/master/examples/io_uring-test.c
>>>
>>> parisc is always big-endian 32-bit userspace, with either 32- or 64-bit kernel.
>>>
>>> On a 64-bit kernel (6.1.11):
>>> deller@parisc:~$ ./io_uring-test test.file
>>> ret=0, wanted 4096
>>> Submitted=4, completed=1, bytes=0
>>> -> failure
>>>
>>> strace shows:
>>> io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf7522000
>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf6922000
>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRECT) = 4
>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=689308, ...}) = 0
>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) = 4
>>> brk(NULL)                               = 0x4ae000
>>> brk(0x4cf000)                           = 0x4cf000
>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     = 0
>>>
>>>
>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>> root@debian:~# ./io_uring-test test.file
>>> Submitted=4, completed=4, bytes=16384
>>> -> ok.
>>>
>>> strace:
>>> io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf6d4c000
>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf694c000
>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) = 4
>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=1855488, ...}) = 0
>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) = 4
>>> brk(NULL)                               = 0x15000
>>> brk(0x36000)                            = 0x36000
>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     = 4
>>>
>>> I'm happy to test any patch if someone has an idea....
>>
>> No idea what this could be, to be honest. I tried your qemu vm image,
>> and it does boot, but it's missing keys to be able to update apt and
>> install packages... After fiddling with this for 30 min I gave up, any
>> chance you can update the sid image? Given how slow this thing is
>> running, it'd take me all day to do a fresh install and I have to admit
>> I'm not THAT motivated about parisc to do that :)
> 
> Yes, I will update that image, but qemu currently only supports a
> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So even if I
> update it, you won't be able to reproduce it, as it only happens with
> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64bit
> translation in the kernel, which triggers only big-endian machines.

I built my own kernel for it, so that should be fine, correct? We'll see
soon enough, managed to disable enough checks on the debian-10 image to
actually make it install packages.

> Does powerpc with a 64-bit ppc64 kernel work?
> I'd assume it will show the same issue.

No idea... Only stuff I use and test on is x86-64/32 and arm64.

> I will try to add some printks and compare the output of 32- and
> 64-bit kernels. If you have some suggestion where to add such (which?)
> debug code, it would help me a lot.

I'd just try:

echo 1 > /sys/kernel/debug/tracing/events/io_uring

on both kernels and run that example. I do wonder if it's some O_DIRECT
thing, does the example work if you just remove O_DIRECT from the file
open?

-- 
Jens Axboe

