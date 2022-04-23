Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFCEC50CCD3
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 20:12:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236187AbiDWSO5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 14:14:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230174AbiDWSO5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 14:14:57 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 925F427CF7
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 11:11:59 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id q3so17936792plg.3
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 11:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language
         :from:to:references:in-reply-to:content-transfer-encoding;
        bh=rZ9bCneq1Z5E94YUQsiDnw+k/24xygdQ7lPf5i3Ih40=;
        b=d2hS2yGN6ben4LrZGrA9cVFbN2Hx+kqXTSO0Tn2NSMt3OHY/o7mVrHzSFEN0gGAh0/
         pzYcfdhpg/YYSJKSwHmaA3Ork7gNZeve+yqqm1Av5MeU8C55hEbZR4q6Nvxa2x1e3qqv
         6t16ldDVE33Fy08zW9lNRBD3vlCQ/OZxecOm7WQ1XIs83/86hv7zCBGMzLMuyIrXteL+
         Re3huA+xukdKdHdN5lWVDmSKzALyyC6Y2SsaQxLlXBvwkeXyFYtyZ/A3Df0nzPZoUY8J
         pB+ghGlywHP66OArAss3f18tv8MYNW1ssxVRAX58jDt2+qynaZjPwU5UQKI4h3Ttxbn1
         Y22g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:from:to:references:in-reply-to
         :content-transfer-encoding;
        bh=rZ9bCneq1Z5E94YUQsiDnw+k/24xygdQ7lPf5i3Ih40=;
        b=Ui7DVyt99OPNeTJGDPKA06McXsruItuz2RkttZT3DMiQceoFC/XyatZLO/S3khYKj7
         +4vh+Ap5Ztjnr5u8d+tyPvA2H7q8SiunYqIzp/GEqGs6Dpo8JvTdgrnr/8NVlvcfJaX6
         iRZLXfPZW4FYNB2vXTRRt55CgonA+OV2Bj0lMHsQ03FUYosgbkq92iPnH2nD63h2UiWG
         QLPdS3Bq/KluxdwmyWAm7Pf65mggeTnADEEkVc2LYMez7ULLN1DNcxPaWQbgjMd9p6kc
         tMZyVpXWGC3P4jc9OvPaROVhx5bLPrPiFB4s4WTxntMn83DE3EVlNQH0wY0f60plZr5p
         ajyg==
X-Gm-Message-State: AOAM533abGZFDeNr+3wLqieA43h4Z9y/B6RRQQd3O4brGUd9ijEmHpxH
        5+HwC75XlARjif02snkjSI9fpKRLsaYtDXGc
X-Google-Smtp-Source: ABdhPJyy4moaNWmbfsin/+xqZntkLXIJtFHyP1tzPt2KuXLt7GMl5u4TtONyZnbOKRCL3qTZ9dfX4A==
X-Received: by 2002:a17:902:dacc:b0:15c:dfb8:28ce with SMTP id q12-20020a170902dacc00b0015cdfb828cemr5356227plx.63.1650737519025;
        Sat, 23 Apr 2022 11:11:59 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t21-20020a17090a951500b001d77f392280sm6952306pjo.30.2022.04.23.11.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 23 Apr 2022 11:11:58 -0700 (PDT)
Message-ID: <3035b054-dfe3-29b8-7d00-a810d15ab696@kernel.dk>
Date:   Sat, 23 Apr 2022 12:11:52 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: memory access op ideas
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Avi Kivity <avi@scylladb.com>, io-uring@vger.kernel.org
References: <e2de976d-c3d1-8bd2-72a8-a7e002641d6c@scylladb.com>
 <17ea341d-156a-c374-daab-2ed0c0fbee49@kernel.dk>
 <c663649e-674e-55d0-a59c-8f4b8f445bfa@kernel.dk>
 <27bf5faf-0b15-57dc-05ec-6a62cd789809@scylladb.com>
 <6041b513-0d85-c704-f1ae-c6657a3e680d@kernel.dk>
 <b5b7a49a-fc43-2af3-f3c8-988ea47ae986@kernel.dk>
In-Reply-To: <b5b7a49a-fc43-2af3-f3c8-988ea47ae986@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/23/22 12:02 PM, Jens Axboe wrote:
> On 4/23/22 11:32 AM, Jens Axboe wrote:
>>> I guess copy_to_user saves us from having to consider endianness.
>>
>> I was considering that too, definitely something that should be
>> investigated. Making it a 1/2/4/8 switch and using put_user() is
>> probably a better idea. Easy enough to benchmark.
> 
> FWIW, this is the current version. Some quick benchmarking doesn't show
> any difference between copy_to_user and put_user, but that may depend on
> the arch as well (using aarch64). But we might as well use put user and
> combine it with the length check, so we explicitly only support 1/2/4/8
> sizes.

In terms of performance, on this laptop, I can do about 36-37M NOP
requests per second. If I use IORING_OP_MEMCPY with immediate mode, it's
around 15M ops/sec. This is regardless of the size, get about the same
whether it's 1 or 8 byte memory writes.

-- 
Jens Axboe

