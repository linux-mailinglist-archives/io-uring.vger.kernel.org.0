Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79A911EA639
	for <lists+io-uring@lfdr.de>; Mon,  1 Jun 2020 16:48:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727769AbgFAOql (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 1 Jun 2020 10:46:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726017AbgFAOqk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 1 Jun 2020 10:46:40 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A19C8C03E96B
        for <io-uring@vger.kernel.org>; Mon,  1 Jun 2020 07:46:39 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 5so5241136pjd.0
        for <io-uring@vger.kernel.org>; Mon, 01 Jun 2020 07:46:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PJv6mD+yHUR+Vq/e8xKUWkbuEu0YctS5xT5X44k6oTo=;
        b=Om+p2SKXwpHoqkI7QRrOtvHf52TeMgu//ne7X47C76RYZhF2dx6vUVrsvsuMKUYYiz
         JVwtEgmWL2gkMt+Fh0caZ++5jORUSDQtdWdKC01rl+MryRE8Cu7AwvcNOuYioSmB2rHN
         77GyRlgW3dejh95iQS6rWA/p3DOwH8R04Q9IDlab0nT9Is6XXphmg5I27E5G1pEE4bR/
         5GnudhgNla9manTS8V7AvESciXfrOJGZdsbt0vZcBvM1hsuiI20ePbgbnpa7GEyI0ooT
         YKM5BtlUSAdIRckTguVbGeVFYChUvumADSQVhPtjv7Ywm3T1Jwc9GUKuZICrgnUrnHXn
         g7Uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PJv6mD+yHUR+Vq/e8xKUWkbuEu0YctS5xT5X44k6oTo=;
        b=Xh9UTUSX+NofS0WZ7Pu7devtPgxI8o+GS05/KkoE0eeH3qbJf5jONXry8oRdLSfjS2
         GKWycIK7561N8WcQuEdWHGV1Cc/YxLEy+Rw1dOKz9ExmFj5xKxBrzeJssgVKcK3tzvGH
         JY1cjkCyPUWImzYuhNwM4ahMwcjVFh9tPpV5tzi4TodT2r89vuh6KzVAzY+GxPcTTPp7
         Z45fFzBkR+0g7+Vagbho/lU/ErbsABBU35PootL5smpNKQQReZzdamH5uhe5OpA1Bj+C
         1iefV+F0kAxNTBlRwBKkNanNrApI7yjkeH+55nXrzu1joz1H3ZRCiYv8YvIE544aSFm0
         71jA==
X-Gm-Message-State: AOAM530cnRNyFK4JNfr3OTwk28kuKKd2OMauTku5tvnOaiKp6fKAbweh
        q6R7UPsMQ5l7Bi5uQJOo4H5aHg==
X-Google-Smtp-Source: ABdhPJw/hsIt3L+CFQ9MXoRriiqusGFuvmvNIsT3yTbURUwDJ/jeBgruCjvHske5O3WWhR0OThOjnw==
X-Received: by 2002:a17:90b:3d4:: with SMTP id go20mr25678281pjb.208.1591022799024;
        Mon, 01 Jun 2020 07:46:39 -0700 (PDT)
Received: from [192.168.1.188] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z1sm6096066pfr.88.2020.06.01.07.46.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2020 07:46:38 -0700 (PDT)
Subject: Re: [PATCHSET v5 0/12] Add support for async buffered reads
To:     sedat.dilek@gmail.com
Cc:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org
References: <20200526195123.29053-1-axboe@kernel.dk>
 <CA+icZUWfX+QmroE6j74C7o-BdfMF5=6PdYrA=5W_JCKddqkJgQ@mail.gmail.com>
 <bab2d6f8-4c65-be21-6a8e-29b76c06807d@kernel.dk>
 <CA+icZUUgazqLRwnbQgFPhCa5vAsAvJhjCGMYs7KYBZgA04mSyw@mail.gmail.com>
 <CA+icZUUwz5TPpT_zS=P4MZBDzzrAcFvZMUce8mJu8M1C7KNO5A@mail.gmail.com>
 <CA+icZUVJT8X3zyafrgbkJppsp4nJEKaLjYNs1kX8H+aY1Y10Qw@mail.gmail.com>
 <CA+icZUWHOYcGUpw4gfT7xP2Twr15YbyXiWA_=Mc+f7NgzZCETw@mail.gmail.com>
 <230d3380-0269-d113-2c32-6e4fb94b79b8@kernel.dk>
 <CA+icZUXxmOA-5+dukCgxfSp4eVHB+QaAHO6tsgq0iioQs3Af-w@mail.gmail.com>
 <CA+icZUV4iSjL8=wLA3qd1c5OQHX2s1M5VKj2CmJoy2rHmzSVbQ@mail.gmail.com>
 <CA+icZUXkWG=08rz9Lp1-ZaRCs+GMTwEiUaFLze9xpL2SpZbdsQ@mail.gmail.com>
 <cdb3ac15-0c41-6147-35f1-41b2a3be1c33@kernel.dk>
 <CA+icZUUfxAc9LaWSzSNV4tidW2KFeVLkDhU30OWbQP-=2bYFHw@mail.gmail.com>
 <b24101f1-c468-8f6b-9dcb-6dc59d0cd4b9@kernel.dk>
 <455dd2c1-7346-2d43-4266-1367c368cee1@kernel.dk>
 <CA+icZUVVL4W46Df5=eQVsb8S6A=_A0ho0jFVf3mde1wpx7kynQ@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <412ec6a7-90c9-5856-bafe-12c8fe2135e7@kernel.dk>
Date:   Mon, 1 Jun 2020 08:46:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <CA+icZUVVL4W46Df5=eQVsb8S6A=_A0ho0jFVf3mde1wpx7kynQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 6/1/20 8:43 AM, Sedat Dilek wrote:
> On Mon, Jun 1, 2020 at 4:35 PM Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 6/1/20 8:14 AM, Jens Axboe wrote:
>>> On 6/1/20 8:13 AM, Sedat Dilek wrote:
>>>> On Mon, Jun 1, 2020 at 4:04 PM Jens Axboe <axboe@kernel.dk> wrote:
>>>>>
>>>>> On 6/1/20 7:35 AM, Sedat Dilek wrote:
>>>>>> Hi Jens,
>>>>>>
>>>>>> with Linux v5.7 final I switched to linux-block.git/for-next and reverted...
>>>>>>
>>>>>> "block: read-ahead submission should imply no-wait as well"
>>>>>>
>>>>>> ...and see no boot-slowdowns.
>>>>>
>>>>> Can you try with these patches applied instead? Or pull my async-readahead
>>>>> branch from the same location.
>>>>>
>>>>
>>>> Yes, I can do that.
>>>> I pulled from linux-block.git#async-readahead and will report later.
>>>>
>>>> Any specific testing desired by you?
>>>
>>> Just do your boot timing test and see if it works, thanks.
>>
>> Actually, can you just re-test with the current async-buffered.6 branch?
>> I think the major surgery should wait for 5.9, we can do this a bit
>> easier without having to touch everything around us.
>>
> 
> With linux-block.git#async-readahead:
> 
>   mycompiler -Wp,-MD,kernel/.sys.o.d -nostdinc -isystem
> /home/dileks/src/llvm-toolchain/install/lib/clang/10.0.1rc1/include
> -I./arch/x86/include -I./arch/x86/include/generated  -I./include
> -I./arch/x86/include/uapi -I./arch/x86/include/generated/uapi
> -I./include/uapi -I./include/generated/uapi -include
> ./include/linux/kconfig.h -include ./include/linux/compiler_types.h
> -D__KERNEL__ -Qunused-arguments -Wall -Wundef
> -Werror=strict-prototypes -Wno-trigraphs -fno-strict-aliasing
> -fno-common -fshort-wchar -fno-PIE
> -Werror=implicit-function-declaration -Werror=implicit-int
> -Wno-format-security -std=gnu89 -no-integrated-as
> -Werror=unknown-warning-option -mno-sse -mno-mmx -mno-sse2 -mno-3dnow
> -mno-avx -m64 -mno-80387 -mstack-alignment=8 -mtune=generic
> -mno-red-zone -mcmodel=kernel -Wno-sign-compare
> -fno-asynchronous-unwind-tables -mretpoline-external-thunk
> -fno-delete-null-pointer-checks -Wno-address-of-packed-member -O2
> -Wframe-larger-than=2048 -fstack-protector-strong
> -Wno-format-invalid-specifier -Wno-gnu -mno-global-merge
> -Wno-unused-const-variable -g -gz=zlib -pg -mfentry -DCC_USING_FENTRY
> -Wdeclaration-after-statement -Wvla -Wno-pointer-sign
> -Wno-array-bounds -fno-strict-overflow -fno-merge-all-constants
> -fno-stack-check -Werror=date-time -Werror=incompatible-pointer-types
> -fmacro-prefix-map=./= -fcf-protection=none -Wno-initializer-overrides
> -Wno-format -Wno-sign-compare -Wno-format-zero-length
> -Wno-tautological-constant-out-of-range-compare
> -DKBUILD_MODFILE='"kernel/sys"' -DKBUILD_BASENAME='"sys"'
> -DKBUILD_MODNAME='"sys"' -c -o kernel/sys.o kernel/sys.c
> fs/9p/vfs_addr.c:112:4: error: use of undeclared identifier 'filp'
>                         filp->private_data);
>                         ^
> 1 error generated.
> make[5]: *** [scripts/Makefile.build:267: fs/9p/vfs_addr.o] Error 1
> make[4]: *** [scripts/Makefile.build:488: fs/9p] Error 2
> make[3]: *** [Makefile:1735: fs] Error 2
> make[3]: *** Waiting for unfinished jobs....
> 
> I guess block.git#async-buffered.6 needs the same revert of "block:
> read-ahead submission should imply no-wait as well".

Sorry, forgot to push out the updated version. But as per previous
email, I think that major work should wait. Just try the updated
async-buffered.6 branch instead.

-- 
Jens Axboe

