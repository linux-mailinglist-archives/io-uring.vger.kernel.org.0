Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE4C3EA78C
	for <lists+io-uring@lfdr.de>; Thu, 12 Aug 2021 17:29:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237682AbhHLP3f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 12 Aug 2021 11:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236028AbhHLP3e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 12 Aug 2021 11:29:34 -0400
Received: from mail-oo1-xc2e.google.com (mail-oo1-xc2e.google.com [IPv6:2607:f8b0:4864:20::c2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51953C061756
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:29:09 -0700 (PDT)
Received: by mail-oo1-xc2e.google.com with SMTP id y23-20020a4a62570000b029028727ffa408so1895067oog.5
        for <io-uring@vger.kernel.org>; Thu, 12 Aug 2021 08:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=5K81qzSnbslnyNoHQzQWlG0SOo00nOS1V/Q3Cobq2Iw=;
        b=wjp+pOCEs9a7GU2ohjtageszgk+f4eBfvh8hpYOR8WM1tQd0fcSBSNwi7oyOimufAv
         spiRSuNVirQI6vNYU0Ultlj42VrtUpfvp55JrpIDICeMwMgPpQa7YFJcchOcnTtrBAkf
         Rv1o4qYkVy0MlnzdQoPvuhZqOcJsMJK6N6fzSAUdtl4YsphDePc26GEZtTbRmDMbJIJH
         stamWPlIdZTALKbs/O3ZqJYOnFVjwQuhbwlRcCpvyvaiUExzCO9LChOGXn/50Pfsk++q
         bkMo84kue/tlkmNpsGu8bX9M23uwlaWPPs4zxUKyYBXdQO/gXIdhaRARUbD2nhy4kboN
         bfAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5K81qzSnbslnyNoHQzQWlG0SOo00nOS1V/Q3Cobq2Iw=;
        b=AE4/hju7Pk0hadxmjrZpHQcHCdt66DQ99fLJLCoElNDgJtdNYcqdTikXqBHexbMy3M
         PEHZwIX17oIkagXafPBJoFan1RLzj18u07ObIzi1uBLJdbqaRbw11ZLsdl8xue1wSE4u
         rjbfLermBXG/yyNGXN/CUsZwN4aEEbLYjN0qc3I2ztHOEZGyfGyGIzNJs6f8IQrkj3Kv
         fek6L4SBfSF9ivXcfAgDFp7sofrTrSWInjKPLPZGe2M6QDp8+5Pq/wQnZbs1URb5buB0
         njfBubVGuV3yvCf54qH1xPw1Ow6lXbd/eBcBKgV05DWtQuwg8gAUFLxtN4YaC6Qg+C/q
         sbhA==
X-Gm-Message-State: AOAM533kfwN0kbqFGAJkn0jDzJolwLxCFfhLhLIVS+o7yZsDB9pOt9CX
        M/pbbtriBy1GcYZza8UyNPeyxg==
X-Google-Smtp-Source: ABdhPJz1WZccMGdrXd5ys6QCNcjUVuBa3wkrMoXH4xi9cNJnuR/yMuoDMqmCTInP83j9I6Cdfn7npg==
X-Received: by 2002:a4a:b04c:: with SMTP id g12mr3497225oon.3.1628782148652;
        Thu, 12 Aug 2021 08:29:08 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id q13sm577115oov.6.2021.08.12.08.29.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Aug 2021 08:29:08 -0700 (PDT)
Subject: Re: [PATCH 1/6] bio: optimize initialization of a bio
To:     Christoph Hellwig <hch@infradead.org>
Cc:     io-uring@vger.kernel.org, linux-block@vger.kernel.org
References: <20210811193533.766613-1-axboe@kernel.dk>
 <20210811193533.766613-2-axboe@kernel.dk> <YRTFDLv7R4ltlvpa@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <46c21d40-2b31-d3e1-f32f-98865c969040@kernel.dk>
Date:   Thu, 12 Aug 2021 09:29:07 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <YRTFDLv7R4ltlvpa@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/12/21 12:51 AM, Christoph Hellwig wrote:
> On Wed, Aug 11, 2021 at 01:35:28PM -0600, Jens Axboe wrote:
>> The memset() used is measurably slower in targeted benchmarks. Get rid
>> of it and fill in the bio manually, in a separate helper.
> 
> If you have some numbers if would be great to throw them in here.

It's about 1% of the overhead of the alloc after the cache, which
comes later in the series.

Percent│    return __underlying_memset(p, c, size);
       │      lea    0x8(%r8),%rdi
       │    bio_alloc_kiocb():
  2.18 │      cmove  %rax,%r9
       │    memset():
       │      mov    %r8,%rcx
       │      and    $0xfffffffffffffff8,%rdi
       │      movq   $0x0,(%r8)
       │      sub    %rdi,%rcx
       │      add    $0x60,%ecx
       │      shr    $0x3,%ecx
 55.02 │      rep    stos %rax,%es:(%rdi)

This is on AMD, might look different on Intel, the manual clear seems
like a nice win on both. As a minor detail, avoids things like
re-setting bio->bi_pool for cached entries, as it never changes.


>> +static inline void __bio_init(struct bio *bio)
> 
> Why is this split from bio_init and what are the criteria where an
> initialization goes?

Got rid of the helper.

>> +	bio->bi_flags = bio->bi_ioprio = bio->bi_write_hint = 0;
> 
> Please keep each initialization on a separate line.

Done

-- 
Jens Axboe

