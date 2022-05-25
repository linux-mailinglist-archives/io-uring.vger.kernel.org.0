Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB275342A9
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 20:04:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiEYSEz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 25 May 2022 14:04:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343627AbiEYSEy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 25 May 2022 14:04:54 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FCE89D07C
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 11:04:53 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id n145so12600064iod.3
        for <io-uring@vger.kernel.org>; Wed, 25 May 2022 11:04:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:cc:references:in-reply-to:content-transfer-encoding;
        bh=Qt+3c+YXaIfHCYOzqxLz/RsODKgYxd4undTTcmyHC+8=;
        b=p5Wjk0AdiE/CRbKfit/y/Nzwd0KHEFtjAHOp42ZeMwxTHekaHNXXCwWZb9R2YIvJTT
         VuxW9zB4dEo6LvY31+3E+PD4sqnSQhZvAO3hj+KV1fYuCLM6/7cayCoYYUp+4pAyd70k
         16GtYo9HwAuBF7sUWNt6fgBs9+n2eCCUgFwcBgbl9/96Vbfk468tX432G5fDJ+YQG/FG
         3Hf+G9UvOWQoB9w6tj3LopgvuEZ73uo72vfYAzozhOOtfhtn4gS6aAR/OMQUIwCyrdOW
         s+GjQR2LsTmItQ5ye6g+aOd7B3ovMbTJQ0TopwJQg3Z+7Y5OdM6YSTkZy8EeORIbTfEW
         26OQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:cc:references:in-reply-to
         :content-transfer-encoding;
        bh=Qt+3c+YXaIfHCYOzqxLz/RsODKgYxd4undTTcmyHC+8=;
        b=W7P/olYVdbi/gnJVhhJY92ZKV7NN8c7NfCZJH98qH0tG6O7B09y6zeSpTNPKWX1avs
         SpTlRuX/kNEz3zi3T9VCP/3p2phEEAhGTMuncsHgOWrL51qzmCe5TGsEviDkZxEGatBz
         RDXL0AkGsPlwT/iykfqozPHxnBrfGj+z2IAnhUD4j1kZNAm30avO83OlR0CP0rBa/IXA
         YsmsrJQN89yrqvG4bSeKrjmx26wVfmEQlnV194PsU6LDglIuR/pJHU0HdNRt8mRnx9Wb
         72joq+BfMCAJ7zRjjXpE/j6Q1A/ht/xawr8KzT/FS/o3OuBvcAq/HnkITzZqp/vxyQsM
         fMHw==
X-Gm-Message-State: AOAM533hxnxzLlYnRsqpezWTqsTW9FmGBmz4ui62JCzJ6GjTDi1mjb75
        x7NvQcD8OO4+MXsU0sayme9TGmp6F4arlg==
X-Google-Smtp-Source: ABdhPJwvbXOCqXfGcsXL6ie4UxqR18lM/C48FMYhi5YcjZZ1k5CBQc7p7ln3n4UAXfisbmVh7ObxjA==
X-Received: by 2002:a6b:c90a:0:b0:65b:48b5:9907 with SMTP id z10-20020a6bc90a000000b0065b48b59907mr15403140iof.102.1653501892541;
        Wed, 25 May 2022 11:04:52 -0700 (PDT)
Received: from [192.168.1.172] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id h2-20020a056602154200b0066580930265sm1084749iow.14.2022.05.25.11.04.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 May 2022 11:04:51 -0700 (PDT)
Message-ID: <9c37e487-2f7e-6141-4f3e-62c52c28b868@kernel.dk>
Date:   Wed, 25 May 2022 12:04:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [GIT PULL] io_uring xattr support
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>
References: <d94a4e55-c4f2-73d8-9e2c-e55ae8436622@kernel.dk>
 <CAHk-=wg54n0DONm_2Fqtpq63ZgfQUef0WLNhW_KaJX4HTh19YQ@mail.gmail.com>
 <d9b44d03-2060-86ef-2864-be263fbcba84@kernel.dk>
In-Reply-To: <d9b44d03-2060-86ef-2864-be263fbcba84@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/23/22 1:59 PM, Jens Axboe wrote:
>> And from a maintenenace standpoint, I really think it would be good to
>> try to try to walk away from those "case IORING_OP_xyz" things, and
>> try to split things up into more manageable pieces.
>>
>> Hmm?
> 
> As mentioned, it's something that I have myself been thinking about for
> the past few releases. It's not difficult work and can be done in a
> sequential kind of manner, but it will add some pain in terms of
> backports. Nothing _really_ major, but... Longer term it'll be nicer for
> sure, which is the most important bit.
> 
> I've got some ideas on how to split the core bits, and the
> related-op-per file kind of idea for the rest makes sense. Eg net
> related bits can go in one, or maybe we can even go finer grained and
> (almost) do per-op.
> 
> I'll spend some time after the merge window to try and get this sorted
> out.

Well I spent some time yesterday, and 53 patches later, I think it looks
pretty sane. At this point everything is split out, except read/write
and poll handling. There's still some things we can split out, like the
io_uring_register() side, but as it stands, ~35% of the code has been
split into separate files for either opcodes or infrastructure that goes
together. We can definitely get this down further, but it's a good
start.

Anyway, I pitted -git vs -git + this merged in, to test with and without
spectre mitigations as we now have an indirect ->prep() and ->issue()
for each opcode in the fast path. I ran my usual peak testing, which is
basically just polled async random reads from 3 devices. The box in
question is a 12900K, so recent cpu. Mitigation status:

/sys/devices/system/cpu/vulnerabilities/spectre_v1:Mitigation: usercopy/swapgs barriers and __user pointer sanitization
/sys/devices/system/cpu/vulnerabilities/spectre_v2:Vulnerable: eIBRS with unprivileged eBPF

Out of 5 runs, here are the results:

-git, RETPOLINE=n, mitigations=off
Maximum IOPS=12837K
Maximum IOPS=12812K
Maximum IOPS=12834K
Maximum IOPS=12856K
Maximum IOPS=12809K

for-5.20/io_uring, RETPOLINE=n, mitigations=off
Maximum IOPS=12877K
Maximum IOPS=12870K
Maximum IOPS=12848K
Maximum IOPS=12837K
Maximum IOPS=12899K

-git, RETPOLINE=y, mitigations=on
Maximum IOPS=12869K
Maximum IOPS=12766K
Maximum IOPS=12817K
Maximum IOPS=12866K
Maximum IOPS=12828K

for-5.20/io_uring, RETPOLINE=y, mitigations=on
Maximum IOPS=12859K
Maximum IOPS=12921K
Maximum IOPS=12899K
Maximum IOPS=12859K
Maximum IOPS=12904K

If anything, the new code seems a smidge faster for both mitigations=off
vs RETPOLINE=y && mitigations=on. Hmm? But at least from a first test
this is promising and it may be a viable path forward to make it a bit
saner.

If you're curious, git tree here:

https://git.kernel.dk/cgit/linux-block/log/?h=for-5.20/io_uring

with the first 5 patches being staged for 5.19 as well as they are just
consistency cleanups.

-- 
Jens Axboe

