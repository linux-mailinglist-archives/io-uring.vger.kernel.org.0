Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3FC6971D2
	for <lists+io-uring@lfdr.de>; Wed, 15 Feb 2023 00:29:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjBNX3V (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Feb 2023 18:29:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBNX3V (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Feb 2023 18:29:21 -0500
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F72F2FCF1
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 15:29:19 -0800 (PST)
Received: by mail-il1-x12c.google.com with SMTP id v6so1978380ilc.10
        for <io-uring@vger.kernel.org>; Tue, 14 Feb 2023 15:29:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=o/GTsZZk/gy+jZewA997GqDtmR9sPVGVZWqtxnpgnBE=;
        b=1skAcVCWjvseMTvykq6aAR4G+enRcu+vmQfr7Et/TPPGnPCw21H2aYvHhYrMDeD8+h
         XVbbw0r/g9BbW3ZyoiwhicGQZOxglzTsBNWOJ7dEozFlUw2RUlh/wPvVngMBYprmKP5K
         SSdKhpeVCymyZBwhEJG6Ej7dO2qmKirb8bNr8i749yUOfBGG7KOTscAR5lnL/67q2r3p
         Zp4szBV2qFdwVPS9e+zT8DRmr6dZvkJxI8q+z4CBGHXZ7stpIvnKLjZepPtSjpk5lmF0
         yQ5Mb8mSzMmUuxwdiSYihvEogvtAATazNQb6QGYWt1IOAzhH2i9eWonOZksnoELXe8C7
         Mj8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=o/GTsZZk/gy+jZewA997GqDtmR9sPVGVZWqtxnpgnBE=;
        b=gd5sKF42acy+6revD3Ns1Pgvagp/v1gzexs2g1aGKEyufc3yog+BlbKVVTPmmIcEdP
         NDy4D1DaIC0P0tgxNVR0X3i4cKJFagtiZs1khAFYQP/dV1nfhx9E4ehKKlsZanvvjGaz
         myRlNV+V4/zc8mzIalDRNMPXY9E7QfDAYio0GKfRng32dY/DLLl1cPkHmNM1pp+wTkpN
         MoBXIGjpEVAiY/Npd6Q/t0joJdvBnxSZ7PauJf3uSrYkYIPWxDXHpVp36HQ8NjcuxAcR
         tWnobeaP65YY74KApdY5odjXUW++HCdtT4lSpwjlvKNjS0K2ILj6AVLmyOjWdqA89VMs
         qc/Q==
X-Gm-Message-State: AO0yUKXepFUXxQok5z4SZ5feX+3WCALrLbJnr8QrvOvA660jdjs8cNn2
        +qB8GY0ZLbf0jZfGXVtZ1NAIbg==
X-Google-Smtp-Source: AK7set/ATWikzrj10Dyz6gVEz97iN47YCBbsx1dGvj88aJ+LAnDoFRMvld1zQstDpymjToQyOsnoow==
X-Received: by 2002:a05:6e02:d4c:b0:315:5436:a632 with SMTP id h12-20020a056e020d4c00b003155436a632mr259105ilj.2.1676417358934;
        Tue, 14 Feb 2023 15:29:18 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id r2-20020a927602000000b003127b668eafsm1119482ilc.19.2023.02.14.15.29.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Feb 2023 15:29:18 -0800 (PST)
Message-ID: <006e8db4-336f-6717-ecb0-d01a0e9bc483@kernel.dk>
Date:   Tue, 14 Feb 2023 16:29:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: io_uring failure on parisc with VIPT caches
Content-Language: en-US
To:     Helge Deller <deller@gmx.de>, io-uring@vger.kernel.org,
        linux-parisc@vger.kernel.org,
        John David Anglin <dave.anglin@bell.net>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
References: <Y+wUwVxeN87gqN6o@p100>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Y+wUwVxeN87gqN6o@p100>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/14/23 4:09 PM, Helge Deller wrote:
> * John David Anglin <dave.anglin@bell.net>:
>> On 2023-02-13 5:05 p.m., Helge Deller wrote:
>>> On 2/13/23 22:05, Jens Axboe wrote:
>>>> On 2/13/23 1:59?PM, Helge Deller wrote:
>>>>>> Yep sounds like it. What's the caching architecture of parisc?
>>>>>
>>>>> parisc is Virtually Indexed, Physically Tagged (VIPT).
>>>>
>>>> That's what I assumed, so virtual aliasing is what we're dealing with
>>>> here.
>>>>
>>>>> Thanks for the patch!
>>>>> Sadly it doesn't fix the problem, as the kernel still sees
>>>>> ctx->rings->sq.tail as being 0.
>>>>> Interestingly it worked once (not reproduceable) directly after bootup,
>>>>> which indicates that we at least look at the right address from kernel side.
>>>>>
>>>>> So, still needs more debugging/testing.
>>>>
>>>> It's not like this is untested stuff, so yeah it'll generally be
>>>> correct, it just seems that parisc is a bit odd in that the virtual
>>>> aliasing occurs between the kernel and userspace addresses too. At least
>>>> that's what it seems like.
>>>
>>> True.
>>>
>>>> But I wonder if what needs flushing is the user side, not the kernel
>>>> side? Either that, or my patch is not flushing the right thing on the
>>>> kernel side.
> 
> 
> The patch below seems to fix the issue.
> 
> I've successfuly tested it with the io_uring-test testcase on
> physical parisc machines with 32- and 64-bit 6.1.11 kernels.
> 
> The idea is similiar on how a file is mmapped shared by two
> userspace processes by keeping the lower bits of the virtual address
> the same.
> 
> Cache flushes from userspace don't seem to be needed.

Are they from the kernel side, if the lower bits mean we end up
with the same coloring? Because I think this is a bit of a big
hammer, in terms of overhead for flushing. As an example, on arm64
that is perfectly fine with the existing code, it's about a 20-25%
performance hit.

Other little complaints too in terms of which pages to flush, eg
it's only the first page that is flushed but the ring may be
larger than that. But those are mostly moot if we can just guarantee
the lowest bits fixes the aliasing.

-- 
Jens Axboe


