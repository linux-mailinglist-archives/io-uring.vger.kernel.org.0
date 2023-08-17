Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36AFE77EE94
	for <lists+io-uring@lfdr.de>; Thu, 17 Aug 2023 03:12:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347458AbjHQBMY (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 16 Aug 2023 21:12:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347467AbjHQBMQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 16 Aug 2023 21:12:16 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFFB9268D
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 18:12:14 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id d9443c01a7336-1bb91c20602so12914175ad.0
        for <io-uring@vger.kernel.org>; Wed, 16 Aug 2023 18:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1692234734; x=1692839534;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xaD49zNxD1CTfghtJCqv8UklQOpjmynArGSu1sZ4jEE=;
        b=0yYPExjBlppKV1qOB8nQf4S/HX2y8W8DFADqZakoEkav3LsHNLkoEZSUL1Gf+U4BpA
         wFNM9oJhJ/zxxfkJQKZGlXt5YbQkKw44LnzGljrl0gCRX+JswXuj9IlzEr/cHW++fjHm
         COFwqtMNQgeuZNVxGJEfm0RNkSXnsJABP88eOwaf9sEFATwT6r47gx0+Y5r5zaPJaWUx
         8p2J51NAOyNABRxYdQHXDd6Z/sKo61Xhr6PP+aonhEMu7VGfI0AMjfTCEQb4x0SMJlpr
         15XzSKTFCz0GNdZJQt+sPA7SMWKl427ev3vUStI6LzcaziekJ2qHuCL1kQs81aSOx5RX
         eepw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692234734; x=1692839534;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xaD49zNxD1CTfghtJCqv8UklQOpjmynArGSu1sZ4jEE=;
        b=R0y/uC7gd1naHheEnDrD7Zhe7RJbxuF2IJlbB/pWAiherYOSnX4LGFFKtybroQMBoN
         Yf+MgxYWNBTeCywX0Atf9fgf3+A3kTC/7bR9rytiMaA+oz4xLhW3kaf6hVLqnvTi4Xin
         k4whLjYv54IMf2d2dl5OahRRmzr8pQIJ8wrw3uMzlo2Hpw25ISTnTALFaMJUifvAkoIU
         sb+sDz4QO+CaxJtJRJ334BqsXIbcHCn77RO3jPaZnLkUgHJ+mul6nCm9NKeLm1P/QGA9
         YAtLjknuINBWCfCB2wp46knFre1+dpQ8nwUA/MasIqGNY1vzXHemsCJjWXV5Y8IMXT2B
         UiBA==
X-Gm-Message-State: AOJu0YyecHWxJ/FoMQj2YmjIIWOB+QIio/+p/vA2JDdB5hiMJ9SVVYdb
        K95+7u8EnXWYjVvcTzQl3vpXLw==
X-Google-Smtp-Source: AGHT+IHcxM0OweYWH8nGM+5EmjbQ+of2/Yti8KnoiJweZQjuHUtQ0bBuH0Z2j9Csu7XIaPqEIvvpIg==
X-Received: by 2002:a17:903:41c2:b0:1b8:b0c4:2e3d with SMTP id u2-20020a17090341c200b001b8b0c42e3dmr3884856ple.4.1692234734141;
        Wed, 16 Aug 2023 18:12:14 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t5-20020a170902e84500b001b881a8251bsm6443935plg.106.2023.08.16.18.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Aug 2023 18:12:13 -0700 (PDT)
Message-ID: <d779f1aa-f6ef-43c6-bfcc-35a6870a639a@kernel.dk>
Date:   Wed, 16 Aug 2023 19:12:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Possible io_uring related race leads to btrfs data csum mismatch
Content-Language: en-US
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        io-uring@vger.kernel.org
References: <95600f18-5fd1-41c8-b31b-14e7f851e8bc@gmx.com>
 <51945229-5b35-4191-a3f3-16cf4b3ffce6@kernel.dk>
 <db15e7a6-6c65-494f-9069-a5d1a72f9c45@gmx.com>
 <d67e7236-a9e4-421c-b5bf-a4b25748cac2@kernel.dk>
 <2b3d6880-59c7-4483-9e08-3b10ac936d04@gmx.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2b3d6880-59c7-4483-9e08-3b10ac936d04@gmx.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/16/23 7:05 PM, Qu Wenruo wrote:
> 
> 
> On 2023/8/17 06:28, Jens Axboe wrote:
> [...]
>>
>>>> 2) What's the .config you are using?
>>>
>>> Pretty common config, no heavy debug options (KASAN etc).
>>
>> Please just send the .config, I'd rather not have to guess. Things like
>> preempt etc may make a difference in reproducing this.
> 
> Sure, please see the attached config.gz

Thanks

>> And just to be sure, this is not mixing dio and buffered, right?
> 
> I'd say it's mixing, there are dwrite() and writev() for the same file,
> but at least not overlapping using this particular seed, nor they are
> concurrent (all inside the same process sequentially).
> 
> But considering if only uring_write is disabled, then no more reproduce,
> thus there must be some untested btrfs path triggered by uring_write.

That would be one conclusion, another would be that timing is just
different and that triggers and issue. Or it could of course be a bug in
io_uring, perhaps a short write that gets retried or something like
that. I've run the tests for hours here and don't hit anything, I've
pulled in the for-next branch for btrfs and see if that'll make a
difference. I'll check your .config too.

Might not be a bad idea to have the writes contain known data, and when
you hit the failure to verify the csum, dump the data where the csum
says it's wrong and figure out at what offset, what content, etc it is?
If that can get correlated to the log of what happened, that might shed
some light on this.

>>>>> However I didn't see any io_uring related callback inside btrfs code,
>>>>> any advice on the io_uring part would be appreciated.
>>>>
>>>> io_uring doesn't do anything special here, it uses the normal page cache
>>>> read/write parts for buffered IO. But you may get extra parallellism
>>>> with io_uring here. For example, with the buffered write that this most
>>>> likely is, libaio would be exactly the same as a pwrite(2) on the file.
>>>> If this would've blocked, io_uring would offload this to a helper
>>>> thread. Depending on the workload, you could have multiple of those in
>>>> progress at the same time.
>>>
>>> My biggest concern is, would io_uring modify the page when it's still
>>> under writeback?
>>
>> No, of course not. Like I mentioned, io_uring doesn't do anything that
>> the normal read/write path isn't already doing - it's using the same
>> ->read_iter() and ->write_iter() that everything else is, there's no
>> page cache code in io_uring.
>>
>>> In that case, it's going to cause csum mismatch as btrfs relies on the
>>> page under writeback to be unchanged.
>>
>> Sure, I'm aware of the stable page requirements.
>>
>> See my followup email as well on a patch to test as well.
>>
> 
> Applied and tested, using "-p 10 -n 1000" as fsstress workload, failed
> at 23rd run.

OK, that rules out the multiple-writers theory.

-- 
Jens Axboe

