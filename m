Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 225516939B3
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 20:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229518AbjBLTmV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 14:42:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjBLTmU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 14:42:20 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 120E1EB58
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 11:42:19 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id be8so11515400plb.7
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 11:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AKhMBaS8kYGegar9613Zk+BHj3ORXxann8uCTTlDauI=;
        b=idgLqzPQXalDMQ46PRM/l/lUyMvnVISwm++dlYQ1fUORIIZ1qStIzeVuw2A+T6ui+x
         C3LRISSbOrJ/cpPZjF+7P+GTD5oqIFfsCP1sMrnAMSn9zBEIsmcoArhYC/kt+gz47XL2
         d4hZTuX3d8NOoKxiaf9XGCurVqEepyKUbKTWY7NCcfCPDxL//YQIsCy2l1EPFHNKC7Oi
         7G3SoBMRYc5h4gkNdv+CFbJTD6znphxVfHD8jhSjjbTgYeQ8mfsnbUwCRWCNddr4ko69
         jUXCumSles8byLn6Qk4CDPXI/8VuaQtjVSNARCpIlkgYWBe5/E/F8Hq0qG46R8Ht6ZKs
         wxUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AKhMBaS8kYGegar9613Zk+BHj3ORXxann8uCTTlDauI=;
        b=cDUWCVTE1R3tBpk050EmTjhsNYZ2qpFJ0JNkUcIAHX8X4mgPZIDDkQFlAt+dDophai
         qT/7YvsqNa8obAPEDhdrVGrgbu3uGl5EaTEl05ztvELmNDIAy7xqbVIyyLUqkEfcvjG+
         I06NjgRQ6ubBUY3oDKI0nXRX4ij0As041iT1m9AUjsQIE1s20djbmc9CsqCPjN+gRp3L
         w0bVT9ZLIRydMTqUy5bdLzyZiWVaE6XVDbx0JWiA6rqOxN8ZE0VzepFHn8wRTVDVjKoF
         ODiZ2prWmcJGgeAMXUtEZ3Kc8w7iGqp4FcuXEiXeKGbW8ajYK7DUf6I47pX9xsZttX8P
         3YaA==
X-Gm-Message-State: AO0yUKWr81fqGpyhpOwghpbJiUQXL2+EWdFDTTc0CJhLs7vm3zNF3K2E
        ZfaSRf4tszrHCMOf9KwpU6iS4A==
X-Google-Smtp-Source: AK7set81TOTHqNOmdvMhdIZy57YyWt5QQ+5nnd8Lm9k7VdlpgAn/SPmMvYOsQTY8rn31/WskXAgqfw==
X-Received: by 2002:a17:903:230c:b0:193:1203:6e3f with SMTP id d12-20020a170903230c00b0019312036e3fmr24009032plh.3.1676230938434;
        Sun, 12 Feb 2023 11:42:18 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p11-20020a170902a40b00b0019460ac7c6asm6627406plq.283.2023.02.12.11.42.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 11:42:17 -0800 (PST)
Message-ID: <0b1946e4-1678-b442-695e-84443e7f2a86@kernel.dk>
Date:   Sun, 12 Feb 2023 12:42:16 -0700
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
 <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
 <4a9a986b-b0f9-8dad-1fc1-a00ea8723914@gmx.de>
 <835f9206-f404-0402-35fe-549d2017ec62@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <835f9206-f404-0402-35fe-549d2017ec62@gmx.de>
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

On 2/12/23 12:35?PM, Helge Deller wrote:
> On 2/12/23 15:03, Helge Deller wrote:
>> On 2/12/23 14:35, Jens Axboe wrote:
>>> On 2/12/23 6:28?AM, Helge Deller wrote:
>>>> On 2/12/23 14:16, Jens Axboe wrote:
>>>>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>>>>> Hi all,
>>>>>>
>>>>>> We see io-uring failures on the parisc architecture with this testcase:
>>>>>> https://github.com/axboe/liburing/blob/master/examples/io_uring-test.c
>>>>>>
>>>>>> parisc is always big-endian 32-bit userspace, with either 32- or 64-bit kernel.
>>>>>>
>>>>>> On a 64-bit kernel (6.1.11):
>>>>>> deller@parisc:~$ ./io_uring-test test.file
>>>>>> ret=0, wanted 4096
>>>>>> Submitted=4, completed=1, bytes=0
>>>>>> -> failure
>>>>>>
>>>>>> strace shows:
>>>>>> io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf7522000
>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf6922000
>>>>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRECT) = 4
>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=689308, ...}) = 0
>>>>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) = 4
>>>>>> brk(NULL)                               = 0x4ae000
>>>>>> brk(0x4cf000)                           = 0x4cf000
>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     = 0
>>>>>>
>>>>>>
>>>>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>>>>> root@debian:~# ./io_uring-test test.file
>>>>>> Submitted=4, completed=4, bytes=16384
>>>>>> -> ok.
>>>>>>
>>>>>> strace:
>>>>>> io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf6d4c000
>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf694c000
>>>>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) = 4
>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=1855488, ...}) = 0
>>>>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) = 4
>>>>>> brk(NULL)                               = 0x15000
>>>>>> brk(0x36000)                            = 0x36000
>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     = 4
>>>>>>
>>>>>> I'm happy to test any patch if someone has an idea....
>>>>>
>>>>> No idea what this could be, to be honest. I tried your qemu vm image,
>>>>> and it does boot, but it's missing keys to be able to update apt and
>>>>> install packages... After fiddling with this for 30 min I gave up, any
>>>>> chance you can update the sid image? Given how slow this thing is
>>>>> running, it'd take me all day to do a fresh install and I have to admit
>>>>> I'm not THAT motivated about parisc to do that :)
>>>>
>>>> Yes, I will update that image, but qemu currently only supports a
>>>> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So even if I
>>>> update it, you won't be able to reproduce it, as it only happens with
>>>> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64bit
>>>> translation in the kernel, which triggers only big-endian machines.
>>>
>>> I built my own kernel for it, so that should be fine, correct?
>>
>> No, as qemu won't boot the 64-bit kernel.
>>
>>> We'll see soon enough, managed to disable enough checks on the
>>> debian-10 image to actually make it install packages.
>>>
>>>> Does powerpc with a 64-bit ppc64 kernel work?
>>>> I'd assume it will show the same issue.
>>>
>>> No idea... Only stuff I use and test on is x86-64/32 and arm64.
>>
>> Would be interesting if someone could test...
>>
>>>> I will try to add some printks and compare the output of 32- and
>>>> 64-bit kernels. If you have some suggestion where to add such (which?)
>>>> debug code, it would help me a lot.
>>>
>>> I'd just try:
>>>
>>> echo 1 > /sys/kernel/debug/tracing/events/io_uring
>>
>> I'll try, but will take some time...
>>
> 
> At entry of io_submit_sqes(), io_sqring_entries() returns 0, because
> ctx->rings->sq.tail is 0 (wrongly on broken 64-bit, but ok value 4 on 32-bit), and
> ctx->cached_sq_head is 0 in both cases.

cached_sq_head will get updated as sqes are consumed, but since sq.tail
is zero, there's nothing to submit as far as io_uring is concerned.

Can you dump addresses/offsets of the sq and cq heads/tails in userspace
and in the kernel? They are u32, so same size of 32 and 64-bit.

-- 
Jens Axboe

