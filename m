Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B35F2693A4D
	for <lists+io-uring@lfdr.de>; Sun, 12 Feb 2023 22:48:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbjBLVsr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 12 Feb 2023 16:48:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229641AbjBLVsq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 12 Feb 2023 16:48:46 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D3EEB76
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 13:48:45 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id d13-20020a17090ad3cd00b0023127b2d602so10427620pjw.2
        for <io-uring@vger.kernel.org>; Sun, 12 Feb 2023 13:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676238524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LLzbzrcpe8M65cG7q35U7FRfwqwMYv4GCJeox8KQEdg=;
        b=JndHXFIj7DI/pfprSxiWFQ1YB8K2vAAywDbfPXtANY0Vlti34BJgHtgBabHd1ANBK+
         dABOEo06zGFQ3mT4a9SmbY/O+zPWEDM+Mx/sWLTd3+Hq8U/8ba+JD/n1sumjJ82fK4cs
         uN+8VEgRcp0ZvTPIVC+E8uCStq1aCm7aQndLOf0fdb4tozrKwVytOjDm4yi/Z5mwNZkw
         KxyTZAY4pbnFxwEvEVzWiVqzvXsOplv5DcIJ1g+v9y9Xyu476TS/RVCACMISUAt6tR/D
         AF/TCHVKGULmdfWTKinPKcRvU/tr2X5a3mdTrI++CLs4paEIMU5S/eYfrX3h3mc7OWOO
         J/Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676238524;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LLzbzrcpe8M65cG7q35U7FRfwqwMYv4GCJeox8KQEdg=;
        b=noMCwh01nhtaRM8yVYoXTOwMckcdLNqdDg7QYaY7pof7uxDaasadYnymETJBwjXX8P
         tA9b62i7C50wkoy5sEyPEpKqjvkzSD9RNeRzi7ftg3zk8OvDA1q5uhJ3OEgzClbxK0Bq
         KmTOxHW78/+0ARBRsZlVHEkNG46Ma7vKXR6Pftar8uEr7qFg5N48wZiNyOdpkYjje69P
         lX5kLjP1/rXNYXhxj56MZYZisIG/uqdczX+qM5kGE7BmsrVKjK1R6vFgOPoKNzbsBS/y
         UQWwpCTx2SVl3FyI17z1dJs/AAmBx0gJNLN/HaCRpZ+Fi9q7c+apab+56JnVAwCBkczx
         ZhEg==
X-Gm-Message-State: AO0yUKUsIAg/qDYnrdn58jt3/xLGMpBlYCRnVqfkfeb4r2cqFD+awaz/
        6Nz2XzvrTkzwS+3H0SG9CTqvMLvVwWXhfVco
X-Google-Smtp-Source: AK7set8jSgvDwHdpD3JPpCN+BiYBqULXPrhpsz8yZnp4agZdQxSaGw55gxQX98jEZw3K6XpMOs1FyQ==
X-Received: by 2002:a17:90a:5d12:b0:233:6d76:27b7 with SMTP id s18-20020a17090a5d1200b002336d7627b7mr9144402pji.3.1676238524522;
        Sun, 12 Feb 2023 13:48:44 -0800 (PST)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id m11-20020a17090a3f8b00b002312586b5b1sm6629304pjc.57.2023.02.12.13.48.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 12 Feb 2023 13:48:43 -0800 (PST)
Message-ID: <05b6adc3-db63-022e-fdec-6558bdb83972@kernel.dk>
Date:   Sun, 12 Feb 2023 14:48:42 -0700
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
 <0b1946e4-1678-b442-695e-84443e7f2a86@kernel.dk>
 <ee1e92d5-6117-003a-3313-48d906dafba8@gmx.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ee1e92d5-6117-003a-3313-48d906dafba8@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/12/23 1:01?PM, Helge Deller wrote:
> On 2/12/23 20:42, Jens Axboe wrote:
>> On 2/12/23 12:35?PM, Helge Deller wrote:
>>> On 2/12/23 15:03, Helge Deller wrote:
>>>> On 2/12/23 14:35, Jens Axboe wrote:
>>>>> On 2/12/23 6:28?AM, Helge Deller wrote:
>>>>>> On 2/12/23 14:16, Jens Axboe wrote:
>>>>>>> On 2/12/23 2:47?AM, Helge Deller wrote:
>>>>>>>> Hi all,
>>>>>>>>
>>>>>>>> We see io-uring failures on the parisc architecture with this testcase:
>>>>>>>> https://github.com/axboe/liburing/blob/master/examples/io_uring-test.c
>>>>>>>>
>>>>>>>> parisc is always big-endian 32-bit userspace, with either 32- or 64-bit kernel.
>>>>>>>>
>>>>>>>> On a 64-bit kernel (6.1.11):
>>>>>>>> deller@parisc:~$ ./io_uring-test test.file
>>>>>>>> ret=0, wanted 4096
>>>>>>>> Submitted=4, completed=1, bytes=0
>>>>>>>> -> failure
>>>>>>>>
>>>>>>>> strace shows:
>>>>>>>> io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
>>>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf7522000
>>>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf6922000
>>>>>>>> openat(AT_FDCWD, "libell0-dbgsym_0.56-2_hppa.deb", O_RDONLY|O_DIRECT) = 4
>>>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=689308, ...}) = 0
>>>>>>>> getrandom("\x5c\xcf\x38\x2d", 4, GRND_NONBLOCK) = 4
>>>>>>>> brk(NULL)                               = 0x4ae000
>>>>>>>> brk(0x4cf000)                           = 0x4cf000
>>>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     = 0
>>>>>>>>
>>>>>>>>
>>>>>>>> Running the same testcase on a 32-bit kernel (6.1.11) works:
>>>>>>>> root@debian:~# ./io_uring-test test.file
>>>>>>>> Submitted=4, completed=4, bytes=16384
>>>>>>>> -> ok.
>>>>>>>>
>>>>>>>> strace:
>>>>>>>> io_uring_setup(4, {flags=0, sq_thread_cpu=0, sq_thread_idle=0, sq_entries=4, cq_entries=8, features=IORING_FEAT_SINGLE_MMAP|IORING_FEAT_NODROP|IORING_FEAT_SUBMIT_STABLE|IORING_FEAT_RW_CUR_POS|IORING_FEAT_CUR_PERSONALITY|IORING_FEAT_FAST_POLL|IORING_FEAT_POLL_32BITS|0x1f80, sq_off={head=0, tail=16, ring_mask=64, ring_entries=72, flags=84, dropped=80, array=224}, cq_off={head=32, tail=48, ring_mask=68, ring_entries=76, overflow=92, cqes=96, flags=0x58 /* IORING_CQ_??? */}}) = 3
>>>>>>>> mmap2(NULL, 240, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0) = 0xf6d4c000
>>>>>>>> mmap2(NULL, 256, PROT_READ|PROT_WRITE, MAP_SHARED|MAP_POPULATE, 3, 0x10000000) = 0xf694c000
>>>>>>>> openat(AT_FDCWD, "trace.dat", O_RDONLY|O_DIRECT) = 4
>>>>>>>> statx(4, "", AT_STATX_SYNC_AS_STAT|AT_NO_AUTOMOUNT|AT_EMPTY_PATH, STATX_BASIC_STATS, {stx_mask=STATX_BASIC_STATS|STATX_MNT_ID, stx_attributes=0, stx_mode=S_IFREG|0644, stx_size=1855488, ...}) = 0
>>>>>>>> getrandom("\xb2\x3f\x0c\x65", 4, GRND_NONBLOCK) = 4
>>>>>>>> brk(NULL)                               = 0x15000
>>>>>>>> brk(0x36000)                            = 0x36000
>>>>>>>> io_uring_enter(3, 4, 0, 0, NULL, 8)     = 4
>>>>>>>>
>>>>>>>> I'm happy to test any patch if someone has an idea....
>>>>>>>
>>>>>>> No idea what this could be, to be honest. I tried your qemu vm image,
>>>>>>> and it does boot, but it's missing keys to be able to update apt and
>>>>>>> install packages... After fiddling with this for 30 min I gave up, any
>>>>>>> chance you can update the sid image? Given how slow this thing is
>>>>>>> running, it'd take me all day to do a fresh install and I have to admit
>>>>>>> I'm not THAT motivated about parisc to do that :)
>>>>>>
>>>>>> Yes, I will update that image, but qemu currently only supports a
>>>>>> 32-bit PA-RISC CPU which can only run the 32-bit kernel. So even if I
>>>>>> update it, you won't be able to reproduce it, as it only happens with
>>>>>> the 64-bit kernel. I'm sure it's some kind of missing 32-to-64bit
>>>>>> translation in the kernel, which triggers only big-endian machines.
>>>>>
>>>>> I built my own kernel for it, so that should be fine, correct?
>>>>
>>>> No, as qemu won't boot the 64-bit kernel.
>>>>
>>>>> We'll see soon enough, managed to disable enough checks on the
>>>>> debian-10 image to actually make it install packages.
>>>>>
>>>>>> Does powerpc with a 64-bit ppc64 kernel work?
>>>>>> I'd assume it will show the same issue.
>>>>>
>>>>> No idea... Only stuff I use and test on is x86-64/32 and arm64.
>>>>
>>>> Would be interesting if someone could test...
>>>>
>>>>>> I will try to add some printks and compare the output of 32- and
>>>>>> 64-bit kernels. If you have some suggestion where to add such (which?)
>>>>>> debug code, it would help me a lot.
>>>>>
>>>>> I'd just try:
>>>>>
>>>>> echo 1 > /sys/kernel/debug/tracing/events/io_uring
>>>>
>>>> I'll try, but will take some time...
>>>>
>>>
>>> At entry of io_submit_sqes(), io_sqring_entries() returns 0, because
>>> ctx->rings->sq.tail is 0 (wrongly on broken 64-bit, but ok value 4 on 32-bit), and
>>> ctx->cached_sq_head is 0 in both cases.
>>
>> cached_sq_head will get updated as sqes are consumed, but since sq.tail
>> is zero, there's nothing to submit as far as io_uring is concerned.
>>
>> Can you dump addresses/offsets of the sq and cq heads/tails in userspace
>> and in the kernel? They are u32, so same size of 32 and 64-bit.
> 
> For both kernels (32- and 64-bit) I get:
> p->sq_off.head = 0  p->sq_off.tail = 16
> p->cq_off.head = 32  p->cq_off.tail = 48

So all that looks as expected. Is it perhaps some mmap thing on 64-bit
kernels? The kernel isn't seeing the updates. You could add the below
debugging, and keep your kernel side stuff. Sounds like they don't quite
agree.


diff --git a/examples/io_uring-test.c b/examples/io_uring-test.c
index 1a685360bff6..f1cfda90c018 100644
--- a/examples/io_uring-test.c
+++ b/examples/io_uring-test.c
@@ -73,7 +73,9 @@ int main(int argc, char *argv[])
 			break;
 	} while (1);
 
+	printf("pre-submit sq head/tail %d/%d, %d/%d\n", *ring.sq.khead, *ring.sq.ktail, ring.sq.sqe_head, ring.sq.sqe_tail);
 	ret = io_uring_submit(&ring);
+	printf("post-submit sq head/tail %d/%d, %d/%d\n", *ring.sq.khead, *ring.sq.ktail, ring.sq.sqe_head, ring.sq.sqe_tail);
 	if (ret < 0) {
 		fprintf(stderr, "io_uring_submit: %s\n", strerror(-ret));
 		return 1;

-- 
Jens Axboe

