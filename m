Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36BFB6937A9
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 15:01:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229568AbjBLOA7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 09:00:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbjBLOA7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 09:00:59 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 963B812862
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 06:00:56 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id e17so2239937plg.12
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 06:00:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ST9TYYAcZZmj+NX7ZF0UTgwailRauMHsfBUD1eDdf0w=;
        b=Jr6Ptxztxtos07U9ymM6Q7WGVf5RcttRm/g0/by0YrroDYhCBZRIILTdM8Hkpn2PiF
         mz7suoGma29fRB7XaDatvurPT3OVi+NiXT38+FWemWQf3/m2UkN389JXJC3FsR5M67cI
         D38wEP8w/7riztF+npUevwo6k4hANa752QsXuw/D/QWE/V+pWRJq+yvjb+9pSPVwuaCe
         wCQm89en3hC4vVqIVWtz0Nlwzyj0tOrtcrN7u9DwSulTEP1EgbEWNDH1jx/Wz7FYbPdn
         ZcGgrS0YKOY95xM1Jz5UZzrKGfMDBriMuL0r/ek9BdyEMSo9RIq2+UnAdHUA6jP0vsfP
         9rmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ST9TYYAcZZmj+NX7ZF0UTgwailRauMHsfBUD1eDdf0w=;
        b=1JY09UVbyKYDORWbxjZwtyUKf6eZpWVtlY2X5XzqZaIyEqs4XiyVaib726TiWUJgeu
         6Q5bGwjSY0YMMcUe9Qgk46uSKJTTXdvhS+N1lj13RnseqZGSbamu80ZACtecWpE7hWQO
         9UxGm/mIPITje9HXxGH+xW2u8qmDwCCwyN6v8zXgLjgZ8H9cqL5+j7FhgF9RwTNgM1DC
         p71PACEQozZaxs2M6WlAaX350dqVWAUsAX9jeeoCjXpvEbsBWJ23c6qQSdoprLhEJuWx
         SVKDGaVybcZijf8ZO9p7+rhW3KD+MQA5fPQbb/ZWmOi9Im9ZgYLQpI3Gtww8okcNsCll
         L5lw==
X-Gm-Message-State: AO0yUKXAfOwZjfzXqACPEbK8AVfhBz6puDPYEliqMo6EcYUBkp5txZ+4
        rVqWFLe8/JWtewSVXaI9zx/Tag==
X-Google-Smtp-Source: AK7set8knAM9u3kgKqTaVZFlTOVpVw0YqyQvKdnjFfy4KC2j0ppsr3s2+3RuI3Lctzwyqt2nRbLoIg==
X-Received: by 2002:a17:902:d4c6:b0:19a:9864:288c with SMTP id o6-20020a170902d4c600b0019a9864288cmr1964864plg.4.1676210454225;
        Sun, 12 Feb 2023 06:00:54 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q10-20020a170902b10a00b00174f61a7d09sm6370374plr.247.2023.02.12.06.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 06:00:53 -0800 (PST)
Message-ID: <1363b082-d61f-57e5-92dd-37db4b1c86c2@kernel.dk>
Date:   Sun, 12 Feb 2023 07:00:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc (32-bit userspace and 64-bit kernel)
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org
Cc:     John David Anglin <dave.anglin@bell.net>,
        linux-parisc <linux-parisc@vger.kernel.org>
References: <216beccc-8ce7-82a2-80ba-1befa7b3bc91@gmx.de>
 <159bfaee-cba0-7fba-2116-2af1a529603c@kernel.dk>
 <c1581c21-631d-94dd-1c0d-822fb9f19cd1@gmx.de>
 <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
In-Reply-To: <d7345188-3e58-35e9-2c8f-657f8f813ad5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/23 6:35 AM, Jens Axboe wrote:
> On 2/12/23 6:28?AM, Helge Deller wrote:
>> On 2/12/23 14:16, Jens Axboe wrote:
>>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>>> Hi all,
>>>>
>>>> We see io-uring failures on the parisc architecture with this testcase:
>>>> https://github.com/axboe/liburing/blob/master/examples/io_uring-test.c
>>>>
>>>> parisc is always big-endian 32-bit userspace, with either 32- or 64-bit kernel.
>>>>
>>>> On a 64-bit kernel (6.1.11):
>>>> deller@parisc:~$ ./io_uring-test test.file
>>>> ret=0, wanted 4096
>>>> Submitted=4, completed=1, bytes=0
>>>> -> failure
>>>>
>>>> strace shows:
>>>> io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf7522000
>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf6922000
>>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRECT) = 4
>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=689308, ...}) = 0
>>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) = 4
>>>> brk(NULL)                               = 0x4ae000
>>>> brk(0x4cf000)                           = 0x4cf000
>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     = 0
>>>>
>>>>
>>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>>> root@debian:~# ./io_uring-test test.file
>>>> Submitted=4, completed=4, bytes=16384
>>>> -> ok.
>>>>
>>>> strace:
>>>> io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf6d4c000
>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf694c000
>>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) = 4
>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=1855488, ...}) = 0
>>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) = 4
>>>> brk(NULL)                               = 0x15000
>>>> brk(0x36000)                            = 0x36000
>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     = 4
>>>>
>>>> I'm happy to test any patch if someone has an idea....
>>>
>>> No idea what this could be, to be honest. I tried your qemu vm image,
>>> and it does boot, but it's missing keys to be able to update apt and
>>> install packages... After fiddling with this for 30 min I gave up, any
>>> chance you can update the sid image? Given how slow this thing is
>>> running, it'd take me all day to do a fresh install and I have to admit
>>> I'm not THAT motivated about parisc to do that :)
>>
>> Yes, I will update that image, but qemu currently only supports a
>> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So even if I
>> update it, you won't be able to reproduce it, as it only happens with
>> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64bit
>> translation in the kernel, which triggers only big-endian machines.
> 
> I built my own kernel for it, so that should be fine, correct? We'll see
> soon enough, managed to disable enough checks on the debian-10 image to
> actually make it install packages.

Oh, qemu doesn't support 64-bit parisc... Totally missed that, just
had to find out for myself.

I know io_uring runs fine on s390 which is big endian iirc, and for
io_uring itself, there's no swapping or ordering going on or assumed.
So a bit puzzled on what this would be. But:

>> I will try to add some printks and compare the output of 32- and
>> 64-bit kernels. If you have some suggestion where to add such (which?)
>> debug code, it would help me a lot.
> 
> I'd just try:
> 
> echo 1 > /sys/kernel/debug/tracing/events/io_uring

This might help shed some light on it for you.

-- 
Jens Axboe


